import 'package:flutter/material.dart';

import '../../../infospect_network_call.dart';
import '../../common_widgets/conditional_widget.dart';
import '../../list/components/expansion_widget.dart';
import '../widgets/details_row_widget.dart';

class InterceptorDetailsError extends StatelessWidget {
  final InfospectNetworkCall call;

  const InterceptorDetailsError(
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
          children: [CircularProgressIndicator(), Text("Waiting for response")],
        ),
      ),
      ifFalse: ListView(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Errors
              if (call.error != null) ...[
                ExpansionWidget(
                  title: 'Error',
                  children: [
                    DetailsRowWidget(
                      'Message',
                      call.error?.error.toString() ?? '',
                      showDivider: call.error?.stackTrace != null,
                    ),
                    if (call.error?.stackTrace != null)
                      DetailsRowWidget(
                        'Stack Trace',
                        call.error?.stackTrace.toString() ?? '',
                        showDivider: false,
                      ),
                  ],
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
