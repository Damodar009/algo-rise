import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static const String _hasSeenOnboardingKey = 'has_seen_onboarding';
  static const String _isLoggedInKey = 'is_logged_in';

  final SharedPreferences _prefs;

  PreferencesService(this._prefs);

  /// Check if user has seen onboarding
  bool get hasSeenOnboarding => _prefs.getBool(_hasSeenOnboardingKey) ?? false;

  /// Mark onboarding as seen
  Future<void> setOnboardingSeen() async {
    await _prefs.setBool(_hasSeenOnboardingKey, true);
  }

  /// Check if user is logged in
  bool get isLoggedIn => _prefs.getBool(_isLoggedInKey) ?? false;

  /// Set login status
  Future<void> setLoggedIn(bool value) async {
    await _prefs.setBool(_isLoggedInKey, value);
  }

  /// Clear all preferences (for testing/logout)
  Future<void> clear() async {
    await _prefs.clear();
  }

  /// Factory method to create instance
  static Future<PreferencesService> create() async {
    final prefs = await SharedPreferences.getInstance();
    return PreferencesService(prefs);
  }
}
