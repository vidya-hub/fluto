import 'dart:async';
import 'package:fluto_core/src/utils/enums.dart';
import 'dart:developer' as developer;

class FlutoLog {
  String logMessage = '';
  FlutoLogType logType = FlutoLogType.info;
  DateTime logTime = DateTime.now();
  Object? error;
  StackTrace? stackTrace;

  FlutoLog({
    required this.logMessage,
    required this.logType,
    required this.logTime,
    this.error,
    this.stackTrace,
  });

  static void log(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    FlutoLogType logType = FlutoLogType.debug,
  }) {
    final logKey = _getLogKey(logType);
    final logFunction = Zone.current[logKey] as void Function(
      String, {
      Object? error,
      StackTrace? stackTrace,
    })?;
    if (logFunction != null) {
      logFunction(
        message,
        error: error,
        stackTrace: stackTrace,
      );
    } else {
      developer.log(
        message,
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  static Object _getLogKey(FlutoLogType logType) {
    switch (logType) {
      case FlutoLogType.debug:
        return #logDebug;
      case FlutoLogType.info:
        return #logInfo;
      case FlutoLogType.warning:
        return #logWarning;
      case FlutoLogType.error:
        return #logError;
      default:
        return #logDebug;
    }
  }
}
