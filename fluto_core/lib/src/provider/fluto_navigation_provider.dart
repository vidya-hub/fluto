import 'package:fluto_core/src/model/fluto_navigation_model.dart';
import 'package:fluto_core/src/navigation/navigation_page.dart';
import 'package:flutter/material.dart';

class FlutoNavigationProvider extends ChangeNotifier {
  List<FlutoNavigationModel> navigationList = [];
  void addNavigation({
    bool isPop = false,
    String routeName = '',
  }) {
    navigationList = [
      ...navigationList,
      FlutoNavigationModel(
        routeName: routeName,
        dateTimeNavigated: DateTime.now(),
        flowStep: FlowStep(
          text: routeName,
          type: FlowStepType.end,
        ),
      )
    ];
  }
}
