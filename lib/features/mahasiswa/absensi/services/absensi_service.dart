import 'package:dio/dio.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/api_exception.dart';
import '../models/attendance_model.dart';

class AbsensiService {
  final Dio _dio = ApiClient.instance.dio;

  Future<AttendanceModel> scanQr(String qrCode) async {
    try {
      final res = await _dio.post(
        ApiEndpoints.attendanceScan,
        data: {'qrCode': qrCode},
      );
      return AttendanceModel.fromJson(ApiClient.unwrapObject(res.data));
    } on DioException catch (e) {
      final ex = ApiException.fromDio(e);
      if (ex.isEndpointMissing) {
        throw const ApiException(
          'Fitur presensi belum aktif — endpoint scan QR belum '
          'diimplementasikan di backend.',
          statusCode: 404,
        );
      }
      throw ex;
    }
  }

  Future<List<AttendanceModel>> fetchRiwayat() async {
    try {
      final res = await _dio.get(
        ApiEndpoints.attendanceHistory,
        queryParameters: {'page': 1, 'limit': 50},
      );
      return ApiClient.unwrapList(res.data)
          .whereType<Map<String, dynamic>>()
          .map(AttendanceModel.fromJson)
          .toList();
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  Future<AttendanceSummary> fetchSummary() async {
    try {
      final res = await _dio.get(ApiEndpoints.attendanceSummary);
      return AttendanceSummary.fromJson(ApiClient.unwrapObject(res.data));
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }
}
