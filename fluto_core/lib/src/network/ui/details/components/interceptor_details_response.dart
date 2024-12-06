import 'package:collection/collection.dart';
import 'package:fluto_core/src/network/infospect_network_call.dart';
import 'package:fluto_core/src/network/ui/details/widgets/details_row_widget.dart';
import 'package:fluto_core/src/utils/common_widgets/conditional_widget.dart';
import 'package:flutter/material.dart';

import '../../list/components/expansion_widget.dart';
import '../models/details_topic_data.dart';
import '../widgets/trailing_widget.dart';

class InterceptorDetailsResponse extends StatelessWidget {
  final InfospectNetworkCall call;

  const InterceptorDetailsResponse(
    this.call, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ConditionalWidget(
      condition: call.loading || call.response == null,
      ifTrue: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [CircularProgressIndicator(), Text("Awaiting response")],
        ),
      ),
      ifFalse: Builder(
        builder: (context) {
          final ResponseDetailsTopicHelper topicHelper = ResponseDetailsTopicHelper(call);
          return ListView(
            children: topicHelper.topics.map(
              (e) {
                return switch (e.body) {
                  /// expansion widget with map
                  TopicDetailsBodyMap(map: Map<String, dynamic> map, trailing: TrailingData? trailing) =>
                    _getExpansionMap(e, map, trailing),

                  /// expansion widget with list
                  TopicDetailsBodyList(list: List<ListData> list) => _getExpansionList(e, list)
                };
              },
            ).toList(),
          );
        },
      ),
    );
  }

  ExpansionWidget _getExpansionList(TopicData e, List<ListData> list) {
    return ExpansionWidget(
      title: e.topic,
      children: list
          .mapIndexed(
            (index, e) => DetailsRowWidget(
              e.title,
              e.subtitle,
              other: e.other,
              showDivider: index != list.length - 1,
            ),
          )
          .toList(),
    );
  }

  ExpansionWidget _getExpansionMap(TopicData e, Map<String, dynamic> map, TrailingData? trailing) {
    return ExpansionWidget.map(
      title: e.topic,
      map: map,
      trailing: trailing != null
          ? TrailingWidget(
              text: trailing.trailing,
              data: trailing.data,
              beautificationRequired: trailing.beautificationRequired,
            )
          : null,
    );
  }
}
