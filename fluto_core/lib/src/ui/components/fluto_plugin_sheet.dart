import 'package:fluto_core/core/pluggable.dart';
import 'package:fluto_core/src/core/plugin_manager.dart';
import 'package:fluto_core/src/provider/fluto_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> showFlutoBottomSheet(BuildContext context) async {
  final pluginList = FlutoPluginRegistrar.pluginList;

  showModalBottomSheet(
    isDismissible: false,
    enableDrag: false,
    context: context,
    builder: (BuildContext _) {
      return Builder(
        builder: (BuildContext _) {
          final provider = context.read<FlutoProvider>();
          provider.setSheetState(PluginSheetState.clickedAndOpened);
          return PopScope(
            onPopInvoked: (_) async {
              provider.setSheetState(PluginSheetState.closed);
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  title: const Text("Fluto Project"),
                  trailing: IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      provider.setSheetState(PluginSheetState.closed);
                    },
                    icon: const Icon(Icons.close),
                  ),
                ),
                const Divider(),
                Expanded(
                  child: Visibility(
                    visible: pluginList.isNotEmpty,
                    replacement:
                        const Center(child: Text("No Plugin Available")),
                    child: GridView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      itemCount: pluginList.length,
                      itemBuilder: (context, index) {
                        final plugin = pluginList[index];

                        return Card(
                          clipBehavior: Clip.antiAlias,
                          color: Color.alphaBlend(
                            Theme.of(context).cardColor,
                            Theme.of(context).secondaryHeaderColor,
                          ),
                          child: FlutoSheetListTile(plugin: plugin),
                        );
                      },
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

class FlutoSheetListTile extends StatelessWidget {
  const FlutoSheetListTile({
    Key? key,
    required this.plugin,
  }) : super(key: key);

  final Pluggable plugin;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        plugin.navigation.onLaunch.call();
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            plugin.pluginConfiguration.icon,
            size: 30,
          ),
          const Padding(padding: EdgeInsets.all(10)),
          Text(
            plugin.pluginConfiguration.name,
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
