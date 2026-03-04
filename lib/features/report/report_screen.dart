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
  late String _month;
  late Future<ReportData> _report;

  @override
  void initState() {
    super.initState();
    _api = MoneylogApi();
    final now = DateTime.now();
    _month = '${now.year}-${now.month.toString().padLeft(2, '0')}';
    _report = _fetch();
  }

  Future<ReportData> _fetch() async {
    final tags = await _api.fetchMonthlyTags(_month);
    final daily = await _api.fetchDailySpending(_month);
    return ReportData(tags: tags, daily: daily);
  }

  String won(int v) =>
      '${v.toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => ',')}원';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('리포트',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
              DropdownButton<String>(
                value: _month,
                onChanged: (v) {
                  if (v == null) return;
                  setState(() {
                    _month = v;
                    _report = _fetch();
                  });
                },
                items: List.generate(3, (i) {
                  final d = DateTime.now().subtract(Duration(days: i * 30));
                  final v = '${d.year}-${d.month.toString().padLeft(2, '0')}';
                  return DropdownMenuItem(value: v, child: Text(v));
                }),
              ),
            ],
          ),
          FutureBuilder<ReportData>(
            future: _report,
            builder: (context, snap) {
              if (snap.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.all(40),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              if (snap.hasError) {
                return Column(children: [
                  Text('리포트를 불러오지 못했어요\n${snap.error}',
                      textAlign: TextAlign.center),
                  const SizedBox(height: 8),
                  FilledButton(
                    onPressed: () => setState(() => _report = _fetch()),
                    child: const Text('다시 시도'),
                  )
                ]);
              }

              final data = snap.data!;
              final total = data.tags.fold<int>(0, (a, b) => a + b.amount);

              return Column(
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('이번 달 총 지출',
                                style: TextStyle(color: Colors.grey)),
                            const SizedBox(height: 6),
                            Text(won(total),
                                style: const TextStyle(
                                    fontSize: 34, fontWeight: FontWeight.w700)),
                          ]),
                    ),
                  ),
                  if (data.tags.isEmpty)
                    const Card(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Text('태그 리포트 데이터가 없어요.'),
                      ),
                    )
                  else
                    _TagChartCard(items: data.tags),
                  const SizedBox(height: 8),
                  if (data.daily.isEmpty)
                    const Card(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Text('일별 지출 데이터가 없어요.'),
                      ),
                    )
                  else
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('일별 지출',
                                style: TextStyle(fontWeight: FontWeight.w700)),
                            const SizedBox(height: 8),
                            ...data.daily.take(10).map(
                                  (d) => Padding(
                                    padding: const EdgeInsets.only(bottom: 6),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                            width: 90,
                                            child: Text(d.date.substring(5))),
                                        Expanded(child: Text(won(d.expense))),
                                      ],
                                    ),
                                  ),
                                ),
                          ],
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _TagChartCard extends StatelessWidget {
  final List<TagReportItem> items;
  const _TagChartCard({required this.items});

  @override
  Widget build(BuildContext context) {
    final maxVal = items.map((e) => e.amount).reduce((a, b) => a > b ? a : b);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: items.map((e) {
            final w = maxVal == 0 ? 0.0 : e.amount / maxVal;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(children: [
                SizedBox(width: 70, child: Text(e.tag)),
                Expanded(
                  child: Stack(children: [
                    Container(
                      height: 8,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF3F8),
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                    FractionallySizedBox(
                      widthFactor: w,
                      child: Container(
                        height: 8,
                        decoration: BoxDecoration(
                          color: const Color(0xFF2F80FF),
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                    ),
                  ]),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: 72,
                  child: Text('${(e.amount / 10000).toStringAsFixed(1)}만',
                      textAlign: TextAlign.right),
                ),
              ]),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class ReportData {
  final List<TagReportItem> tags;
  final List<DailySpendingItem> daily;

  ReportData({required this.tags, required this.daily});
}
