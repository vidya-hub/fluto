import 'package:example/core/fluto/fluto_storage.dart';
import 'package:example/core/fluto/plugin.dart';
import 'package:example/pages/home_page.dart';
import 'package:fluto_core/fluto.dart';
import 'package:flutter/material.dart';

void main(List<String> args) {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark(),
      home: Builder(
        builder: (context) => Fluto(
          globalContext: context,
          storage: SharedPreferencesFlutoStorage(),
          pluginList: [
            ScreenLauncherPlugin(
              devIdentifier: 'one',
              screen: Scaffold(
                appBar: AppBar(title: const Text("first screen")),
                body: const Text("first screen"),
              ),
              name: "first screen",
            ),
            StorageTestPlugin(devIdentifier: "storage_test"),
          ],
          child: const HomePage(),
        ),
      ),
    );
  }
}
