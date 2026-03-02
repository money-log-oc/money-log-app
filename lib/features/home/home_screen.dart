import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
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

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          const Text('홈', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Card(
            color: const Color(0xFF2F80FF),
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('이번 주 사용 한도', style: TextStyle(color: Colors.white70)),
                SizedBox(height: 4),
                Text('110,000원', style: TextStyle(fontSize: 34, color: Colors.white, fontWeight: FontWeight.w700)),
              ]),
            ),
          ),
          Row(children: [stat('이번 주 사용', '92,000원'), const SizedBox(width: 8), stat('계좌 잔액', '438,200원')]),
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: const [
                  _Mini('월 예산', '70', '만원'),
                  _Mini('월 지출', '26.2', '만원'),
                  _Mini('남은일', '23', '일'),
                  _Mini('미분류', '8', '건'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Mini extends StatelessWidget {
  final String a,b,c;
  const _Mini(this.a,this.b,this.c);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text(a, style: const TextStyle(fontSize: 11, color: Colors.grey)),
      Text(b, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
      Text(c, style: const TextStyle(fontSize: 11, color: Colors.grey)),
    ]);
  }
}
