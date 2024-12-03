import 'package:fluto_core/core/navigation.dart';
import 'package:fluto_core/core/pluggable.dart';
import 'package:fluto_core/model/plugin_configuration.dart';
import 'package:fluto_core/src/shared_preference/shared_preference_provider.dart';
import 'package:fluto_core/src/shared_preference/shared_preference_viewer.dart';
import 'package:flutter/material.dart';

class ScreenLauncherPlugin extends Pluggable {
  final Widget screen;
  final String name;
  final IconData icon;
  final String description;

  ScreenLauncherPlugin({
    required super.devIdentifier,
    required this.screen,
    required this.name,
    this.icon = Icons.bug_report,
    this.description = "",
  });

  @override
  Navigation get navigation => Navigation.byScreen(
        globalContext: context!,
        screen: screen,
      );

  @override
  PluginConfiguration get pluginConfiguration => PluginConfiguration(
        name: name,
        icon: icon,
        description: description,
      );
}

class InternalStoragePlugin extends Pluggable {
  InternalStoragePlugin({
    required StorageDriver storageDriver,
  })  : _provider = StorageDriverController(storageDriver: storageDriver),
        super(devIdentifier: "internal_storage_plugin");

  final StorageDriverController _provider;

  @override
  Navigation get navigation => Navigation.byScreen(
        globalContext: context!,
        screen: SharedPreferencesViewer(
          provider: _provider,
        ),
      );

  @override
  PluginConfiguration get pluginConfiguration => PluginConfiguration(
        name: "Internal Storage Viewer",
        icon: Icons.storage,
        description: "View and clear shared preferences",
      );
}
