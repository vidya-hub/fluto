import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseProvider extends ChangeNotifier {
  Supabase? _supabase;

  initSupabase() async {
    if (_supabase != null) return;
    _supabase = await Supabase.initialize(
      url: dotenv.env["URL"] ?? "",
      anonKey: dotenv.env["ANNON_KEY"] ?? "",
    );
    notifyListeners();
  }

  Future<Stream<List<Map<String, dynamic>>>> getLogStream() async {
    if (_supabase == null) {
      await initSupabase();
    }
    return _supabase!.client
        .from(
          'fluto_logs',
        )
        .select()
        .asStream();
  }
}
