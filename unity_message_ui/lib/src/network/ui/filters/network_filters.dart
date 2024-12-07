import '/src/network/infospect_network_call.dart';
import 'package:flutter/material.dart';

class UnityFiltersHandler {
  // final Set<UnityMessageModel> _networkCalls;

  // const FiltersHandler({required Set<UnityMessageModel> networkCalls}) : _networkCalls = networkCalls;

  // static Iterable<UnityMessageModel> filterByMethod(
  //     String method, Iterable<UnityMessageModel> networkCalls) {
  //   return networkCalls.where((call) => call.method == method).toSet();
  // }

  // Method to search network calls by a query
  static Iterable<UnityMessageModel> search(
      String query, Iterable<UnityMessageModel> networkCalls) {
    return networkCalls.where((call) {
      final String? url = call.messageData["type"];
      if (url == null) return false;
      return url.toString().contains(query);
    });
  }

  // // Method to filter network calls by status code
  // static Iterable<UnityMessageModel> filterByStatusCode(
  //     int statusCode, Iterable<UnityMessageModel> networkCalls) {
  //   return networkCalls.where((call) {
  //     return call.response?.status == statusCode;
  //   });
  // }

  // Method to filter network calls by status code range
  // static Iterable<UnityMessageModel> filterByStatus(
  //     String status, Iterable<UnityMessageModel> networkCalls) {
  //   return networkCalls.where((call) {
  //     final String? statusString = call.response?.statusString;
  //     if (statusString == null) return false;
  //     return status == 'success'
  //         ? statusString.contains('OK')
  //         : !statusString.contains('OK');
  //   });
  // }

  // add sort based on the time of the network call
  static Iterable<UnityMessageModel> sortByTime(
    Iterable<UnityMessageModel> networkCalls,
  ) {
    final list = networkCalls.toList();
    list.sort((a, b) {
      return b.timeSpan.compareTo(a.timeSpan);
    });
    return list;
  }

  // filter by Api type (GET, POST, PUT, DELETE)
  static Iterable<UnityMessageModel> filterByApiType(
    Iterable<String> selectedMethods,
    Iterable<UnityMessageModel> networkCalls,
  ) {
    return networkCalls.where(
      (call) {
        return selectedMethods.contains(call.messageData["process_id"]);
      },
    );
  }
}

class UnityMessageFilters extends ChangeNotifier {
  UnityMessageFilters({
    required this.networkCallsGetter,
  });

  final ValueGetter<Set<UnityMessageModel>> networkCallsGetter;
  // Set<UnityMessageModel> _networkCalls = <UnityMessageModel>{};

  Set<UnityMessageModel> get filteredCalls {
    Iterable<UnityMessageModel> calls = Set.from(networkCallsGetter.call());

    if (query.isNotEmpty) {
      calls = UnityFiltersHandler.search(query, calls);
    }
    // if (_method.isNotEmpty) {
    //   calls = FiltersHandler.filterByMethod(_method, calls);
    // }
    // if (_status.isNotEmpty) {
    //   calls = FiltersHandler.filterByStatus(_status, calls);
    // }
    // if (_statusCode != -1) {
    //   calls = FiltersHandler.filterByStatusCode(_statusCode, calls);
    // }
    if (selectedMethods.isNotEmpty) {
      calls = UnityFiltersHandler.filterByApiType(selectedMethods, calls);
    }

    return UnityFiltersHandler.sortByTime(calls).toSet();
  }

  // void updateNetworkCalls(Set<UnityMessageModel> networkCalls) {
  //   _networkCalls = networkCalls;
  //   notifyListeners();
  // }

  String _query = '';
  String get query => _query;
  void onQueryChanged(String newQuery) {
    _query = newQuery;
    notifyListeners();
  }

  // String _method = '';
  // void onMethodChanged(String newMethod) {
  //   _method = newMethod;
  //   notifyListeners();
  // }

  // String _status = '';
  // void onStatusChanged(String newStatus) {
  //   _status = newStatus;
  //   notifyListeners();
  // }

  // int _statusCode = -1;
  // void onStatusCodeChanged(int newStatusCode) {
  //   _statusCode = newStatusCode;
  //   notifyListeners();
  // }

  final Set<String> _selectedMethods = <String>{};
  Set<String> get selectedMethods => _selectedMethods;
  void onMethodSelected(String value) {
    _selectedMethods.add(value);
    notifyListeners();
  }

  void onMethodRemoved(String value) {
    _selectedMethods.remove(value);
    notifyListeners();
  }

  void clearFilters() {
    _query = '';
    // _method = '';
    // _status = '';
    // _statusCode = -1;
    notifyListeners();
  }
}
