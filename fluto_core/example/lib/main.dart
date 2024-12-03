import 'package:example/pages/first_page.dart';
import 'package:example/pages/home_page.dart';
import 'package:example/pages/second_page.dart';
import 'package:fluto_core/fluto.dart';
import 'package:flutter/material.dart';

final GlobalKey<NavigatorState> globalNavigatorKey =
    GlobalKey<NavigatorState>();

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
      routes: {
        "/": (context) => Builder(
              builder: (context) => Fluto(
                globalNavigatorKey: globalNavigatorKey,
                child: const HomePage(),
              ),
            ),
        '/first': (context) => const FirstPage(),
        '/second': (context) => const SecondPage(),
      },
      debugShowCheckedModeBanner: false,
      navigatorKey: globalNavigatorKey,
      navigatorObservers: [
        FlutoNavigationObserver(),
      ],
      theme: ThemeData.dark(),
      initialRoute: '/',
    );
  }
}
