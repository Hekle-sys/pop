import 'package:uuid/uuid.dart';

class Task {
  final String id;
  final String title;
  final String category;
  final int durationMinutes;
  final DateTime createdAt;
  final DateTime? completedAt;
  final DateTime? scheduledFor;

  Task({
    String? id,
    required this.title,
    required this.category,
    required this.durationMinutes,
    DateTime? createdAt,
    this.completedAt,
    this.scheduledFor,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now();

  bool get isCompleted => completedAt != null;

  bool get isToday {
    final now = DateTime.now();
    final scheduled = scheduledFor ?? createdAt;
    return scheduled.year == now.year &&
        scheduled.month == now.month &&
        scheduled.day == now.day;
  }

  Task copyWith({
    String? id,
    String? title,
    String? category,
    int? durationMinutes,
    DateTime? createdAt,
    DateTime? completedAt,
    DateTime? scheduledFor,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
      scheduledFor: scheduledFor ?? this.scheduledFor,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'durationMinutes': durationMinutes,
      'createdAt': createdAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'scheduledFor': scheduledFor?.toIso8601String(),
    };
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] as String,
      title: json['title'] as String,
      category: json['category'] as String,
      durationMinutes: json['durationMinutes'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'] as String)
          : null,
      scheduledFor: json['scheduledFor'] != null
          ? DateTime.parse(json['scheduledFor'] as String)
          : null,
    );
  }
}
