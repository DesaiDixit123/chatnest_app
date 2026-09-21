import 'dart:convert';

InvoiceListResponseModel invoiceListResponseModelFromJson(String str) =>
    InvoiceListResponseModel.fromJson(json.decode(str));

class InvoiceListResponseModel {
  String? message;
  List<InvoiceModel>? data;
  int? status;
  bool? isSuccess;

  InvoiceListResponseModel({
    this.message,
    this.data,
    this.status,
    this.isSuccess,
  });

  factory InvoiceListResponseModel.fromJson(Map<String, dynamic> json) {
    List<InvoiceModel>? invoices;

    if (json["Data"] != null && json["Data"] is List) {
      invoices = List<InvoiceModel>.from(
        (json["Data"] as List).map((x) => InvoiceModel.fromJson(x)),
      );
    } else if (json["data"] != null && json["data"] is List) {
      invoices = List<InvoiceModel>.from(
        (json["data"] as List).map((x) => InvoiceModel.fromJson(x)),
      );
    }

    return InvoiceListResponseModel(
      message: json["Message"] ?? json["message"],
      data: invoices,
      status: json["Status"] ?? json["status"],
      isSuccess: json["IsSuccess"] ?? json["isSuccess"],
    );
  }

  Map<String, dynamic> toJson() => {
        "Message": message,
        "Data": data == null
            ? null
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "Status": status,
        "IsSuccess": isSuccess,
      };
}

class InvoiceModel {
  String? id;
  String? invoiceNumber;
  String? planTitle;
  int? durationDays;
  String? durationLabel;
  double? amount;
  double? basePrice;
  double? gstAmount;
  double? gstPercentage;
  String? currency;
  String? paymentId;
  String? orderId;
  String? paymentMethod;
  String? status;
  DateTime? createdAt;
  String? downloadUrl;

  InvoiceModel({
    this.id,
    this.invoiceNumber,
    this.planTitle,
    this.durationDays,
    this.durationLabel,
    this.amount,
    this.basePrice,
    this.gstAmount,
    this.gstPercentage,
    this.currency,
    this.paymentId,
    this.orderId,
    this.paymentMethod,
    this.status,
    this.createdAt,
    this.downloadUrl,
  });

  factory InvoiceModel.fromJson(Map<String, dynamic> json) {
    DateTime? parsedDate;
    if (json["createdAt"] != null) {
      try {
        parsedDate = DateTime.parse(json["createdAt"]);
      } catch (_) {}
    }

    return InvoiceModel(
      id: json["_id"] ?? json["id"],
      invoiceNumber: json["invoiceNumber"],
      planTitle: json["planTitle"] ?? "Membership Plan",
      durationDays: json["durationDays"] != null
          ? int.tryParse(json["durationDays"].toString())
          : 30,
      durationLabel: json["durationLabel"] ?? "30 Days",
      amount: json["amount"] != null
          ? double.tryParse(json["amount"].toString())
          : 0.0,
      basePrice: json["basePrice"] != null
          ? double.tryParse(json["basePrice"].toString())
          : 0.0,
      gstAmount: json["gstAmount"] != null
          ? double.tryParse(json["gstAmount"].toString())
          : 0.0,
      gstPercentage: json["gstPercentage"] != null
          ? double.tryParse(json["gstPercentage"].toString())
          : (json["gst"] != null ? double.tryParse(json["gst"].toString()) : null),
      currency: json["currency"] ?? "INR",
      paymentId: json["paymentId"] ?? "N/A",
      orderId: json["orderId"] ?? "N/A",
      paymentMethod: json["paymentMethod"] ?? "razorpay",
      status: json["status"] ?? "completed",
      createdAt: parsedDate,
      downloadUrl: json["downloadUrl"],
    );
  }

  Map<String, dynamic> toJson() => {
        "_id": id,
        "invoiceNumber": invoiceNumber,
        "planTitle": planTitle,
        "durationDays": durationDays,
        "durationLabel": durationLabel,
        "amount": amount,
        "basePrice": basePrice,
        "gstAmount": gstAmount,
        "gstPercentage": gstPercentage,
        "currency": currency,
        "paymentId": paymentId,
        "orderId": orderId,
        "paymentMethod": paymentMethod,
        "status": status,
        "createdAt": createdAt?.toIso8601String(),
        "downloadUrl": downloadUrl,
      };
}
