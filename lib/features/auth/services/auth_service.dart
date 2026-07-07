import 'package:dio/dio.dart';

import '../../../core/network/api_client.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/storage/token_storage.dart';
import '../models/user_model.dart';

class AuthService {
  final Dio _dio = ApiClient.instance.dio;

  Future<UserModel> login({
    required String username,
    required String password,
  }) async {
    try {
      final res = await _dio.post(
        ApiEndpoints.login,
        data: {'username': username, 'password': password},
      );

      final data = ApiClient.unwrapObject(res.data);
      final access = data['access'] as String?;
      final refresh = data['refresh'] as String?;
      if (access == null) {
        throw const ApiException(
          'Server tidak mengirim access token. '
          'Pastikan patch backend sudah diterapkan.',
        );
      }

      await TokenStorage.instance.saveTokens(
        accessToken: access,
        refreshToken: refresh,
      );

      return UserModel.fromJson(data['user'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  Future<UserModel> fetchMe() async {
    try {
      final res = await _dio.get(ApiEndpoints.me);
      return UserModel.fromJson(ApiClient.unwrapObject(res.data));
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  Future<StudentModel?> fetchStudentProfile() async {
    try {
      final res = await _dio.get(ApiEndpoints.studentMe);
      return StudentModel.fromJson(ApiClient.unwrapObject(res.data));
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return null;
      throw ApiException.fromDio(e);
    }
  }

  Future<void> logout() async {
    try {
      await _dio.post(ApiEndpoints.logout);
    } catch (_) {
    } finally {
      await TokenStorage.instance.clear();
    }
  }
}
