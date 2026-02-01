# 🚀 Quick Start Guide - POP

## ⏱️ En 5 minutes

### 1️⃣ Setup (2 min)
```bash
cd /Users/filou/pop
flutter pub get
```

### 2️⃣ Lancer l'app (1 min)
```bash
flutter run
```

### 3️⃣ Complétez l'onboarding (2 min)
- Cliquez "Commençons"
- Sélectionnez votre compagnon (corn)
- Remplissez vos préférences
- Boom! Vous êtes dans l'app

---

## 📱 Test rapide des features

### Feature 1: Créer une tâche
```
Home → Sélectionnez "Santé" → Écrivez "Boire de l'eau" → Créer
👉 Vous verrez un grain se détacher de l'épis
```

### Feature 2: Compléter une tâche
```
Home → Bouton "Valider la tâche" → 
👉 Vous verrez le pop corn explosif 🍿
```

### Feature 3: Voir vos stats
```
Bottom Nav → "Statistiques" → 
👉 Voir votre streak, calendrier, progression
```

### Feature 4: Débloquer récompenses
```
Bottom Nav → "Récompenses" → 
👉 Si vous avez 10+ pop corns, vous pouvez débloquer des skins
```

---

## 🎯 Checklist Quick Features

- [ ] **Onboarding**: Complètement fait
- [ ] **Home Page**: Épis visible, créer tâche fonctionne
- [ ] **Complete Task**: Bouton valider fonctionne
- [ ] **Stats**: Voir calendrier et streaks
- [ ] **Rewards**: Débloquer cosmétiques

---

## 🔧 Commandes utiles au quotidien

```bash
# Redémarrer avec hot reload (plus rapide)
# Dans le terminal flutter, appuyez sur 'r'

# Redémarrer complètement l'app (si bug)
# Appuyez sur 'R'

# Quitter flutter run
# Appuyez sur 'q'

# Nettoyer et relancer
flutter clean && flutter pub get && flutter run
```

---

## 🐛 Problèmes courants

| Problème | Solution |
|----------|----------|
| App crash au démarrage | `flutter clean && flutter pub get` |
| Pas de grains visibles | Rafraîchir avec 'R' |
| Boutons ne répondent pas | Vérifier catégorie sélectionnée |
| Sons ne jouent pas | Normal (fichiers audio à ajouter) |

---

## 📂 Structure rapide

```
lib/
├── main.dart              ← Point d'entrée
├── models/                ← Task, User, Reward
├── storage/               ← Persistance données
├── services/              ← Sounds, Notifications
└── ui/
    ├── pages/             ← 5 pages principales
    └── widgets/           ← Épis customisé
```

---

## 🎨 Personnalisation 5 min

### Changer les couleurs
```dart
// lib/ui/app.dart ligne 18
colorScheme: ColorScheme.fromSeed(
  seedColor: Colors.blue  // Changer orange → blue
),
```

### Ajouter catégories
```dart
// lib/ui/pages/home_page_new.dart ligne 46
final List<String> _categories = [
  'Santé',
  'Apprentissage',
  'Travail',
  'Social',
  'Créatif',
  'Sport',  // ← Ajouter
];
```

### Changer nombre de grains
```dart
// lib/models/user_model.dart
int get grainRemaining => 20 - grainUsedToday;  // 10 → 20
```

---

## 📊 Prochaines meilleures actions

### Pour demain (Priorité HIGH 🔴)
1. **Animer l'épis** - rend l'experience 10x meilleure (2h)
2. **Ajouter sons** - gratuit, très impactant (1h)
3. **Tester sur vrai device** - vérifier tout fonctionne (1h)

### Cette semaine (Priorité MEDIUM 🟠)
4. **Dark mode** - Material3 automatic
5. **Suggestions tâches** - Database simple
6. **Firebase setup** - Cloud sync optionnel

### Ce mois-ci (Priorité LOW 🟡)
7. **Store prep** - Screenshots, descriptions
8. **Beta testing** - Inviter 5-10 amis
9. **Polish** - Animations finales

---

## 💡 Tips pour dev plus rapide

### Hot Reload trick
```
Modifier code → Ctrl+S → 'r' dans terminal → Instant update
```

### Débugger rapidement
```dart
// Ajouter partout:
print('DEBUG: $variable');

// Voir les logs:
flutter logs
```

### Tester sur device
```bash
# USB debugging Android
flutter run

# XCode iPhone
flutter run -d iPhone
```

---

## 🧪 Tester sans coding

### Scénario 1: Vérifier comportement jour suivant
1. Créez une tâche
2. Fermez l'app
3. Changez date système (dev mode)
4. Rouvrez app → grains doivent être reset

### Scénario 2: Vérifier persistence
1. Créez tâche, fermez app
2. Réinstallez app
3. Ouvrez app → tâche doit être là

### Scénario 3: Tester animations
1. Créez tâche → observe grain detach
2. Validez tâche → observe pop corn

---

## 📚 Docs complètes

- **DEVELOPMENT.md** - Guide technique complet
- **ROADMAP.md** - Étapes détaillées avec code
- **IMPLEMENTATION_SUMMARY.md** - Overview du projet
- **COMMANDS.md** - Toutes commandes Flutter
- **CHANGES.md** - Fichiers créés/modifiés

---

## 🎓 Apprendre en 30 min

### Partie 1: Parcourir la structure (10 min)
1. Ouvrez `lib/main.dart` - point d'entrée
2. Regardez `lib/models/` - structures données
3. Regardez `lib/ui/pages/home_page_new.dart` - logic principale

### Partie 2: Modifier quelque chose (15 min)
1. Changer une couleur (app.dart)
2. Ajouter une catégorie (home_page_new.dart)
3. Voir les changements avec hot reload

### Partie 3: Déboguer (5 min)
1. Ajouter print() statements
2. Voir logs avec `flutter logs`
3. Comprendre le flow

---

## 🚀 Premier déploiement checklist

Avant de pousser en production:

- [ ] Tester sur iOS + Android
- [ ] Vérifier tous les boutons
- [ ] Tester onboarding complet
- [ ] Vérifier persistence données
- [ ] Ajouter sounds/animations
- [ ] Écrire privacy policy
- [ ] Créer screenshots Store
- [ ] Beta test 5-10 amis

---

## 🎉 Félicitations!

Vous avez un **MVP fonctionnel**. 

**Prochain step**: Polir les animations (2-3 jours) → Sortir en beta → Lancer en production! 🚀

---

**Questions?** Consultez `DEVELOPMENT.md` ou `ROADMAP.md`

**Happy coding!** 🌽🍿
