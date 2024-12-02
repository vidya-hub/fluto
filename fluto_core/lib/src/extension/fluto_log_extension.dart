import 'package:fluto_core/fluto.dart';

extension FlutoExtension on FlutoLogModel {
  String get getFormattedLogTime {
    return '${logTime.year}-${logTime.month.toString().padLeft(2, '0')}-${logTime.day.toString().padLeft(2, '0')} '
        '${(logTime.hour % 12 == 0 ? 12 : logTime.hour % 12).toString().padLeft(2, '0')}:${logTime.minute.toString().padLeft(2, '0')}:${logTime.second.toString().padLeft(2, '0')} '
        '${logTime.hour < 12 ? 'AM' : 'PM'}';
  }
}

extension StackTraceFormatter on StackTrace {
  String get getFormattedError {
    return toString().split('\n').take(5).join('\n');
  }
}

extension StringExtensions on String {
  String get camelCase {
    return this[0].toUpperCase() + substring(1);
  }
}
