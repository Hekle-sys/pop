# 📝 Commandes utiles pour développement POP

## Installation et Setup

```bash
# Cloner le projet
cd /Users/filou/pop

# Installer les dépendances
flutter pub get

# Mettre à jour une dépendance spécifique
flutter pub add firebase_core

# Vérifier les dépendances obsolètes
flutter pub outdated

# Mettre à jour toutes les dépendances
flutter pub upgrade
```

---

## Lancer l'app

```bash
# Lancer sur device par défaut
flutter run

# Lancer en mode release (optimisé)
flutter run --release

# Lancer sur iOS spécifiquement
flutter run -d iPhone

# Lancer sur Android spécifiquement
flutter run -d android

# Lancer avec hot reload activé (par défaut)
flutter run

# Lancer avec hot restart (redémarre complètement l'app)
flutter run --no-fast-start

# Lancer avec logs verbeux
flutter run -v
```

---

## Analyse et Vérification

```bash
# Analyser le code (vérifier erreurs/warnings)
flutter analyze

# Formatter le code (Auto-format)
flutter format lib/

# Activer null safety
flutter analyze --no-pub

# Vérifier les dépendances non utilisées
flutter pub deps

# Lister les packages installés
flutter pub global list
```

---

## Debugging

```bash
# Ouvrir DevTools (outils de débogage Flutter)
flutter pub global activate devtools
devtools

# Lister les devices disponibles
flutter devices

# Démarrer avec observer de performance
flutter run --profile

# Logs de l'app en cours d'exécution
flutter logs

# Analyser les performances (timeline)
flutter trace
```

---

## Testing

```bash
# Lancer tous les tests
flutter test

# Lancer un fichier test spécifique
flutter test test/models_test.dart

# Tests avec couverture de code
flutter test --coverage

# Générer rapport de couverture
lcov --list coverage/lcov.info

# Tests en continu (watch mode)
flutter test --watch

# Tests avec output verbeux
flutter test -v
```

---

## Building

```bash
# Build APK (Android Debug)
flutter build apk --debug

# Build APK (Android Release - optimisé)
flutter build apk --release

# Build Bundle (App Bundle pour Play Store)
flutter build appbundle --release

# Build iOS (nécessite Xcode)
flutter build ios --release

# Build pour Web
flutter build web --release

# Build macOS
flutter build macos --release

# Build Linux
flutter build linux --release

# Build Windows
flutter build windows --release

# Lister les fichiers générés
flutter build --analyze-size
```

---

## Cleaning

```bash
# Nettoyer les fichiers générés
flutter clean

# Supprimer build artifacts
rm -rf build/

# Supprimer .pub-cache
flutter pub cache clean

# Réinstaller complètement les dépendances
flutter clean && flutter pub get
```

---

## Installation sur device physique

### iOS (iPhone/iPad)

```bash
# Vérifier que Xcode est installé
xcode-select --install

# Lancer sur iPhone physique
flutter run

# Signer le certificat pour App Store
flutter build ios --release --codesign
```

### Android (téléphone/tablette)

```bash
# Activer USB Debugging sur le device
# Paramètres > À propos du téléphone > Numéro de build (7 fois) > Options de développement

# Vérifier que le device est connecté
adb devices

# Lancer l'app
flutter run

# Installer l'APK directement
adb install build/app/outputs/flutter-apk/app-debug.apk
```

---

## Commandes Git utiles

```bash
# Voir les changements
git status

# Ajouter tous les fichiers modifiés
git add .

# Commit avec message
git commit -m "feat: ajouter animations épis"

# Voir l'historique
git log --oneline

# Créer une branche pour feature
git checkout -b feature/animations

# Fusionner une branche
git merge feature/animations

# Annuler changements
git checkout -- lib/main.dart
```

---

## Commandes Android Studio / Xcode (si utilisé)

```bash
# Ouvrir Android Studio
open -a "Android Studio" .

# Ouvrir Xcode
open ios/Runner.xcworkspace

# Ouvrir le dossier Android
open android/
```

---

## Publier sur les stores

### App Store (iOS)

```bash
# Configurer iOS
cd ios/
pod install
cd ..

# Build pour App Store
flutter build ios --release

# Créer archive Xcode
open ios/Runner.xcworkspace
# Archive → Distribute App → App Store Connect

# OU utiliser transporter
xcrun altool --upload-app --type ios \
  --file "build/ios/ipa/app.ipa" \
  --apple-id "email@apple.com" \
  --password "app-specific-password"
```

### Google Play Store (Android)

```bash
# Créer clé de signature
keytool -genkey -v -keystore ~/key.jks -alias flutter_app -keyalg RSA -keysize 2048 -validity 10000

# Configurer signing
# Créer android/key.properties

# Build App Bundle
flutter build appbundle --release

# Uploader sur Play Console
# https://play.google.com/console
```

---

## Performance & Profiling

```bash
# Profiler l'app (CPU, Memory, GPU)
flutter run --profile

# Analyser la taille APK
flutter analyze-bundle

# Générer timeline de performance
flutter trace

# Voir les FPS en direct
# Secouer le device → Show Performance Overlay
```

---

## Localisation (i18n)

```bash
# Générer fichiers localisation
flutter gen-l10n

# Mettre à jour les traductions
# Éditer lib/l10n/app_*.arb

# Rebuilder les strings
flutter pub run intl_utils:generate
```

---

## Commandes utiles au quotidien

```bash
# Mon workflow de dev typique:

# 1. Start session
flutter clean
flutter pub get
flutter run -d iPhone

# 2. Pendant le dev
# Modifier code → Hot Reload automatique avec Ctrl+R

# 3. Avant commit
flutter format lib/
flutter analyze
flutter test

# 4. Avant version release
flutter build apk --release
flutter build ios --release
```

---

## Raccourcis Flutter Run

Une fois que `flutter run` est actif, vous pouvez taper:

| Touche | Action |
|--------|--------|
| `r` | Hot reload |
| `R` | Hot restart |
| `l` | Toggle Grid overlay |
| `o` | Toggle platform (iOS ↔️ Android) |
| `p` | Toggle Performance overlay |
| `d` | Detach |
| `q` | Quitter |
| `w` | Widget inspector |
| `t` | Trackball mode |

---

## Problèmes courants et solutions

```bash
# Pub cache corrompu
flutter pub cache clean

# Build cachéisé
flutter clean && flutter pub get

# Pods iOS obsolètes
cd ios && rm -rf Pods && pod install && cd ..

# Version Flutter obsolète
flutter upgrade

# Dart version incompatible
flutter doctor

# Device pas détecté
adb devices  # Android
# iOS: débrancher et rebrancher

# Erreur "Unable to find bundletool"
flutter clean && flutter pub get
```

---

## Ressources additionnelles

- [Flutter CLI commands](https://flutter.dev/docs/reference/flutter-cli)
- [Dart commands](https://dart.dev/tools/pub/cmd)
- [iOS deployment guide](https://flutter.dev/docs/deployment/ios)
- [Android deployment guide](https://flutter.dev/docs/deployment/android)

---

**Tips**: Gardez ces commandes en favori pour dev plus rapide! 🚀
