import 'package:flutter/material.dart';
import 'package:headlessfluto/fluto_log_type.dart';

class HeadlessFlutoLoggerProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _logs = [];
  final Map<FlutoLogType, List<Map<String, dynamic>>> _segregatedLogs = {
    FlutoLogType.error: [],
    FlutoLogType.print: [],
  };

  List<Map<String, dynamic>> get logs => _logs;
  Map<FlutoLogType, List<Map<String, dynamic>>> get segregatedLogs =>
      _segregatedLogs;

  void addLog(Map<String, dynamic> log) {
    _logs = [log, ..._logs];
    if (_logs.isEmpty) {
      return;
    }
    try {
      
    FlutoLogType? logType = FlutoLogType.values.firstWhere(
        (type) => type.toString().split('.').last == log['log_type']);
    _segregatedLogs[logType] = [log, ..._segregatedLogs[logType]!];
    } catch (e) {
      print("some error $e");
    }

    notifyListeners();
  }
}
