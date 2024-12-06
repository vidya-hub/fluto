import 'package:flutter/material.dart';
import 'package:headlessfluto/model/network_model.dart';

class FlutoNetworkProvider extends ChangeNotifier {
  List<NetworkCallModel> _networkCalls = [];
  List<NetworkCallModel> get networkCalls => _networkCalls;
  void addNetworkCall(NetworkCallModel networkCall) {
    _networkCalls = [networkCall, ..._networkCalls];
    notifyListeners();
  }
}
