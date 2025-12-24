# Documentation Technique - Veterinaire App

## Architecture

L'application suit l'architecture **Clean Architecture** avec la séparation suivante :

### 1. Modèles (`lib/models/`)
- **Client** : Gestion des clients avec annotations Hive
- **Produit** : Gestion des produits avec code-barres
- **Facture** : Gestion des factures avec statuts
- **LigneFacture** : Lignes de facture avec date d'ajout
- **Parametres** : Configuration du magasin

Tous les modèles incluent :
- Annotations Hive pour le stockage local
- Méthodes `fromJson` et `toJson` pour Supabase
- Méthode `copyWith` pour l'immutabilité

### 2. Services (`lib/services/`)

#### SupabaseService
Service générique pour les opérations CRUD avec Supabase :
- `getData(table)` : Récupérer des données
- `insertData(table, data)` : Insérer des données
- `updateData(table, id, data)` : Mettre à jour
- `deleteData(table, id)` : Supprimer
- `callRpc(function, params)` : Appeler une fonction RPC
- `uploadImage(bucket, path, bytes)` : Upload d'images

#### HiveService
Service pour le stockage local hors ligne :
- Cache automatique de toutes les données
- Méthodes spécifiques pour chaque type de données
- Support de la synchronisation bidirectionnelle

#### ClientService, ProduitService, FactureService
Services métier qui combinent Supabase et Hive :
- Chargement depuis le cache ou le serveur
- Synchronisation automatique
- Gestion des erreurs avec fallback sur le cache

#### SyncService
Gestion de la synchronisation :
- `syncAll()` : Synchroniser toutes les données
- `checkConnection()` : Vérifier la connexion
- Timestamp de dernière synchronisation

#### PdfService
Génération de PDF A4 pour les factures :
- Format professionnel avec en-tête
- Tableau des lignes avec date d'ajout
- Signature et cachet

### 3. Providers (`lib/providers/`)
State management avec Provider :
- **ClientProvider** : Gestion d'état des clients
- **ProduitProvider** : Gestion d'état des produits
- **FactureProvider** : Gestion d'état des factures

Chaque provider expose :
- Liste des éléments
- État de chargement
- Messages d'erreur
- Méthodes CRUD

### 4. Écrans (`lib/screens/`)

#### Clients
- `clients_list_screen.dart` : Liste avec recherche
- `client_form_screen.dart` : Création/Modification
- `client_details_screen.dart` : Détails + Factures

#### À venir
- Produits (liste, formulaire, labels)
- Factures (liste, nouvelle, détails, scanner)
- Paramètres (configuration magasin)

### 5. Widgets (`lib/widgets/`)
Composants réutilisables :
- `CustomButton` : Bouton avec icône et loading
- `CustomTextField` : Champ de texte avec validation
- `CustomAppBar` : AppBar personnalisée

### 6. Utilitaires (`lib/utils/`)
- `constants.dart` : Constantes de l'application
- `helpers.dart` : Fonctions utilitaires (formatage, validation)

## Fonctionnalités Clés

### Mode Hors Ligne
1. Chargement initial depuis Hive (instantané)
2. Synchronisation en arrière-plan depuis Supabase
3. En cas d'erreur réseau, utilisation du cache
4. Queue de synchronisation pour les modifications hors ligne

### Gestion des Factures
- Création via RPC `creer_facture`
- Ajout de lignes via RPC `ajouter_ligne_facture`
- Scan de code-barres via `ajouter_ligne_by_barcode`
- Calcul automatique du total
- Système de statuts (OUVERTE, FERMEE, PAYEE)
- Alertes pour échéances (≤7 jours)

### Sécurité
- Toutes les données sensibles via Supabase RLS
- Pas de stockage de mots de passe en local
- Validation côté client et serveur

## Base de Données Supabase

### Tables Principales
```sql
parametres (id, nom_magasin, adresse, telephone, email, logo_url, signature_url, cachet_url, nif, numero_registre, delai_paiement_defaut)

clients (id, nom, adresse, telephone, culture, notes)

produits (id, code, barcode, designation, description, prix_unitaire, stock, stock_min, categorie, unite, actif)

factures (id, numero, client_id, date_facture, date_echeance, date_paiement, montant_total, statut, est_modifiable, notes)

lignes_facture (id, facture_id, produit_id, designation, quantite, prix_unitaire, montant, date_ajout)
```

### Fonctions RPC
- `creer_facture(client_id, numero, delai_jours)` → facture_id
- `ajouter_ligne_facture(facture_id, produit_id, quantite, prix_unitaire)` → ligne_id
- `ajouter_ligne_by_barcode(facture_id, barcode, quantite)` → ligne_id
- `recalculer_facture(facture_id)` → void
- `fermer_facture(facture_id)` → void
- `enregistrer_paiement(facture_id)` → void

### Vues
- `v_factures_complet` : Factures avec infos client
- `v_factures_a_notifier` : Factures urgentes (≤7 jours)
- `v_produits_stock_faible` : Produits en stock faible

## Configuration

### Supabase
URL et clé configurés dans `lib/config/supabase_config.dart`

### Hive
Initialisation dans `lib/config/hive_config.dart`
Les adapters seront générés via :
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Thème
Configuration Material Design 3 dans `lib/config/theme_config.dart`
- Mode clair et sombre
- Couleurs personnalisées
- Typographie Google Fonts (Roboto)

## Prochaines Étapes

1. Générer les adapters Hive
2. Compléter les écrans de produits
3. Créer les écrans de factures
4. Implémenter le scanner de code-barres
5. Finaliser le service PDF avec images
6. Ajouter les notifications
7. Tests et déploiement

## Commandes Utiles

```bash
# Installer les dépendances
flutter pub get

# Générer les fichiers Hive
flutter pub run build_runner build --delete-conflicting-outputs

# Lancer l'application
flutter run -d windows
flutter run -d android

# Build pour production
flutter build windows --release
flutter build apk --release
```
