import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseProvider extends ChangeNotifier {
  Supabase? supabase;
  Future<void> initSupabase() async {
    supabase = await Supabase.initialize(
      url: dotenv.env["URL"] ?? "",
      anonKey: dotenv.env["ANNON_KEY"] ?? "",
    );
    notifyListeners();
  }
}
