import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/core/api_client.dart';
import 'package:flutter_application_1/src/core/models.dart';
import 'package:flutter_application_1/src/services/auth_service.dart';

class SessionController extends ChangeNotifier {
  SessionController()
    : _apiClient = ApiClient(),
      _authService = AuthService(ApiClient());

  final ApiClient _apiClient;
  final AuthService _authService;

  AuthSession? _session;

  AuthSession? get session => _session;
  SessionUser? get user => _session?.user;
  String? get accessToken => _session?.accessToken;
  bool get isAuthenticated => _session != null;
  ApiClient get apiClient => _apiClient;

  Future<void> login({required String email, required String password}) async {
    _session = await _authService.login(email: email, password: password);
    notifyListeners();
  }

  Future<void> register({
    required String email,
    required String password,
    required String displayName,
  }) async {
    _session = await _authService.register(
      email: email,
      password: password,
      displayName: displayName,
    );
    notifyListeners();
  }

  void logout() {
    _session = null;
    notifyListeners();
  }
}
