import 'package:flutter/material.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Widget bar(String tag, double w, String amount) => Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(children: [
        SizedBox(width: 50, child: Text(tag)),
        Expanded(
          child: Stack(children: [
            Container(height: 8, decoration: BoxDecoration(color: const Color(0xFFEFF3F8), borderRadius: BorderRadius.circular(999))),
            FractionallySizedBox(widthFactor: w, child: Container(height: 8, decoration: BoxDecoration(color: const Color(0xFF2F80FF), borderRadius: BorderRadius.circular(999)))),
          ]),
        ),
        const SizedBox(width: 8),
        SizedBox(width: 50, child: Text(amount, textAlign: TextAlign.right)),
      ]),
    );

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
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(children: [
                bar('음식', .82, '11.2만'),
                bar('카페', .56, '6.4만'),
                bar('교통', .39, '4.4만'),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
