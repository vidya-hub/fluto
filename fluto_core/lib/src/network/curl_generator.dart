import 'package:fluto_core/src/network/infospect_network_call.dart';

class CurlGenerator {
  final InfospectNetworkCall call;

  const CurlGenerator({required this.call});

  String buildCurlCommand() {
    bool compressed = false; // A flag indicating if the request is compressed using gzip.
    String curlCmd = "curl"; // The base cURL command string.
    curlCmd += " -X ${call.request?.method ?? ''}"; // Add the Network method to the cURL command.
    final request = call.request;

    if (call.request != null) {
      // Get the headers from the Network request.
      final Map<String, dynamic> headers = request!.headers;
      // Check if the request is compressed with gzip.
      compressed = headers['Accept-Encoding'] == 'gzip';
      // Add each header to the cURL command.
      headers.forEach((key, dynamic value) {
        curlCmd += " -H '$key: $value'";
      });

      // Get the request body as a string.
      final String requestBody = request!.body.toString();
      // If the request body is not empty, add it to the cURL command.
      if (requestBody != '') {
        curlCmd += " --data \$'${requestBody.replaceAll("\n", "\\n")}'";
      }

      // Get the query parameters from the Net request.
      final Map<String, dynamic> queryParamMap = request!.queryParameters;
      int paramCount = queryParamMap.keys.length;
      String queryParams = "";
      // If there are query parameters, add them to the cURL command.
      if (paramCount > 0) {
        queryParams += "?";
        queryParamMap.forEach((key, dynamic value) {
          queryParams += '$key=$value';
          paramCount -= 1;
          if (paramCount > 0) {
            queryParams += "&";
          }
        });
      }
      // final isHttps = call.request!.url.isScheme('https');
      final url = '${request.url.origin}${request.url.path}$queryParams';
      curlCmd += "${compressed ? " --compressed " : " "}${"'$url'"}";
      // // If the server URL already has http(s), don't add it again.
      // if (server.contains("http://") || server.contains("https://")) {
      //   curlCmd += "${compressed ? " --compressed " : " "}${"'$server$endpoint$queryParams'"}";
      // } else {
      //   curlCmd +=
      //       "${compressed ? " --compressed " : " "}${"'${secure ? 'https://' : 'http://'}$server$endpoint$queryParams'"}";
      // }
    }

    return curlCmd;
  }
}
