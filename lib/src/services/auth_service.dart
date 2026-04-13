import 'package:flutter_application_1/src/core/api_client.dart';
import 'package:flutter_application_1/src/core/models.dart';

class AuthService {
  AuthService(this._apiClient);

  final ApiClient _apiClient;

  Future<AuthSession> login({
    required String email,
    required String password,
  }) async {
    final payload =
        await _apiClient.post(
              '/api/auth/login',
              body: {'email': email, 'password': password},
            )
            as Map<String, dynamic>;

    return AuthSession.fromJson(payload);
  }

  Future<AuthSession> register({
    required String email,
    required String password,
    required String displayName,
  }) async {
    final payload =
        await _apiClient.post(
              '/api/auth/register',
              body: {
                'email': email,
                'password': password,
                'displayName': displayName,
              },
            )
            as Map<String, dynamic>;

    return AuthSession.fromJson(payload);
  }
}
