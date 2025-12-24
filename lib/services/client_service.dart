import '../models/client.dart';
import 'supabase_service.dart';
import 'hive_service.dart';

class ClientService {
  final SupabaseService _supabaseService = SupabaseService();
  final HiveService _hiveService = HiveService();
  
  static const String tableName = 'clients';

  // Récupérer tous les clients
  Future<List<Client>> getAllClients({bool fromCache = false}) async {
    if (fromCache) {
      return await _hiveService.getClients();
    }

    try {
      final data = await _supabaseService.getData(tableName);
      final clients = data.map((json) => Client.fromJson(json)).toList();
      
      // Sauvegarder dans le cache
      await _hiveService.saveClients(clients);
      
      return clients;
    } catch (e) {
      // En cas d'erreur, récupérer depuis le cache
      return await _hiveService.getClients();
    }
  }

  // Récupérer un client par ID
  Future<Client?> getClientById(int id) async {
    try {
      final clients = await getAllClients();
      return clients.firstWhere(
        (client) => client.id == id,
        orElse: () => throw Exception('Client non trouvé'),
      );
    } catch (e) {
      throw Exception('Erreur lors de la récupération du client: $e');
    }
  }

  // Créer un nouveau client
  Future<Client> createClient(Client client) async {
    try {
      final data = await _supabaseService.insertData(
        tableName,
        client.toJson(),
      );
      final newClient = Client.fromJson(data);
      
      // Mettre à jour le cache
      final clients = await _hiveService.getClients();
      clients.add(newClient);
      await _hiveService.saveClients(clients);
      
      return newClient;
    } catch (e) {
      throw Exception('Erreur lors de la création du client: $e');
    }
  }

  // Mettre à jour un client
  Future<Client> updateClient(Client client) async {
    if (client.id == null) {
      throw Exception('ID du client manquant');
    }

    try {
      final data = await _supabaseService.updateData(
        tableName,
        client.id!,
        client.toJson(),
      );
      final updatedClient = Client.fromJson(data);
      
      // Mettre à jour le cache
      final clients = await _hiveService.getClients();
      final index = clients.indexWhere((c) => c.id == client.id);
      if (index != -1) {
        clients[index] = updatedClient;
        await _hiveService.saveClients(clients);
      }
      
      return updatedClient;
    } catch (e) {
      throw Exception('Erreur lors de la mise à jour du client: $e');
    }
  }

  // Supprimer un client
  Future<void> deleteClient(int id) async {
    try {
      await _supabaseService.deleteData(tableName, id);
      
      // Mettre à jour le cache
      final clients = await _hiveService.getClients();
      clients.removeWhere((c) => c.id == id);
      await _hiveService.saveClients(clients);
    } catch (e) {
      throw Exception('Erreur lors de la suppression du client: $e');
    }
  }

  // Rechercher des clients
  Future<List<Client>> searchClients(String query) async {
    final clients = await getAllClients();
    final lowerQuery = query.toLowerCase();
    
    return clients.where((client) {
      return client.nom.toLowerCase().contains(lowerQuery) ||
          (client.telephone?.toLowerCase().contains(lowerQuery) ?? false) ||
          (client.culture?.toLowerCase().contains(lowerQuery) ?? false);
    }).toList();
  }
}
