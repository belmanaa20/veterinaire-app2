import 'package:flutter/foundation.dart';
import '../models/produit.dart';
import '../services/produit_service.dart';

class ProduitProvider with ChangeNotifier {
  final ProduitService _produitService = ProduitService();
  
  List<Produit> _produits = [];
  bool _isLoading = false;
  String? _error;

  List<Produit> get produits => _produits;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Produits avec stock faible
  List<Produit> get produitsStockFaible =>
      _produits.where((p) => p.isStockFaible && p.actif).toList();

  // Charger tous les produits
  Future<void> loadProduits({bool fromCache = false}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _produits = await _produitService.getAllProduits(fromCache: fromCache);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Créer un produit
  Future<bool> createProduit(Produit produit) async {
    try {
      final newProduit = await _produitService.createProduit(produit);
      _produits.add(newProduit);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Mettre à jour un produit
  Future<bool> updateProduit(Produit produit) async {
    try {
      final updatedProduit = await _produitService.updateProduit(produit);
      final index = _produits.indexWhere((p) => p.id == produit.id);
      if (index != -1) {
        _produits[index] = updatedProduit;
        notifyListeners();
      }
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Supprimer un produit (désactiver)
  Future<bool> deleteProduit(int id) async {
    try {
      await _produitService.deleteProduit(id);
      final index = _produits.indexWhere((p) => p.id == id);
      if (index != -1) {
        _produits[index] = _produits[index].copyWith(actif: false);
        notifyListeners();
      }
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Rechercher des produits
  Future<void> searchProduits(String query) async {
    if (query.isEmpty) {
      await loadProduits();
      return;
    }

    try {
      _produits = await _produitService.searchProduits(query);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // Récupérer un produit par code-barres
  Future<Produit?> getProduitByBarcode(String barcode) async {
    try {
      return await _produitService.getProduitByBarcode(barcode);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }

  // Générer un nouveau code
  Future<String> generateCode() async {
    try {
      return await _produitService.generateCode();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return '';
    }
  }

  // Effacer l'erreur
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
