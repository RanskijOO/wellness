import 'dart:convert';

import 'package:http/http.dart' as http;

class RestClient {
  RestClient({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Future<Map<String, dynamic>> getJson(
    Uri uri, {
    Map<String, String> headers = const <String, String>{},
  }) async {
    final http.Response response = await _client.get(uri, headers: headers);
    return _decodeResponse(response);
  }

  Future<Map<String, dynamic>> postJson(
    Uri uri, {
    Map<String, String> headers = const <String, String>{},
    Map<String, dynamic> body = const <String, dynamic>{},
  }) async {
    final http.Response response = await _client.post(
      uri,
      headers: <String, String>{'Content-Type': 'application/json', ...headers},
      body: jsonEncode(body),
    );
    return _decodeResponse(response);
  }

  Map<String, dynamic> _decodeResponse(http.Response response) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw RestClientException(
        statusCode: response.statusCode,
        body: response.body,
      );
    }

    final Object? decoded = jsonDecode(response.body);
    if (decoded is Map<String, dynamic>) {
      return decoded;
    }

    return <String, dynamic>{'data': decoded};
  }
}

class RestClientException implements Exception {
  const RestClientException({required this.statusCode, required this.body});

  final int statusCode;
  final String body;

  @override
  String toString() =>
      'RestClientException(statusCode: $statusCode, body: $body)';
}
