import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  static const String supabaseUrl = 'https://teaawwipetvopccqmxpsj.supabase.co';
  static const String supabaseAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InRlYWF3d2lwZXR2b3BjY3FteHBzaiIsInJvbGUiOiJhbm9uIiwiaWF0IjoxNzM0OTY5NjAwLCJleHAiOjIwNTA1NDU2MDB9.vfTEmjjf_jWxSK-zaPquzzw_8PtVCYXQ';

  static Future<void> initialize() async {
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
      debug: true,
    );
  }

  static SupabaseClient get client => Supabase.instance.client;
}
