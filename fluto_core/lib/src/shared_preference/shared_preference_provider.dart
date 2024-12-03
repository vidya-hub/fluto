import 'dart:async';

import 'package:flutter/material.dart';

class StorageDriverController with ChangeNotifier {
  Map<String, dynamic> _sharedPrefsData = {};
  Map<String, dynamic> get sharedPrefsData => _sharedPrefsData;

  final StorageDriver storageDriver;

  StorageDriverController({
    required this.storageDriver,
  });

  Future<void> loadSharedPreferences() async {
    final keys = await storageDriver.getKeys();

    final data = <String, dynamic>{};
    for (var key in keys) {
      data[key] = storageDriver.read(key);
    }

    _sharedPrefsData = data;
    notifyListeners();
  }

  Future<void> clearSharedPreferences({String? key}) async {
    if (key != null) {
      await storageDriver.delete(key);
    } else {
      await storageDriver.clear();
    }

    await loadSharedPreferences();
  }

  Future<void> updateSharedPreference(String key, dynamic value) async {
    storageDriver.write(key: key, value: value);
    await loadSharedPreferences();
  }
}

abstract class StorageDriver {
  FutureOr<Set<String>> getKeys();
  FutureOr<T?> read<T>(String key);
  FutureOr<void> write<T>({required String key, required T value});
  FutureOr<void> delete(String key);
  FutureOr<void> clear();
}
