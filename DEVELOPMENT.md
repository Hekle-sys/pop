# 🌽 POP - Application de Productivité Quotidienne

## Vue d'ensemble

**POP** est une application mobile innovante conçue pour aider les utilisateurs à accomplir une tâche par jour et progresser à leur rythme. Avec un système de gamification unique basé sur un épis de maïs qui se transforme en pop corn 🍿, l'app crée une expérience mémorable et motivante.

## Architecture implémentée

### Modèles de données
```
lib/models/
├── user_model.dart       # UserProfile: profil utilisateur, grains, pop corns
├── task_model.dart       # Task: structure des tâches quotidiennes
└── reward_model.dart     # Reward: système de récompenses/cosmétiques
```

### Stockage et Services
```
lib/storage/
├── app_storage.dart      # AppStorage: gestion centralisée des données
├── history_storage.dart  # Historique tâches (existant)
└── settings_storage.dart # Paramètres (existant)

lib/services/
├── notification_service.dart  # Notifications quotidiennes
└── sound_service.dart        # Sons pop, crunch, succès
```

### Pages de l'application
```
lib/ui/pages/
├── onboarding_page.dart   # 5 écrans d'introduction
├── home_page_new.dart     # Page accueil avec épis (système grain/pop corn)
├── stats_page.dart        # Statistiques, streaks, calendrier
├── rewards_page.dart      # Cosmétiques et récompenses
├── main_navigation.dart   # Navigation principale (3 onglets)
└── (anciens fichiers historiques)

lib/ui/widgets/
├── corn_stalk.dart        # Affichage de l'épis avec animations
└── (autres widgets existants)
```

## Fonctionnalités implémentées

### 1. Système d'Onboarding (5 écrans)
- ✅ Bienvenue motivante
- ✅ Explication de la mécanique grain/pop corn
- ✅ Sélection du compagnon (corn pour la v1)
- ✅ Choix des catégories d'intérêt
- ✅ Configuration du temps disponible

### 2. Système de Tâches
- ✅ Créer une tâche quotidienne
- ✅ Limite de 10 tâches/jour (10 grains)
- ✅ Catégorisation (Santé, Apprentissage, Travail, Social, Créatif)
- ✅ Marquer comme complétée
- ✅ Historique des tâches

### 3. Mécanique Épis → Pop Corn
- ✅ Affichage de l'épis avec N grains
- ✅ Grain se détache quand on crée une tâche
- ✅ Grain se transforme en pop corn quand on complète la tâche
- ✅ Accumulation des pop corns
- ✅ Compteur visible

### 4. Système de Récompenses
- ✅ Déblocage cosmétiques à X pop corns
- ✅ Exemples: Corn Halloween, Corn Christmas, Dark Theme
- ✅ Affichage de la galerie des récompenses
- ✅ Progression visible

### 5. Statistiques et Suivi
- ✅ Streak quotidien (🔥)
- ✅ Record personnel
- ✅ Total jours complétés
- ✅ Calendrier mensuel (heatmap)
- ✅ Tendances

### 6. Architecture de Données
- ✅ SharedPreferences pour persistance locale
- ✅ Modèles JSON-serializable pour futures API
- ✅ Reset automatique des grains chaque jour
- ✅ Sync historique et profil utilisateur

## Installation et Lancement

### Prérequis
- Flutter 3.10.4+
- Dart 3.10.4+
- macOS/iOS ou Android SDK configuré

### Installation
```bash
cd /Users/filou/pop
flutter pub get
```

### Lancer l'app
```bash
# Sur émulateur iOS
flutter run -d iOS

# Sur émulateur Android
flutter run -d android

# Sur device physique
flutter run
```

### Tester l'onboarding
À la première ouverture, l'app affichera l'onboarding. Complétez les 5 écrans pour accéder à l'accueil.

## Structure des données

