import 'dart:async';
import 'package:fluto_core/src/fluto_app_runner.dart';
import 'package:flutter/material.dart';

Future<void> runFlutoApp({
  required Widget child,
}) async {
  FlutoAppRunner flutoAppRunner = FlutoAppRunner();
  flutoAppRunner.runFlutoRunner(
    child: child,
  );
}
