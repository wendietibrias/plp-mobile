import 'package:flutter/foundation.dart';

import '../../../../core/network/api_exception.dart';
import '../models/attendance_model.dart';
import '../services/absensi_service.dart';

class AbsensiProvider extends ChangeNotifier {
  AbsensiProvider({AbsensiService? service})
      : _service = service ?? AbsensiService();

  final AbsensiService _service;

  bool _isSubmitting = false;
  bool get isSubmitting => _isSubmitting;

  AttendanceModel? _lastResult;
  AttendanceModel? get lastResult => _lastResult;

  Future<AttendanceModel> submitScan(String qrCode) async {
    if (_isSubmitting) {
      throw const ApiException('Sedang memproses, mohon tunggu…');
    }
    _isSubmitting = true;
    notifyListeners();

    try {
      _lastResult = await _service.scanQr(qrCode);
      return _lastResult!;
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }

  void reset() {
    _isSubmitting = false;
    _lastResult = null;
    notifyListeners();
  }
}
