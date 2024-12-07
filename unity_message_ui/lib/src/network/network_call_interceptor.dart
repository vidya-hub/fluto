import 'infospect_network_call.dart';
import 'network_storage.dart';

abstract class UnityCoreInterceptor {
  void interceptedRequest(UnityMessageModel messageData);
}

class UnityMessageInterceptor extends UnityCoreInterceptor {
  static final UnityMessageInterceptor _instance =
      UnityMessageInterceptor._internal();
  late final UnityMessageStorage storage;
  static bool _isInitialized = false;

  factory UnityMessageInterceptor.init(UnityMessageStorage storage) {
    if (_isInitialized) return _instance;
    _instance.storage = storage;
    _isInitialized = true;
    return _instance;
  }

  factory UnityMessageInterceptor() {
    if (!_isInitialized) {
      throw Exception("NetworkProvider is not initialized");
    }
    return _instance;
  }

  UnityMessageInterceptor._internal();

  @override
  void interceptedRequest(UnityMessageModel messageData) {
    storage.addNetworkCall(messageData);
  }
}
