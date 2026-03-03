import 'package:flutter/material.dart';

import '../../core/model/api_models.dart';
import '../../core/network/moneylog_api.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final MoneylogApi _api;
  late Future<HomeSummary> _summary;

  @override
  void initState() {
    super.initState();
    _api = MoneylogApi();
    _summary = _api.fetchHomeSummary();
  }

  String won(int v) => '${v.toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => ',')}원';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FutureBuilder<HomeSummary>(
        future: _summary,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Text('홈 데이터를 불러오지 못했어요\n${snap.error}', textAlign: TextAlign.center),
                const SizedBox(height: 8),
                FilledButton(
                  onPressed: () => setState(() => _summary = _api.fetchHomeSummary()),
                  child: const Text('다시 시도'),
                )
              ]),
            );
          }

          final s = snap.data!;

          Widget stat(String label, String value) => Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                      const SizedBox(height: 6),
                      Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700)),
                    ]),
                  ),
                ),
              );

          return ListView(
            padding: const EdgeInsets.all(12),
            children: [
              const Text('홈', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              Card(
                color: const Color(0xFF2F80FF),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const Text('이번 주 사용 한도', style: TextStyle(color: Colors.white70)),
                    const SizedBox(height: 4),
                    Text(won(s.weeklyLimit), style: const TextStyle(fontSize: 34, color: Colors.white, fontWeight: FontWeight.w700)),
                  ]),
                ),
              ),
              Row(children: [stat('이번 주 사용', won(s.weeklySpent)), const SizedBox(width: 8), stat('계좌 잔액', won(s.livingAccountBalance))]),
              const SizedBox(height: 8),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _Mini('월 예산', (s.monthlyBudget / 10000).toStringAsFixed(0), '만원'),
                      _Mini('월 지출', (s.weeklySpent / 10000).toStringAsFixed(1), '만원'),
                      const _Mini('남은일', '23', '일'),
                      const _Mini('미분류', '8', '건'),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _Mini extends StatelessWidget {
  final String a, b, c;
  const _Mini(this.a, this.b, this.c);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text(a, style: const TextStyle(fontSize: 11, color: Colors.grey)),
      Text(b, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
      Text(c, style: const TextStyle(fontSize: 11, color: Colors.grey)),
    ]);
  }
}
