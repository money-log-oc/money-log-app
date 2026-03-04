import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthSession {
  static const _storage = FlutterSecureStorage();
  static const _kAccess = 'auth.accessToken';
  static const _kRefresh = 'auth.refreshToken';
  static const _kUserId = 'auth.userId';

  static String? accessToken;
  static String? refreshToken;
  static String? userId;

  static bool get isLoggedIn => accessToken != null && accessToken!.isNotEmpty;

  static Future<void> initialize() async {
    accessToken = await _storage.read(key: _kAccess);
    refreshToken = await _storage.read(key: _kRefresh);
    userId = await _storage.read(key: _kUserId);
  }

  static Future<void> save(
      {required String access,
      required String refresh,
      required String uid}) async {
    accessToken = access;
    refreshToken = refresh;
    userId = uid;

    await _storage.write(key: _kAccess, value: access);
    await _storage.write(key: _kRefresh, value: refresh);
    await _storage.write(key: _kUserId, value: uid);
  }

  static Future<void> clear() async {
    accessToken = null;
    refreshToken = null;
    userId = null;

    await _storage.delete(key: _kAccess);
    await _storage.delete(key: _kRefresh);
    await _storage.delete(key: _kUserId);
  }
}
