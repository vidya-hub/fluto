import 'package:fluto_core/src/utils/common_widgets/app_adaptive_dialog.dart';
import 'package:fluto_core/src/utils/common_widgets/conditional_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../utils/common_widgets/action_widget.dart';
import '../../../../utils/common_widgets/app_search_bar.dart';

enum NetworkActionType {
  method,
  status,
  share,
  clear,
}

abstract class NetworkAction {
  static ActionModel get filterModel {
    return ActionModel(
      icon: Icons.filter_alt_outlined,
      actions: const [
        PopupAction(
          id: NetworkActionType.method,
          name: "Method",
          subActions: [
            PopupAction(
              id: 'get',
              name: "GET",
            ),
            PopupAction(
              id: 'post',
              name: "POST",
            ),
            PopupAction(
              id: 'put',
              name: "PUT",
            ),
            PopupAction(
              id: 'delete',
              name: "DELETE",
            ),
            PopupAction(
              id: 'option',
              name: "OPTION",
            ),
          ],
        ),
        PopupAction(
          id: NetworkActionType.status,
          name: "Status",
          subActions: [
            PopupAction(
              id: 'success',
              name: "Success",
            ),
            PopupAction(
              id: 'error',
              name: "Error",
            ),
          ],
        ),
      ],
    );
  }

  static ActionModel<NetworkActionType> get menuModel {
    return ActionModel(
      icon: Icons.more_vert,
      actions: const [
        PopupAction(
          id: NetworkActionType.share,
          name: "Share",
        ),
        PopupAction(
          id: NetworkActionType.clear,
          name: "Clear",
        ),
      ],
    );
  }
}

class NetworkCallAppBar extends StatefulWidget implements PreferredSizeWidget {
  const NetworkCallAppBar({super.key, this.hasBottom = false}) : isDesktop = false;

  const NetworkCallAppBar.desktop({super.key, this.hasBottom = false}) : isDesktop = true;

  final bool hasBottom;
  final bool isDesktop;

  @override
  State<NetworkCallAppBar> createState() => _NetworkCallAppBarState();

  @override
  Size get preferredSize => hasBottom
      ? Size.fromHeight(isDesktop ? 74 : kToolbarHeight + 40)
      : Size.fromHeight(isDesktop ? 40 : kToolbarHeight);
}

class _NetworkCallAppBarState extends State<NetworkCallAppBar> {
  late final TextEditingController _controller = TextEditingController();
  late final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final networkListBloc = context.read<NetworksListBloc>();

    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 0,
      leading: widget.isDesktop
          ? null
          : BackButton(
              onPressed: () => Navigator.of(context).pop(),
            ),
      title: AppSearchBar(
        controller: _controller,
        focusNode: _focusNode,
        isDesktop: widget.isDesktop,
        onChanged: (value) {},
      ),
      actions: [
        AppBarActionWidget(
          actionModel: NetworkAction.filterModel,
          // selectedActions: networkListBloc.state.filters,

          onItemSelected: (value) {
            // networkListBloc.add(NetworkLogsFilterAdded(action: value));
          },
          // selected: networkListBloc.state.filters.isNotEmpty,
        ),
        AppBarActionWidget<NetworkActionType>(
          actionModel: NetworkAction.menuModel,
          onItemSelected: (value) {
            if (value.id == NetworkActionType.share) {
              // networkListBloc.add(const ShareNetworkLogsClicked());
            } else if (value.id == NetworkActionType.clear) {
              AppAdaptiveDialog.show(
                context,
                tag: 'network_calls',
                title: 'Clear Network Call Logs?',
                body: 'Are you sure you want to clear all network call logs? This will clear up the list.',
                onPositiveActionClick: () {
                  // networkListBloc.add(const ClearNetworkLogsClicked());
                },
              );
            }
          },
        ),
      ],
      // bottom: widget.hasBottom ? _BottomWidget(widget.isDesktop) : null,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();

    super.dispose();
  }
}

// class _BottomWidget extends StatelessWidget implements PreferredSizeWidget {
//   const _BottomWidget(this.isDesktop);

//   final bool isDesktop;

//   @override
//   Size get preferredSize => const Size.fromHeight(30);

//   @override
//   Widget build(BuildContext context) {
//     return BlocSelector<NetworksListBloc, NetworksListState, List<PopupAction>>(
//       selector: (state) {
//         return state.filters;
//       },
//       builder: (context, filters) {
//         return LayoutBuilder(
//           builder: (context, constraints) {
//             return SizedBox(
//               width: constraints.maxWidth - 10,
//               child: SingleChildScrollView(
//                 scrollDirection: Axis.horizontal,
//                 child: Row(
//                   children: filters.map(
//                     (e) {
//                       return ConditionalWidget(
//                         condition: isDesktop,
//                         ifTrue: Transform(
//                           transform: Matrix4.identity()..scale(0.8),
//                           child: chipWidget(e, context),
//                         ),
//                         ifFalse: chipWidget(e, context),
//                       );
//                     },
//                   ).toList(),
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }

//   Padding chipWidget(PopupAction<dynamic> e, BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: isDesktop ? 0 : 8),
//       child: Chip(
//         label: Text(e.name),
//         deleteIcon: Container(
//           height: 14,
//           width: 14,
//           decoration: BoxDecoration(
//             color: Theme.of(context).colorScheme.primary,
//             border: Border.all(),
//             shape: BoxShape.circle,
//           ),
//           child: const Icon(Icons.close_rounded, size: 12),
//         ),
//         labelPadding: const EdgeInsetsDirectional.only(
//           start: 4,
//         ),
//         onDeleted: () {
//           context.read<NetworksListBloc>().add(
//                 NetworkLogsFilterRemoved(action: e),
//               );
//         },
//       ),
//     );
//   }
// }
