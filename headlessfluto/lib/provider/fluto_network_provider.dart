import 'package:flutter/material.dart';
import 'package:headlessfluto/model/network_model.dart';

class FlutoNetworkProvider extends ChangeNotifier {
  List<NetworkNetworkCall> _networkCalls = [];
  List<NetworkNetworkCall> get networkCalls => _networkCalls;
  void addNetworkCall(NetworkNetworkCall networkCall) {
    _networkCalls = [networkCall, ..._networkCalls];
    notifyListeners();
  }
}
