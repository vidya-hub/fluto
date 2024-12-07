import '../../common_widgets/highlight_text_widget.dart';
import '/src/network/infospect_network_call.dart';
import 'package:flutter/material.dart';

class NetworkCallItem extends StatelessWidget {
  final UnityMessageModel networkCall;
  final Function onItemClicked;
  final String searchedText;

  const NetworkCallItem({
    super.key,
    required this.networkCall,
    required this.onItemClicked,
    this.searchedText = '',
  });

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: () => onItemClicked(networkCall),
      enableFeedback: true,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(width: 1, color: Theme.of(context).colorScheme.outline),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 8, left: 4, right: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 4),
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 4,
                children: [
                  /// Loader or status indicator
                  _StatusIndicatorWidget(networkCall: networkCall),

                  /// Method
                  Text(networkCall.messageData["type"], style: textTheme.labelMedium),

                  // /// Status
                  // _ResponseStatusWidget(networkCall),

                  // /// Time
                  // Text(
                  //   ' • ${(networkCall.request?.time ?? DateTime.now()).formatTime}',
                  //   style: textTheme.labelSmall,
                  // ),

                  /// Duration
                  Text(
                    ' • ${DateTime.fromMillisecondsSinceEpoch(networkCall.timeSpan)}',
                    style: textTheme.labelSmall,
                  ),

                  // /// Transfered bytes
                  // Text(
                  //   " • ${(networkCall.request?.size ?? 0).toReadableBytes} ↑ / "
                  //   "${(networkCall.response?.size ?? 0).toReadableBytes} ↓",
                  //   style: textTheme.labelSmall,
                  // )
                ],
              ),
              const SizedBox(height: 4),

              /// Path
              HighlightText(
                text: networkCall.messageData["type"],
                highlight: searchedText,
                selectable: false,
                style: textTheme.titleMedium,
              ),

              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusIndicatorWidget extends StatelessWidget {
  const _StatusIndicatorWidget({
    required this.networkCall,
  });

  final UnityMessageModel networkCall;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 10,
      width: 10,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: getStatusTextColor(networkCall, context),
      ),
    );
  }

  Color? getStatusTextColor(UnityMessageModel response, BuildContext context) {
    if (response.isSendMessage) {
      return Colors.red[400];
    } else {
      return Colors.green[400];
    }
  }
}
//
// class _ResponseStatusWidget extends StatelessWidget {
//   final UnityMessageModel networkCall;
//   const _ResponseStatusWidget(this.networkCall);
//
//   String statusString(int status) {
//     if (status == -1) {
//       return "ERR";
//     } else if (status < 200) {
//       return status.toString();
//     } else if (status >= 200 && status < 300) {
//       return "$status OK";
//     } else if (status >= 300 && status < 400) {
//       return status.toString();
//     } else if (status >= 400 && status < 600) {
//       return status.toString();
//     } else {
//       return "ERR";
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return ConditionalWidget(
//       condition: networkCall.loading,
//       ifTrue: const SizedBox.shrink(),
//       ifFalse: Text(
//         // ' • ${networkCall.response?.statusString ?? ''}',
//         ' • ${statusString(networkCall.response?.status ?? -1)}',
//         style: Theme.of(context).textTheme.labelSmall,
//       ),
//     );
//   }
// }
