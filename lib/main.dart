import 'package:flutter/material.dart';

void main() {
  runApp(const MoneylogApp());
}

class MoneylogApp extends StatelessWidget {
  const MoneylogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '머니로그',
      home: Scaffold(
        appBar: AppBar(title: const Text('머니로그 v1')),
        body: const Center(child: Text('Flutter SDK 설치 후 본격 구현 시작')),
      ),
    );
  }
}
