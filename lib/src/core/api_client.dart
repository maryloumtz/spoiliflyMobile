import 'dart:convert';

import 'package:flutter_application_1/src/core/api_client_impl_stub.dart'
    if (dart.library.io) 'package:flutter_application_1/src/core/api_client_impl_io.dart'
    if (dart.library.js_interop) 'package:flutter_application_1/src/core/api_client_impl_web.dart';
import 'package:flutter_application_1/src/core/config.dart';

class ApiException implements Exception {
  ApiException(this.message, {this.fieldErrors = const {}});

  final String message;
  final Map<String, String> fieldErrors;
}

class ApiClient {
  Future<dynamic> get(
    String path, {
    String? accessToken,
    Map<String, String> query = const {},
  }) {
    return _send('GET', path, accessToken: accessToken, query: query);
  }

  Future<dynamic> post(String path, {String? accessToken, Object? body}) {
    return _send('POST', path, accessToken: accessToken, body: body);
  }

  Future<dynamic> patch(String path, {String? accessToken, Object? body}) {
    return _send('PATCH', path, accessToken: accessToken, body: body);
  }

  Future<dynamic> _send(
    String method,
    String path, {
    String? accessToken,
    Map<String, String> query = const {},
    Object? body,
  }) async {
    final baseUri = Uri.parse(AppConfig.apiBaseUrl);
    final uri = baseUri.resolveUri(
      Uri(path: path, queryParameters: query.isEmpty ? null : query),
    );

    final response = await sendApiRequest(
      method: method,
      uri: uri,
      accessToken: accessToken,
      bodyJson: body == null ? null : jsonEncode(body),
    );

    final decoded = response.body.isEmpty ? null : jsonDecode(response.body);

    if (response.statusCode >= 400) {
      final map = decoded is Map<String, dynamic>
          ? decoded
          : <String, dynamic>{};
      final rawFieldErrors = map['fieldErrors'];
      final fieldErrors = <String, String>{};
      if (rawFieldErrors is Map) {
        for (final entry in rawFieldErrors.entries) {
          fieldErrors['${entry.key}'] = '${entry.value}';
        }
      }
      throw ApiException(
        map['error']?.toString() ?? 'Une erreur est survenue.',
        fieldErrors: fieldErrors,
      );
    }

    return decoded;
  }
}
