import 'dart:async';
import 'package:fluto_core/src/fluto_app_runner.dart';
import 'package:flutter/material.dart';

Future<void> runFlutoApp({
  required Widget child,
  Future<void> Function()? onInit,

  void Function(Object error, StackTrace stack)? onError,
  VoidCallback? onBeforeRebirth,
}) async {
  FlutoAppRunner flutoAppRunner = FlutoAppRunner();
  flutoAppRunner.runFlutoRunner(
    onBeforeRebirth: onBeforeRebirth,
    child: child,
    onInit: onInit,
    onError: onError,
  );
}