### UserProfile (app_storage)
```dart
UserProfile(
  userId: "uuid",
  selectedCompanion: "corn",
  totalPopCorns: 42,          // Pop corns accumulés
  grainUsedToday: 5,          // Grains utilisés aujourd'hui (0-10)
  unlockedSkins: ["default", "corn_halloween"],
  hasCompletedOnboarding: true,
)
```

### Task
```dart
Task(
  id: "uuid",
  title: "Lire 30 pages",
  category: "Apprentissage",
  durationMinutes: 30,
  createdAt: DateTime.now(),
  completedAt: null, // null si non complétée
  scheduledFor: DateTime.now(),
)
```

## Prochaines étapes (Roadmap)

### Phase 1: Polish MVP
- [ ] Animations lisses pour épis et pop corn
- [ ] Sons détaillés (pop, crunch, succès)
- [ ] Dark mode complet
- [ ] Gestion de l'orientation (portrait/paysage)

### Phase 2: Fonctionnalités avancées
- [ ] Suggestions de tâches IA
- [ ] Intégrations calendrier (Google Calendar, Apple Calendar)
- [ ] Partage social (Instagram Stories, TikTok)
- [ ] Notifications intelligentes
- [ ] Préférences de timing

### Phase 3: Backend et Cloud
- [ ] Firebase pour sync cloud
- [ ] Authentification (Google, Apple)
- [ ] Backup automatique
- [ ] Analytics (Mixpanel, Amplitude)

### Phase 4: Monétisation
- [ ] Packs cosmétiques premium
- [ ] Abonnement pour features avancées
- [ ] Événements saisonniers exclusifs
- [ ] Partenariats B2B (entreprises)

### Phase 5: Publication
- [ ] Beta testing (TestFlight, Google Play Beta)
- [ ] Préparation App Store / Play Store
- [ ] ASO (App Store Optimization)
- [ ] Lancement officiel

## Fichiers clés à connaître

| Fichier | Rôle |
|---------|------|
| `main.dart` | Initialisation app + check onboarding |
| `lib/ui/app.dart` | Configuration MaterialApp |
| `lib/storage/app_storage.dart` | Toute la logique de persistance |
| `lib/models/*.dart` | Structures de données |
| `lib/ui/pages/main_navigation.dart` | Routeur principal (3 onglets) |
| `pubspec.yaml` | Dépendances (lottie, audioplayers, uuid, etc.) |

## Dépendances principales
- **shared_preferences**: Stockage local
- **flutter_local_notifications**: Notifications
- **lottie**: Animations complexes
- **audioplayers**: Sons
- **uuid**: Génération d'IDs uniques

## Notes développeur

### Avertissements Flutter à ignorer
L'analyse peut signaler des avertissements mineurs sur:
- Dépréciation de Radio (to-do: refactoriser vers RadioGroup)
- Dépréciation de withOpacity (déjà corrigé)
- Spread operators avec toList()

Ces avertissements n'affectent pas la fonctionnalité.

### Personnalisation facile
- **Couleurs**: Changer le seed color dans `app.dart` (ligne 19)
- **Catégories**: Modifier liste dans `home_page_new.dart` (ligne 46)
- **Récompenses**: Ajouter dans `reward_model.dart`
- **Sons**: Ajouter fichiers dans `assets/sounds/` et mettre à jour `sound_service.dart`

## Questions fréquentes

**Q: L'app va où les données?**
A: Actuellement sur SharedPreferences (stockage local de l'appareil). À passer à Firebase/Firestore pour v2.

**Q: Puis-je changer l'épis?**
A: Oui! Le système est modulaire. Modifier `corn_stalk.dart` pour changer le design.

**Q: Comment ajouter des sons?**
A: Créer dossier `assets/sounds/`, ajouter fichiers MP3, les référencer dans `sound_service.dart`.

**Q: Tester sans l'onboarding?**
A: Modifier `UserProfile.hasCompletedOnboarding = true` manuellement dans SharedPreferences (utiliser app comme DevTools).

---

**Version**: 1.0.0 (MVP)
**Créé**: Janvier 2026
**État**: Fonctionnel et prêt pour tests
