import 'package:flutter/foundation.dart';

import '../../../../core/network/api_exception.dart';
import '../../absensi/models/attendance_model.dart';
import '../../absensi/services/absensi_service.dart';

enum RiwayatState { initial, loading, loaded, error }

class RiwayatProvider extends ChangeNotifier {
  RiwayatProvider({AbsensiService? service})
      : _service = service ?? AbsensiService();

  final AbsensiService _service;

  RiwayatState _state = RiwayatState.initial;
  List<AttendanceModel> _items = [];
  AttendanceSummary? _summary;
  String? _errorMessage;
  bool _endpointMissing = false;

  RiwayatState get state => _state;
  List<AttendanceModel> get items => _items;
  AttendanceSummary? get summary => _summary;
  String? get errorMessage => _errorMessage;

  bool get endpointMissing => _endpointMissing;

  Future<void> fetch({bool refresh = false}) async {
    if (_state == RiwayatState.loaded && !refresh) return;

    _state = RiwayatState.loading;
    notifyListeners();

    try {
      final results = await Future.wait([
        _service.fetchRiwayat(),
        _service.fetchSummary().then<AttendanceSummary?>((s) => s).catchError(
              (_) => null,
            ),
      ]);

      _items = results[0] as List<AttendanceModel>;
      _summary = results[1] as AttendanceSummary?;
      _summary ??= _buildSummaryFromItems();
      _state = RiwayatState.loaded;
      _errorMessage = null;
      _endpointMissing = false;
    } on ApiException catch (e) {
      _state = RiwayatState.error;
      _endpointMissing = e.isEndpointMissing;
      _errorMessage = _endpointMissing
          ? 'Riwayat kehadiran belum tersedia — endpoint absensi '
              'belum diimplementasikan di backend.'
          : e.message;
    }
    notifyListeners();
  }

  AttendanceSummary _buildSummaryFromItems() {
    final hadir = _items.length;
    final terlambat = _items.where((e) => !e.tepatWaktu).length;
    return AttendanceSummary(
      hadir: hadir,
      totalSesi: hadir,
      terlambat: terlambat,
      izin: 0,
      alpa: 0,
    );
  }

  void reset() {
    _state = RiwayatState.initial;
    _items = [];
    _summary = null;
    _errorMessage = null;
    _endpointMissing = false;
    notifyListeners();
  }
}
