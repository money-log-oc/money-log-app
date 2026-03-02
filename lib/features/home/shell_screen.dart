import 'package:flutter/material.dart';
import '../report/report_screen.dart';
import '../settings/settings_screen.dart';
import '../transactions/transactions_screen.dart';
import 'home_screen.dart';

class ShellScreen extends StatefulWidget {
  const ShellScreen({super.key});

  @override
  State<ShellScreen> createState() => _ShellScreenState();
}

class _ShellScreenState extends State<ShellScreen> {
  int index = 0;

  final pages = const [
    HomeScreen(),
    TransactionsScreen(),
    ReportScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (v) => setState(() => index = v),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), label: '홈'),
          NavigationDestination(icon: Icon(Icons.receipt_long_outlined), label: '내역'),
          NavigationDestination(icon: Icon(Icons.bar_chart_outlined), label: '리포트'),
          NavigationDestination(icon: Icon(Icons.person_outline), label: '설정'),
        ],
      ),
    );
  }
}
