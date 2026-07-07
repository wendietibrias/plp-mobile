import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../storage/token_storage.dart';
import 'api_endpoints.dart';
import 'api_exception.dart';

class ApiClient {
  ApiClient._() {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 20),
        headers: {'Accept': 'application/json'},
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(onRequest: _onRequest, onError: _onError),
    );

    if (kDebugMode) {
      dio.interceptors.add(
        LogInterceptor(requestBody: true, responseBody: true),
      );
    }
  }

  static final ApiClient instance = ApiClient._();

  late final Dio dio;

  VoidCallback? onSessionExpired;

  bool _isRefreshing = false;

  Future<void> _onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (options.path != ApiEndpoints.login &&
        options.path != ApiEndpoints.refreshToken) {
      final token = await TokenStorage.instance.accessToken;
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }
    handler.next(options);
  }

  Future<void> _onError(
    DioException error,
    ErrorInterceptorHandler handler,
  ) async {
    final response = error.response;
    final isAuthPath = error.requestOptions.path == ApiEndpoints.login ||
        error.requestOptions.path == ApiEndpoints.refreshToken;
    final alreadyRetried = error.requestOptions.extra['retried'] == true;

    if (response?.statusCode == 401 && !isAuthPath && !alreadyRetried) {
      final refreshed = await _tryRefreshToken();
      if (refreshed) {
        try {
          final retried = await _retry(error.requestOptions);
          return handler.resolve(retried);
        } on DioException catch (e) {
          return handler.next(e);
        }
      }
      await TokenStorage.instance.clear();
      onSessionExpired?.call();
    }

    handler.next(error);
  }

  Future<bool> _tryRefreshToken() async {
    if (_isRefreshing) return false;
    _isRefreshing = true;
    try {
      final refreshToken = await TokenStorage.instance.refreshToken;
      if (refreshToken == null) return false;

      final plainDio = Dio(BaseOptions(baseUrl: ApiEndpoints.baseUrl));
      final res = await plainDio.patch(
        ApiEndpoints.refreshToken,
        options: Options(headers: {'Authorization': 'Bearer $refreshToken'}),
      );

      final data = res.data is Map ? res.data['data'] : null;
      final newAccess = data is Map ? data['access'] as String? : null;
      final newRefresh = data is Map ? data['refresh'] as String? : null;
      if (newAccess == null) return false;

      await TokenStorage.instance.saveTokens(
        accessToken: newAccess,
        refreshToken: newRefresh,
      );
      return true;
    } catch (_) {
      return false;
    } finally {
      _isRefreshing = false;
    }
  }

  Future<Response<dynamic>> _retry(RequestOptions options) async {
    final token = await TokenStorage.instance.accessToken;
    options.extra['retried'] = true;
    options.headers['Authorization'] = 'Bearer $token';
    return dio.fetch(options);
  }

  static Map<String, dynamic> unwrapObject(dynamic body) {
    if (body is Map<String, dynamic>) {
      final data = body['data'];
      if (data is Map<String, dynamic>) return data;
      if (data == null) return body;
    }
    throw const ApiException('Format response server tidak dikenali.');
  }

  static List<dynamic> unwrapList(dynamic body) {
    if (body is List) return body;
    if (body is Map<String, dynamic>) {
      final data = body['data'];
      if (data is List) return data;
      if (data is Map<String, dynamic> && data['items'] is List) {
        return data['items'] as List;
      }
      if (body['items'] is List) return body['items'] as List;
    }
    return const [];
  }
}
