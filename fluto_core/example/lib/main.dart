import 'package:example/core/fluto/fluto_storage.dart';
import 'package:example/pages/home_page.dart';
import 'package:fluto_core/fluto.dart';
import 'package:flutter/material.dart';

void main(
  List<String> args,
) {
  runFlutoApp(
    child: const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: Builder(
        builder: (context) => Fluto(
          globalContext: context,
          child: const HomePage(),
        ),
      ),
    );
  }
}
