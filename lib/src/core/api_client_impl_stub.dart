import 'package:flutter_application_1/src/core/api_client_response.dart';

Future<ApiRawResponse> sendApiRequest({
  required String method,
  required Uri uri,
  required String? accessToken,
  required String? bodyJson,
}) {
  throw UnsupportedError('Aucune implémentation réseau disponible.');
}
