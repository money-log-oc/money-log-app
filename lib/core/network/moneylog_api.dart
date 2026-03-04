import 'dart:convert';

import 'package:http/http.dart' as http;

import '../auth/auth_api.dart';
import '../auth/auth_session.dart';
import '../config/app_config.dart';
import '../model/api_models.dart';

class MoneylogApi {
  final http.Client _client;
  final AuthApi _authApi;

  MoneylogApi({http.Client? client, AuthApi? authApi})
      : _client = client ?? http.Client(),
        _authApi = authApi ?? AuthApi(client: client);

  Uri _u(String path, [Map<String, String>? q]) =>
      Uri.parse('${AppConfig.apiBaseUrl}$path').replace(queryParameters: q);

  Future<HomeSummary> fetchHomeSummary() async {
    final res = await _authedGet(_u('/api/home/summary'));
    _ensureOk(res);
    return HomeSummary.fromJson(jsonDecode(res.body));
  }

  Future<List<TransactionItem>> fetchTransactions(
      {String? month, bool unclassified = false}) async {
    final q = <String, String>{
      if (month != null && month.isNotEmpty) 'month': month,
      'unclassified': '$unclassified',
    };
    final res = await _authedGet(_u('/api/transactions', q));
    _ensureOk(res);
    return (jsonDecode(res.body) as List)
        .map((e) => TransactionItem.fromJson(e))
        .toList();
  }

  Future<TransactionItem> updateTransactionTag(
      int id, List<String> tags) async {
    final res = await _authedPatch(
      _u('/api/transactions/$id/tag'),
      body: jsonEncode({'tagIds': tags}),
    );
    _ensureOk(res);
    return TransactionItem.fromJson(jsonDecode(res.body));
  }

  Future<TransactionItem> updateTransactionExcluded(int id, bool excluded,
      {String? reason}) async {
    final res = await _authedPatch(
      _u('/api/transactions/$id/exclude'),
      body: jsonEncode({'excluded': excluded, 'reason': reason}),
    );
    _ensureOk(res);
    return TransactionItem.fromJson(jsonDecode(res.body));
  }

  Future<List<TagReportItem>> fetchMonthlyTags(String month) async {
    final res =
        await _authedGet(_u('/api/reports/monthly-tags', {'month': month}));
    _ensureOk(res);
    return (jsonDecode(res.body) as List)
        .map((e) => TagReportItem.fromJson(e))
        .toList();
  }

  Future<List<DailySpendingItem>> fetchDailySpending(String month) async {
    final res =
        await _authedGet(_u('/api/reports/daily-spending', {'month': month}));
    _ensureOk(res);
    return (jsonDecode(res.body) as List)
        .map((e) => DailySpendingItem.fromJson(e))
        .toList();
  }

  Future<http.Response> _authedGet(Uri uri) async {
    var res = await _client.get(uri, headers: _authHeaders());
    if (res.statusCode == 401 || res.statusCode == 403) {
      final refreshed = await _tryRefreshToken();
      if (refreshed) {
        res = await _client.get(uri, headers: _authHeaders());
      }
    }
    return res;
  }

  Future<http.Response> _authedPatch(Uri uri, {required String body}) async {
    var res = await _client.patch(uri, headers: _jsonAuthHeaders(), body: body);
    if (res.statusCode == 401 || res.statusCode == 403) {
      final refreshed = await _tryRefreshToken();
      if (refreshed) {
        res = await _client.patch(uri, headers: _jsonAuthHeaders(), body: body);
      }
    }
    return res;
  }

  Map<String, String> _authHeaders() => {
        if ((AuthSession.accessToken ?? '').isNotEmpty)
          'Authorization': 'Bearer ${AuthSession.accessToken}',
      };

  Map<String, String> _jsonAuthHeaders() => {
        'Content-Type': 'application/json',
        ..._authHeaders(),
      };

  Future<bool> _tryRefreshToken() async {
    final refresh = AuthSession.refreshToken;
    if (refresh == null || refresh.isEmpty) return false;
    try {
      final out = await _authApi.refresh(refresh);
      await AuthSession.save(
          access: out.accessToken, refresh: out.refreshToken, uid: out.userId);
      return true;
    } catch (_) {
      await AuthSession.clear();
      return false;
    }
  }

  void _ensureOk(http.Response res) {
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('API error ${res.statusCode}: ${res.body}');
    }
  }
}
