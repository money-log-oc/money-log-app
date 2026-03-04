import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart' as kakao;

import '../../core/auth/auth_api.dart';
import '../../core/auth/auth_session.dart';
import '../../core/config/app_config.dart';
import '../onboarding/onboarding_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _authApi = AuthApi();
  bool _loading = false;

  Future<String> _issueKakaoAccessToken() async {
    if (AppConfig.kakaoNativeAppKey.isEmpty) {
      throw Exception('KAKAO_NATIVE_APP_KEY가 설정되지 않았습니다.');
    }

    if (await kakao.isKakaoTalkInstalled()) {
      try {
        final token = await kakao.UserApi.instance.loginWithKakaoTalk();
        return token.accessToken;
      } catch (_) {
        // fallback to account login
      }
    }

    final token = await kakao.UserApi.instance.loginWithKakaoAccount();
    return token.accessToken;
  }

  Future<void> _onTapLogin() async {
    setState(() => _loading = true);
    try {
      final kakaoAccessToken = await _issueKakaoAccessToken();
      final res = await _authApi.loginWithKakao(kakaoAccessToken);
      AuthSession.save(
          access: res.accessToken, refresh: res.refreshToken, uid: res.userId);

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const OnboardingScreen()),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('로그인 실패: $e')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),
              const Text('월급일까지,\n돈 흐름을 관리해요',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              const Text('이번 주 사용 한도, 내역 정리, 리포트를\n머니로그에서 한 번에.'),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFFFEE500),
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: _loading ? null : _onTapLogin,
                  child: Text(_loading ? '로그인 중...' : '카카오로 시작하기',
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
