import 'client_service.dart';
import 'produit_service.dart';
import 'facture_service.dart';

class SyncService {
  final ClientService _clientService = ClientService();
  final ProduitService _produitService = ProduitService();
  final FactureService _factureService = FactureService();

  bool _isSyncing = false;
  DateTime? _lastSyncTime;

  bool get isSyncing => _isSyncing;
  DateTime? get lastSyncTime => _lastSyncTime;

  // Synchroniser toutes les données
  Future<bool> syncAll() async {
    if (_isSyncing) {
      return false;
    }

    _isSyncing = true;
    
    try {
      // Synchroniser les clients
      await _clientService.getAllClients();
      
      // Synchroniser les produits
      await _produitService.getAllProduits();
      
      // Synchroniser les factures
      await _factureService.getAllFactures();
      
      _lastSyncTime = DateTime.now();
      _isSyncing = false;
      
      return true;
    } catch (e) {
      _isSyncing = false;
      throw Exception('Erreur lors de la synchronisation: $e');
    }
  }

  // Synchroniser uniquement les clients
  Future<void> syncClients() async {
    await _clientService.getAllClients();
  }

  // Synchroniser uniquement les produits
  Future<void> syncProduits() async {
    await _produitService.getAllProduits();
  }

  // Synchroniser uniquement les factures
  Future<void> syncFactures() async {
    await _factureService.getAllFactures();
  }

  // Vérifier la connexion internet
  Future<bool> checkConnection() async {
    try {
      await _clientService.getAllClients();
      return true;
    } catch (e) {
      return false;
    }
  }
}
