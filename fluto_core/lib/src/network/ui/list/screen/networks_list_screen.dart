import 'package:fluto_core/src/network/infospect_network_call.dart';
import 'package:fluto_core/src/network/network_storage.dart';
import 'package:fluto_core/src/network/ui/details/bloc/interceptor_details_bloc.dart';
import 'package:fluto_core/src/network/ui/details/screen/interceptor_details_screen.dart';
import 'package:fluto_core/src/network/ui/filters/network_filters.dart';
import 'package:fluto_core/src/network/ui/list/components/network_call_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../components/network_call_app_bar.dart';

class NetworksListScreen extends StatefulWidget {
  const NetworksListScreen({super.key, required this.storage});
  final NetworkStorage storage;

  @override
  State<NetworksListScreen> createState() => _NetworksListScreenState();
}

class _NetworksListScreenState extends State<NetworksListScreen> {
  late NetworkFilters _networkFilters;

  @override
  void initState() {
    _networkFilters = NetworkFilters(networkCalls: widget.storage.networkCall);
    initStream();
    super.initState();
  }

  Future<void> initStream() async {
    await for (final Set<InfospectNetworkCall> event in widget.storage.networkCallStream) {
      _networkFilters.updateNetworkCalls(event);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _networkFilters,
      builder: (context, child) {
        final filteredCalls = _networkFilters.filteredCalls;
        return Scaffold(
          appBar: NetworkCallAppBar(
            filters: _networkFilters,
            hasBottom: _networkFilters.selectedMethods.isNotEmpty,
          ),
          body: Visibility(
            visible: filteredCalls.isNotEmpty,
            replacement: const Center(child: Text("No network calls")),
            child: ListenableBuilder(
                listenable: _networkFilters,
                builder: (context, child) {
                  return ListView.builder(
                    itemCount: filteredCalls.length,
                    itemBuilder: (context, index) {
                      return NetworkCallItem(
                        networkCall: filteredCalls.elementAt(index),
                        searchedText: _networkFilters.query,
                        onItemClicked: (InfospectNetworkCall call) {
                          // mobileRoutes.logsList(context, infospect, call);
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) {
                                return BlocProvider(
                                  create: (_) => InterceptorDetailsBloc(),
                                  child: InterceptorDetailsScreen(call),
                                );
                              },
                            ),
                          );
                        },
                      );
                    },
                  );
                }),
          ),
        );
      },
    );
  }
  
  
}
