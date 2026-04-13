// ignore_for_file: deprecated_member_use, avoid_web_libraries_in_flutter

import 'dart:html' as html;

import 'package:flutter_application_1/src/core/api_client_response.dart';

Future<ApiRawResponse> sendApiRequest({
  required String method,
  required Uri uri,
  required String? accessToken,
  required String? bodyJson,
}) async {
  final headers = <String, String>{'Accept': 'application/json'};
  if (bodyJson != null) {
    headers['Content-Type'] = 'application/json';
  }
  if (accessToken != null && accessToken.isNotEmpty) {
    headers['Authorization'] = 'Bearer $accessToken';
  }

  final response = await html.HttpRequest.request(
    uri.toString(),
    method: method,
    sendData: bodyJson,
    requestHeaders: headers,
  );

  return ApiRawResponse(
    statusCode: response.status ?? 200,
    body: response.responseText ?? '',
  );
}
