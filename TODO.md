# TODO - Prochaines Étapes

## 🚀 Actions Immédiates (Avant de Coder)

### 1. Configuration de l'Environnement
```bash
# Installer Flutter SDK
# Suivre: https://docs.flutter.dev/get-started/install

# Vérifier l'installation
flutter doctor

# Dans le répertoire du projet
cd /path/to/veterinaire-app2

# Installer les dépendances
flutter pub get

# ⚠️ CRITIQUE: Générer les adapters Hive
flutter pub run build_runner build --delete-conflicting-outputs
```

### 2. Configuration Supabase
- [ ] Créer un compte sur https://supabase.com (si pas déjà fait)
- [ ] Créer un nouveau projet
- [ ] Copier l'URL et la clé ANON (déjà dans le code)
- [ ] Aller dans SQL Editor
- [ ] Coller et exécuter le script SQL fourni dans le problem statement
- [ ] Vérifier que les tables sont créées

### 3. Test Initial
```bash
# Lister les devices disponibles
flutter devices

# Lancer sur Windows
flutter run -d windows

# OU sur Android
flutter run -d android

# OU sur iOS (Mac only)
flutter run -d ios
```

## 📋 Développement Phase par Phase

### Phase 2 : Factures (Priorité HAUTE)

#### 2.1 Liste des Factures
**Fichier**: `lib/screens/factures/factures_list_screen.dart`

```dart
// À créer - S'inspirer de clients_list_screen.dart
// Fonctionnalités:
// - Liste avec Consumer<FactureProvider>
// - Filtres par statut (Chips)
// - Recherche par numéro
// - Navigation vers détails
// - Bouton FAB pour nouvelle facture
// - Affichage du statut avec couleur
```

#### 2.2 Nouvelle Facture
**Fichier**: `lib/screens/factures/nouvelle_facture_screen.dart`

```dart
// Fonctionnalités:
// 1. Sélection client (Dropdown avec recherche)
// 2. Liste des produits ajoutés (ListView)
// 3. Bouton "Ajouter produit manuellement"
//    - Autocomplete pour chercher le produit
//    - Champ quantité
//    - Prix unitaire pré-rempli
// 4. Bouton "Scanner code-barres" (mobile)
// 5. Affichage du total en temps réel
// 6. Date d'échéance calculée automatiquement
// 7. Bouton "Créer la facture"

// Services à utiliser:
// - FactureProvider.createFacture()
// - FactureProvider.ajouterLigne()
// - ProduitProvider.loadProduits()
```

#### 2.3 Détails Facture
**Fichier**: `lib/screens/factures/facture_details_screen.dart`

```dart
// Fonctionnalités:
// - Affichage complet (en-tête + lignes + total)
// - Chaque ligne affiche la date_ajout
// - Boutons d'action selon le statut:
//   * OUVERTE: Modifier, Fermer, Imprimer
//   * FERMEE: Enregistrer paiement, Imprimer
//   * PAYEE: Imprimer uniquement
// - Génération PDF
// - Affichage de l'alerte si urgent
```

#### 2.4 Scanner Code-Barres (Mobile)
**Fichier**: `lib/screens/factures/barcode_scanner_screen.dart`

```dart
// Utiliser: mobile_scanner package
// Fonctionnalités:
// - Scanner en plein écran
// - Feedback visuel (cadre vert quand détecté)
// - Appel automatique à ajouterLigneByBarcode
// - Retour à l'écran facture
// - Gestion des erreurs (produit non trouvé)
```

### Phase 3 : Produits (Priorité MOYENNE)

#### 3.1 Liste Produits
**Fichier**: `lib/screens/produits/produits_list_screen.dart`

```dart
// Similar à clients_list_screen.dart
// Ajouts:
// - Badge stock faible (rouge)
// - Affichage du prix
// - Filtre par catégorie
// - Tri (nom, prix, stock)
```

#### 3.2 Formulaire Produit
**Fichier**: `lib/screens/produits/produit_form_screen.dart`

```dart
// Champs:
// - Code (auto-généré avec bouton refresh)
// - Code-barres (optionnel, généré si vide)
// - Désignation *
// - Description
// - Prix unitaire *
// - Stock
// - Stock minimum
// - Catégorie (Dropdown)
// - Unité (Dropdown: Unité, Boîte, Kg, L, etc.)
```

#### 3.3 Impression Étiquettes
**Fichier**: `lib/screens/produits/print_labels_screen.dart`

```dart
// Fonctionnalités:
// - Sélection de produits (multi-select)
// - Nombre d'étiquettes par produit
// - Aperçu avant impression
// - Génération PDF avec codes-barres
// - Utiliser: barcode_widget package
```

### Phase 5 : Paramètres (Priorité BASSE)

#### 5.1 Écran Paramètres
**Fichier**: `lib/screens/settings/parametres_screen.dart`

```dart
// Sections:
// 1. Informations générales (TextFields)
// 2. Images (3 sections):
//    - Logo: ImagePicker + Upload + Preview
//    - Signature: ImagePicker + Upload + Preview
//    - Cachet: ImagePicker + Upload + Preview
// 3. Délai de paiement (Slider 1-90 jours)
```

