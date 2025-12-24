import '../models/facture.dart';
import '../models/ligne_facture.dart';
import 'supabase_service.dart';
import 'hive_service.dart';

class FactureService {
  final SupabaseService _supabaseService = SupabaseService();
  final HiveService _hiveService = HiveService();
  
  static const String tableName = 'factures';
  static const String lignesTableName = 'lignes_facture';

  // Récupérer toutes les factures
  Future<List<Facture>> getAllFactures({bool fromCache = false}) async {
    if (fromCache) {
      return await _hiveService.getFactures();
    }

    try {
      // Utiliser la vue complète pour avoir les infos client
      final data = await _supabaseService.getData('v_factures_complet');
      final factures = data.map((json) => Facture.fromJson(json)).toList();
      
      // Sauvegarder dans le cache
      await _hiveService.saveFactures(factures);
      
      return factures;
    } catch (e) {
      // En cas d'erreur, récupérer depuis le cache
      return await _hiveService.getFactures();
    }
  }

  // Récupérer une facture par ID avec ses lignes
  Future<Facture?> getFactureById(int id) async {
    try {
      final factures = await getAllFactures();
      final facture = factures.firstWhere(
        (f) => f.id == id,
        orElse: () => throw Exception('Facture non trouvée'),
      );

      // Récupérer les lignes de la facture
      final lignes = await getLignesFacture(id);
      
      return facture.copyWith(lignes: lignes);
    } catch (e) {
      throw Exception('Erreur lors de la récupération de la facture: $e');
    }
  }

  // Récupérer les lignes d'une facture
  Future<List<LigneFacture>> getLignesFacture(int factureId) async {
    try {
      final allLignes = await _hiveService.getLignesFacture();
      final cachedLignes = allLignes.where((l) => l.factureId == factureId).toList();
      
      if (cachedLignes.isNotEmpty) {
        return cachedLignes;
      }

      // Si pas en cache, récupérer de Supabase
      final data = await _supabaseService.getData(lignesTableName);
      final allLignesFromDb = data.map((json) => LigneFacture.fromJson(json)).toList();
      
      // Sauvegarder dans le cache
      await _hiveService.saveLignesFacture(allLignesFromDb);
      
      return allLignesFromDb.where((l) => l.factureId == factureId).toList();
    } catch (e) {
      throw Exception('Erreur lors de la récupération des lignes: $e');
    }
  }

  // Créer une nouvelle facture (via RPC)
  Future<int> createFacture({
    required int clientId,
    String? numero,
    int delaiJours = 45,
  }) async {
    try {
      final result = await _supabaseService.callRpc('creer_facture', {
        'p_client_id': clientId,
        'p_numero': numero,
        'p_delai_jours': delaiJours,
      });
      
      // Rafraîchir le cache
      await getAllFactures();
      
      return result as int;
    } catch (e) {
      throw Exception('Erreur lors de la création de la facture: $e');
    }
  }

  // Ajouter une ligne à une facture (via RPC)
  Future<int> ajouterLigneFacture({
    required int factureId,
    required int produitId,
    required double quantite,
    required double prixUnitaire,
  }) async {
    try {
      final result = await _supabaseService.callRpc('ajouter_ligne_facture', {
        'p_facture_id': factureId,
        'p_produit_id': produitId,
        'p_quantite': quantite,
        'p_prix_unitaire': prixUnitaire,
      });
      
      // Rafraîchir le cache des lignes et de la facture
      await getLignesFacture(factureId);
      await getFactureById(factureId);
      
      return result as int;
    } catch (e) {
      throw Exception('Erreur lors de l\'ajout de la ligne: $e');
    }
  }

  // Ajouter une ligne par code-barres (via RPC)
  Future<int> ajouterLigneByBarcode({
    required int factureId,
    required String barcode,
    double quantite = 1,
  }) async {
    try {
      final result = await _supabaseService.callRpc('ajouter_ligne_by_barcode', {
        'p_facture_id': factureId,
        'p_barcode': barcode,
        'p_quantite': quantite,
      });
      
      // Rafraîchir le cache
      await getLignesFacture(factureId);
      await getFactureById(factureId);
      
      return result as int;
    } catch (e) {
      throw Exception('Erreur: $e');
    }
  }

  // Recalculer le total d'une facture (via RPC)
  Future<void> recalculerFacture(int factureId) async {
    try {
      await _supabaseService.callRpc('recalculer_facture', {
        'p_facture_id': factureId,
      });
      
      // Rafraîchir le cache
      await getFactureById(factureId);
    } catch (e) {
      throw Exception('Erreur lors du recalcul: $e');
    }
  }

  // Fermer une facture (via RPC)
  Future<void> fermerFacture(int factureId) async {
    try {
      await _supabaseService.callRpc('fermer_facture', {
        'p_facture_id': factureId,
      });
      
      // Rafraîchir le cache
      await getFactureById(factureId);
    } catch (e) {
      throw Exception('Erreur lors de la fermeture: $e');
    }
  }

  // Enregistrer un paiement (via RPC)
  Future<void> enregistrerPaiement(int factureId) async {
    try {
      await _supabaseService.callRpc('enregistrer_paiement', {
        'p_facture_id': factureId,
      });
      
      // Rafraîchir le cache
      await getFactureById(factureId);
    } catch (e) {
      throw Exception('Erreur lors de l\'enregistrement du paiement: $e');
    }
  }

  // Récupérer les factures urgentes (≤7 jours)
  Future<List<Facture>> getFacturesUrgentes() async {
    try {
      final data = await _supabaseService.getData('v_factures_a_notifier');
      return data.map((json) => Facture.fromJson(json)).toList();
    } catch (e) {
      // Filtrer depuis le cache
      final factures = await getAllFactures(fromCache: true);
      return factures.where((f) => f.isUrgent).toList();
    }
  }

  // Filtrer les factures par statut
  Future<List<Facture>> getFacturesByStatut(String statut) async {
    final factures = await getAllFactures();
    return factures.where((f) => f.statut == statut).toList();
  }

  // Récupérer les factures d'un client
  Future<List<Facture>> getFacturesByClient(int clientId) async {
    final factures = await getAllFactures();
    return factures.where((f) => f.clientId == clientId).toList();
  }
}
