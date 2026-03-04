import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

import 'app/moneylog_app.dart';
import 'core/config/app_config.dart';

void main() {
  if (AppConfig.kakaoNativeAppKey.isNotEmpty) {
    KakaoSdk.init(nativeAppKey: AppConfig.kakaoNativeAppKey);
  }
  runApp(const MoneylogApp());
}
