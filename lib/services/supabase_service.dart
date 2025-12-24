import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/supabase_config.dart';

class SupabaseService {
  final SupabaseClient _client = SupabaseConfig.client;

  // Méthode générique pour récupérer des données
  Future<List<Map<String, dynamic>>> getData(String table) async {
    try {
      final response = await _client.from(table).select();
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Erreur lors de la récupération des données: $e');
    }
  }

  // Méthode générique pour insérer des données
  Future<Map<String, dynamic>> insertData(
    String table,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _client.from(table).insert(data).select().single();
      return response;
    } catch (e) {
      throw Exception('Erreur lors de l\'insertion: $e');
    }
  }

  // Méthode générique pour mettre à jour des données
  Future<Map<String, dynamic>> updateData(
    String table,
    int id,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _client
          .from(table)
          .update(data)
          .eq('id', id)
          .select()
          .single();
      return response;
    } catch (e) {
      throw Exception('Erreur lors de la mise à jour: $e');
    }
  }

  // Méthode générique pour supprimer des données
  Future<void> deleteData(String table, int id) async {
    try {
      await _client.from(table).delete().eq('id', id);
    } catch (e) {
      throw Exception('Erreur lors de la suppression: $e');
    }
  }

  // Appeler une fonction RPC
  Future<dynamic> callRpc(String functionName, Map<String, dynamic> params) async {
    try {
      final response = await _client.rpc(functionName, params: params);
      return response;
    } catch (e) {
      throw Exception('Erreur lors de l\'appel RPC: $e');
    }
  }

  // Upload d'image vers Supabase Storage
  Future<String> uploadImage(String bucket, String path, List<int> bytes) async {
    try {
      await _client.storage.from(bucket).uploadBinary(path, bytes);
      return _client.storage.from(bucket).getPublicUrl(path);
    } catch (e) {
      throw Exception('Erreur lors de l\'upload d\'image: $e');
    }
  }
}
