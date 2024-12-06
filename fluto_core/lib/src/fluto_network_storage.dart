import 'package:hive/hive.dart';
import 'package:networking_ui/networking_ui.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

class FlutoNetworkLazyBox extends LazyNetworkBox {
  final LazyBox _box;

  FlutoNetworkLazyBox(this._box);

  @override
  Future<void> clear() {
    return _box.clear();
  }

  @override
  Future get(key) {
    return _box.get(key);
  }

  @override
  Iterable get keys => _box.keys;

  @override
  Future<void> put(key, value) {
    return _box.put(key, value);
  }
}

class FlutoNetworkStorage extends NetworkStorage {
  final Supabase? supabase;
  FlutoNetworkStorage({required LazyBox box, this.supabase}) : super(FlutoNetworkLazyBox(box));

  @override
  Future<void> addNetworkCall(InfospectNetworkCall call) async {
    if (supabase != null) {
      try {
        await supabase!.client.from('fluto_network').insert({
          "network_data": call.toJson(),
        });
      } catch (e) {
        print("Error adding network call to supabase\n$e");
      }
    }
    return super.addNetworkCall(call);
  }
}
