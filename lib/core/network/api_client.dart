import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../constants/api_constants.dart';
import '../constants/app_constants.dart';
import '../errors/exceptions.dart';

class ApiClient {
  final http.Client _client;
  String? _authToken;

  ApiClient({http.Client? client}) : _client = client ?? http.Client();

  void setAuthToken(String? token) {
    _authToken = token;
  }

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        if (_authToken != null) 'Authorization': 'Bearer $_authToken',
      };

  Uri _buildUri(String endpoint) {
    return Uri.parse('${ApiConstants.baseUrl}${ApiConstants.apiVersion}$endpoint');
  }

  Future<Map<String, dynamic>> get(String endpoint) async {
    try {
      final response = await _client
          .get(_buildUri(endpoint), headers: _headers)
          .timeout(AppConstants.connectionTimeout);
      return _handleResponse(response);
    } on SocketException {
      throw const NetworkException(message: 'Sin conexión a internet');
    }
  }

  Future<Map<String, dynamic>> post(
    String endpoint, {
    Map<String, dynamic>? body,
  }) async {
    try {
      final response = await _client
          .post(
            _buildUri(endpoint),
            headers: _headers,
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(AppConstants.connectionTimeout);
      return _handleResponse(response);
    } on SocketException {
      throw const NetworkException(message: 'Sin conexión a internet');
    }
  }

  Future<Map<String, dynamic>> put(
    String endpoint, {
    Map<String, dynamic>? body,
  }) async {
    try {
      final response = await _client
          .put(
            _buildUri(endpoint),
            headers: _headers,
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(AppConstants.connectionTimeout);
      return _handleResponse(response);
    } on SocketException {
      throw const NetworkException(message: 'Sin conexión a internet');
    }
  }

  Future<Map<String, dynamic>> delete(String endpoint) async {
    try {
      final response = await _client
          .delete(_buildUri(endpoint), headers: _headers)
          .timeout(AppConstants.connectionTimeout);
      return _handleResponse(response);
    } on SocketException {
      throw const NetworkException(message: 'Sin conexión a internet');
    }
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    final body = response.body.isNotEmpty 
        ? jsonDecode(response.body) as Map<String, dynamic>
        : <String, dynamic>{};

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return body;
    } else if (response.statusCode == 401) {
      throw AuthException(
        message: body['message'] as String? ?? 'No autorizado',
      );
    } else {
      throw ServerException(
        message: body['message'] as String? ?? 'Error del servidor',
        statusCode: response.statusCode,
      );
    }
  }

  void dispose() {
    _client.close();
  }
}
