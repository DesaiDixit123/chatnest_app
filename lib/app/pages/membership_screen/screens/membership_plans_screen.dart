import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:chatnest/app/app.dart';
import 'package:chatnest/app/navigators/navigators.dart';
import 'package:chatnest/domain/domain.dart';

class MembershipPlansScreen extends StatelessWidget {
  const MembershipPlansScreen({super.key});

  Future<bool> _showExitConfirmDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext ctx) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: const Text(
                "Exit App",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Color(0xFF111827),
                ),
              ),
              content: const Text(
                "Do you want to exit the app?",
                style: TextStyle(
                  fontSize: 15,
                  color: Color(0xFF4B5563),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(false),
                  child: const Text(
                    "Cancel",
                    style: TextStyle(
                      color: Color(0xFF6B7280),
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(ctx).pop(true);
                    SystemNavigator.pop();
                  },
                  child: const Text(
                    "Yes, Exit",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MembershipPlansController>(
      builder: (controller) {
        return WillPopScope(
          onWillPop: () async {
            if (controller.hasActivePlan) {
              RouteManagement.goToHomeScreenView();
              return false;
            }
            return await _showExitConfirmDialog(context);
          },
          child: Scaffold(
            backgroundColor: const Color(0xFFF9FAFB),
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0.5,
              centerTitle: true,
              automaticallyImplyLeading: false,
              leading: controller.hasActivePlan
                  ? IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_rounded,
                          color: Colors.black87, size: 20),
                      onPressed: () => RouteManagement.goToHomeScreenView(),
                    )
                  : IconButton(
                      icon: const Icon(Icons.close_rounded,
                          color: Colors.black87, size: 22),
                      onPressed: () => _showExitConfirmDialog(context),
                    ),
              title: const Text(
                "Membership Plans",
                style: TextStyle(
                  color: Color(0xFF111827),
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          body: controller.isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    color: ColorsValue.maincolor1,
                  ),
                )
              : RefreshIndicator(
                  color: ColorsValue.maincolor1,
                  onRefresh: () => controller.loadData(),
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Active subscription banner if available
                        if (controller.currentSubscription != null &&
                            controller.currentSubscription!.status == 'active' &&
                            !(controller.currentSubscription!.isExpired ?? false)) ...[
                          _buildActiveSubscriptionBanner(controller.currentSubscription!),
                          const SizedBox(height: 20),
                        ],

                        // Header subtitle
                        const Text(
                          "Choose the right plan for you",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF111827),
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          "Unlock unlimited chat, high quality audio/video, sessions, community access and marketplace features.",
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF6B7280),
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 20),

                        if (controller.plans.isEmpty)
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                            alignment: Alignment.center,
                            child: const Column(
                              children: [
                                Icon(Icons.card_membership_rounded, size: 48, color: Color(0xFF9CA3AF)),
                                SizedBox(height: 12),
                                Text(
                                  "No active membership plans found.",
                                  style: TextStyle(fontSize: 15, color: Color(0xFF6B7280)),
                                ),
                              ],
                            ),
                          )
                        else
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: controller.plans.length,
                            separatorBuilder: (_, __) => const SizedBox(height: 20),
                            itemBuilder: (context, index) {
                              final plan = controller.plans[index];
                              return _buildPlanCard(context, controller, plan);
                            },
                          ),

                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
          ),
        );
      },
    );
  }

  Widget _buildActiveSubscriptionBanner(UserSubscriptionModel sub) {
    final expiryFormatted = sub.expiryDate != null
        ? "${sub.expiryDate!.day.toString().padLeft(2, '0')}-${sub.expiryDate!.month.toString().padLeft(2, '0')}-${sub.expiryDate!.year}"
        : "-";

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0F9D58), Color(0xFF34D058)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF34D058).withOpacity(0.25),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.verified_rounded, color: Colors.white, size: 14),
                    SizedBox(width: 4),
                    Text(
                      "CURRENT ACTIVE PLAN",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Text(
                "${sub.remainingDays ?? 0} Days Left",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            sub.planTitle ?? "Active Membership",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Valid till: $expiryFormatted (${sub.durationLabel ?? ''})",
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanCard(
    BuildContext context,
    MembershipPlansController controller,
    PlanDatum plan,
  ) {
    final isCurrentPlan = controller.currentSubscription?.planId == plan.id &&
        !(controller.currentSubscription?.isExpired ?? false);

    final durationOptions = plan.normalizedDurations;
    final selectedOption = controller.getSelectedOption(plan);
    final selectedIndex = controller.getSelectedDurationIndex(plan.id ?? "");

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isCurrentPlan
              ? ColorsValue.maincolor1
              : const Color(0xFFE5E7EB),
          width: isCurrentPlan ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row: Title & Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  plan.title ?? "Package",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF111827),
                  ),
                ),
              ),
              if (isCurrentPlan)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: ColorsValue.maincoloropacity1,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    "ACTIVE",
                    style: TextStyle(
                      color: ColorsValue.maincolor1,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
            ],
          ),

          // Description
          if (plan.description != null && plan.description!.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              plan.description!.replaceAll(RegExp(r'<[^>]*>'), ''),
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF6B7280),
                height: 1.3,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],

          const SizedBox(height: 16),
          const Divider(height: 1, color: Color(0xFFF3F4F6)),
          const SizedBox(height: 16),

          // Duration Selector (Month-wise Chips)
          const Text(
            "Select Duration:",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF4B5563),
            ),
          ),
          const SizedBox(height: 10),

          // Duration Chips (1 Month, 3 Month, 6 Month, 12 Month, etc.)
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: List.generate(durationOptions.length, (idx) {
              final opt = durationOptions[idx];
              final isSelected = selectedIndex == idx;
              final displayPrice = controller.isGstApplicable
                  ? controller.getTotalPrice(opt.price ?? 0.0)
                  : (opt.price ?? 0.0);
              return InkWell(
                onTap: () {
                  controller.selectDuration(plan.id ?? "", idx);
                },
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? ColorsValue.maincolor1
                        : const Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isSelected
                          ? ColorsValue.maincolor1
                          : const Color(0xFFE5E7EB),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        opt.label ?? "${opt.days} Days",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                          color: isSelected ? Colors.white : const Color(0xFF374151),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        displayPrice > 0
                            ? "₹${controller.formatPrice(displayPrice)}"
                            : "Free",
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.white : ColorsValue.maincolor1,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),

          const SizedBox(height: 16),

          // Price Tag for selected duration
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.currency_rupee_rounded, size: 22, color: Color(0xFF111827)),
                    Text(
                      controller.formatPrice(
                        controller.isGstApplicable
                            ? controller.getTotalPrice(selectedOption.price ?? 0.0)
                            : (selectedOption.price ?? 0.0),
                      ),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF111827),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      "/ ${selectedOption.label ?? '${selectedOption.days} Days'}",
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
                if (controller.isGstApplicable && (selectedOption.price ?? 0) > 0) ...[
                  const SizedBox(height: 8),
                  const Divider(height: 1, color: Color(0xFFE5E7EB)),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Base: ₹${controller.formatPrice(selectedOption.price ?? 0.0)} + ${controller.gst.percentage % 1 == 0 ? controller.gst.percentage.toInt() : controller.gst.percentage}% ${controller.gst.label} (₹${controller.formatPrice(controller.getGstAmount(selectedOption.price ?? 0.0))})",
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF6B7280),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        "Total: ₹${controller.formatPrice(controller.getTotalPrice(selectedOption.price ?? 0.0))}",
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF111827),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: 18),

          // Included Features List
          const Text(
            "What's included:",
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 10),

          if (plan.functionalities != null && plan.functionalities!.isNotEmpty)
            ...plan.functionalities!.map((func) {
              final featureName = func.name;
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  children: [
                    const Icon(
                      Icons.check_circle_rounded,
                      color: ColorsValue.maincolor1,
                      size: 18,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      featureName,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF374151),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            })
          else ...[
            _buildFeatureRow("Chat & Messaging"),
            _buildFeatureRow("Audio & Video Calls"),
            _buildFeatureRow("Sessions / Meetings"),
            _buildFeatureRow("Community & Broadcast"),
            _buildFeatureRow("Marketplace Access"),
          ],

          const SizedBox(height: 20),

          // Action Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: isCurrentPlan
                    ? const Color(0xFF111827)
                    : ColorsValue.maincolor1,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                controller.showPaymentSummaryDialog(plan: plan, option: selectedOption);
              },
              child: Text(
                isCurrentPlan ? "Renew Plan" : "Choose Plan",
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
    );
  }

  static Widget _buildFeatureRow(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          const Icon(
            Icons.check_circle_rounded,
            color: ColorsValue.maincolor1,
            size: 18,
          ),
          const SizedBox(width: 10),
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF374151),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
