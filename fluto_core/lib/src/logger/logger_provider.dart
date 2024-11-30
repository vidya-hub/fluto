import 'dart:developer';
import 'package:fluto_core/src/logger/fluto_logger.dart';
import 'package:fluto_core/src/utils/enums.dart';
import 'package:flutter/foundation.dart';

class FlutoLoggerProvider with ChangeNotifier {
  List<FlutoLog> debugLogs = [];
  List<FlutoLog> infoLogs = [];
  List<FlutoLog> warningLogs = [];
  List<FlutoLog> errorLogs = [];
  List<FlutoLog> printLogs = [];

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
      case FlutoLogType.print:
        return printLogs;
      default:
        return printLogs;
    }
  }

  void insertDebugLog(String message) {
    log(message, name: FlutoLogType.debug.name);
    debugLogs = [
      ...debugLogs,
      FlutoLog(
        logMessage: message,
        logType: FlutoLogType.debug,
        logTime: DateTime.now(),
      )
    ];
    notifyListeners();
  }

  void insertPrintLog(String message) {
    log(message, name: FlutoLogType.print.name);
    printLogs = [
      ...printLogs,
      FlutoLog(
        logMessage: message,
        logType: FlutoLogType.print,
        logTime: DateTime.now(),
      )
    ];
    notifyListeners();
  }

  void insertInfoLog(String message) {
    log(message, name: FlutoLogType.info.name);
    infoLogs = [
      ...infoLogs,
      FlutoLog(
        logMessage: message,
        logType: FlutoLogType.info,
        logTime: DateTime.now(),
      ),
    ];
    notifyListeners();
  }

  void insertWarningLog(String message) {
    log(message, name: FlutoLogType.warning.name);
    warningLogs = [
      ...warningLogs,
      FlutoLog(
        logMessage: message,
        logType: FlutoLogType.warning,
        logTime: DateTime.now(),
      ),
    ];
    notifyListeners();
  }

  void insertErrorLog(
    String message, {
    Object? error,
    StackTrace? stackTrace,
  }) {
    log(message, name: FlutoLogType.error.name);
    errorLogs = [
      ...errorLogs,
      FlutoLog(
        logMessage: message,
        logType: FlutoLogType.error,
        logTime: DateTime.now(),
      ),
    ];
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
