import 'package:hive_flutter/hive_flutter.dart';
import '../models/client.dart';
import '../models/produit.dart';
import '../models/facture.dart';
import '../models/ligne_facture.dart';
import '../models/parametres.dart';

class HiveService {
  static const String clientsBox = 'clients';
  static const String produitsBox = 'produits';
  static const String facturesBox = 'factures';
  static const String lignesFactureBox = 'lignes_facture';
  static const String parametresBox = 'parametres';

  // Sauvegarder une liste d'éléments
  Future<void> saveList<T>(String boxName, List<T> items) async {
    final box = await Hive.openBox<T>(boxName);
    await box.clear();
    await box.addAll(items);
  }

  // Récupérer une liste d'éléments
  Future<List<T>> getList<T>(String boxName) async {
    final box = await Hive.openBox<T>(boxName);
    return box.values.toList();
  }

  // Sauvegarder un élément unique
  Future<void> saveItem<T>(String boxName, String key, T item) async {
    final box = await Hive.openBox<T>(boxName);
    await box.put(key, item);
  }

  // Récupérer un élément unique
  Future<T?> getItem<T>(String boxName, String key) async {
    final box = await Hive.openBox<T>(boxName);
    return box.get(key);
  }

  // Supprimer un élément
  Future<void> deleteItem<T>(String boxName, String key) async {
    final box = await Hive.openBox<T>(boxName);
    await box.delete(key);
  }

  // Vider une box
  Future<void> clearBox(String boxName) async {
    final box = await Hive.openBox(boxName);
    await box.clear();
  }

  // Méthodes spécifiques pour chaque type

  // Clients
  Future<void> saveClients(List<Client> clients) async {
    await saveList(clientsBox, clients);
  }

  Future<List<Client>> getClients() async {
    return await getList<Client>(clientsBox);
  }

  // Produits
  Future<void> saveProduits(List<Produit> produits) async {
    await saveList(produitsBox, produits);
  }

  Future<List<Produit>> getProduits() async {
    return await getList<Produit>(produitsBox);
  }

  // Factures
  Future<void> saveFactures(List<Facture> factures) async {
    await saveList(facturesBox, factures);
  }

  Future<List<Facture>> getFactures() async {
    return await getList<Facture>(facturesBox);
  }

  // Lignes de facture
  Future<void> saveLignesFacture(List<LigneFacture> lignes) async {
    await saveList(lignesFactureBox, lignes);
  }

  Future<List<LigneFacture>> getLignesFacture() async {
    return await getList<LigneFacture>(lignesFactureBox);
  }

  // Paramètres (un seul élément)
  Future<void> saveParametres(Parametres parametres) async {
    await saveItem(parametresBox, 'main', parametres);
  }

  Future<Parametres?> getParametres() async {
    return await getItem<Parametres>(parametresBox, 'main');
  }
}
