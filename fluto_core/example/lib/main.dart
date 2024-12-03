import 'package:example/pages/home_page.dart';
import 'package:fluto_core/fluto.dart';
import 'package:flutter/material.dart';

import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:fluto_core/src/shared_preference/shared_preference_provider.dart';

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

class SharedPreferencesDriver implements StorageDriver {
  SharedPreferencesDriver(this.sharedPreferences);

  final SharedPreferences sharedPreferences;

  @override
  Set<String> getKeys() {
    return sharedPreferences.getKeys();
  }

  @override
  FutureOr<T?> read<T>(String key) {
    return sharedPreferences.get(key) as T;
  }

  @override
  FutureOr<void> write<T>({required String key, required T value}) async {
    if (value is int) {
      await sharedPreferences.setInt(key, value);
      return;
    }
    if (value is double) {
      await sharedPreferences.setDouble(key, value);
      return;
    }
    if (value is String) {
      await sharedPreferences.setString(key, value);
      return;
    }
    if (value is List<String>) {
      await sharedPreferences.setStringList(key, value);
      return;
    }
    if (value is bool) {
      await sharedPreferences.setBool(key, value);
      return;
    }
  }

  @override
  FutureOr<void> delete(String key) {
    sharedPreferences.remove(key);
  }

  @override
  FutureOr<void> clear() => sharedPreferences.clear();
}
