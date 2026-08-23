import '../repositories/repository.dart';
import '../models/models.dart';

/// Use case for getting the data from the API
class AuthUseCases {
  AuthUseCases(this.repository);

  final Repository repository;

  Future<SendOtpModel?> sendOtpApi({
    required String mobile,
    required String countryCode,
    required String fcmToken,
    bool isLoading = false,
  }) async =>
      await repository.sendOtpApi(
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
      await repository.verifyOtpApi(
        mobile: mobile,
        key: key,
        otp: otp,
        isLoading: isLoading,
      );

  Future<GetProfileModel?> getProfile({
    bool isLoading = false,
  }) async =>
      await repository.getProfile(
        isLoading: isLoading,
      );

  Future<VerifyOtpModel?> postChangeNumberVerify({
    bool isLoading = false,
    required String key,
    required String otp,
    required String mobile,
  }) async =>
      await repository.postChangeNumberVerify(
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
      await repository.postSubUserLogin(
        username: username,
        password: password,
        fcmToken: fcmToken,
        isLoading: isLoading,
      );
}
