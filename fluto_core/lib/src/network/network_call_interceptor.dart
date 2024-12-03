import 'dart:math';

import 'package:fluto_core/src/network/network_provider.dart';
import 'package:http/http.dart';

import 'infospect_network_call.dart';

abstract class CoreInterceptor {
  Future<void> onRequest(BaseRequest request, {bool skipContentType});
  Future<void> onResponse(Response response);
  Future<void> onError(dynamic error, StackTrace stackTrace);
}

class NetworkCallInterceptor extends CoreInterceptor {
  static final NetworkCallInterceptor _instance = NetworkCallInterceptor._internal();
  late final NetworkProvider provider;
  static bool _isInitialized = false;

  factory NetworkCallInterceptor.init(NetworkProvider provider) {
    if (_isInitialized) return _instance;
    _instance.provider = provider;
    _isInitialized = true;
    return _instance;
  }

  factory NetworkCallInterceptor() {
    if (!_isInitialized) {
      throw Exception("NetworkProvider is not initialized");
    }
    return _instance;
  }

  NetworkCallInterceptor._internal();
  InfospectNetworkRequest? _networkRequest;

  @override
  Future<void> onError(dynamic error, StackTrace stackTrace) async {
    final networkCall = InfospectNetworkCall(
      stackTrace.hashCode,
      request: _networkRequest!,
      client: '',
      error: InfospectNetworkError(
        error: e,
        stackTrace: stackTrace,
      ),
    );

    provider.addCall(networkCall);
  }

  @override
  Future<void> onRequest(BaseRequest request, {bool skipContentType = false}) async {
    dynamic requestBody = '';
    int requestSize = 0;
    final List<InfospectFormDataFile> files = [];
    final List<InfospectFormDataField> fields = [];

    if (request is Request && request.body.isNotEmpty) {
      requestBody = request.body;
      requestSize = request.bodyBytes.length;
    }

    if (request is MultipartRequest) {
      request.fields.forEach((key, value) {
        fields.add(InfospectFormDataField(key, value));
      });

      for (final entry in request.files) {
        files.add(
          InfospectFormDataFile(
            entry.filename,
            entry.contentType.toString(),
            entry.length,
          ),
        );
      }
    } else if (request is Request) {
      try {
        if (request.body.isNotEmpty) {
          requestBody = request.body;
        }
      } catch (e) {
        // TODO:// ADD LOGS (@vidya)
      }
      requestSize = request.bodyBytes.length;
    }
    _networkRequest = InfospectNetworkRequest(
      body: requestBody,
      size: requestSize,
      formDataFields: fields,
      formDataFiles: files,
      headers: request.headers,
      contentType: request.headers['content-type'],
      queryParameters: request.url.queryParameters,
      requestTime: DateTime.now(),
      method: request.method,
      url: request.url,
    );
  }

  @override
  Future<void> onResponse(Response response) async {
    final networkResponse = InfospectNetworkResponse(
      size: response.bodyBytes.length,
      headers: response.headers,
      status: response.statusCode,
      body: response.body,
      responseTime: DateTime.now(),
    );

    final networkCall = InfospectNetworkCall(
      response.hashCode,
      request: _networkRequest,
      response: networkResponse,
      client: 'Poker',
      server: response.request!.url.host,
      duration: _networkRequest?.time == null ? 0: networkResponse.time.difference(_networkRequest!.time).inMilliseconds,
      loading: false,
    );

    provider.addCall(networkCall);
  }
}
