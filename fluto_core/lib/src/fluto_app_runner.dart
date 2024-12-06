import 'dart:async';

import 'package:fluto_core/fluto.dart';
import 'package:fluto_core/src/network/network_storage.dart';
import 'package:fluto_core/src/provider/supabase_provider.dart';
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
  late NetworkStorage _networkStorage;
  late SupabaseProvider _supabaseProvider;

  factory FlutoAppRunner() {
    return _instance;
  }

  FlutoAppRunner._internal() {
    _loggerProvider = FlutoLoggerProvider();
    _supabaseProvider = SupabaseProvider();
  }

  Future<void> runFlutoRunner({
    required Widget child,
    required VoidCallback? onBeforeRebirth,
    Future<void> Function()? onInit,
    void Function(Object error, StackTrace stack)? onError,
  }) async {
    BindingBase.debugZoneErrorsAreFatal = true;

    await runZonedGuarded(
      () async {
        WidgetsFlutterBinding.ensureInitialized();
        await dotenv.load(fileName: ".env");

        try {
          await _supabaseProvider.initSupabase();
          await Hive.initFlutter();

          if (!Hive.isAdapterRegistered(FlutoLogModelAdapter().typeId)) {
            Hive.registerAdapter(FlutoLogModelAdapter());
          }
          if (!Hive.isAdapterRegistered(FlutoLogTypeAdapter().typeId)) {
            Hive.registerAdapter(FlutoLogTypeAdapter());
          }

          BindingBase.debugZoneErrorsAreFatal = false;
          await _loggerProvider.initHive(
            supabase: _supabaseProvider.supabase,
          );
          if (onInit != null) {
            await onInit();
          }
          final LazyBox box = await Hive.openLazyBox('NetworkProvider');
          _networkStorage = NetworkStorage(box, _supabaseProvider.supabase);
          await _networkStorage.init();
          NetworkCallInterceptor.init(_networkStorage);

          runApp(
            Phoenix(
              onBeforeRebirth: onBeforeRebirth,
              child: MultiProvider(
                providers: [
                  ChangeNotifierProvider.value(
                    value: _loggerProvider,
                  ),
                  ChangeNotifierProvider.value(
                    value: _supabaseProvider,
                  ),
                ],
                child: child,
              ),
            ),
          );
        } catch (error, stackTrace) {
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
  NetworkStorage get networkStorage => _networkStorage;
}

/// Wrap your root App widget in this widget and call [Phoenix.rebirth] to restart your app.
class Phoenix extends StatefulWidget {
  final Widget child;
  final VoidCallback? onBeforeRebirth;

  const Phoenix({
    super.key,
    required this.child,
    this.onBeforeRebirth,
  });

  @override
  State<Phoenix> createState() => _PhoenixState();

  static rebirth(BuildContext context) {
    context.findAncestorStateOfType<_PhoenixState>()!.restartApp();
  }
}

class _PhoenixState extends State<Phoenix> {
  Key _key = UniqueKey();

  void restartApp() {
    widget.onBeforeRebirth?.call();
    setState(() {
      _key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: _key,
      child: widget.child,
    );
  }
}
