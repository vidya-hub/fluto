import 'package:draggable_widget/draggable_widget.dart';
import 'package:fluto_core/src/provider/fluto_provider.dart';
import 'package:fluto_core/src/ui/components/fluto_plugin_sheet.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DraggingButton extends StatelessWidget {
  final GlobalKey<NavigatorState> childNavigatorKey;
  const DraggingButton({
    super.key,
    required this.childNavigatorKey,
  });

  @override
  Widget build(BuildContext context) {
    final flutoProvider = context.read<FlutoProvider>();
    final showDraggingButton = context
        .select<FlutoProvider, bool>((value) => value.showDraggingButton);
    return DraggableWidget(
      bottomMargin: 120,
      topMargin: 120,
      intialVisibility: showDraggingButton,
      horizontalSpace: 5,
      shadowBorderRadius: 1,
      initialPosition: AnchoringPosition.bottomRight,
      dragController: flutoProvider.dragController,
      normalShadow: const BoxShadow(
          color: Colors.transparent, offset: Offset(0, 4), blurRadius: 2),
      child: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.bug_report),
        onPressed: () {
          showFlutoBottomSheet(childNavigatorKey.currentContext!);
        },
      ),
    );
  }
}
