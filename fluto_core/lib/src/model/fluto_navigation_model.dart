// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:fluto_core/src/navigation/navigation_page.dart';

class FlutoNavigationModel {
  final String routeName;
  final DateTime dateTimeNavigated;
  final bool isPop;
  final FlowStep flowStep;
  FlutoNavigationModel({
    required this.routeName,
    required this.dateTimeNavigated,
    this.isPop = false,
    required this.flowStep,
  });

  FlutoNavigationModel copyWith({
    String? routeName,
    DateTime? dateTimeNavigated,
    FlowStep? flowStep,
  }) {
    return FlutoNavigationModel(
      routeName: routeName ?? this.routeName,
      dateTimeNavigated: dateTimeNavigated ?? this.dateTimeNavigated,
      flowStep: flowStep ?? this.flowStep,
    );
  }
}
