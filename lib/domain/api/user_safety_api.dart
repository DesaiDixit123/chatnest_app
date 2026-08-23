import 'package:chatnest/data/helpers/api_wrapper.dart';
import 'package:chatnest/app/utils/utility.dart';
import 'package:dio/dio.dart';

class UserSafetyApi {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: ApiWrapper.baseUrl,
    headers: {
      'Content-Type': 'application/json',
    },
  ));

  Map<String, String> _getHeaders() {
    return {
      'Content-Type': 'application/json',
      'Authorization': Utility.headers(),
    };
  }

  Future<void> reportContent(
      {required String contentId, required String reason}) async {
    final response = await _dio.post(
      '/apis/v2/safety/report',
      data: {
        'contentId': contentId,
        'reason': reason,
      },
      options: Options(headers: _getHeaders()),
    );
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to report content');
    }
  }

  Future<void> blockUser({required String userId}) async {
    final response = await _dio.post(
      '/apis/v2/safety/block',
      data: {
        'blockedUserId': userId,
      },
      options: Options(headers: _getHeaders()),
    );
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to block user');
    }
  }

  Future<void> unblockUser({required String userId}) async {
    final response = await _dio.post(
      '/apis/v2/safety/unblock',
      data: {
        'blockedUserId': userId,
      },
      options: Options(headers: _getHeaders()),
    );
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to unblock user');
    }
  }

  Future<bool> checkBlockStatus({required String userId}) async {
    try {
      final response = await _dio.get(
        '/apis/v2/safety/check',
        queryParameters: {
          'userId': userId,
        },
        options: Options(headers: _getHeaders()),
      );
      if (response.statusCode == 200 && response.data != null) {
        final data = response.data['data'] ?? response.data['Data'];
        if (data != null) {
          return (data['blocked'] ?? false) as bool;
        }
      }
    } catch (e) {
      // ignore check failures
    }
    return false;
  }

  Future<String> getTerms() async {
    final response = await _dio.get(
      '/apis/v2/safety/terms',
      options: Options(headers: {
        'Content-Type': 'application/json',
      }),
    );
    if (response.statusCode == 200 && response.data != null) {
      final data = response.data['data'] ?? response.data['Data'];
      if (data != null && data['terms'] != null) {
        return data['terms'] as String;
      }
    }
    throw Exception('Failed to retrieve terms');
  }
}
