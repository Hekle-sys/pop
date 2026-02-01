# 📋 Guide d'implémentation détaillé - Étapes suivantes

## Ce qui a été codé ✅

### ✅ MVP Complet
1. **Onboarding** (5 écrans animés)
2. **Page d'accueil** avec épis et grain/pop corn
3. **Système de tâches** (création, validation, historique)
4. **Mécanique épis** (grain détachement/transformation)
5. **Récompenses** (cosmétiques, progression)
6. **Statistiques** (streak, calendrier, tendances)
7. **Navigation** (3 onglets: Accueil, Stats, Récompenses)
8. **Persistance** (SharedPreferences)
9. **Sons** (service prêt, mais sans fichiers audio)

---

## Prochaines étapes recommandées (Roadmap)

### 🎯 **SEMAINE 1-2: Animation & Polish**

#### Étape 1: Animer l'épis qui pop
**Fichier**: `lib/ui/widgets/corn_stalk.dart`

```dart
// À ajouter:
- AnimationController pour rotation/scale
- ParticleEffect quand grain se détache
- Transition couleur (jaune → orange) pendant pop
- Confetti quand pop corn créé

Exemple:
class CornPopAnimation extends StatefulWidget {
  onTap: () {
    _animationController.forward().then((_) {
      // Grain part
      _showParticles();
      _playPopSound();
    });
  }
}
```

**Temps estimé**: 3-4 heures

---

#### Étape 2: Ajouter les fichiers audio
**Fichiers à créer**:
- `assets/sounds/pop.mp3` (200ms, explosif)
- `assets/sounds/crunch.mp3` (150ms, léger)
- `assets/sounds/success.mp3` (400ms, enjoué)

**Mettre à jour**:
```yaml
# pubspec.yaml
flutter:
  assets:
    - assets/sounds/
```

**Intégrer dans l'app**:
```dart
// Dans home_page_new.dart à la création/complétion tâche:
await SoundService().playPopSound();
```

**Temps estimé**: 2-3 heures (chercher/acheter sons)

---

#### Étape 3: Mode Dark complet
**Fichier**: `lib/ui/app.dart`

```dart
// Ajouter darkTheme:
darkTheme: ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.orange,
    brightness: Brightness.dark,
  ),
)

// Et dans home_page_new.dart:
// Vérifier que couleurs s'adaptent automatiquement
```

**Temps estimé**: 2 heures

---

### 🎮 **SEMAINE 3: Suggerer des tâches**

#### Étape 4: Base de données de tâches suggérées
**Fichier à créer**: `lib/data/suggested_tasks.dart`

```dart
final Map<String, List<String>> suggestedTasks = {
  'Santé': [
    'Faire 30 min de sport',
    'Boire 2L d\'eau',
    'Méditer 10 min',
    'Faire une marche',
  ],
  'Apprentissage': [
    'Lire 30 pages',
    'Apprendre 10 mots (langue)',
    'Suivre 1 leçon cours',
    'Regarder vidéo éducative',
  ],
  // ... etc
};
```

**Intégrer dans UI**:
```dart
// Dans home_page_new.dart, ajouter section suggestions:
_buildSuggestedTasks() {
  final tasks = suggestedTasks[_selectedCategory] ?? [];
  return ListView.builder(
    itemCount: tasks.length,
    itemBuilder: (_, i) => _buildSuggestionChip(tasks[i]),
  );
}
```

**Temps estimé**: 3 heures

---

### 📱 **SEMAINE 4: Firebase Setup**

#### Étape 5: Ajouter Firebase (optionnel mais recommandé pour v2)
**Dépendance**:
```bash
flutter pub add firebase_core firebase_auth cloud_firestore
```

**Service à créer**: `lib/services/firebase_service.dart`

```dart
class FirebaseService {
  static Future<void> init() async {
    await Firebase.initializeApp();
  }
  
  static Future<void> syncUser(UserProfile user) async {
    // Sync vers Firestore
  }
  
  static Future<void> syncTasks(List<Task> tasks) async {
    // Sync vers Firestore
  }
}
```

**Mettre à jour**: `main.dart`
```dart
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseService.init();  // <- AJOUTER
  // ... rest
}
```

**Temps estimé**: 4-5 heures

---

### 📊 **SEMAINE 5: Analytics**

#### Étape 6: Ajouter analytics
**Dépendance**:
```bash
flutter pub add firebase_analytics
```

**Service à créer**: `lib/services/analytics_service.dart`

```dart
class AnalyticsService {
  static final _analytics = FirebaseAnalytics.instance;
  
  static Future<void> logTaskCreated(Task task) async {
    await _analytics.logEvent(
      name: 'task_created',
      parameters: {
        'category': task.category,
        'duration': task.durationMinutes,
      },
    );
  }
  
  static Future<void> logTaskCompleted() async {
    await _analytics.logEvent(name: 'task_completed');
  }
}
```

