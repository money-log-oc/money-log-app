import 'package:flutter/material.dart';
import '../home/shell_screen.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Widget box(String text) => Container(
          width: double.infinity,
          margin: const EdgeInsets.only(top: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFE6EBF1)),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(text),
        );

    return Scaffold(
      appBar: AppBar(title: const Text('초기 설정')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('생활비 계좌 등록', style: TextStyle(fontWeight: FontWeight.w700)),
                  box('은행 선택: 카카오뱅크'),
                  box('계좌 별칭: 생활비 통장'),
                ]),
              ),
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('예산 기준 설정', style: TextStyle(fontWeight: FontWeight.w700)),
                  box('월급일: 매월 25일'),
                  box('월 생활비: 70만원'),
                ]),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const ShellScreen()),
                  );
                },
                child: const Text('계좌 연결하고 시작하기'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
