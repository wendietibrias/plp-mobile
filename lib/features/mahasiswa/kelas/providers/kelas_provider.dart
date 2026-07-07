import 'package:flutter/foundation.dart';

import '../../../../core/network/api_exception.dart';
import '../models/class_schedule_model.dart';
import '../services/kelas_service.dart';

enum ViewState { initial, loading, loaded, error }

class KelasProvider extends ChangeNotifier {
  KelasProvider({KelasService? service})
      : _service = service ?? KelasService();

  final KelasService _service;

  ViewState _state = ViewState.initial;
  List<ClassScheduleModel> _jadwal = [];
  String? _errorMessage;

  ViewState get state => _state;
  List<ClassScheduleModel> get jadwal => _jadwal;
  String? get errorMessage => _errorMessage;

  List<ClassScheduleModel> get jadwalHariIni => _jadwal
      .where((j) => j.isToday && j.status == 'active')
      .toList()
    ..sort((a, b) => a.startMinutes.compareTo(b.startMinutes));

  ClassScheduleModel? get kelasSelanjutnya {
    final now = DateTime.now();
    final nowMinutes = now.hour * 60 + now.minute;
    final hariIni = jadwalHariIni;
    for (final j in hariIni) {
      if (j.startMinutes >= nowMinutes) return j;
    }
    if (hariIni.isNotEmpty) return hariIni.first;
    final aktif = _jadwal.where((j) => j.status == 'active').toList();
    return aktif.isEmpty ? null : aktif.first;
  }

  Future<void> fetchJadwal(int? classId, {bool refresh = false}) async {
    if (_state == ViewState.loaded && !refresh) return; // cache sederhana

    if (classId == null) {
      _state = ViewState.error;
      _errorMessage =
          'Akun ini belum terdaftar pada kelas manapun. Hubungi admin akademik.';
      notifyListeners();
      return;
    }

    _state = ViewState.loading;
    notifyListeners();

    try {
      _jadwal = await _service.fetchJadwalByClass(classId);
      _state = ViewState.loaded;
      _errorMessage = null;
    } on ApiException catch (e) {
      _state = ViewState.error;
      _errorMessage = e.message;
    }
    notifyListeners();
  }

  ViewState _pertemuanState = ViewState.initial;
  List<PertemuanModel> _pertemuan = [];
  String? _pertemuanError;
  int? _loadedScheduleId;

  ViewState get pertemuanState => _pertemuanState;
  List<PertemuanModel> get pertemuan => _pertemuan;
  String? get pertemuanError => _pertemuanError;

  Future<void> fetchPertemuan(int scheduleId, {bool refresh = false}) async {
    if (_loadedScheduleId == scheduleId &&
        _pertemuanState == ViewState.loaded &&
        !refresh) {
      return;
    }

    _pertemuanState = ViewState.loading;
    _pertemuan = [];
    notifyListeners();

    try {
      _pertemuan = await _service.fetchPertemuan(scheduleId);
      _loadedScheduleId = scheduleId;
      _pertemuanState = ViewState.loaded;
      _pertemuanError = null;
    } on ApiException catch (e) {
      _pertemuanState = ViewState.error;
      _pertemuanError = e.isEndpointMissing
          ? 'Data pertemuan belum tersedia — endpoint course-sessions '
              'belum diimplementasikan di backend.'
          : e.message;
    }
    notifyListeners();
  }

  void reset() {
    _state = ViewState.initial;
    _jadwal = [];
    _errorMessage = null;
    _pertemuanState = ViewState.initial;
    _pertemuan = [];
    _pertemuanError = null;
    _loadedScheduleId = null;
    notifyListeners();
  }
}
