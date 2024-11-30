import 'dart:async';
import 'package:fluto_core/src/logger/logger_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void runFlutoApp({
  required Widget child,
}) {
  BindingBase.debugZoneErrorsAreFatal = true;
  FlutoLoggerProvider? loggerProvider;

  loggerProvider = FlutoLoggerProvider();

  runZoned(
    () {
      runApp(
        ChangeNotifierProvider.value(
          value: loggerProvider!,
          child: child,
        ),
      );
    },
    zoneSpecification: ZoneSpecification(
      print: (Zone self, ZoneDelegate parent, Zone zone, String line) {
        loggerProvider?.insertPrintLog(line);
      },
      handleUncaughtError: (self, parent, zone, error, stackTrace) {
        loggerProvider?.insertErrorLog(
          error.toString(),
          error: error,
          stackTrace: stackTrace,
        );
      },
    ),
    zoneValues: loggerProvider.getLogZones,
  );
}
