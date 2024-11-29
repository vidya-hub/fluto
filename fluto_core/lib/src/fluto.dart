import 'dart:developer';
import 'package:fluto_core/core/fluto_storage.dart';
import 'package:fluto_core/core/pluggable.dart';
import 'package:fluto_core/core/plugin_callback_register.dart';
import 'package:fluto_core/fluto.dart';
import 'package:fluto_core/src/model/fluto_storage_model.dart';
import 'package:fluto_core/src/provider/fluto_provider.dart';
import 'package:fluto_core/src/ui/components/dragging_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Fluto extends StatefulWidget {
  const Fluto({
    super.key,
    required this.child,
    this.wrappedWidgetList = const [],
    this.storage = const NoFlutoStorage(),
    this.pluginList = const [],
    required this.globalContext,
  });

  final Widget child;
  final List<TransitionBuilder> wrappedWidgetList;

  final FlutoStorage storage;
  final BuildContext globalContext;
  final List<Pluggable> pluginList;
  @override
  State<Fluto> createState() => _FlutoState();
}

class _FlutoState extends State<Fluto> {
  FlutoStorageModel? _savedData;

  @override
  void initState() {
    super.initState();
    _loadSavedData();
  }

  Future<void> _loadSavedData() async {
    widget.storage.load().then((savedData) {
      if (savedData != null) {
        _savedData = FlutoStorageModel.fromJson(savedData);
      }
    });

    final pluginList = widget.pluginList;
    FlutoPluginRegistrar.registerAllPlugins(pluginList);
    for (final plugin in pluginList) {
      analysePlugin(plugin);
      final pluginRegister = PluginRegister(
        globalContext: widget.globalContext,
        savePluginData: (final value) async {
          if (_savedData == null) {
            _savedData = FlutoStorageModel(
              setting: {..._savedData?.setting ?? {}},
              pluginInternalData: {
                ..._savedData?.pluginInternalData ?? {},
                ...{plugin.devIdentifier: value}
              },
            );
          } else {
            _savedData?.pluginInternalData?[plugin.devIdentifier] = value;
          }
          if (_savedData != null) {
            widget.storage.save((_savedData!.toJson()));
          }
        },
        loadPluginData: () async {
          return _savedData?.pluginInternalData?[plugin.devIdentifier];
        },
      );
      plugin.setup(pluginRegister: pluginRegister);
    }
  }

  void analysePlugin(Pluggable plugin) {
    try {
      plugin.pluginConfiguration.description;
    } catch (e) {
      log(plugin.devIdentifier, error: e);
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget child = widget.child;

    for (final widgetBuilder in widget.wrappedWidgetList.reversed) {
      child = widgetBuilder.call(context, widget.child);
    }

    return ChangeNotifierProvider<FlutoProvider>(
      create: (context) => FlutoProvider(widget.globalContext),
      builder: (context, child) {
        return child ?? Container();
      },
      child: Scaffold(
        body: Stack(
          children: [
            child,
            const DraggingButton(),
          ],
        ),
      ),
    );
  }
}
