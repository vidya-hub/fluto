import 'dart:async';

import 'package:fluto_core/fluto.dart';
import 'package:fluto_core/src/provider/fluto_navigation_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'provider/logger_provider.dart';

class FlutoAppRunner {
  static final FlutoAppRunner _instance = FlutoAppRunner._internal();
  late FlutoLoggerProvider _loggerProvider;
  late FlutoNavigationProvider _flutoNavigationProvider;
  late NetworkProvider _networkProvider;
  static FlutoNavigationProvider get navigationProvider =>
      _instance._flutoNavigationProvider;

  factory FlutoAppRunner() {
    return _instance;
  }

  FlutoAppRunner._internal() {
    _loggerProvider = FlutoLoggerProvider();
    _flutoNavigationProvider = FlutoNavigationProvider();
  }
  Future<void> initNetworkProvider() async {
    _networkProvider = await NetworkProvider.init();
    NetworkCallInterceptor.init(_networkProvider);
  }

  Future<void> runFlutoRunner({
    required Widget child,
  }) async {
    await runZonedGuarded(
      () async {
        BindingBase.debugZoneErrorsAreFatal = true;
        WidgetsFlutterBinding.ensureInitialized();

        try {
          await Hive.initFlutter();

          if (!Hive.isAdapterRegistered(FlutoLogModelAdapter().typeId)) {
            Hive.registerAdapter(FlutoLogModelAdapter());
          }
          if (!Hive.isAdapterRegistered(FlutoLogTypeAdapter().typeId)) {
            Hive.registerAdapter(FlutoLogTypeAdapter());
          }

          BindingBase.debugZoneErrorsAreFatal = false;

          await _loggerProvider.initHive();
          await initNetworkProvider();

          runApp(
            MultiProvider(
              providers: [
                ChangeNotifierProvider.value(
                  value: _loggerProvider,
                ),
                ChangeNotifierProvider.value(
                  value: _flutoNavigationProvider,
                ),
              ],
              child: child,
            ),
          );
        } catch (error, stackTrace) {
          FlutterError.reportError(
            FlutterErrorDetails(
              exception: error,
              stack: stackTrace,
              library: 'FlutoAppRunner',
              context: ErrorDescription('Failed to initialize application'),
            ),
          );
          rethrow;
        }
      },
      (error, stackTrace) {
        _loggerProvider.insertErrorLog(
          error.toString(),
          error: error,
          stackTrace: stackTrace,
        );
        FlutterError.reportError(
          FlutterErrorDetails(
            exception: error,
            stack: stackTrace,
            library: 'FlutoAppRunner',
            context: ErrorDescription('Unhandled error in application zone'),
          ),
        );
      },
      zoneSpecification: ZoneSpecification(
        print: (Zone self, ZoneDelegate parent, Zone zone, String line) {
          _loggerProvider.insertPrintLog(line);
          parent.print(zone, line);
        },
      ),
      zoneValues: _loggerProvider.getLogZones,
    );
  }

  FlutoLoggerProvider get loggerProvider => _loggerProvider;
}
