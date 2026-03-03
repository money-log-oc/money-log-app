class AuthSession {
  static String? accessToken;
  static String? refreshToken;
  static String? userId;

  static bool get isLoggedIn => accessToken != null && accessToken!.isNotEmpty;

  static void save({required String access, required String refresh, required String uid}) {
    accessToken = access;
    refreshToken = refresh;
    userId = uid;
  }

  static void clear() {
    accessToken = null;
    refreshToken = null;
    userId = null;
  }
}
