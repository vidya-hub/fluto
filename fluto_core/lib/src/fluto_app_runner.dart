import 'dart:async';

import 'package:fluto_core/fluto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'logger/logger_provider.dart';

class FlutoAppRunner {
  static final FlutoAppRunner _instance = FlutoAppRunner._internal();
  late FlutoLoggerProvider _loggerProvider;
  late NetworkProvider _networkProvider;

  factory FlutoAppRunner() {
    return _instance;
  }

  FlutoAppRunner._internal() {
    _loggerProvider = FlutoLoggerProvider();
  }
  Future<void> initNetworkProvider() async {
    _networkProvider = await NetworkProvider.init();
    NetworkCallInterceptor.init(_networkProvider);
  }

  Future<void> runFlutoRunner({
    required Widget child,
    Future<void> Function()? onInit,
    void Function(Object error, StackTrace stack)? onError,
  }) async {
    BindingBase.debugZoneErrorsAreFatal = true;

    await runZonedGuarded(
      () async {
        WidgetsFlutterBinding.ensureInitialized();
        if (onInit != null) {
          await onInit();
        }
        try {
        
          await Hive.initFlutter();

          if (!Hive.isAdapterRegistered(FlutoLogModelAdapter().typeId)) {
            Hive.registerAdapter(FlutoLogModelAdapter());
          }
          if (!Hive.isAdapterRegistered(FlutoLogTypeAdapter().typeId)) {
            Hive.registerAdapter(FlutoLogTypeAdapter());
          }

          BindingBase.debugZoneErrorsAreFatal = false;
          await dotenv.load(fileName: ".env");
          await _loggerProvider.initHive();
          await initNetworkProvider();

          runApp(
            MultiProvider(
              providers: [
                ChangeNotifierProvider.value(
                  value: _loggerProvider,
                ),
              ],
              child: child,
            ),
          );
        } catch (error, stackTrace) {
          onError?.call(error, stackTrace);
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
        onError?.call(error, stackTrace);
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
