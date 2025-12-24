import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'config/supabase_config.dart';
import 'config/hive_config.dart';
import 'config/theme_config.dart';
import 'screens/home_screen.dart';
import 'providers/client_provider.dart';
import 'providers/produit_provider.dart';
import 'providers/facture_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialiser Supabase
  await SupabaseConfig.initialize();

  // Initialiser Hive
  await HiveConfig.initialize();

  runApp(const VeterinaireApp());
}

class VeterinaireApp extends StatelessWidget {
  const VeterinaireApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ClientProvider()),
        ChangeNotifierProvider(create: (_) => ProduitProvider()),
        ChangeNotifierProvider(create: (_) => FactureProvider()),
      ],
      child: MaterialApp(
        title: 'Pharmacie Vétérinaire',
        debugShowCheckedModeBanner: false,
        theme: ThemeConfig.lightTheme,
        darkTheme: ThemeConfig.darkTheme,
        themeMode: ThemeMode.light,
        home: const HomeScreen(),
      ),
    );
  }
}
