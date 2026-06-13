import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static const String _hasSeenOnboardingKey = 'has_seen_onboarding';
  static const String _isLoggedInKey = 'is_logged_in';
  static const String _solvedCountKey = 'solved_count';
  static const String _totalXpKey = 'total_xp';
  static const String _streakKey = 'streak';
  static const String _wakesCountKey = 'wakes_count';
  static const String _wakeupsKey = 'wakeups';
  static const String _avgTimeKey = 'avg_time';

  static PreferencesService? _instance;
  static PreferencesService get instance {
    if (_instance == null) {
      throw Exception('PreferencesService not initialized! Call create() first.');
    }
    return _instance!;
  }

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

  // Solved challenges count
  int get solvedCount => _prefs.getInt(_solvedCountKey) ?? 124;
  Future<void> incrementSolvedCount() async {
    await _prefs.setInt(_solvedCountKey, solvedCount + 1);
  }

  // Total XP earned
  int get totalXp => _prefs.getInt(_totalXpKey) ?? 2400;
  Future<void> addXp(int amount) async {
    await _prefs.setInt(_totalXpKey, totalXp + amount);
  }

  // Streak days
  int get streak => _prefs.getInt(_streakKey) ?? 14;
  Future<void> setStreak(int value) async {
    await _prefs.setInt(_streakKey, value);
  }

  // Profile Wakes count
  int get wakesCount => _prefs.getInt(_wakesCountKey) ?? 312;
  Future<void> incrementWakesCount() async {
    await _prefs.setInt(_wakesCountKey, wakesCount + 1);
  }

  // Progress page Wake-ups
  int get wakeups => _prefs.getInt(_wakeupsKey) ?? 48;
  Future<void> incrementWakeups() async {
    await _prefs.setInt(_wakeupsKey, wakeups + 1);
  }

  // Avg solve time
  String get avgTime => _prefs.getString(_avgTimeKey) ?? '4:12';
  Future<void> setAvgTime(String value) async {
    await _prefs.setString(_avgTimeKey, value);
  }

  /// Clear all preferences (for testing/logout)
  Future<void> clear() async {
    await _prefs.clear();
  }

  /// Factory method to create instance
  static Future<PreferencesService> create() async {
    final prefs = await SharedPreferences.getInstance();
    _instance = PreferencesService(prefs);
    return _instance!;
  }
}
