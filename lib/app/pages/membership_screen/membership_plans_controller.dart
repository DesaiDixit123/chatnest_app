import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:chatnest/app/app.dart';
import 'package:chatnest/app/navigators/navigators.dart';
import 'package:chatnest/domain/domain.dart';
import 'package:chatnest/data/helpers/api_wrapper.dart';
import 'package:chatnest/app/utils/invoice_pdf_creator.dart';
import 'package:intl/intl.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class MembershipPlansController extends GetxController {
  MembershipPlansController(this.presenter);

  final MembershipPlansPresenter presenter;

  late Razorpay _razorpay;
  PlanDatum? _pendingPlan;
  DurationOption? _pendingOption;
  String? _pendingOrderId;

  bool isLoading = true;
  bool isSubscribing = false;
  List<PlanDatum> plans = [];
  UserSubscriptionModel? currentSubscription;
  GstModel gst = GstModel();

  // Selected duration option index per plan ID
  final Map<String, int> selectedDurationIndices = {};

  bool get hasActivePlan =>
      currentSubscription != null &&
      currentSubscription!.status == 'active' &&
      !(currentSubscription!.isExpired ?? false) &&
      (currentSubscription!.remainingDays ?? 0) > 0;

  bool get isGstApplicable => gst.isApplicable; // status == true && percentage >= 1.0

  double getGstAmount(double basePrice) {
    if (!isGstApplicable || basePrice <= 0) return 0.0;
    return (basePrice * gst.percentage) / 100.0;
  }

  double getTotalPrice(double basePrice) {
    return basePrice + getGstAmount(basePrice);
  }

  String formatPrice(double price) {
    if (price <= 0) return "0";
    if (price % 1 == 0) {
      return price.toInt().toString();
    }
    return price.toStringAsFixed(2);
  }

  @override
  void onInit() {
    super.onInit();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    loadData();
  }

  @override
  void onClose() {
    _razorpay.clear();
    super.onClose();
  }

  Future<void> loadData() async {
    isLoading = true;
    update();

    await Future.wait([
      fetchPlans(),
      fetchMySubscription(),
      fetchGst(),
    ]);

    isLoading = false;
    update();
  }

  Future<void> fetchGst() async {
    try {
      final gstData = await presenter.getGst(isLoading: false);
      if (gstData != null) {
        gst = gstData;
        final repo = Get.find<Repository>();
        repo.saveValue(LocalKeys.adminGstPercentage, gst.percentage.toString());
        repo.saveValue(LocalKeys.adminGstLabel, gst.label);
      }
    } catch (e) {
      debugPrint("Error fetching GST: $e");
    }
  }

  Future<void> fetchPlans() async {
    try {
      final response = await presenter.getPlansList(isLoading: false);
      if (response != null) {
        if (response.gst != null) {
          gst = response.gst!;
          final repo = Get.find<Repository>();
          repo.saveValue(LocalKeys.adminGstPercentage, gst.percentage.toString());
          repo.saveValue(LocalKeys.adminGstLabel, gst.label);
        }
        if (response.data != null) {
          plans = response.data!;
          // Initialize default selected duration (0 = first duration) for each plan
          for (var plan in plans) {
            if (plan.id != null) {
              selectedDurationIndices[plan.id!] = 0;
            }
          }
        }
      }
    } catch (e) {
      debugPrint("Error fetching plans: $e");
    }
  }

  Future<void> fetchMySubscription() async {
    try {
      final response = await presenter.getMySubscription(isLoading: false);
      if (response != null) {
        dynamic decoded = response.data;
        if (decoded is String) {
          decoded = jsonDecode(decoded);
        }
        if (decoded is Map<String, dynamic> && decoded.containsKey("Data")) {
          final data = decoded["Data"];
          if (data != null && data is Map<String, dynamic>) {
            currentSubscription = UserSubscriptionModel.fromJson(data);
          }
        } else if (decoded is Map<String, dynamic>) {
          currentSubscription = UserSubscriptionModel.fromJson(decoded);
        }
      }
    } catch (e) {
      debugPrint("Error fetching subscription: $e");
    }
  }

  int getSelectedDurationIndex(String planId) {
    return selectedDurationIndices[planId] ?? 0;
  }

  void selectDuration(String planId, int index) {
    selectedDurationIndices[planId] = index;
    update();
  }

  DurationOption getSelectedOption(PlanDatum plan) {
    final durations = plan.normalizedDurations;
    final index = getSelectedDurationIndex(plan.id ?? "");
    if (index >= 0 && index < durations.length) {
      return durations[index];
    }
    return durations.isNotEmpty
        ? durations.first
        : DurationOption(label: "1 Month (30 Days)", days: 30, price: 0);
  }

  void showPaymentSummaryDialog({
    required PlanDatum plan,
    required DurationOption option,
  }) {
    final basePrice = option.price ?? 0.0;
    final gstAmount = getGstAmount(basePrice);
    final totalPayable = getTotalPrice(basePrice);
    final gstRateText = "${gst.percentage % 1 == 0 ? gst.percentage.toInt() : gst.percentage}% ${gst.label}";

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.white,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Padding(
          padding: const EdgeInsets.all(22.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: ColorsValue.maincoloropacity1,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.receipt_long_rounded,
                          color: ColorsValue.maincolor1,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "Payment Details",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF111827),
                            ),
                          ),
                          Text(
                            "Order & Tax Summary",
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () => Get.back(),
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Color(0xFFF3F4F6),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.close_rounded, size: 18, color: Color(0xFF4B5563)),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              // Selected Plan Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            plan.title ?? "Membership Plan",
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF111827),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            option.label ?? "${option.days} Days",
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF6B7280),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: ColorsValue.maincoloropacity1,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "${option.days} Days",
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: ColorsValue.maincolor1,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Price Breakdown
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Plan Base Price",
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF4B5563),
                          ),
                        ),
                        Text(
                          "₹${formatPrice(basePrice)}",
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF111827),
                          ),
                        ),
                      ],
                    ),
                    if (isGstApplicable) ...[
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "GST ($gstRateText)",
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF4B5563),
                            ),
                          ),
                          Text(
                            "+ ₹${formatPrice(gstAmount)}",
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF2563EB),
                            ),
                          ),
                        ],
                      ),
                    ],
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Divider(height: 1, color: Color(0xFFE5E7EB)),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Total Payable Amount",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF111827),
                          ),
                        ),
                        Text(
                          "₹${formatPrice(totalPayable)}",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: ColorsValue.maincolor1,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // Security Trust Note
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.shield_rounded, size: 14, color: Color(0xFF059669)),
                  SizedBox(width: 4),
                  Text(
                    "Secure payment • Instant activation",
                    style: TextStyle(
                      fontSize: 11,
                      color: Color(0xFF059669),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              // Pay Now Action Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorsValue.maincolor1,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: isSubscribing
                      ? null
                      : () async {
                          Get.back(); // close payment summary popup
                          await initiateRazorpayPayment(plan, option);
                        },
                  child: Text(
                    "Pay Now • ₹${formatPrice(totalPayable)}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: true,
    );
  }

  Future<void> initiateRazorpayPayment(PlanDatum plan, DurationOption option) async {
    if (isSubscribing) return;
    isSubscribing = true;
    update();

    _pendingPlan = plan;
    _pendingOption = option;

    final basePrice = option.price ?? 0.0;
    final totalPayable = getTotalPrice(basePrice);
    final amountInPaise = (totalPayable * 100).round();
    String? orderId;
    const razorpayKeyId = "rzp_test_TbPA2cXw0tTa91";

    try {
      // 1. Create order on backend (no blocking loader dialog)
      final orderResponse = await presenter.createPaymentOrder(
        isLoading: false,
        planId: plan.id ?? "",
        durationDays: option.days ?? 30,
        durationLabel: option.label ?? "${option.days} Days",
        price: basePrice,
      );

      if (orderResponse != null && orderResponse.data != null) {
        try {
          dynamic decoded = orderResponse.data;
          if (decoded is String && decoded.trim().startsWith('{')) {
            decoded = jsonDecode(decoded);
          }
          if (decoded is Map) {
            final dataObj = decoded['Data'] ?? decoded['data'] ?? decoded;
            if (dataObj is Map && dataObj['orderId'] != null) {
              orderId = dataObj['orderId'].toString();
            }
          }
        } catch (_) {}
      }
    } catch (e) {
      debugPrint("Order creation note: $e");
    } finally {
      isSubscribing = false;
      update();
    }

    _pendingOrderId = orderId;

    final int validAmount = amountInPaise < 100 ? 100 : amountInPaise;

    // 2. Launch official Razorpay Checkout SDK with clean standard options
    final Map<String, dynamic> options = {
      'key': razorpayKeyId,
      'amount': validAmount,
      'currency': 'INR',
      'name': 'ChatNest',
      'description': '${plan.title ?? "Membership"} (${option.label ?? "${option.days} Days"})',
      'theme': {
        'color': '#138808',
      },
    };

    final mobile = Utility.profileData?.mobile;
    final email = Utility.profileData?.email;
    final Map<String, String> prefill = {};
    if (mobile != null && mobile.trim().isNotEmpty) {
      String cleanDigits = mobile.replaceAll(RegExp(r'[^0-9]'), '');
      if (cleanDigits.length > 10) {
        cleanDigits = cleanDigits.substring(cleanDigits.length - 10);
      }
      if (cleanDigits.length == 10) {
        prefill['contact'] = cleanDigits;
      }
    }
    if (email != null && email.trim().isNotEmpty && email.contains('@')) {
      prefill['email'] = email.trim();
    }
    if (prefill.isNotEmpty) {
      options['prefill'] = prefill;
    }

    try {
      debugPrint("Opening official Razorpay Checkout with options: $options");
      _razorpay.open(options);
    } catch (e) {
      debugPrint("Error launching Razorpay: $e");
      Utility.showMessage("Unable to open Razorpay: $e", MessageType.error, () => null, '');
    }
  }

  void _saveLocalInvoice(InvoiceModel invoice) {
    try {
      final repo = Get.find<Repository>();
      final localJson = repo.getStringValue(LocalKeys.userInvoices);
      List<dynamic> list = [];
      if (localJson.isNotEmpty) {
        try {
          final decoded = jsonDecode(localJson);
          if (decoded is List) list = decoded;
        } catch (_) {}
      }
      final exists = list.any((item) =>
          item is Map &&
          ((item['id'] != null && item['id'] == invoice.id) ||
           (item['invoiceNumber'] != null && item['invoiceNumber'] == invoice.invoiceNumber)));
      if (!exists) {
        list.insert(0, invoice.toJson());
        repo.saveValue(LocalKeys.userInvoices, jsonEncode(list));
      }
    } catch (e) {
      debugPrint("Error saving local invoice: $e");
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    debugPrint("Razorpay Payment Success: paymentId=${response.paymentId}, orderId=${response.orderId}");
    final plan = _pendingPlan;
    final option = _pendingOption;
    if (plan == null || option == null) return;

    final basePrice = option.price ?? 0.0;
    final gstAmount = getGstAmount(basePrice);
    final totalPayable = getTotalPrice(basePrice);
    final now = DateTime.now();

    final dateStr = DateFormat("yyyyMMdd").format(now);
    final String resolvedPaymentId = (response.paymentId != null && response.paymentId!.trim().isNotEmpty)
        ? response.paymentId!.trim()
        : 'pay_RZP$dateStr${now.millisecondsSinceEpoch.toString().substring(now.millisecondsSinceEpoch.toString().length - 4)}';
    final String resolvedOrderId = (response.orderId != null && response.orderId!.trim().isNotEmpty)
        ? response.orderId!.trim()
        : (_pendingOrderId != null && _pendingOrderId!.isNotEmpty ? _pendingOrderId! : 'order_RZP$dateStr');
    final shortId = resolvedPaymentId.length >= 4
        ? resolvedPaymentId.substring(resolvedPaymentId.length - 4).toUpperCase()
        : 'ACTV';
    final invNum = 'INV-$dateStr-$shortId';

    // 1. Immediately activate subscription locally
    final activatedSub = UserSubscriptionModel(
      planId: plan.id,
      planTitle: plan.title,
      durationDays: option.days ?? 30,
      durationLabel: option.label ?? "${option.days} Days",
      price: totalPayable,
      currency: 'INR',
      startDate: now,
      expiryDate: now.add(Duration(days: option.days ?? 30)),
      status: 'active',
      remainingDays: option.days ?? 30,
      isExpired: false,
      paymentId: resolvedPaymentId,
      orderId: resolvedOrderId,
      functionalities: plan.functionalities,
    );
    currentSubscription = activatedSub;
    Get.find<Repository>().saveSubscription(activatedSub);

    // 2. Immediately save invoice locally
    final localInv = InvoiceModel(
      id: resolvedPaymentId,
      invoiceNumber: invNum,
      planTitle: plan.title ?? "Membership Plan",
      durationDays: option.days ?? 30,
      durationLabel: option.label ?? "${option.days} Days",
      amount: totalPayable,
      basePrice: basePrice,
      gstAmount: gstAmount,
      gstPercentage: gst.percentage,
      currency: 'INR',
      paymentId: resolvedPaymentId,
      orderId: resolvedOrderId,
      paymentMethod: 'razorpay',
      status: 'completed',
      createdAt: now,
    );
    _saveLocalInvoice(localInv);

    try {
      // 3. Activate subscription on backend
      await presenter.subscribePlan(
        isLoading: false,
        planId: plan.id ?? "",
        durationDays: option.days ?? 30,
        durationLabel: option.label ?? "${option.days} Days",
        price: totalPayable,
        paymentId: resolvedPaymentId,
        orderId: resolvedOrderId,
      );
    } catch (e) {
      debugPrint("Subscription activation note: $e");
    }

    // 4. Mark local popup as seen
    Get.find<Repository>().saveValue(LocalKeys.hasSeenSubscriptionPopup, true);

    // 5. Reload current active subscription from server
    await fetchMySubscription();
    if (currentSubscription != null) {
      Get.find<Repository>().saveSubscription(currentSubscription);
    }

    // 6. Show the original popup with "Continue to App" & "Download Invoice" buttons!
    showActivationSuccessDialog(
      planTitle: plan.title ?? "Membership",
      durationLabel: option.label ?? "${option.days} Days",
      days: option.days ?? 30,
      paymentId: response.paymentId,
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    debugPrint("Razorpay Payment Error: code=${response.code}, message=${response.message}");
    isSubscribing = false;
    update();

    String message = response.message ?? "Payment was cancelled or failed";
    try {
      if (message.contains('{')) {
        final decoded = jsonDecode(message);
        if (decoded is Map && decoded['error'] != null && decoded['error']['description'] != null) {
          message = decoded['error']['description'].toString();
        }
      }
    } catch (_) {}

    if (message.toLowerCase().contains("authentication failed")) {
      message = "Razorpay Test Key Expired/Invalid (Authentication failed). Please generate a new key from Razorpay Dashboard.";
    }

    Utility.showMessage(
      message,
      MessageType.error,
      () => null,
      '',
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    debugPrint("Razorpay External Wallet: ${response.walletName}");
    Utility.showMessage(
      "External wallet selected: ${response.walletName}",
      MessageType.information,
      () => null,
      '',
    );
  }

  bool isDownloadingInvoice = false;

  Future<void> downloadInvoiceFromPopup({String? paymentId}) async {
    isDownloadingInvoice = true;
    update();

    try {
      final token = Get.find<Repository>().getStringValue(LocalKeys.authToken);
      final id = (paymentId != null && paymentId.isNotEmpty) ? paymentId : 'active_sub';
      final downloadUrl =
          '${ApiWrapper.baseUrl}/apis/v2/plans/invoice-download/$id?token=$token';

      Directory? dir;
      if (Platform.isAndroid) {
        dir = await getExternalStorageDirectory() ??
            await getApplicationDocumentsDirectory();
      } else {
        dir = await getApplicationDocumentsDirectory();
      }

      final fileName = 'ChatNest_Invoice_${DateTime.now().millisecondsSinceEpoch}.pdf';
      final savePath = '${dir.path}/$fileName';

      bool downloadOk = false;
      try {
        final dio = Dio();
        final response = await dio.download(
          downloadUrl,
          savePath,
          options: Options(
            headers: {
              'authorization': 'Token $token',
            },
          ),
        );
        if (response.statusCode == 200 && await File(savePath).exists()) {
          downloadOk = true;
        }
      } catch (dioError) {
        debugPrint("Remote invoice download failed, generating PDF locally: $dioError");
      }

      // If backend download did not produce the file, generate PDF locally
      if (!downloadOk || !await File(savePath).exists()) {
        final dateStr = DateFormat("yyyyMMdd").format(DateTime.now());
        final shortId = (paymentId != null && paymentId.length >= 4)
            ? paymentId.substring(paymentId.length - 4).toUpperCase()
            : 'ACTV';
        final invNum = 'INV-$dateStr-$shortId';
        final sub = currentSubscription;
        final total = sub?.price ?? 0.0;
        final double gstRate = gst.status ? gst.percentage : 0.0;
        final double base = total > 0
            ? (gstRate > 0 ? (total / (1.0 + (gstRate / 100.0))) : total)
            : (_pendingOption?.price ?? 0.0);
        final double gstAmt = total > 0 ? (total - base) : getGstAmount(_pendingOption?.price ?? 0.0);

        final invModel = InvoiceModel(
          id: id,
          invoiceNumber: invNum,
          planTitle: sub?.planTitle ?? _pendingPlan?.title ?? "Membership Plan",
          durationDays: sub?.durationDays ?? _pendingOption?.days ?? 30,
          durationLabel: sub?.durationLabel ?? _pendingOption?.label ?? "30 Days",
          amount: total > 0 ? total : getTotalPrice(_pendingOption?.price ?? 0.0),
          basePrice: base,
          gstAmount: gstAmt,
          gstPercentage: gstRate,
          currency: 'INR',
          paymentId: (paymentId != null && paymentId.isNotEmpty) ? paymentId : 'COMPLETED',
          orderId: _pendingOrderId ?? 'N/A',
          paymentMethod: 'razorpay',
          status: 'completed',
          createdAt: DateTime.now(),
        );

        final repo = Get.find<Repository>();
        final custName = Utility.profileData?.fullname?.isNotEmpty == true
            ? Utility.profileData!.fullname!
            : repo.getStringValue(LocalKeys.fullName);

        final rawMobile = Utility.profileData?.mobile ?? "";
        final countryCode = Utility.profileData?.countryCode ?? "";
        final custPhone = rawMobile.isNotEmpty
            ? (countryCode.isNotEmpty ? "$countryCode $rawMobile" : rawMobile)
            : "";

        final custEmail = Utility.profileData?.email?.isNotEmpty == true
            ? Utility.profileData!.email!
            : (Utility.profileData?.recoveryEmail ?? "");

        await InvoicePdfCreator.generateInvoicePdf(
          invoice: invModel,
          filePath: savePath,
          customerName: custName,
          customerPhone: custPhone,
          customerEmail: custEmail,
        );
        _saveLocalInvoice(invModel);
      }

      if (await File(savePath).exists()) {
        Get.snackbar(
          'Invoice Downloaded',
          'Tax invoice saved to your device',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: ColorsValue.maincolor1,
          colorText: Colors.white,
          margin: const EdgeInsets.all(12),
          duration: const Duration(seconds: 4),
          mainButton: TextButton(
            onPressed: () {
              OpenFile.open(savePath);
            },
            child: const Text(
              'OPEN',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );

        await OpenFile.open(savePath);
      }
    } catch (e) {
      debugPrint("Error downloading invoice from popup: $e");
      Get.snackbar(
        'Invoice Notice',
        'Invoice generated. You can view or download it anytime from Controls > Invoices.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: ColorsValue.maincolor1,
        colorText: Colors.white,
        margin: const EdgeInsets.all(12),
      );
    } finally {
      isDownloadingInvoice = false;
      update();
    }
  }

  void showActivationSuccessDialog({
    required String planTitle,
    required String durationLabel,
    required int days,
    String? paymentId,
  }) {
    final now = DateTime.now();
    final expiry = now.add(Duration(days: days));
    final formattedExpiry = "${expiry.day.toString().padLeft(2, '0')}-${expiry.month.toString().padLeft(2, '0')}-${expiry.year}";

    bool hasNavigatedHome = false;
    void closeAndGoHome() {
      if (hasNavigatedHome) return;
      hasNavigatedHome = true;
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }
      RouteManagement.goToHomeScreenView();
    }

    Get.dialog(
      PopScope(
        canPop: false,
        onPopInvoked: (didPop) {
          if (didPop) return;
          closeAndGoHome();
        },
        child: Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: ColorsValue.maincoloropacity1,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle_rounded,
                    color: ColorsValue.maincolor1,
                    size: 44,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "Membership Activated!",
                  style: Styles.black70020.copyWith(fontSize: 22),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  "Your \"$planTitle\" ($durationLabel) has been successfully activated.",
                  style: Styles.hinttext40014,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F9FB),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE5E7EB)),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Validity Period", style: TextStyle(color: Color(0xFF6B7280), fontSize: 13)),
                          Text("$days Days", style: const TextStyle(color: Color(0xFF111827), fontWeight: FontWeight.bold, fontSize: 13)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Expires On", style: TextStyle(color: Color(0xFF6B7280), fontSize: 13)),
                          Text(formattedExpiry, style: const TextStyle(color: Color(0xFF111827), fontWeight: FontWeight.bold, fontSize: 13)),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // 1. Download Invoice Button
                StatefulBuilder(
                  builder: (context, setBtnState) {
                    return SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: ColorsValue.maincolor1, width: 1.5),
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: isDownloadingInvoice
                            ? null
                            : () async {
                                setBtnState(() => isDownloadingInvoice = true);
                                await downloadInvoiceFromPopup(paymentId: paymentId);
                                if (context.mounted) {
                                  setBtnState(() => isDownloadingInvoice = false);
                                }
                              },
                        icon: isDownloadingInvoice
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: ColorsValue.maincolor1,
                                ),
                              )
                            : const Icon(
                                Icons.download_rounded,
                                color: ColorsValue.maincolor1,
                                size: 20,
                              ),
                        label: Text(
                          isDownloadingInvoice ? "Downloading...".tr : "Download Invoice".tr,
                          style: const TextStyle(
                            color: ColorsValue.maincolor1,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                // 2. Continue to App Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorsValue.maincolor1,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      closeAndGoHome();
                    },
                    child: const Text(
                      "Continue to App",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: true,
    ).then((_) {
      // If dialog was dismissed in any way, ensure navigation to Home Screen
      closeAndGoHome();
    });
  }
}
