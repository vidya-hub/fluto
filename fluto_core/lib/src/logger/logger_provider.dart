import 'dart:developer';
import 'package:fluto_core/src/model/fluto_log_model.dart';
import 'package:fluto_core/src/utils/enums.dart';
import 'package:flutter/foundation.dart';

class FlutoLoggerProvider with ChangeNotifier {
  List<FlutoLogModel> debugLogs = [];
  List<FlutoLogModel> infoLogs = [];
  List<FlutoLogModel> warningLogs = [];
  List<FlutoLogModel> errorLogs = [];
  List<FlutoLogModel> printLogs = [];

  List<FlutoLogModel> logs({
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
      FlutoLogModel(
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
      FlutoLogModel(
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
      FlutoLogModel(
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
      FlutoLogModel(
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
    final formattedStackTrace =
        stackTrace.toString().split('\n').take(5).join('\n');

    log(
      "Error: $error\nStackTrace:\n$formattedStackTrace",
      name: FlutoLogType.error.name,
    );
    errorLogs = [
      ...errorLogs,
      FlutoLogModel(
        logMessage: message,
        logType: FlutoLogType.error,
        logTime: DateTime.now(),
        error: error,
        stackTrace: stackTrace,
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
