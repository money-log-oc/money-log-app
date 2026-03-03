import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/app_config.dart';
import '../model/api_models.dart';

class MoneylogApi {
  final http.Client _client;

  MoneylogApi({http.Client? client}) : _client = client ?? http.Client();

  Uri _u(String path, [Map<String, String>? q]) =>
      Uri.parse('${AppConfig.apiBaseUrl}$path').replace(queryParameters: q);

  Future<HomeSummary> fetchHomeSummary() async {
    final res = await _client.get(_u('/api/v1/home/summary'));
    _ensureOk(res);
    return HomeSummary.fromJson(jsonDecode(res.body));
  }

  Future<List<TransactionItem>> fetchTransactions({String? month, bool unclassified = false}) async {
    final q = <String, String>{
      if (month != null && month.isNotEmpty) 'month': month,
      'unclassified': '$unclassified',
    };
    final res = await _client.get(_u('/api/v1/transactions', q));
    _ensureOk(res);
    return (jsonDecode(res.body) as List).map((e) => TransactionItem.fromJson(e)).toList();
  }

  Future<TransactionItem> updateTransactionTag(int id, List<String> tags) async {
    final res = await _client.patch(
      _u('/api/v1/transactions/$id/tag'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'tagIds': tags}),
    );
    _ensureOk(res);
    return TransactionItem.fromJson(jsonDecode(res.body));
  }

  Future<TransactionItem> updateTransactionExcluded(int id, bool excluded, {String? reason}) async {
    final res = await _client.patch(
      _u('/api/v1/transactions/$id/exclude'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'excluded': excluded, 'reason': reason}),
    );
    _ensureOk(res);
    return TransactionItem.fromJson(jsonDecode(res.body));
  }

  Future<List<TagReportItem>> fetchMonthlyTags(String month) async {
    final res = await _client.get(_u('/api/v1/reports/monthly-tags', {'month': month}));
    _ensureOk(res);
    return (jsonDecode(res.body) as List).map((e) => TagReportItem.fromJson(e)).toList();
  }

  void _ensureOk(http.Response res) {
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('API error ${res.statusCode}: ${res.body}');
    }
  }
}