#### 5.2 Service Upload Images
**Améliorations à**: `lib/services/supabase_service.dart`

```dart
// Ajouter:
// - Compression d'images
// - Suppression de l'ancienne image
// - Gestion du bucket Supabase Storage
// - Retour de l'URL publique
```

### Phase 6 : Notifications & Polish (Priorité FINALE)

#### 6.1 Service de Notifications
**Fichier**: `lib/services/notification_service.dart`

```dart
// Package: flutter_local_notifications
// Fonctionnalités:
// - Initialisation
// - Vérification quotidienne (background task)
// - Notification pour factures urgentes
// - Notification pour stock faible
// - Navigation vers facture au clic
```

#### 6.2 Sync Avancée
**Améliorations à**: `lib/services/sync_service.dart`

```dart
// Ajouter:
// - Queue pour modifications hors ligne
// - Retry automatique en cas d'échec
// - Indicateur de progression
// - Résolution de conflits
```

#### 6.3 UI Polish
```dart
// - Ajouter SharedPreferences pour le thème
// - Toggle dark mode dans paramètres
// - Animations page transitions
// - Skeleton loaders
// - Empty states améliorés
// - Success/Error snackbars cohérents
```

## 🎨 Exemples de Code Utiles

### Créer une Nouvelle Facture
```dart
// Dans nouvelle_facture_screen.dart
final provider = Provider.of<FactureProvider>(context, listen: false);

// Créer la facture
final factureId = await provider.createFacture(
  clientId: selectedClient.id!,
  delaiJours: 45,
);

if (factureId != null) {
  // Ajouter les lignes
  for (var ligne in lignesTemp) {
    await provider.ajouterLigne(
      factureId: factureId,
      produitId: ligne.produitId,
      quantite: ligne.quantite,
      prixUnitaire: ligne.prixUnitaire,
    );
  }
  
  // Naviguer vers détails
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => FactureDetailsScreen(factureId: factureId),
    ),
  );
}
```

### Scanner Code-Barres
```dart
// Dans barcode_scanner_screen.dart
import 'package:mobile_scanner/mobile_scanner.dart';

MobileScanner(
  onDetect: (capture) async {
    final barcode = capture.barcodes.first.rawValue;
    if (barcode != null) {
      // Ajouter à la facture
      final success = await provider.ajouterLigneByBarcode(
        factureId: widget.factureId,
        barcode: barcode,
      );
      
      if (success) {
        Navigator.pop(context);
      }
    }
  },
)
```

### Générer PDF Facture
```dart
// Dans facture_details_screen.dart
final pdfService = PdfService();
await pdfService.generateFacturePdf(
  facture: facture,
  lignes: lignes,
  parametres: parametres,
);
```

## 📚 Ressources Utiles

### Documentation
- Flutter Widgets: https://docs.flutter.dev/ui/widgets
- Provider Tutorial: https://docs.flutter.dev/data-and-backend/state-mgmt/simple
- Supabase Flutter: https://supabase.com/docs/reference/dart/introduction
- Hive Guide: https://docs.hivedb.dev/#/

### Packages Importants
```yaml
# Déjà dans pubspec.yaml:
supabase_flutter: ^2.3.0      # Backend
hive_flutter: ^1.1.0          # Local DB
provider: ^6.1.1              # State Management
mobile_scanner: ^5.0.0        # Barcode Scanner
pdf: ^3.10.7                  # PDF Generation
printing: ^5.11.1             # PDF Printing
```

## 🐛 Debugging Tips

### Logs Supabase
```dart
// Dans supabase_service.dart, ajouter:
print('Calling RPC: $functionName with $params');
```

### Logs Provider
```dart
// Dans les providers, ajouter:
@override
void notifyListeners() {
  debugPrint('${this.runtimeType} - Notifying listeners');
  super.notifyListeners();
}
```

### Vérifier Hive
```dart
// Dans main.dart, ajouter:
final box = await Hive.openBox('clients');
print('Clients in Hive: ${box.length}');
```

## ✅ Checklist Avant Déploiement

- [ ] Tous les écrans fonctionnent
- [ ] Mode hors ligne testé
- [ ] PDF génération testée
- [ ] Scanner testé sur appareil réel
- [ ] Pas d'erreurs de linting
- [ ] Images compressées
- [ ] Build release sans warnings
- [ ] Testé sur Windows/Android/iOS
- [ ] Documentation utilisateur créée

## 🎯 Objectifs de Performance

- Temps de démarrage: < 3s
- Temps de sync initiale: < 5s
- Taille APK: < 50MB
- Scroll fluide: 60fps
- Réponse UI: < 100ms

---

**Bon courage ! 🚀**

*N'hésitez pas à consulter les autres fichiers de documentation :*
- `README.md` - Vue d'ensemble
- `SETUP_GUIDE.md` - Installation détaillée
- `DOCUMENTATION.md` - Architecture technique
- `PROJECT_STATUS.md` - État actuel du projet
