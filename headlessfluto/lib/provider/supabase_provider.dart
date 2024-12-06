import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:headlessfluto/model/network_model.dart';
import 'package:headlessfluto/provider/fluto_logger_provider.dart';
import 'package:headlessfluto/provider/fluto_network_provider.dart';
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
    return _supabase!.client.from('fluto_logs').stream(primaryKey: ['id']);
  }

  Future<Stream<List<Map<String, dynamic>>>> getNetworkStream() async {
    return _supabase!.client.from('fluto_network').stream(primaryKey: ['id']);
  }

  Future<void> setInitialLogData({
    required HeadlessFlutoLoggerProvider loggerProvider,
    required FlutoNetworkProvider networkProvider,
  }) async {
    await _supabase!.client.from('fluto_logs').select().then((value) {
      for (var element in value) {
        loggerProvider.addLog(element);
      }
    });
    await _supabase!.client.from('fluto_network').select().then((value) {
      for (var element in value) {
        networkProvider.addNetworkCall(NetworkNetworkCall.fromJson(
          element,
        ));
      }
    });
  }
}
