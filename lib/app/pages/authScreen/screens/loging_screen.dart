import 'package:chatnest/app/navigators/navigators.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:chatnest/app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:get/get.dart';

class Logingscreen extends StatelessWidget {
  const Logingscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginController>(
      builder: (controller) => Scaffold(
        backgroundColor: ColorsValue.whiteColor,
        body: Column(
          children: [
            // ── Branded gradient header ───────────────────────────────────
            Container(
              width: double.infinity,
              height: 240,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF1A1A2E),
                    Color(0xFF16213E),
                    Color(0xFF0F3460),
                  ],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(36),
                  bottomRight: Radius.circular(36),
                ),
              ),
              child: Stack(
                children: [
                  // decorative blobs
                  Positioned(
                    top: -40,
                    right: -40,
                    child: Container(
                      width: 160,
                      height: 160,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color:
                            const Color(0xFF34D058).withOpacity(0.12),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -30,
                    left: -30,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color:
                            const Color(0xFF7B61FF).withOpacity(0.12),
                      ),
                    ),
                  ),
                  // Logo + app name
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 50),
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFF34D058),
                                Color(0xFF7B61FF),
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF34D058)
                                    .withOpacity(0.35),
                                blurRadius: 20,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(16),
                          child: Image.asset(
                            AssetConstants.applogoimage,
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ShaderMask(
                          shaderCallback: (bounds) =>
                              const LinearGradient(
                            colors: [
                              Color(0xFF34D058),
                              Color(0xFF7B61FF),
                            ],
                          ).createShader(bounds),
                          child: const Text(
                            'ChatNest',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Connect. Chat. Belong.',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFFB0B8CC),
                            letterSpacing: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ── Form area ────────────────────────────────────────────────
            Expanded(
              child: Padding(
                padding: Dimens.edgeInsets30_0_30_0,
                child: Form(
                  key: controller.loginFormKey,
                  child: ListView(
                    children: [
                      Dimens.boxHeight24,
                      Text(
                        "welcome".tr,
                        style: Styles.main70030,
                      ),
                      Dimens.boxHeight8,
                      Text(
                        "enteryournumber".tr,
                        style: Styles.black70024,
                      ),
                      Dimens.boxHeight6,
                      Text(
                        "logingdiscription".tr,
                        style: Styles.hinttext40014,
                      ),
                      Dimens.boxHeight16,
                      CustomInternationalPhoneFild(
                        hintText: 'Phone Number',
                        text: ''.tr,
                        initialvalue: PhoneNumber(
                            isoCode: PhoneNumber.getISO2CodeByPrefix(
                                controller.dailcode)),
                        onInputChanged: (PhoneNumber number) {
                          controller.dailcode = number.dialCode ?? '';
                        },
                        oninitialValidation: (bool value) {
                          controller.isValid = value;
                          controller.update();
                        },
                        textEditingController:
                            controller.phonenumbercontroller,
                        validation: (value) {
                          if (value!.isEmpty) {
                            return "enteryournumber".tr;
                          } else if (!controller.isValid) {
                            return "enter_valid_phone_number".tr;
                          }
                          return null;
                        },
                      ),
                      Dimens.boxHeight20,

                      // ── Terms + Privacy checkbox row ──────────────────
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 24,
                            width: 24,
                            child: Checkbox(
                              value: controller.isAgreeTerms,
                              activeColor: ColorsValue.maincolor1,
                              onChanged: (value) {
                                controller.isAgreeTerms =
                                    value ?? false;
                                controller.update();
                              },
                            ),
                          ),
                          Dimens.boxWidth10,
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                text: 'I agree to the ',
                                style: Styles.black40014,
                                children: [
                                  TextSpan(
                                    text: 'Terms & Conditions',
                                    style: Styles.mainUnderline40014,
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        RouteManagement
                                            .goToTermConditionScreen();
                                      },
                                  ),
                                  const TextSpan(text: ' and '),
                                  TextSpan(
                                    text: 'Privacy Policy',
                                    style: Styles.mainUnderline40014,
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        RouteManagement
                                            .goToPrivacyPolicyScreen();
                                      },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),

                      Dimens.boxHeight28,
                      CustomButton(
                        height: Dimens.fifty,
                        text: 'continue'.tr.toUpperCase(),
                        onTap: controller.isAgreeTerms
                            ? () {
                                controller.sendOtpApi();
                              }
                            : null,
                        backgroundColor: controller.isAgreeTerms
                            ? ColorsValue.maincolor1
                            : ColorsValue.greyColor8888,
                      ),
                      Dimens.boxHeight20,

                      // ── Safety note ──────────────────────────────────
                      Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.shield_outlined,
                              size: 13,
                              color: ColorsValue.greyColor8888,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              'Safe & secure messaging',
                              style: TextStyle(
                                fontSize: 11,
                                color: ColorsValue.greyColor8888,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
