import 'package:fluto_core/src/network/infospect_network_call.dart';
import 'package:fluto_core/src/network/network_provider.dart';
import 'package:fluto_core/src/network/ui/details/bloc/interceptor_details_bloc.dart';
import 'package:fluto_core/src/network/ui/details/screen/interceptor_details_screen.dart';
import 'package:fluto_core/src/network/ui/list/components/network_call_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../components/network_call_app_bar.dart';

class NetworksListScreen extends StatelessWidget {
  const NetworksListScreen({super.key, required this.provider});
  final NetworkProvider provider;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: provider,
      child: Consumer<NetworkProvider>(
        builder: (context, value, child) {
          final networkCalls = value.networkCalls;
          return Scaffold(
            appBar: NetworkCallAppBar(
              hasBottom: value.networkCalls.isNotEmpty,
            ),
            body: Visibility(
              visible: value.networkCalls.isNotEmpty,
              replacement: const Center(child: Text("No network calls")),
              child: ListView.builder(
                itemCount: networkCalls.length,
                itemBuilder: (context, index) {
                  return NetworkCallItem(
                    networkCall: networkCalls.elementAt(index),
                    searchedText: '',
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
              ),
            ),
          );
        },
      ),
    );
  }
}
