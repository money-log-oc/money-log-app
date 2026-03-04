import 'package:flutter/material.dart';

import '../core/auth/auth_session.dart';
import '../features/home/shell_screen.dart';
import '../features/login/login_screen.dart';

class MoneylogApp extends StatelessWidget {
  const MoneylogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '머니로그',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Pretendard',
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2F80FF)),
      ),
      home: FutureBuilder<void>(
        future: AuthSession.initialize(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Scaffold(
                body: Center(child: CircularProgressIndicator()));
          }
          return AuthSession.isLoggedIn
              ? const ShellScreen()
              : const LoginScreen();
        },
      ),
    );
  }
}
