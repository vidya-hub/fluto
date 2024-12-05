import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HeadlessFlutoLoggerProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _logs = [];

  List<Map<String, dynamic>> get logs => _logs;

  void addLog(Map<String, dynamic> log) {
    _logs = [..._logs, log];
    notifyListeners();
  }

Future<void> getLogs({
 required Supabase supabase,
})async{

}
}
