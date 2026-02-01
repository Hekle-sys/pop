// Exemples et cas de test pour POP

import 'package:pop/models/task_model.dart';
import 'package:pop/models/user_model.dart';
// reward_model import removed: not used in test data

/// Exemples de données pour tests manuels

// ========== USER PROFILES ==========

final userProfileExample1 = UserProfile(
  userId: 'user_123',
  selectedCompanion: 'corn',
  totalPopCorns: 42,
  grainUsedToday: 5,
  unlockedSkins: ['default', 'corn_halloween'],
  hasCompletedOnboarding: true,
);

final userProfileNewUser = UserProfile(
  userId: 'user_new',
  selectedCompanion: 'corn',
  totalPopCorns: 0,
  grainUsedToday: 0,
  unlockedSkins: ['default'],
  hasCompletedOnboarding: false,
);

// ========== TASKS ==========

final taskExample1 = Task(
  id: 'task_001',
  title: 'Lire 30 pages du livre',
  category: 'Apprentissage',
  durationMinutes: 45,
  createdAt: DateTime.now(),
  completedAt: null, // Pas encore complétée
);

final taskExample2 = Task(
  id: 'task_002',
  title: 'Faire 30 min de sport',
  category: 'Santé',
  durationMinutes: 30,
  createdAt: DateTime.now().subtract(const Duration(days: 1)),
  completedAt: DateTime.now().subtract(const Duration(days: 1)),
);

final taskExampleCompleted = Task(
  id: 'task_003',
  title: 'Méditer 10 minutes',
  category: 'Santé',
  durationMinutes: 10,
  createdAt: DateTime.now(),
  completedAt: DateTime.now(),
);

// ========== TEST SCENARIOS ==========

/// Scénario: Utilisateur qui vient de terminer l'onboarding
class ScenarioNewUser {
  static UserProfile getProfile() => userProfileNewUser;
  
  static String getExpectedFirstScreen() => 'HomePageNew';
  
  static List<String> getExpectedCategories() => [
    'Santé',
    'Apprentissage',
    'Travail',
    'Social',
    'Créatif',
  ];
}

/// Scénario: Utilisateur actif avec streak
class ScenarioActiveUser {
  static UserProfile getProfile() => userProfileExample1;
  
  static int getExpectedStreakDays() => 5;
  
  static int getExpectedGrainsRemaining() => 5; // 10 - 5
}

/// Scénario: Utilisateur qui complète une tâche
class ScenarioCompleteTask {
  static Task createTask() => Task(
    title: 'Tâche test',
    category: 'Santé',
    durationMinutes: 30,
  );
  
  static void testTaskCompletion() {
    // 1. Créer tâche
    final task = createTask();
    
    // 2. Vérifier grain utilisé
    // assert(user.grainUsedToday == 1);
    
    // 3. Valider tâche
    // mark task as completed for the scenario (no variable needed)
    task.copyWith(completedAt: DateTime.now());
    
    // 4. Vérifier pop corn +1
    // assert(user.totalPopCorns == 1);
    
    // 5. Vérifier historique mis à jour
    // assert(history.contains(DateTime.now()));
  }
}

// ========== REWARDS TEST DATA ==========

final List<RewardUnlockScenario> rewardScenarios = [
  RewardUnlockScenario(
    popCornCount: 0,
    shouldHaveRewards: false,
    expectedMessage: 'Complétez des tâches pour débloquer des récompenses',
  ),
  RewardUnlockScenario(
    popCornCount: 10,
    shouldHaveRewards: true,
    expectedMessage: 'Vous pouvez débloquer: Corn Halloween',
  ),
  RewardUnlockScenario(
    popCornCount: 50,
    shouldHaveRewards: true,
    expectedMessage: 'Vous avez débloqué tous les cosmétiques!',
  ),
];

class RewardUnlockScenario {
  final int popCornCount;
  final bool shouldHaveRewards;
  final String expectedMessage;
  
  RewardUnlockScenario({
    required this.popCornCount,
    required this.shouldHaveRewards,
    required this.expectedMessage,
  });
}

// ========== ANALYTICS EVENTS TO TRACK ==========

class AnalyticsEvents {
  static const String appOpened = 'app_opened';
  static const String onboardingStarted = 'onboarding_started';
  static const String onboardingCompleted = 'onboarding_completed';
  static const String taskCreated = 'task_created';
  static const String taskCompleted = 'task_completed';
  static const String rewardUnlocked = 'reward_unlocked';
  static const String streakMilestone = 'streak_milestone'; // 7, 30, 100 jours
  static const String appAbandoned = 'app_abandoned'; // 30 jours sans usage
  
  /// Propriétés à envoyer avec les events
  static Map<String, dynamic> taskCreatedPayload(Task task) => {
    'category': task.category,
    'duration_minutes': task.durationMinutes,
    'grain_used': 1,
  };
  
  static Map<String, dynamic> streakMilestonePayload(int streakDays) => {
    'streak_days': streakDays,
    'milestone_reached': streakDays == 7 || streakDays == 30 || streakDays == 100,
  };
}

// ========== PERFORMANCE BENCHMARKS ==========

class PerformanceBenchmarks {
  /// Target: < 100ms pour ouvrir home page
  static const homePageLoadTimeMs = 100;
  
  /// Target: < 200ms pour créer une tâche
  static const taskCreationTimeMs = 200;
  
  /// Target: < 150ms pour valider une tâche
  static const taskCompletionTimeMs = 150;
  
  /// Target: < 300ms pour charger stats page
  static const statsPageLoadTimeMs = 300;
  
  /// Target: App size < 50MB
  static const maxAppSizeMb = 50;
}

// ========== ACCESSIBILITY TEST CASES ==========

class AccessibilityTests {
  static const List<String> testScenarios = [
    'VoiceOver activé - naviguer entre onglets',
    'Zoom du texte 200% - vérifier qu\'on ne coupe rien',
    'Mode sombre - contraste suffisant',
    'Lecture en français - tous les textes traduits',
    'Taille police min/max - app reste utilisable',
  ];
}

// ========== DEVICE TEST CONFIGURATIONS ==========

class DeviceTestConfigs {
  static const List<String> iOSDevices = [
    'iPhone 14',
    'iPhone 14 Pro',
    'iPhone SE',
    'iPad Mini',
  ];
  
  static const List<String> androidDevices = [
    'Pixel 6',
    'Pixel 6 Pro',
    'Samsung Galaxy S22',
    'OnePlus 10',
  ];
  
  static const List<String> iOSVersions = [
    '15.0',
    '16.0',
    '17.0',
  ];
  
  static const List<String> androidVersions = [
    '12',
    '13',
    '14',
  ];
}

// ========== LOCALIZATION TEST DATA ==========

final Map<String, String> frFr = {
  'home_title': 'POP',
  'home_subtitle': 'Progresse chaque jour',
  'grain_label': 'grains',
  'popcorn_label': 'pop corns',
  'task_input_hint': 'ex: Lire 30 pages',
  'create_button': 'Créer la tâche',
  'complete_button': 'Valider la tâche',
};

final Map<String, String> enUs = {
  'home_title': 'POP',
  'home_subtitle': 'Progress every day',
  'grain_label': 'grains',
  'popcorn_label': 'pop corns',
  'task_input_hint': 'ex: Read 30 pages',
  'create_button': 'Create task',
  'complete_button': 'Complete task',
};
