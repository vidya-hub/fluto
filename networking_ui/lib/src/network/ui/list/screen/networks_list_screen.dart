import '/src/network/infospect_network_call.dart';
import '/src/network/network_storage.dart';
import '/src/network/ui/details/bloc/interceptor_details_bloc.dart';
import '/src/network/ui/details/screen/interceptor_details_screen.dart';
import '/src/network/ui/filters/network_filters.dart';
import '/src/network/ui/list/components/network_call_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../components/network_call_app_bar.dart';
import 'dart:io';

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
    _networkFilters = NetworkFilters(networkCallsGetter: () => widget.storage.networkCall);
    widget.storage.addListener(_listener);
    super.initState();
  }

  void _listener() => setState(() {});
  @override
  void dispose() {
    widget.storage.removeListener(_listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: _networkFilters.selectedMethods.isNotEmpty
            ? Size.fromHeight(kToolbarHeight + 5 + (Platform.isMacOS ? 25 : 0))
            : Size.fromHeight(kToolbarHeight),
        child: ListenableBuilder(
          listenable: _networkFilters,
          builder: (context, child) {
            return NetworkCallAppBar(
              onClearLogs: () => widget.storage.clear(),
              filters: _networkFilters,
              hasBottom: _networkFilters.selectedMethods.isNotEmpty,
            );
          },
        ),
      ),
      body: NetworkListBody(filters: _networkFilters),
    );
  }
}

class NetworkListBody extends StatelessWidget {
  const NetworkListBody({super.key, required this.filters});
  final NetworkFilters filters;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: filters,
      builder: (context, child) {
        final filteredCalls = filters.filteredCalls;
        return Visibility(
          visible: filteredCalls.isNotEmpty,
          replacement: const Center(child: Text("No network calls")),
          child: ListView.builder(
            itemCount: filteredCalls.length,
            itemBuilder: (context, index) {
              return NetworkCallItem(
                networkCall: filteredCalls.elementAt(index),
                searchedText: filters.query,
                onItemClicked: (InfospectNetworkCall call) {
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
          ),
        );
      },
    );
  }
}
