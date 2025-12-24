import 'package:flutter/foundation.dart';
import '../models/facture.dart';
import '../models/ligne_facture.dart';
import '../services/facture_service.dart';

class FactureProvider with ChangeNotifier {
  final FactureService _factureService = FactureService();
  
  List<Facture> _factures = [];
  Facture? _currentFacture;
  List<LigneFacture> _currentLignes = [];
  bool _isLoading = false;
  String? _error;

  List<Facture> get factures => _factures;
  Facture? get currentFacture => _currentFacture;
  List<LigneFacture> get currentLignes => _currentLignes;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Factures urgentes
  List<Facture> get facturesUrgentes =>
      _factures.where((f) => f.isUrgent).toList();

  // Factures en retard
  List<Facture> get facturesEnRetard =>
      _factures.where((f) => f.isEnRetard).toList();

  // Charger toutes les factures
  Future<void> loadFactures({bool fromCache = false}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _factures = await _factureService.getAllFactures(fromCache: fromCache);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Charger une facture spécifique
  Future<void> loadFacture(int id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _currentFacture = await _factureService.getFactureById(id);
      _currentLignes = _currentFacture?.lignes ?? [];
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Créer une nouvelle facture
  Future<int?> createFacture({
    required int clientId,
    String? numero,
    int delaiJours = 45,
  }) async {
    try {
      final factureId = await _factureService.createFacture(
        clientId: clientId,
        numero: numero,
        delaiJours: delaiJours,
      );
      await loadFactures();
      return factureId;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }

  // Ajouter une ligne à la facture
  Future<bool> ajouterLigne({
    required int factureId,
    required int produitId,
    required double quantite,
    required double prixUnitaire,
  }) async {
    try {
      await _factureService.ajouterLigneFacture(
        factureId: factureId,
        produitId: produitId,
        quantite: quantite,
        prixUnitaire: prixUnitaire,
      );
      await loadFacture(factureId);
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Ajouter une ligne par code-barres
  Future<bool> ajouterLigneByBarcode({
    required int factureId,
    required String barcode,
    double quantite = 1,
  }) async {
    try {
      await _factureService.ajouterLigneByBarcode(
        factureId: factureId,
        barcode: barcode,
        quantite: quantite,
      );
      await loadFacture(factureId);
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Fermer une facture
  Future<bool> fermerFacture(int factureId) async {
    try {
      await _factureService.fermerFacture(factureId);
      await loadFacture(factureId);
      await loadFactures();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Enregistrer un paiement
  Future<bool> enregistrerPaiement(int factureId) async {
    try {
      await _factureService.enregistrerPaiement(factureId);
      await loadFacture(factureId);
      await loadFactures();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Filtrer par statut
  List<Facture> getFacturesByStatut(String statut) {
    return _factures.where((f) => f.statut == statut).toList();
  }

  // Filtrer par client
  List<Facture> getFacturesByClient(int clientId) {
    return _factures.where((f) => f.clientId == clientId).toList();
  }

  // Effacer la facture courante
  void clearCurrentFacture() {
    _currentFacture = null;
    _currentLignes = [];
    notifyListeners();
  }

  // Effacer l'erreur
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
