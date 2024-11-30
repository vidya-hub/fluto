import 'package:fluto_core/src/logger/fluto_logger.dart';
import 'package:fluto_core/src/utils/enums.dart';
import 'package:flutter/foundation.dart';

class FlutoLoggerProvider with ChangeNotifier {
  final Map<FlutoLogType, List<FlutoLog>> _logs = {};
  final List<FlutoLog> debugLogs = [];
  final List<FlutoLog> infoLogs = [];
  final List<FlutoLog> warningLogs = [];
  final List<FlutoLog> errorLogs = [];

  List<FlutoLog> logs({
    FlutoLogType type = FlutoLogType.debug,
  }) {
    switch (type) {
      case FlutoLogType.debug:
        return debugLogs;
      case FlutoLogType.info:
        return infoLogs;
      case FlutoLogType.warning:
        return warningLogs;
      case FlutoLogType.error:
        return errorLogs;
      default:
        return [];
    }
  }

  void insertDebugLog(String message) {
    _logs[FlutoLogType.debug] = _logs[FlutoLogType.info] ?? [];
    notifyListeners();
  }

  void insertInfoLog(String message) {
    _logs[FlutoLogType.info] = _logs[FlutoLogType.info] ?? [];
    notifyListeners();
  }

  void insertWarningLog(String message) {
    _logs[FlutoLogType.warning] = _logs[FlutoLogType.warning] ?? [];
    notifyListeners();
  }

  void insertErrorLog(
    String message, {
    Object? error,
    StackTrace? stackTrace,
  }) {
    _logs[FlutoLogType.error] = _logs[FlutoLogType.error] ?? [];
    notifyListeners();
  }

  void clearLogs() {
    _logs.clear();
    notifyListeners();
  }

  Map<Object?, Object?>? get getLogZones => {
        #logDebug: (
          String message, {
          Object? error,
          StackTrace? stackTrace,
        }) {
          insertDebugLog(message);
        },
        #logInfo: (
          String message, {
          Object? error,
          StackTrace? stackTrace,
        }) {
          insertInfoLog(message);
        },
        #logWarning: (
          String message, {
          Object? error,
          StackTrace? stackTrace,
        }) {
          insertWarningLog(message);
        },
        #logError: (
          String message, {
          Object? error,
          StackTrace? stackTrace,
        }) {
          insertErrorLog(
            message,
            error: error,
            stackTrace: stackTrace,
          );
        },
      };
}
