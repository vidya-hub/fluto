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
  runZonedGuarded(
    () {
      runApp(
        ChangeNotifierProvider.value(
          value: loggerProvider!,
          child: child,
        ),
      );
    },
    (error, stackTrace) {
      loggerProvider?.insertErrorLog(
        error.toString(),
        error: error,
        stackTrace: stackTrace,
      );
      FlutterError.reportError(FlutterErrorDetails(
        exception: error,
        stack: stackTrace,
        library: 'runFlutoAppGuarded',
        context: ErrorDescription('An error occurred in a guarded zone.'),
      ));
    },
    zoneSpecification: ZoneSpecification(
      print: (Zone self, ZoneDelegate parent, Zone zone, String line) {
        loggerProvider?.insertPrintLog(line);
      },
    ),
    zoneValues: loggerProvider.getLogZones,
  );
}
