import 'package:dio/dio.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  const ApiException(this.message, {this.statusCode});

  bool get isEndpointMissing =>
      statusCode == 404 && message.startsWith('Cannot ');

  factory ApiException.fromDio(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const ApiException(
          'Koneksi ke server melebihi batas waktu. Coba lagi.',
        );
      case DioExceptionType.connectionError:
        return const ApiException(
          'Tidak dapat terhubung ke server. Pastikan server berjalan dan '
          'perangkat berada di jaringan yang sama.',
        );
      case DioExceptionType.badResponse:
        return ApiException(
          _extractMessage(error.response),
          statusCode: error.response?.statusCode,
        );
      case DioExceptionType.cancel:
        return const ApiException('Permintaan dibatalkan.');
      default:
        return const ApiException('Terjadi kesalahan. Silakan coba lagi.');
    }
  }

  static String _extractMessage(Response? response) {
    final data = response?.data;
    if (data is Map<String, dynamic>) {
      final msg = data['message'];
      if (msg is String && msg.isNotEmpty) return msg;
      if (msg is List && msg.isNotEmpty) return msg.join('\n');
    }
    return switch (response?.statusCode) {
      400 => 'Data yang dikirim tidak valid.',
      401 => 'Sesi berakhir. Silakan masuk kembali.',
      403 => 'Kamu tidak memiliki akses untuk aksi ini.',
      404 => 'Data tidak ditemukan.',
      _ => 'Terjadi kesalahan pada server (${response?.statusCode ?? '-'}).',
    };
  }

  @override
  String toString() => message;
}