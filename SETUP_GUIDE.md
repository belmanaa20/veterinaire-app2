# Guide de Démarrage Rapide - Veterinaire App

## 📋 Prérequis

Avant de commencer, assurez-vous d'avoir installé :

1. **Flutter SDK 3.5+**
   - Télécharger depuis : https://flutter.dev/docs/get-started/install
   - Vérifier l'installation : `flutter doctor`

2. **Dart SDK 3.5+** (inclus avec Flutter)

3. **Pour Desktop (Windows)**
   - Visual Studio 2022 avec "Desktop development with C++"
   - Activer le support Windows : `flutter config --enable-windows-desktop`

4. **Pour Mobile (Android)**
   - Android Studio
   - Android SDK
   - Un émulateur ou appareil physique

5. **Pour Mobile (iOS)** - Mac uniquement
   - Xcode
   - CocoaPods

## 🚀 Installation

### 1. Cloner le Repository

```bash
git clone https://github.com/belmanaa20/veterinaire-app2.git
cd veterinaire-app2
```

### 2. Installer les Dépendances

```bash
flutter pub get
```

### 3. Générer les Fichiers Hive (TypeAdapters)

⚠️ **IMPORTANT** : Cette étape est cruciale pour que l'application fonctionne !

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

Cette commande va générer les fichiers suivants :
- `lib/models/client.g.dart`
- `lib/models/produit.g.dart`
- `lib/models/facture.g.dart`
- `lib/models/ligne_facture.g.dart`
- `lib/models/parametres.g.dart`

### 4. Configuration Supabase

La configuration Supabase est déjà en place dans `lib/config/supabase_config.dart` :

```dart
const String supabaseUrl = 'https://teaawwipetvopccqmxpsj.supabase.co';
const String supabaseAnonKey = '...';
```

Si vous souhaitez utiliser votre propre instance Supabase :

1. Créer un compte sur https://supabase.com
2. Créer un nouveau projet
3. Exécuter le script SQL fourni dans le problem statement
4. Mettre à jour les constantes dans `supabase_config.dart`

### 5. Lancer l'Application

#### Windows Desktop
```bash
flutter run -d windows
```

#### Android
```bash
flutter run -d android
```

#### iOS (Mac uniquement)
```bash
flutter run -d ios
```

#### Choisir un device
```bash
flutter devices  # Liste les devices disponibles
flutter run -d <device-id>
```

## 🛠️ Commandes de Développement

### Build pour Production

```bash
# Windows
flutter build windows --release

# Android APK
flutter build apk --release

# Android App Bundle (pour Google Play)
flutter build appbundle --release

# iOS
flutter build ios --release
```

### Nettoyage

```bash
# Nettoyer le build
flutter clean

# Réinstaller les dépendances
flutter pub get
```

### Regénérer les Fichiers Hive

Si vous modifiez les modèles, régénérez les adapters :

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

## 📱 Structure de l'Application

```
Pharmacie Vétérinaire
├── Tableau de bord (Dashboard)
│   ├── Statistiques
│   └── Alertes
├── Factures
│   ├── Liste des factures
│   ├── Nouvelle facture
│   └── Détails facture
├── Produits
│   ├── Liste des produits
│   ├── Nouveau produit
│   └── Scanner code-barres
├── Clients
│   ├── Liste des clients ✅
│   ├── Nouveau client ✅
│   └── Détails client ✅
└── Paramètres
    └── Configuration magasin
```

## 🔍 Résolution de Problèmes

### Erreur : "Hive adapter not found"

**Solution** : Générer les adapters Hive
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Erreur : "Supabase connection failed"

**Vérifications** :
1. Connexion internet active
2. URL Supabase correcte
3. Clé API valide
4. Base de données correctement configurée

**Mode hors ligne** : L'app fonctionne hors ligne avec le cache Hive

### Erreur de build Windows

**Solutions** :
```bash
# Nettoyer et rebuilder
flutter clean
flutter pub get
flutter build windows
```

### Problème avec les imports

Si vous voyez des erreurs sur les imports manquants :
```bash
flutter pub get
dart pub global activate flutter_gen
```

## 📚 Ressources

- **Documentation Flutter** : https://docs.flutter.dev
- **Documentation Supabase** : https://supabase.com/docs
- **Documentation Hive** : https://docs.hivedb.dev
- **Material Design 3** : https://m3.material.io

## 🎯 Fonctionnalités Actuellement Implémentées

### ✅ Phase 1 (Complète)
- Configuration de base
- Modèles de données
- Services Supabase et Hive
- Providers pour state management
- Widgets réutilisables

### ✅ Phase 4 (Complète)
- Gestion des clients
  - Liste avec recherche
  - Création/Modification
  - Détails avec historique factures
  - Suppression

### 🚧 À Venir
- Gestion des factures (Phase 2)
- Gestion des produits (Phase 3)
- Paramètres magasin (Phase 5)
- Notifications (Phase 6)

## 💡 Conseils

1. **Mode Hors Ligne** : L'application cache automatiquement toutes les données. Vous pouvez travailler sans connexion.

2. **Synchronisation** : Cliquez sur l'icône sync dans l'AppBar pour synchroniser manuellement.

3. **Recherche** : Utilisez la barre de recherche dans la liste des clients pour filtrer rapidement.

4. **Développement** : Utilisez le mode debug pour voir les logs détaillés :
   ```bash
   flutter run --debug
   ```

## 📞 Support

Pour toute question ou problème :
- Ouvrir une issue sur GitHub
- Consulter la DOCUMENTATION.md

---

**Bon développement ! 🚀**
