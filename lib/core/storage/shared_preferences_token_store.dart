import "package:shared_preferences/shared_preferences.dart";

import "token_store.dart";

class SharedPreferencesTokenStore implements TokenStore {
  SharedPreferencesTokenStore(this._preferences);

  static const _sessionTokenKey = "session_token";

  final SharedPreferences _preferences;

  @override
  Future<void> clear() async {
    await _preferences.remove(_sessionTokenKey);
  }

  @override
  Future<String?> read() async {
    return _preferences.getString(_sessionTokenKey);
  }

  @override
  Future<void> write(String token) async {
    await _preferences.setString(_sessionTokenKey, token);
  }
}
