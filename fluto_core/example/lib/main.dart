import 'package:example/core/fluto/storage_driver.dart';
import 'package:example/pages/home_page.dart';
import 'package:fluto_core/fluto.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

final GlobalKey<NavigatorState> globalNavigatorKey =
    GlobalKey<NavigatorState>();

void main(
  List<String> args,
) async {
  final sharedPref = await SharedPreferences.getInstance();
  runFlutoApp(
    child: MyApp(
      sharedPreferences: sharedPref,
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.sharedPreferences,
  });

  final SharedPreferences sharedPreferences;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: globalNavigatorKey,
      theme: ThemeData.dark(),
      home: Builder(
        builder: (context) => Fluto(
          globalNavigatorKey: globalNavigatorKey,
          pluginList: [
            InternalStoragePlugin(
              storageDriver: SharedPreferencesDriver(sharedPreferences),
            ),
          ],
          child: const HomePage(),
        ),
      ),
    );
  }
}

