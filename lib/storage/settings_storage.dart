import 'package:shared_preferences/shared_preferences.dart';

class SettingsStorage {
  static const _notifEnabledKey = 'notif_enabled';
  static const _notifHourKey = 'notif_hour';

  static Future<bool> isNotifEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_notifEnabledKey) ?? true;
  }

  static Future<void> setNotifEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_notifEnabledKey, value);
  }

  static Future<int> getNotifHour() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_notifHourKey) ?? 9;
  }

  static Future<void> setNotifHour(int hour) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_notifHourKey, hour);
  }
}
