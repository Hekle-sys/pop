import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:pop/models/user_model.dart';
import 'package:pop/models/task_model.dart';

class AppStorage {
  static const String _userKey = 'user_profile';
  static const String _tasksKey = 'tasks';
  static const String _historyKey = 'history_dates';

  static Future<UserProfile> loadUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(_userKey);

    if (json == null) {
      // Create new user
      final newUser = UserProfile(
        userId: const Uuid().v4(),
        selectedCompanion: 'corn',
      );
      await saveUserProfile(newUser);
      return newUser;
    }

    return UserProfile.fromJson(jsonDecode(json) as Map<String, dynamic>);
  }

  static Future<void> saveUserProfile(UserProfile user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, jsonEncode(user.toJson()));
  }

  static Future<List<Task>> loadAllTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(_tasksKey);

    if (json == null) return [];

    final list = jsonDecode(json) as List;
    return list
        .map((item) => Task.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  static Future<void> saveAllTasks(List<Task> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _tasksKey,
      jsonEncode(tasks.map((t) => t.toJson()).toList()),
    );
  }

  static Future<Task?> getTodayTask() async {
    final tasks = await loadAllTasks();
    try {
      return tasks.firstWhere((t) => t.isToday && !t.isCompleted);
    } catch (e) {
      return null;
    }
  }

  static Future<void> addTask(Task task) async {
    final tasks = await loadAllTasks();
    tasks.add(task);
    await saveAllTasks(tasks);
  }

  static Future<void> completeTask(String taskId) async {
    final tasks = await loadAllTasks();
    final index = tasks.indexWhere((t) => t.id == taskId);

    if (index != -1) {
      tasks[index] = tasks[index].copyWith(completedAt: DateTime.now());
      await saveAllTasks(tasks);
    }
  }

  static Future<void> deleteTask(String taskId) async {
    final tasks = await loadAllTasks();
    tasks.removeWhere((t) => t.id == taskId);
    await saveAllTasks(tasks);
  }

  static Future<List<String>> loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_historyKey) ?? [];
  }

  static Future<void> addToHistory(DateTime date) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_historyKey) ?? [];
    final iso = date.toIso8601String();

    if (!list.contains(iso)) {
      list.add(iso);
      await prefs.setStringList(_historyKey, list);
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

  static Future<void> resetDailyGrains() async {
    final user = await loadUserProfile();
    final now = DateTime.now();

    // Check if it's a new day
    if (user.isNewDay) {
      final updated = user.copyWith(
        grainUsedToday: 0,
        lastUpdated: now,
      );
      await saveUserProfile(updated);
    }
  }

  static Future<void> useGrain() async {
    await resetDailyGrains();
    final user = await loadUserProfile();
    final updated = user.copyWith(
      grainUsedToday: user.grainUsedToday + 1,
    );
    await saveUserProfile(updated);
  }

  static Future<void> addPopCorn(int count) async {
    final user = await loadUserProfile();
    final updated = user.copyWith(
      totalPopCorns: user.totalPopCorns + count,
    );
    await saveUserProfile(updated);
  }
}
