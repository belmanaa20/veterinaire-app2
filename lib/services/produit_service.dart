import '../models/produit.dart';
import 'supabase_service.dart';
import 'hive_service.dart';

class ProduitService {
  final SupabaseService _supabaseService = SupabaseService();
  final HiveService _hiveService = HiveService();
  
  static const String tableName = 'produits';

  // Récupérer tous les produits
  Future<List<Produit>> getAllProduits({bool fromCache = false}) async {
    if (fromCache) {
      return await _hiveService.getProduits();
    }

    try {
      final data = await _supabaseService.getData(tableName);
      final produits = data.map((json) => Produit.fromJson(json)).toList();
      
      // Sauvegarder dans le cache
      await _hiveService.saveProduits(produits);
      
      return produits;
    } catch (e) {
      // En cas d'erreur, récupérer depuis le cache
      return await _hiveService.getProduits();
    }
  }

  // Récupérer un produit par ID
  Future<Produit?> getProduitById(int id) async {
    try {
      final produits = await getAllProduits();
      return produits.firstWhere(
        (produit) => produit.id == id,
        orElse: () => throw Exception('Produit non trouvé'),
      );
    } catch (e) {
      throw Exception('Erreur lors de la récupération du produit: $e');
    }
  }

  // Récupérer un produit par code-barres
  Future<Produit?> getProduitByBarcode(String barcode) async {
    try {
      final produits = await getAllProduits();
      return produits.firstWhere(
        (produit) => produit.barcode == barcode && produit.actif,
        orElse: () => throw Exception('Produit non trouvé'),
      );
    } catch (e) {
      throw Exception('Erreur: $e');
    }
  }

  // Créer un nouveau produit
  Future<Produit> createProduit(Produit produit) async {
    try {
      final data = await _supabaseService.insertData(
        tableName,
        produit.toJson(),
      );
      final newProduit = Produit.fromJson(data);
      
      // Mettre à jour le cache
      final produits = await _hiveService.getProduits();
      produits.add(newProduit);
      await _hiveService.saveProduits(produits);
      
      return newProduit;
    } catch (e) {
      throw Exception('Erreur lors de la création du produit: $e');
    }
  }

  // Mettre à jour un produit
  Future<Produit> updateProduit(Produit produit) async {
    if (produit.id == null) {
      throw Exception('ID du produit manquant');
    }

    try {
      final data = await _supabaseService.updateData(
        tableName,
        produit.id!,
        produit.toJson(),
      );
      final updatedProduit = Produit.fromJson(data);
      
      // Mettre à jour le cache
      final produits = await _hiveService.getProduits();
      final index = produits.indexWhere((p) => p.id == produit.id);
      if (index != -1) {
        produits[index] = updatedProduit;
        await _hiveService.saveProduits(produits);
      }
      
      return updatedProduit;
    } catch (e) {
      throw Exception('Erreur lors de la mise à jour du produit: $e');
    }
  }

  // Supprimer un produit (désactivation)
  Future<void> deleteProduit(int id) async {
    try {
      // Au lieu de supprimer, on désactive le produit
      final produit = await getProduitById(id);
      if (produit != null) {
        await updateProduit(produit.copyWith(actif: false));
      }
    } catch (e) {
      throw Exception('Erreur lors de la désactivation du produit: $e');
    }
  }

  // Récupérer les produits avec stock faible
  Future<List<Produit>> getProduitsStockFaible() async {
    final produits = await getAllProduits();
    return produits.where((p) => p.isStockFaible && p.actif).toList();
  }

  // Rechercher des produits
  Future<List<Produit>> searchProduits(String query) async {
    final produits = await getAllProduits();
    final lowerQuery = query.toLowerCase();
    
    return produits.where((produit) {
      return produit.actif &&
          (produit.designation.toLowerCase().contains(lowerQuery) ||
              (produit.code?.toLowerCase().contains(lowerQuery) ?? false) ||
              (produit.barcode?.toLowerCase().contains(lowerQuery) ?? false) ||
              (produit.categorie?.toLowerCase().contains(lowerQuery) ?? false));
    }).toList();
  }

  // Générer un code unique pour un produit
  Future<String> generateCode() async {
    final produits = await getAllProduits();
    final maxNumber = produits.fold<int>(
      0,
      (max, produit) {
        if (produit.code != null && produit.code!.startsWith('P')) {
          final numberPart = produit.code!.substring(1);
          final number = int.tryParse(numberPart) ?? 0;
          return number > max ? number : max;
        }
        return max;
      },
    );
    return 'P${(maxNumber + 1).toString().padLeft(3, '0')}';
  }
}
