// import 'package:supabase_flutter/supabase_flutter.dart';

import 'infospect_network_call.dart';
import 'package:flutter/foundation.dart';

abstract class LazyUnityBox {
  Iterable<dynamic> get keys;
  Future<void> put(dynamic key, dynamic value);
  Future<dynamic> get(dynamic key);
  Future<void> clear();
}

class UnityMessageStorage extends ChangeNotifier {
  final LazyUnityBox _box;
  // Supabase? supaBase;

  UnityMessageStorage(this._box) {
    // supaBase = supabase;
    notifyListeners();
    init();
  }

  Future<void> init() async {
    final futures = await Future.wait(_box.keys.map((key) => _getNetworkCall(key)));
    final calls = futures.whereType<UnityMessageModel>();
    _networkCall.addAll(calls);
    notifyListeners();
  }

  final Set<UnityMessageModel> _networkCall = {};
  Set<UnityMessageModel> get networkCall => _networkCall;

  Future<void> addNetworkCall(UnityMessageModel call) async {
    try {
      _networkCall.add(call);
      await _box.put(call.hashCode, call.toJson());
      // if (supaBase != null) {
      //   try {
      //     await supaBase!.client.from('fluto_network').insert({
      //       "network_data": call.toJson(),
      //     });
      //   } catch (e) {
      //     print("Error adding network call to supabase\n$e");
      //   }
      // }
    } catch (e) {
      throw Exception("Error adding network call\n$e");
    }
  }

  Future<UnityMessageModel?> _getNetworkCall(int hashCode) async {
    try {
      final data = await _box.get(hashCode);
      if (data == null) return null;
      return UnityMessageModel.fromJson(data);
    } catch (e, s) {
      throw Exception("Error getting network call\n$e");
    }
  }

  Future<void> clear() async {
    _networkCall.clear();
    await _box.clear();
    notifyListeners();
  }
}
