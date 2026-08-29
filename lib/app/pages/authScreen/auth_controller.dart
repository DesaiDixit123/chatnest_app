import 'dart:async';
import 'package:chatnest/app/app.dart';
import 'package:chatnest/app/navigators/navigators.dart';
import 'package:chatnest/domain/domain.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:validators/validators.dart';

class LoginController extends GetxController
    with GetSingleTickerProviderStateMixin {
  LoginController(this.loginPresenter);

  final LoginPresenter loginPresenter;
  bool isbuttonactivate = true;
  bool isValid = false;
  var dailcode = '+91';
  bool isAgreeTerms = false;
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> otpFormKey = GlobalKey<FormState>();
  TextEditingController phonenumbercontroller = TextEditingController();
  TextEditingController otpTextEditingController = TextEditingController();
  late AnimationController countercontroller;

  var firebaseMessaging = FirebaseMessaging.instance;

  String? fcmToken;
  String? demoOtp;

  @override
  onInit() async {
    await firebaseMessaging.getToken().then((token) async {
      fcmToken = token;
      print('🔥 FCM Token Generated: $fcmToken');
    });

    super.onInit();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  int counter = 30;
  Timer? _timer;

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer?.cancel();
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (counter == 0) {
          _timer?.cancel();
          update();
        } else {
          counter--;
          update();
        }
      },
    );
  }

  String? validotp(String value) {
    if (value.isEmpty) {
      return "pleaseenterotp".tr;
    } else if (!(isNumeric(value) && value.length == 6)) {
      return "pleaseenterrightotp".tr;
    } else {
      return null;
    }
  }

  SendOtpData? sendOtpData = SendOtpData();

  String countryCode = "";

  Future<void> sendOtpApi({
    bool isLoading = true,
  }) async {
    final isvalid = loginFormKey.currentState!.validate();
    if (isvalid) {
      if (fcmToken == null || fcmToken!.isEmpty) {
        fcmToken = await firebaseMessaging.getToken();
      }
      print('📤 Sending FCM Token to Backend: $fcmToken');
      var response = await loginPresenter.sendOtpApi(
        isLoading: isLoading,
        mobile: phonenumbercontroller.text,
        countryCode: dailcode,
        fcmToken: fcmToken ?? "",
      );

      if (response?.status == 200) {
        sendOtpData = response?.data;
        demoOtp = response?.data?.demoOtp;
        print('\n========================================');
        print('📱 [OTP RECEIVED] Mobile: ${phonenumbercontroller.text} | OTP: ${demoOtp ?? sendOtpData?.demoOtp}');
        print('========================================\n');
        RouteManagement.goToOtpView("", false, "");
        update();
      } else {
        Utility.errorMessage(response?.message ?? "");
      }
    }
  }

  Future<void> verifyOtpApi({
    bool isLoading = true,
  }) async {
    final isvalid = otpFormKey.currentState!.validate();
    if (isvalid) {
      var response = await loginPresenter.verifyOtpApi(
        isLoading: isLoading,
        mobile: phonenumbercontroller.text,
        key: sendOtpData?.key ?? "",
        otp: otpTextEditingController.text,
      );
      Get.closeAllSnackbars();
      if (response?.status == 200) {
        RouteManagement.goToHomeScreenView();
        update();
      } else {
        Utility.closeDialog();
        Utility.snacBar("otp_error_msg".tr, ColorsValue.maincolor1);
      }
    }
  }

  Future<void> postChangeNumberVerify({
    bool isLoading = true,
  }) async {
    final isvalid = otpFormKey.currentState!.validate();
    if (isvalid) {
      var response = await loginPresenter.postChangeNumberVerify(
        isLoading: isLoading,
        mobile: Get.arguments[2],
        key: Get.arguments[0] ?? "",
        otp: otpTextEditingController.text,
      );
      Get.closeAllSnackbars();
      if (response?.status == 200) {
        RouteManagement.goToHomeScreenView();
        update();
      } else {
        Utility.closeDialog();
        Utility.snacBar("otp_error_msg".tr, ColorsValue.maincolor1);
      }
    }
  }

  /////// ============================================== LoginSubUserScreen =================================================== //////

  GlobalKey<FormState> subUserKey = GlobalKey<FormState>();
  TextEditingController userController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isShow = true;

  Future<void> postSubUserLogin({
    bool isLoading = true,
  }) async {
    final isvalid = subUserKey.currentState!.validate();
    if (isvalid) {
      if (fcmToken == null || fcmToken!.isEmpty) {
        fcmToken = await firebaseMessaging.getToken();
      }
      var response = await loginPresenter.postSubUserLogin(
        isLoading: isLoading,
        password: passwordController.text,
        username: userController.text,
        fcmToken: fcmToken ?? "",
      );
      Get.closeAllSnackbars();
      if (response?.data != null) {
        Get.find<Repository>()
            .saveValue(LocalKeys.userIds, response?.data?.profile?.id ?? "");
        Get.find<Repository>().saveValue(
            LocalKeys.parentUserId, response?.data?.profile?.parentid ?? "");
        Get.find<Repository>().saveValue(
            LocalKeys.chanelId, response?.data?.profile?.channelId ?? "");
        RouteManagement.goToHomeScreenView();
        update();
      } else {
        Utility.errorMessage(response?.message ?? "");
      }
    }
  }
}
