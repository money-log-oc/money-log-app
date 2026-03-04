import 'package:flutter/material.dart';

import '../../core/auth/auth_session.dart';
import '../../core/model/api_models.dart';
import '../../core/network/moneylog_api.dart';
import '../login/login_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late final MoneylogApi _api;
  late Future<BudgetSettings> _settings;

  @override
  void initState() {
    super.initState();
    _api = MoneylogApi();
    _settings = _api.fetchBudgetSettings();
  }

  String won(int v) => '${(v / 10000).toStringAsFixed(0)}만원';

  Future<void> _editBudget(BudgetSettings current) async {
    final paydayCtrl =
        TextEditingController(text: current.paydayDay.toString());
    final budgetCtrl =
        TextEditingController(text: current.monthlyBudget.toString());

    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('예산 설정 수정'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: paydayCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: '월급일(1~28)'),
            ),
            TextField(
              controller: budgetCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: '월 생활비(원)'),
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('취소')),
          FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('저장')),
        ],
      ),
    );

    if (ok != true) return;

    final payday = int.tryParse(paydayCtrl.text.trim());
    final budget = int.tryParse(budgetCtrl.text.trim());
    if (payday == null || budget == null) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('숫자를 정확히 입력해 주세요.')));
      }
      return;
    }

    try {
      final updated = await _api.updateBudgetSettings(
          paydayDay: payday, monthlyBudget: budget);
      setState(() => _settings = Future.value(updated));
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('예산 설정이 저장되었습니다.')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('저장 실패: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FutureBuilder<BudgetSettings>(
        future: _settings,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Text('설정 데이터를 불러오지 못했어요\n${snap.error}',
                    textAlign: TextAlign.center),
                const SizedBox(height: 8),
                FilledButton(
                  onPressed: () =>
                      setState(() => _settings = _api.fetchBudgetSettings()),
                  child: const Text('다시 시도'),
                )
              ]),
            );
          }

          final data = snap.data!;

          return ListView(
            padding: const EdgeInsets.all(12),
            children: [
              const Text('설정',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
              Card(
                child: Column(children: [
                  ListTile(
                      title: const Text('로그인 계정'),
                      subtitle: Text('카카오 · ${AuthSession.userId ?? '-'}')),
                  const Divider(height: 1),
                  ListTile(
                      title: const Text('월급일 기준'),
                      subtitle: Text('매월 ${data.paydayDay}일')),
                  const Divider(height: 1),
                  ListTile(
                      title: const Text('월 생활비'),
                      subtitle: Text(won(data.monthlyBudget))),
                  const Divider(height: 1),
                  ListTile(
                    title: const Text('예산 설정 수정'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _editBudget(data),
                  ),
                ]),
              ),
              Card(
                child: Column(children: const [
                  SwitchListTile(
                      value: true, onChanged: null, title: Text('자동 동기화')),
                  Divider(height: 1),
                  SwitchListTile(
                      value: true, onChanged: null, title: Text('미분류 알림')),
                ]),
              ),
              Card(
                child: Column(children: [
                  const ListTile(title: Text('약관/개인정보 처리방침')),
                  const Divider(height: 1),
                  const ListTile(
                      title: Text('앱 버전'), trailing: Text('v1.0.0-beta')),
                  const Divider(height: 1),
                  ListTile(
                    title:
                        const Text('로그아웃', style: TextStyle(color: Colors.red)),
                    onTap: () async {
                      await AuthSession.clear();
                      if (!context.mounted) return;
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                        (route) => false,
                      );
                    },
                  ),
                ]),
              ),
            ],
          );
        },
      ),
    );
  }
}
