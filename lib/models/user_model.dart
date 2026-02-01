class UserProfile {
  final String userId;
  final String selectedCompanion; // 'corn' for now
  final int totalPopCorns;
  final int grainUsedToday;
  final DateTime lastUpdated;
  final List<String> unlockedSkins;
  final bool hasCompletedOnboarding;

  UserProfile({
    required this.userId,
    this.selectedCompanion = 'corn',
    this.totalPopCorns = 0,
    this.grainUsedToday = 0,
    DateTime? lastUpdated,
    this.unlockedSkins = const ['default'],
    this.hasCompletedOnboarding = false,
  }) : lastUpdated = lastUpdated ?? DateTime.now();

  UserProfile copyWith({
    String? userId,
    String? selectedCompanion,
    int? totalPopCorns,
    int? grainUsedToday,
    DateTime? lastUpdated,
    List<String>? unlockedSkins,
    bool? hasCompletedOnboarding,
  }) {
    return UserProfile(
      userId: userId ?? this.userId,
      selectedCompanion: selectedCompanion ?? this.selectedCompanion,
      totalPopCorns: totalPopCorns ?? this.totalPopCorns,
      grainUsedToday: grainUsedToday ?? this.grainUsedToday,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      unlockedSkins: unlockedSkins ?? this.unlockedSkins,
      hasCompletedOnboarding:
          hasCompletedOnboarding ?? this.hasCompletedOnboarding,
    );
  }

  int get grainRemaining => 10 - grainUsedToday;

  bool get isNewDay {
    final now = DateTime.now();
    return lastUpdated.year != now.year ||
        lastUpdated.month != now.month ||
        lastUpdated.day != now.day;
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'selectedCompanion': selectedCompanion,
      'totalPopCorns': totalPopCorns,
      'grainUsedToday': grainUsedToday,
      'lastUpdated': lastUpdated.toIso8601String(),
      'unlockedSkins': unlockedSkins,
      'hasCompletedOnboarding': hasCompletedOnboarding,
    };
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      userId: json['userId'] as String,
      selectedCompanion: json['selectedCompanion'] as String? ?? 'corn',
      totalPopCorns: json['totalPopCorns'] as int? ?? 0,
      grainUsedToday: json['grainUsedToday'] as int? ?? 0,
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
      unlockedSkins: List<String>.from(json['unlockedSkins'] as List? ?? []),
      hasCompletedOnboarding: json['hasCompletedOnboarding'] as bool? ?? false,
    );
  }
}
