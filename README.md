# Veterinaire App - Application de Gestion de Pharmacie Vétérinaire

Application Flutter complète pour la gestion d'une pharmacie vétérinaire avec support Desktop (Windows) et Mobile (Android, iOS).

## 🎯 Fonctionnalités

### ✅ Gestion des Factures
- Création de factures avec sélection client
- Ajout de produits par code-barres ou manuellement
- Affichage de la date d'ajout pour chaque ligne
- Calcul automatique du total
- Système de paiement à 45 jours
- Filtres par statut (OUVERTE, FERMEE, PAYEE, EN_RETARD)
- Génération de PDF A4 professionnels
- Système de notifications pour les échéances

### ✅ Gestion des Produits
- CRUD complet
- Génération et scan de codes-barres
- Impression d'étiquettes
- Alertes de stock faible
- Gestion des catégories

### ✅ Gestion des Clients
- CRUD complet
- Historique des factures
- Recherche par nom/téléphone/culture

### ✅ Paramètres
- Configuration du magasin
- Upload logo, signature, cachet
- Configuration NIF, RC
- Délai de paiement par défaut

### ✅ Mode Hors Ligne
- Cache local avec Hive
- Travail en mode déconnecté
- Synchronisation automatique

## 🛠️ Technologies

- **Frontend**: Flutter 3.5+
- **Backend**: Supabase (PostgreSQL)
- **Storage Local**: Hive
- **State Management**: Provider
- **PDF**: pdf package + printing
- **Barcode**: mobile_scanner + barcode_widget
- **UI**: Material Design 3 + Google Fonts

## 📦 Installation

### Prérequis
- Flutter SDK 3.5 ou supérieur
- Dart SDK 3.5 ou supérieur
- Android Studio / Xcode (pour mobile)
- Visual Studio 2022 (pour Windows Desktop)

### Configuration

1. Cloner le repository:
```bash
git clone https://github.com/belmanaa20/veterinaire-app2.git
cd veterinaire-app2
```

2. Installer les dépendances:
```bash
flutter pub get
```

3. Générer les fichiers Hive (TypeAdapters):
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

4. Configuration Supabase:
Les identifiants Supabase sont déjà configurés dans `lib/config/supabase_config.dart`

5. Lancer l'application:

Pour Desktop (Windows):
```bash
flutter run -d windows
```

Pour Android:
```bash
flutter run -d android
```

Pour iOS:
```bash
flutter run -d ios
```

## 🗄️ Base de Données

La structure de la base de données Supabase est définie dans le script SQL fourni.

### Tables Principales:
- **parametres** - Informations du magasin
- **clients** - Clients
- **produits** - Produits avec codes-barres
- **factures** - Factures
- **lignes_facture** - Lignes de facture avec date_ajout

### Fonctions RPC:
- `creer_facture(client_id, numero, delai_jours)`
- `ajouter_ligne_facture(facture_id, produit_id, quantite, prix_unitaire)`
- `ajouter_ligne_by_barcode(facture_id, barcode, quantite)`
- `recalculer_facture(facture_id)`
- `fermer_facture(facture_id)`
- `enregistrer_paiement(facture_id)`

## 📁 Structure du Projet

```
lib/
├── main.dart
├── config/
│   ├── supabase_config.dart
│   ├── hive_config.dart
│   └── theme_config.dart
├── models/
│   ├── client.dart
│   ├── produit.dart
│   ├── facture.dart
│   ├── ligne_facture.dart
│   └── parametres.dart
├── services/
│   ├── supabase_service.dart
│   ├── hive_service.dart
│   └── (autres services à venir)
├── screens/
│   ├── home_screen.dart
│   └── (autres écrans à venir)
└── (autres répertoires)
```

## 🚀 Développement

### Générer les fichiers Hive après modification des modèles:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Lancer en mode debug:
```bash
flutter run --debug
```

### Build pour production:

Windows:
```bash
flutter build windows --release
```

Android:
```bash
flutter build apk --release
```

iOS:
```bash
flutter build ios --release
```

## 📝 Notes

- L'application supporte le mode sombre
- Interface en français
- Support complet du mode hors ligne
- Les factures incluent la date d'ajout pour chaque produit
- Format PDF A4 professionnel avec logo, signature et cachet

## 📄 Licence

MIT License - voir le fichier LICENSE pour plus de détails