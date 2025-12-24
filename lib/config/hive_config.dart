import 'package:hive_flutter/hive_flutter.dart';

class HiveConfig {
  static Future<void> initialize() async {
    await Hive.initFlutter();
    
    // Register adapters here after they are generated
    // Hive.registerAdapter(ClientHiveAdapter());
    // Hive.registerAdapter(ProduitHiveAdapter());
    // Hive.registerAdapter(FactureHiveAdapter());
    // Hive.registerAdapter(LigneFactureHiveAdapter());
    // Hive.registerAdapter(ParametresHiveAdapter());
  }

  static Future<Box<T>> openBox<T>(String name) async {
    return await Hive.openBox<T>(name);
  }
}
