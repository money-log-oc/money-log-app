import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/app_config.dart';

class AuthResult {
  final String accessToken;
  final String refreshToken;
  final String userId;

  AuthResult(
      {required this.accessToken,
      required this.refreshToken,
      required this.userId});

  factory AuthResult.fromJson(Map<String, dynamic> j) => AuthResult(
        accessToken: (j['accessToken'] ?? '') as String,
        refreshToken: (j['refreshToken'] ?? '') as String,
        userId: (j['userId'] ?? '') as String,
      );
}

class AuthApi {
  final http.Client _client;
  AuthApi({http.Client? client}) : _client = client ?? http.Client();

  Future<AuthResult> loginWithKakao(String kakaoAccessToken) async {
    final uri = Uri.parse('${AppConfig.apiBaseUrl}/api/auth/kakao');
    final res = await _client.post(uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'accessToken': kakaoAccessToken}));
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('Login failed ${res.statusCode}: ${res.body}');
    }
    return AuthResult.fromJson(jsonDecode(res.body));
  }

  Future<AuthResult> refresh(String refreshToken) async {
    final uri = Uri.parse('${AppConfig.apiBaseUrl}/api/auth/refresh');
    final res = await _client.post(uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'refreshToken': refreshToken}));
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('Refresh failed ${res.statusCode}: ${res.body}');
    }
    return AuthResult.fromJson(jsonDecode(res.body));
  }
}
