import 'dart:convert';

import 'package:networking_ui/src/extensions/int_extension.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'curl_generator.dart';
import 'infospect_network_call.dart';

extension _MapExtension on Map? {
  String get contentType {
    if (this != null && (this!.containsKey('content-type') || this!.containsKey('Content-Type'))) {
      return (this!['content-type'] ?? this!['Content-Type'] ?? 'unknown').toString();
    }
    return 'unknown';
  }
}

class NetworkLogsGenerator {
  final InfospectNetworkCall call;

  const NetworkLogsGenerator({required this.call});

  Future<String> networkLogs() async {
    try {
      return await _buildLog() + _buildNetworkCallLog();
    } catch (exception) {
      return "Failed to generate call log";
    }
  }

  Future<String> _buildLog() async {
    final StringBuffer stringBuffer = StringBuffer();
    final packageInfo = await PackageInfo.fromPlatform();
    stringBuffer.write("Junglee - HTTP Inspector\n");
    stringBuffer.write("App name:  ${packageInfo.appName}\n");
    stringBuffer.write("Package: ${packageInfo.packageName}\n");
    stringBuffer.write("Version: ${packageInfo.version}\n");
    stringBuffer.write("Build number: ${packageInfo.buildNumber}\n");
    stringBuffer.write("Generated: ${DateTime.now().toIso8601String()}\n");
    stringBuffer.write("\n");
    return stringBuffer.toString();
  }

  String _buildNetworkCallLog() {
    const JsonEncoder encoder = JsonEncoder.withIndent('  ');
    final StringBuffer stringBuffer = StringBuffer();
    final method = call.request!.method;
    final endpoint = call.request!.url.path;
    final client = call.client;
    final duration = call.duration;
    final loading = call.loading;
    final request = call.request;
    final response = call.response;
    final error = call.error;

    final curl = CurlGenerator(call: call).buildCurlCommand();

    stringBuffer.write("===========================================\n");
    stringBuffer.write("Id: ${call.id}\n");
    stringBuffer.write("============================================\n");
    stringBuffer.write("--------------------------------------------\n");
    stringBuffer.write("General data\n");
    stringBuffer.write("--------------------------------------------\n");
    stringBuffer.write("Server: ${call.request!.url.origin} \n");
    stringBuffer.write("Method: $method \n");
    stringBuffer.write("Endpoint: $endpoint \n");
    stringBuffer.write("Client: $client \n");
    stringBuffer.write("Duration ${duration.toReadableTime}\n");
    stringBuffer.write("Completed: ${!loading} \n");
    stringBuffer.write("--------------------------------------------\n");
    stringBuffer.write("Request\n");
    stringBuffer.write("--------------------------------------------\n");
    stringBuffer.write("Request time: ${request!.time}\n");
    stringBuffer.write("Request content type: ${request.contentType}\n");
    stringBuffer.write("Request cookies: ${encoder.convert(request.cookies)}\n");
    stringBuffer.write("Request headers: ${encoder.convert(request.headers)}\n");
    if (request.queryParameters.isNotEmpty) {
      stringBuffer.write("Request query params: ${encoder.convert(request.queryParameters)}\n");
    }
    stringBuffer.write("Request size: ${request.size.toReadableBytes}\n");
    stringBuffer.write("Request body: ${_formatBody(request.body, request.headers.contentType)}\n");
    stringBuffer.write("--------------------------------------------\n");
    stringBuffer.write("Response\n");
    stringBuffer.write("--------------------------------------------\n");
    stringBuffer.write("Response time: ${response!.time}\n");
    stringBuffer.write("Response status: ${response.status}\n");
    stringBuffer.write("Response size: ${response.size.toReadableBytes}\n");
    stringBuffer.write("Response headers: ${jsonEncode(response.headers)}\n");
    stringBuffer.write("Response body: ${_formatBody(response.body, response.headers.contentType)}\n");
    if (error != null) {
      stringBuffer.write("--------------------------------------------\n");
      stringBuffer.write("Error\n");
      stringBuffer.write("--------------------------------------------\n");
      stringBuffer.write("Error: ${error.error}\n");
      if (error.stackTrace != null) {
        stringBuffer.write("Error stacktrace: ${error.stackTrace}\n");
      }
    }
    stringBuffer.write("--------------------------------------------\n");
    stringBuffer.write("Curl\n");
    stringBuffer.write("--------------------------------------------\n");
    stringBuffer.write(curl);
    stringBuffer.write("\n");
    stringBuffer.write("==============================================\n");
    stringBuffer.write("\n");

    return stringBuffer.toString();
  }

  String _formatBody(dynamic body, String? contentType) {
    try {
      if (body == null) {
        return 'Empty';
      }

      var bodyContent = 'Empty';

      if (contentType == null || !contentType.toLowerCase().contains('application/json')) {
        final bodyTemp = body.toString();

        if (bodyTemp.isNotEmpty) {
          bodyContent = bodyTemp;
        }
      } else {
        if (body is String && body.contains("\n")) {
          bodyContent = body;
        } else {
          if (body is String) {
            if (body.isNotEmpty) {
              //body is minified json, so decode it to a map and let the encoder pretty print this map
              bodyContent = jsonDecode(_decodeJson(body));
            }
          } else if (body is Stream) {
            bodyContent = 'stream';
          } else {
            bodyContent = _parseJson(body);
          }
        }
      }

      return bodyContent;
    } catch (exception) {
      return 'Failed$body';
    }
  }

  static const JsonEncoder encoder = JsonEncoder.withIndent('  ');

  static String _parseJson(dynamic json) {
    try {
      return encoder.convert(json);
    } catch (exception) {
      return json.toString();
    }
  }

  static dynamic _decodeJson(dynamic body) {
    try {
      return json.decode(body as String);
    } catch (exception) {
      return body;
    }
  }
}
