import 'package:fluto_core/core/pluggable.dart';
import 'package:fluto_core/fluto.dart';
import 'package:fluto_core/src/logger/log_viewer.dart';
import 'package:fluto_core/src/navigation/navigation_page.dart';
import 'package:fluto_core/src/network/network_viewer.dart';

abstract class FlutoPluginRegistrar {
  static Map<String, Pluggable> defaultPlugins = {
    "Log-Viewer": ScreenLauncherPlugin(
      devIdentifier: 'one',
      screen: const LogViewer(),
      name: "Log-Viewer",
    ),
    "Network": ScreenLauncherPlugin(
      devIdentifier: 'two',
      screen: const NetworkViewer(),
      name: "Network",
    ),
    "Navigation": ScreenLauncherPlugin(
      devIdentifier: 'three',
      screen: NavigationPage(),
      name: "Navigation",
    ),
  };
  static final Map<String, Pluggable> _plugins = {};

  static Map<String, Pluggable> get plugins => _plugins;
  static List<Pluggable> get pluginList => _plugins.values.toList();

  static void registerPlugin(Pluggable plugin) {
    _plugins.addEntries([MapEntry(plugin.devIdentifier, plugin)]);
  }

  static void unregisterPlugin(Pluggable plugin) {
    _plugins.remove(plugin);
  }

  static void unregisterPluginById(String pluginId) {
    return _plugins.removeWhere((key, value) => key == pluginId);
  }

  static void unregisterAllPlugins() {
    _plugins.clear();
  }

  static void registerAllPlugins([List<Pluggable>? plugins]) {
    if (plugins != null) {
      _plugins.addEntries(plugins.map((e) => MapEntry(e.devIdentifier, e)));
    }
  }
}
