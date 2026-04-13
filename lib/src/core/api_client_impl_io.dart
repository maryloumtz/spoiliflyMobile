import 'dart:convert';
import 'dart:io';

import 'package:flutter_application_1/src/core/api_client_response.dart';

Future<ApiRawResponse> sendApiRequest({
  required String method,
  required Uri uri,
  required String? accessToken,
  required String? bodyJson,
}) async {
  final httpClient = HttpClient();
  final request = await httpClient.openUrl(method, uri);
  request.headers.set(HttpHeaders.acceptHeader, 'application/json');

  if (bodyJson != null) {
    request.headers.set(HttpHeaders.contentTypeHeader, 'application/json');
    request.write(bodyJson);
  }

  if (accessToken != null && accessToken.isNotEmpty) {
    request.headers.set(HttpHeaders.authorizationHeader, 'Bearer $accessToken');
  }

  final response = await request.close();
  final responseBody = await response.transform(utf8.decoder).join();
  return ApiRawResponse(statusCode: response.statusCode, body: responseBody);
}