**Intégrer**:
```dart
// Dans home_page_new.dart:
await AnalyticsService.logTaskCreated(task);  // après _createTask()
await AnalyticsService.logTaskCompleted();    // après _completeTask()
```

**Temps estimé**: 2 heures

---

### 🎨 **SEMAINE 6: Cosmétiques avancés**

#### Étape 7: Système d'avatars/skins complet
**Fichier à créer**: `lib/data/cosmetics.dart`

```dart
final List<CosmeticItem> cornSkins = [
  CosmeticItem(
    id: 'corn_default',
    name: 'Épis classique',
    requiredPopCorns: 0,
    color: Colors.amber[600],
  ),
  CosmeticItem(
    id: 'corn_halloween',
    name: 'Corn Halloween',
    requiredPopCorns: 10,
    color: Colors.orange[800],
    emoji: '🎃',
  ),
  // ... plus de skins
];
```

**Créer widget**: `lib/ui/widgets/cosmetic_preview.dart`

```dart
class CosmeticPreview extends StatelessWidget {
  final CosmeticItem cosmetic;
  final bool isUnlocked;
  final bool isSelected;
  
  // Afficher aperçu du skin
}
```

**Temps estimé**: 4 heures

---

### 🌐 **SEMAINE 7-8: Préparation Stores**

#### Étape 8: App Store / Play Store Metadata
**À créer**:

```
android/app/src/main/AndroidManifest.xml
  - app name: "POP"
  - icon
  - permissions

ios/Runner/Info.plist
  - app name
  - icon
  - splash screen
```

**Fichiers**:
- Screenshots (3-5 pour chaque plateforme)
- Description courte (80 caractères max)
- Mots-clés
- Icône app (1024x1024px)
- Splash screen

**Temps estimé**: 4-5 heures

---

#### Étape 9: Privacy & Compliance
**À documenter**:
- Privacy Policy
- Terms of Service
- Data Retention Policy
- GDPR Compliance

**Template simple**:
```markdown
# Privacy Policy

## Data Collection
We collect:
- Task history (stored locally)
- Anonymous usage stats (Firebase)

We DON'T collect:
- Personal info
- Location
- Contacts

## Data Rights
Users can:
- Export their data
- Delete account (all data)
- Request data copy
```

**Temps estimé**: 2-3 heures

---

### 🧪 **Testing & QA**

#### Étape 10: Tests unitaires
**Fichier à créer**: `test/models_test.dart`

```dart
void main() {
  group('UserProfile', () {
    test('grainRemaining calcule correctement', () {
      final user = UserProfile(
        userId: 'test',
        grainUsedToday: 3,
      );
      expect(user.grainRemaining, 7);
    });
  });
}
```

**Lancer**:
```bash
flutter test
```

**Temps estimé**: 2-3 heures

---

#### Étape 11: Tests UI (widget tests)
**Fichier à créer**: `test/pages_test.dart`

```dart
void main() {
  testWidgets('HomePage affiche corn stalk', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    
    expect(find.byType(CornStalk), findsOneWidget);
    expect(find.text('POP'), findsWidgets);
  });
}
```

**Temps estimé**: 3-4 heures

---

## 📈 Ordre de priorité recommandé

1. ✅ **MVP (déjà fait)**
2. 🎯 **Animation + Sounds** (URGENT - rend meilleur UX)
3. 🎮 **Task Suggestions** (augmente rétention)
4. 📊 **Analytics** (comprendre utilisateurs)
5. 🌐 **Store Prep** (pour lancer)
6. 🧪 **Tests** (réduire bugs avant lancement)
7. 🎨 **Cosmétiques avancés** (bonus, peut attendre v1.1)

---

## 📚 Ressources utiles

### Flutter
- [Flutter docs](https://flutter.dev/docs)
- [Material Design 3](https://m3.material.io/)
- [Dart packages](https://pub.dev)

### Audio
- [Freesound.org](https://freesound.org) (sons libres)
- [Zapsplat](https://www.zapsplat.com) (effets sonores gratuits)

### Design
- [Figma template](https://www.figma.com) (wireframes)
- [App Mockup tools](https://www.figma.com) (design mockups)

### Store Optimization
- [App Store Connect](https://appstoreconnect.apple.com)
- [Google Play Console](https://play.google.com/console)
- [AppFigures](https://www.appfigures.com) (ASO tools)

---

## Questions fréquentes

**Q: Par où commencer?**
A: Semaine 1-2 (Animations) → Semaine 3 (Suggestions) → Semaine 4-5 (Backend) → Semaine 6-8 (Stores)

**Q: Combien de temps pour sortir v1.0?**
A: ~4-6 semaines de dev + 2 semaines review/test + 1-2 semaines App Store approval

**Q: Faut-il Firebase?**
A: Non pour MVP, mais oui pour monitorer utilisateurs et sync cloud (recommandé avant launch)

**Q: Comment tester?**
A: iPhone + Android émulateurs, puis TestFlight (iOS) et Google Play Beta (Android)

---

**Prochaine milestone**: Animation épis (Semaine 1-2) 🎬
