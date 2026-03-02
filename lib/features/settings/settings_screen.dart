import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          const Text('설정', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
          Card(
            child: Column(children: const [
              ListTile(title: Text('로그인 계정'), subtitle: Text('카카오 · hwanggyuhyeog.')),
              Divider(height: 1),
              ListTile(title: Text('월급일 기준'), subtitle: Text('매월 25일')),
              Divider(height: 1),
              ListTile(title: Text('월 생활비'), subtitle: Text('70만원')),
            ]),
          ),
          Card(
            child: Column(children: const [
              SwitchListTile(value: true, onChanged: null, title: Text('자동 동기화')),
              Divider(height: 1),
              SwitchListTile(value: true, onChanged: null, title: Text('미분류 알림')),
            ]),
          ),
          Card(
            child: Column(children: const [
              ListTile(title: Text('약관/개인정보 처리방침')),
              Divider(height: 1),
              ListTile(title: Text('앱 버전'), trailing: Text('v1.0.0-beta')),
            ]),
          ),
        ],
      ),
    );
  }
}
