import 'package:hive_flutter/hive_flutter.dart';

class HiveConfig {
  static Future<void> initialize() async {
    await Hive.initFlutter();
    
    // Note: Adapters must be registered after they are generated with build_runner
    // Uncomment the following lines after running:
    // flutter pub run build_runner build --delete-conflicting-outputs
    
    // Hive.registerAdapter(ClientAdapter());
    // Hive.registerAdapter(ProduitAdapter());
    // Hive.registerAdapter(FactureAdapter());
    // Hive.registerAdapter(LigneFactureAdapter());
    // Hive.registerAdapter(ParametresAdapter());
  }

  static Future<Box<T>> openBox<T>(String name) async {
    return await Hive.openBox<T>(name);
  }
}
