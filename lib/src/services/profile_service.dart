import 'package:flutter_application_1/src/core/api_client.dart';
import 'package:flutter_application_1/src/core/models.dart';

class ProfileService {
  ProfileService(this._apiClient);

  final ApiClient _apiClient;

  Future<ProfilePayload> fetchProfile({required String accessToken}) async {
    final payload =
        await _apiClient.get('/api/profile', accessToken: accessToken)
            as Map<String, dynamic>;

    return ProfilePayload.fromJson(payload);
  }
}
