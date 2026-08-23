import 'package:chatnest/domain/domain.dart';

class LoginPresenter {
  LoginPresenter(this.authUseCases);

  final AuthUseCases authUseCases;

  Future<SendOtpModel?> sendOtpApi({
    required String mobile,
    required String countryCode,
    required String fcmToken,
    bool isLoading = false,
  }) async =>
      await authUseCases.sendOtpApi(
        mobile: mobile,
        countryCode: countryCode,
        fcmToken: fcmToken,
        isLoading: isLoading,
      );

  Future<VerifyOtpModel?> verifyOtpApi({
    required String key,
    required String otp,
    required String mobile,
    bool isLoading = false,
  }) async =>
      await authUseCases.verifyOtpApi(
        mobile: mobile,
        key: key,
        otp: otp,
        isLoading: isLoading,
      );

  Future<GetProfileModel?> getProfile({
    bool isLoading = false,
  }) async =>
      await authUseCases.getProfile(
        isLoading: isLoading,
      );

  Future<VerifyOtpModel?> postChangeNumberVerify({
    bool isLoading = false,
    required String key,
    required String otp,
    required String mobile,
  }) async =>
      await authUseCases.postChangeNumberVerify(
        key: key,
        otp: otp,
        mobile: mobile,
        isLoading: isLoading,
      );

  Future<SubUserLoginModel?> postSubUserLogin({
    bool isLoading = false,
    required String username,
    required String password,
    required String fcmToken,
  }) async =>
      await authUseCases.postSubUserLogin(
        username: username,
        password: password,
        fcmToken: fcmToken,
        isLoading: isLoading,
      );
}
