import 'package:flutter/material.dart';

import '../../core/model/api_models.dart';
import '../../core/network/moneylog_api.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  late final MoneylogApi _api;
  late Future<List<TagReportItem>> _tags;

  @override
  void initState() {
    super.initState();
    _api = MoneylogApi();
    _tags = _api.fetchMonthlyTags('2026-03');
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          const Text('리포트', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
                Text('이번 달 총 지출', style: TextStyle(color: Colors.grey)),
                SizedBox(height: 6),
                Text('262,300원', style: TextStyle(fontSize: 34, fontWeight: FontWeight.w700)),
              ]),
            ),
          ),
          FutureBuilder<List<TagReportItem>>(
            future: _tags,
            builder: (context, snap) {
              if (snap.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snap.hasError) {
                return Column(children: [
                  Text('리포트를 불러오지 못했어요\n${snap.error}', textAlign: TextAlign.center),
                  const SizedBox(height: 8),
                  FilledButton(
                    onPressed: () => setState(() => _tags = _api.fetchMonthlyTags('2026-03')),
                    child: const Text('다시 시도'),
                  )
                ]);
              }

              final items = snap.data!;
              if (items.isEmpty) {
                return const Card(child: Padding(padding: EdgeInsets.all(16), child: Text('리포트 데이터가 없어요.')));
              }
              final maxVal = items.map((e) => e.amount).reduce((a, b) => a > b ? a : b);

              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: items.map((e) {
                      final w = e.amount / maxVal;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(children: [
                          SizedBox(width: 60, child: Text(e.tag)),
                          Expanded(
                            child: Stack(children: [
                              Container(height: 8, decoration: BoxDecoration(color: const Color(0xFFEFF3F8), borderRadius: BorderRadius.circular(999))),
                              FractionallySizedBox(widthFactor: w, child: Container(height: 8, decoration: BoxDecoration(color: const Color(0xFF2F80FF), borderRadius: BorderRadius.circular(999)))),
                            ]),
                          ),
                          const SizedBox(width: 8),
                          SizedBox(width: 64, child: Text('${(e.amount / 10000).toStringAsFixed(1)}만', textAlign: TextAlign.right)),
                        ]),
                      );
                    }).toList(),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
