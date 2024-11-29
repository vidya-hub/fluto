import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class PluginRegister {
  final BuildContext globalContext;
  final AsyncValueSetter<String?> savePluginData;
  final AsyncValueGetter<String?> loadPluginData;
  PluginRegister({
    required this.globalContext,
    required this.savePluginData,
    required this.loadPluginData,
  });
}
