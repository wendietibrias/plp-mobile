import 'package:dio/dio.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/api_exception.dart';
import '../models/class_schedule_model.dart';

class KelasService {
  final Dio _dio = ApiClient.instance.dio;

  Future<List<ClassScheduleModel>> fetchJadwalByClass(int classId) async {
    try {
      final res = await _dio.get(ApiEndpoints.schedulesByClass(classId));
      return ApiClient.unwrapList(res.data)
          .whereType<Map<String, dynamic>>()
          .map(ClassScheduleModel.fromJson)
          .toList();
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  Future<List<PertemuanModel>> fetchPertemuan(int scheduleId) async {
    try {
      final res = await _dio.get(ApiEndpoints.sessionsBySchedule(scheduleId));
      final list = ApiClient.unwrapList(res.data);
      return [
        for (var i = 0; i < list.length; i++)
          if (list[i] is Map<String, dynamic>)
            PertemuanModel.fromJson(list[i] as Map<String, dynamic>, i),
      ];
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }
}
