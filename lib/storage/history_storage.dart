import 'package:shared_preferences/shared_preferences.dart';

class HistoryStorage {
  static const _key = 'history_dates';

  static Future<List<String>> load() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_key) ?? [];
  }

  static Future<void> add(DateTime date) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_key) ?? [];
    final iso = date.toIso8601String();

    if (!list.contains(iso)) {
      list.add(iso);
      await prefs.setStringList(_key, list);
    }
  }
  static int computeStreak(List<String> dates) {
  if (dates.isEmpty) return 0;

  final parsed = dates
      .map(DateTime.parse)
      .toList()
    ..sort((a, b) => b.compareTo(a)); // du plus récent au plus ancien

  int streak = 1;

  for (int i = 0; i < parsed.length - 1; i++) {
    final current = parsed[i];
    final previous = parsed[i + 1];

    final diff = current.difference(previous).inDays;

    if (diff == 1) {
      streak++;
    } else {
      break;
    }
  }

  return streak;
}
}
