import 'dart:async';
import 'package:chatnest/app/app.dart';
import 'package:chatnest/app/navigators/app_pages.dart';
import 'package:chatnest/app/navigators/routes_management.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../domain/services/user_safety_service.dart';

class EulaScreen extends StatefulWidget {
  const EulaScreen({Key? key}) : super(key: key);

  @override
  State<EulaScreen> createState() => _EulaScreenState();
}

class _EulaScreenState extends State<EulaScreen> {
  bool _isLoading = true;
  String _eulaText = '';
  bool _isOfflineFallback = false;

  static const String _fallbackEulaText = '''Last Updated: June 17, 2026

End User License Agreement (EULA) and Terms of Service

Please read this End User License Agreement ("Agreement" or "EULA") carefully before using the ChatNest Mobile Application ("Application" or "Service"). By downloading, installing, or using the Application, you agree to be bound by the terms and conditions of this Agreement.

1. Zero Tolerance Policy for Objectionable Content and Abusive Users
ChatNest is a platform for real-time communication. We enforce a zero-tolerance policy against any forms of objectionable, abusive, harassing, threatening, defamatory, or harmful behavior. You must not upload, post, transmit, or share any content that:
- Is sexually explicit, pornographic, or obscene.
- Promotes hate speech, discrimination, racism, or bigotry.
- Depicts or promotes violence, self-harm, or illegal acts.
- Infringes on third-party intellectual property or privacy rights.

2. User-Generated Content (UGC) Controls
To ensure safety and security, ChatNest equips users with built-in mechanisms to manage their interactions:
- Report Content/User: If you encounter objectionable content or an abusive user, you can report them immediately from the chat menu. Our moderation team reviews reports and takes appropriate action when necessary. Objectionable content will be removed, and users violating these rules will be permanently banned.
- Block User: You can block any user at any time. Once blocked, the user will not be able to send you messages, view your profile, or contact you.

3. Monitoring and Enforcement
The Application owner reserves the right, but is not obligated, to monitor all User-Generated Content. We reserve the right to remove any content and terminate or suspend user accounts immediately, without prior notice, if they violate this Agreement.

4. Support & Developer Contact Information
If you have any questions, concerns, or wish to report violations of the Zero Tolerance Policy directly, you can contact our support team at:
Email: admin@thekhushiempire.com
Phone: +91 9924697299

5. Limitation of Liability
The Application is provided "AS IS" and "AS AVAILABLE". We make no warranties of any kind regarding its stability, availability, or suitability for any purpose.

By tapping "Accept", you acknowledge that you have read, understood, and agreed to be bound by all the terms of this Agreement.''';

  late final TapGestureRecognizer _termsRecognizer;
  late final TapGestureRecognizer _privacyRecognizer;
  late final TapGestureRecognizer _eulaRecognizer;

  @override
  void initState() {
    super.initState();
    _fetchEula();
    _termsRecognizer = TapGestureRecognizer()..onTap = _onTermsTap;
    _privacyRecognizer = TapGestureRecognizer()..onTap = _onPrivacyTap;
    _eulaRecognizer = TapGestureRecognizer()..onTap = _onEulaTap;
  }

  @override
  void dispose() {
    _termsRecognizer.dispose();
    _privacyRecognizer.dispose();
    _eulaRecognizer.dispose();
    super.dispose();
  }

  void _onTermsTap() {
    RouteManagement.goToTermConditionScreen();
  }

  void _onPrivacyTap() {
    RouteManagement.goToPrivacyPolicyScreen();
  }

  void _onEulaTap() {
    RouteManagement.goToTermConditionScreen();
  }

  Future<void> _fetchEula() async {
    setState(() {
      _isLoading = true;
      _isOfflineFallback = false;
    });

    try {
      final terms = await Get.find<UserSafetyService>().getTerms();
      if (mounted) {
        setState(() {
          _eulaText = terms;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("[EULA] API Fetch failed: \$e. Falling back to offline EULA.");
      if (mounted) {
        setState(() {
          _eulaText = _fallbackEulaText;
          _isOfflineFallback = true;
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final UserSafetyService safetyService = Get.find<UserSafetyService>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'User Safety & Agreement',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: _isLoading
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        color: ColorsValue.appColor,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Loading EULA & Terms...',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (_isOfflineFallback)
                      Container(
                        margin: const EdgeInsets.only(bottom: 12.0),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 8.0),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade50,
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(color: Colors.orange.shade200),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.wifi_off, color: Colors.orange.shade800, size: 20),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Loaded offline safety agreement copy.',
                                style: TextStyle(
                                  color: Colors.orange.shade900,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: _fetchEula,
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: const Size(50, 30),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: Text(
                                'Retry',
                                style: TextStyle(
                                  color: Colors.orange.shade900,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Scrollbar(
                          thumbVisibility: true,
                          thickness: 4.0,
                          radius: const Radius.circular(8.0),
                          child: SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding: const EdgeInsets.only(right: 12.0),
                            child: Text(
                              _eulaText,
                              style: const TextStyle(
                                fontSize: 14.5,
                                color: Colors.black87,
                                height: 1.45,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Column(
                      children: [
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: const TextStyle(
                              fontSize: 11,
                              color: Colors.grey,
                              height: 1.4,
                            ),
                            children: [
                              const TextSpan(text: 'By tapping Accept, you agree to ChatNest\'s '),
                              TextSpan(
                                text: 'Terms of Use',
                                style: TextStyle(
                                  color: ColorsValue.appColor,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                ),
                                recognizer: _termsRecognizer,
                              ),
                              const TextSpan(text: ', '),
                              TextSpan(
                                text: 'Privacy Policy',
                                style: TextStyle(
                                  color: ColorsValue.appColor,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                ),
                                recognizer: _privacyRecognizer,
                              ),
                              const TextSpan(text: ', and '),
                              TextSpan(
                                text: 'EULA',
                                style: TextStyle(
                                  color: ColorsValue.appColor,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                ),
                                recognizer: _eulaRecognizer,
                              ),
                              const TextSpan(text: ', including the zero-tolerance policy on abusive behavior.'),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: () async {
                              await safetyService.acceptEula();
                              Get.offAllNamed(Routes.splashScreen);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColorsValue.appColor,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Accept',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
