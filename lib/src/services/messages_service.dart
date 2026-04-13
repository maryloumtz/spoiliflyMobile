import 'package:flutter_application_1/src/core/api_client.dart';
import 'package:flutter_application_1/src/core/models.dart';

class MessagesService {
  MessagesService(this._apiClient);

  final ApiClient _apiClient;

  Future<MessagesPayload> fetchMessages({required String accessToken}) async {
    final payload =
        await _apiClient.get('/api/messages', accessToken: accessToken)
            as Map<String, dynamic>;
    return MessagesPayload.fromJson(payload);
  }

  Future<void> sendMessage({
    required String accessToken,
    required String recipientEmail,
    required String content,
  }) async {
    await _apiClient.post(
      '/api/messages',
      accessToken: accessToken,
      body: {'recipientEmail': recipientEmail, 'content': content},
    );
  }
}
