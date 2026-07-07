import 'package:flutter/foundation.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/storage/token_storage.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated }

class AuthProvider extends ChangeNotifier {
  AuthProvider({AuthService? service}) : _service = service ?? AuthService();

  final AuthService _service;

  AuthStatus _status = AuthStatus.initial;
  UserModel? _user;
  StudentModel? _student;
  String? _errorMessage;

  AuthStatus get status => _status;
  UserModel? get user => _user;
  StudentModel? get student => _student;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _status == AuthStatus.loading;

  Future<void> loadSession() async {
    if (!await TokenStorage.instance.hasSession) {
      _status = AuthStatus.unauthenticated;
      notifyListeners();
      return;
    }
    try {
      _user = await _service.fetchMe();
      _student = await _service.fetchStudentProfile();
      _status = AuthStatus.authenticated;
    } on ApiException {
      await TokenStorage.instance.clear();
      _status = AuthStatus.unauthenticated;
    }
    notifyListeners();
  }

  Future<bool> login({
    required String username,
    required String password,
  }) async {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _user = await _service.login(username: username, password: password);
      _student = await _service.fetchStudentProfile();
      _status = AuthStatus.authenticated;
      notifyListeners();
      return true;
    } on ApiException catch (e) {
      _errorMessage = e.message;
      _status = AuthStatus.unauthenticated;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await _service.logout();
    _user = null;
    _student = null;
    _status = AuthStatus.unauthenticated;
    notifyListeners();
  }

  void onSessionExpired() {
    _user = null;
    _student = null;
    _status = AuthStatus.unauthenticated;
    notifyListeners();
  }
}