import 'dart:async';

import 'package:fluto_core/src/network/network_call_interceptor.dart';
import 'package:fluto_core/src/network/ui/list/screen/networks_list_screen.dart';
import 'package:flutter/material.dart';

import 'network_provider.dart';

class NetworkViewer extends StatefulWidget {
  const NetworkViewer({super.key});

  @override
  State<NetworkViewer> createState() => _NetworkViewerState();
}

class _NetworkViewerState extends State<NetworkViewer> {
  NetworkCallInterceptor? _networkCallInterceptor;
  bool loading = true;
  Timer? _timer;

  Future<void> _initNetworkCallInterceptor() async {
    _networkCallInterceptor = NetworkCallInterceptor();
    _timer = Timer.periodic(const Duration(milliseconds: 1000), callback);
  }

  void callback(Timer timer) {
    if (_networkCallInterceptor?.provider == null) {
      setState(() => loading = false);
    } else {
      timer.cancel();
    }
  }

  @override
  void initState() {
    _initNetworkCallInterceptor();
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _timer = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_networkCallInterceptor?.provider == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return NetworksListScreen(
      provider: _networkCallInterceptor!.provider,
    );
  }
}
