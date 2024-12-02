import 'dart:async';
import 'package:fluto_core/src/model/fluto_log_type.dart';
import 'dart:developer' as developer;
import 'package:hive/hive.dart';
part 'fluto_log_model.g.dart';

@HiveType(typeId: 0)
class FlutoLogModel {
  @HiveField(0)
  String logMessage;

  @HiveField(1)
  String logType;

  @HiveField(2)
  DateTime logTime;

  @HiveField(3)
  String? errorString;

  @HiveField(4)
  String? stackTraceString;

  FlutoLogModel({
    required this.logMessage,
    required this.logType,
    required this.logTime,
    this.errorString,
    this.stackTraceString,
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
