import 'package:fluto_core/src/fluto_app_runner.dart';
import 'package:flutter/material.dart';

class FlutoNavigationObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    FlutoAppRunner.navigationProvider.addNavigation(
      routeName: route.settings.name ?? "",
    );
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    FlutoAppRunner.navigationProvider.addNavigation(
      routeName: route.settings.name ?? "",
      isPop: true,
    );
  }
}
