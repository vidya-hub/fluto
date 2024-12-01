import 'package:flutter/material.dart';

class Navigation {
  final VoidCallback onLaunch;
  Navigation(this.onLaunch);

  factory Navigation.byScreen({
    required BuildContext globalContext,
    required Widget screen,
  }) {
    Navigator.pop(globalContext);
    return _ScreenNavigation(
      globalContext: globalContext,
      screen: screen,
    );
  }
}

class _ScreenNavigation extends Navigation {
  _ScreenNavigation({
    required Widget screen,
    required BuildContext globalContext,
  }) : super(
          () {
            Navigator.of(globalContext).push(
              MaterialPageRoute<void>(
                builder: (BuildContext context) => screen,
              ),
            );
          },
        );
}
