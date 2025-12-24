import 'package:flutter/foundation.dart';
import '../models/client.dart';
import '../services/client_service.dart';

class ClientProvider with ChangeNotifier {
  final ClientService _clientService = ClientService();
  
  List<Client> _clients = [];
  bool _isLoading = false;
  String? _error;

  List<Client> get clients => _clients;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Charger tous les clients
  Future<void> loadClients({bool fromCache = false}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _clients = await _clientService.getAllClients(fromCache: fromCache);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Créer un client
  Future<bool> createClient(Client client) async {
    try {
      final newClient = await _clientService.createClient(client);
      _clients.add(newClient);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Mettre à jour un client
  Future<bool> updateClient(Client client) async {
    try {
      final updatedClient = await _clientService.updateClient(client);
      final index = _clients.indexWhere((c) => c.id == client.id);
      if (index != -1) {
        _clients[index] = updatedClient;
        notifyListeners();
      }
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Supprimer un client
  Future<bool> deleteClient(int id) async {
    try {
      await _clientService.deleteClient(id);
      _clients.removeWhere((c) => c.id == id);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Rechercher des clients
  Future<void> searchClients(String query) async {
    if (query.isEmpty) {
      await loadClients();
      return;
    }

    try {
      _clients = await _clientService.searchClients(query);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // Effacer l'erreur
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
