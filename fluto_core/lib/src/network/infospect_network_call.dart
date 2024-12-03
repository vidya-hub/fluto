import 'dart:convert';
import 'dart:io';

import 'package:equatable/equatable.dart';

class InfospectFormDataFile extends Equatable {
  final String? fileName; // The name of the file.
  final String contentType; // The content type (MIME type) of the file.
  final int length; // The length (size) of the file in bytes.

  /// Creates an instance of the `InfospectFormDataFile` class with the provided [fileName], [contentType], and [length].
  ///
  /// Parameters:
  /// - [fileName]: The name of the file (optional). Can be null if the file is not available or has no name.
  /// - [contentType]: The content type (MIME type) of the file.
  /// - [length]: The length (size) of the file in bytes.
  const InfospectFormDataFile(this.fileName, this.contentType, this.length);

  /// Converts the `InfospectFormDataFile` object into a Map representation.
  ///
  /// Returns a Map with the following key-value pairs:
  /// - 'fileName': The name of the file.
  /// - 'contentType': The content type (MIME type) of the file.
  /// - 'length': The length (size) of the file in bytes.
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'fileName': fileName,
      'contentType': contentType,
      'length': length,
    };
  }

  /// Creates an instance of the `InfospectFormDataFile` class from a Map representation.
  ///
  /// Parameters:
  /// - [map]: A Map containing the key-value pairs representing the `InfospectFormDataFile` object.
  ///
  /// Returns an instance of the `InfospectFormDataFile` class with the data populated from the provided Map.
  factory InfospectFormDataFile.fromMap(Map map) {
    return InfospectFormDataFile(
      map['fileName'] as String?,
      map['contentType'] as String,
      map['length'] as int,
    );
  }

  @override
  List<Object?> get props => [fileName, contentType, length];
}

/// Represents a data field for the Infospect application.
class InfospectFormDataField extends Equatable {
  final String name; // The name of the data field.
  final String value; // The value of the data field.

  /// Creates an instance of the `InfospectFormDataField` class with the provided [name] and [value].
  const InfospectFormDataField(this.name, this.value);

  /// Converts the `InfospectFormDataField` object into a Map representation.
  ///
  /// Returns a Map with the following key-value pairs:
  /// - 'name': The name of the data field.
  /// - 'value': The value of the data field.
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'value': value,
    };
  }

  /// Creates an instance of the `InfospectFormDataField` class from a Map representation.
  ///
  /// Parameters:
  /// - [map]: A Map containing the key-value pairs representing the `InfospectFormDataField` object.
  ///
  /// Returns an instance of the `InfospectFormDataField` class with the data populated from the provided Map.
  factory InfospectFormDataField.fromMap(Map map) {
    return InfospectFormDataField(
      map['name'] as String,
      map['value'] as String,
    );
  }

  @override
  List<Object?> get props => [name, value];
}

class InfospectNetworkError {
  /// The error object.
  final dynamic error;

  /// The stack trace associated with the error, if available.
  final StackTrace? stackTrace;

  /// Creates an instance of the `InfospectNetworkError` class.
  ///
  /// Parameters:
  /// - [error]: The error object (can be of any type).
  /// - [stackTrace]: The stack trace associated with the error (optional).
  const InfospectNetworkError({
    this.error,
    this.stackTrace,
  });

  /// Converts the `InfospectNetworkError` object into a Map representation.
  ///
  /// Returns a Map with the following key-value pairs:
  /// - 'error': The string representation of the error object using the `toString()` method.
  /// - 'stackTrace': The string representation of the stack trace, if available, using `toString()`.
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'error': error.toString(),
      'stackTrace': stackTrace?.toString(),
    };
  }

  /// Creates an instance of the `InfospectNetworkError` class from a Map representation.
  ///
  /// Parameters:
  /// - [map]: A Map containing the key-value pairs representing the `InfospectNetworkError` object.
  ///
  /// Returns an instance of the `InfospectNetworkError` class with the data populated from the provided Map.
  factory InfospectNetworkError.fromMap(Map map) {
    return InfospectNetworkError(
      error: map['error'] as dynamic,
      stackTrace: map['stackTrace'] != null ? StackTrace.fromString(map['stackTrace']) : null,
    );
  }
}

class InfospectNetworkResponse {
  /// The Network status code of the response.
  final int? status;

  /// The size of the response data in bytes.
  final int size;

  /// The timestamp when the response was received.
  final DateTime time;

  /// The body of the Network response.
  final dynamic body;

  /// The headers of the Network response.
  final Map<String, String>? headers;

  /// Creates an instance of the `InfospectNetworkResponse` class.
  ///
  /// Parameters:
  /// - [status]: The Network status code of the response (optional).
  /// - [size]: The size of the response data in bytes (default is 0).
  /// - [responseTime]: The timestamp when the response was received (default is the current time).
  /// - [body]: The body of the Network response (can be of any type).
  /// - [headers]: The headers of the Network response (optional).
  InfospectNetworkResponse({
    this.status,
    this.size = 0,
    DateTime? responseTime,
    this.body = '',
    this.headers,
  }) : time = responseTime ?? DateTime.now();

  InfospectNetworkResponse copyWith({
    int? status,
    int? size,
    DateTime? time,
    dynamic body,
    Map<String, String>? headers,
  }) {
    return InfospectNetworkResponse(
      status: status ?? this.status,
      size: size ?? this.size,
      responseTime: time ?? this.time,
      body: body ?? this.body,
      headers: headers ?? this.headers,
    );
  }

  String get statusString {
    int status = this.status ?? -1;
    if (status == -1) {
      return "ERR";
    } else if (status < 200) {
      return status.toString();
    } else if (status >= 200 && status < 300) {
      return "$status OK";
    } else if (status >= 300 && status < 400) {
      return status.toString();
    } else if (status >= 400 && status < 600) {
      return status.toString();
    } else {
      return "ERR";
    }
  }

  /// Converts the `InfospectNetworkResponse` object into a Map representation.
  ///
  /// Returns a Map with the following key-value pairs:
  /// - 'status': The Network status code of the response (can be null if not set).
  /// - 'size': The size of the response data in bytes.
  /// - 'time': The timestamp when the response was received (in microseconds since epoch).
  /// - 'body': The body of the Network response.
  /// - 'headers': The headers of the Network response (can be null if not set).
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'status': status,
      'size': size,
      'time': time.microsecondsSinceEpoch,
      'body': body,
      'headers': headers,
    };
  }

  Map<String, dynamic> get bodyMap {
    if (body is String && body.toString().isNotEmpty) {
      try {
        return jsonDecode(body) as Map<String, dynamic>;
      } catch (_) {
        return {};
      }
    } else if (body is Map) {
      return (body as Map).cast<String, dynamic>();
    }
    return {};
  }

  /// Creates an instance of the `InfospectNetworkResponse` class from a Map representation.
  ///
  /// Parameters:
  /// - [map]: A Map containing the key-value pairs representing the `InfospectNetworkResponse` object.
  ///
  /// Returns an instance of the `InfospectNetworkResponse` class with the data populated from the provided Map.
  factory InfospectNetworkResponse.fromMap(Map map) {
    return InfospectNetworkResponse(
      status: map['status'] != null ? map['status'] as int : null,
      size: map['size'] ?? 0,
      responseTime: DateTime.fromMicrosecondsSinceEpoch(map['time']),
      body: map['body'] as dynamic,
      headers: (map['headers'] as Map?)?.cast<String, String>(),
    );
  }


}

/// Represents an Network request data for the Infospect application.
class InfospectNetworkRequest {
  /// The size of the request data in bytes.
  final int size;

  /// The timestamp when the request was made.
  final DateTime time;

  /// The headers of the Network request.
  final Map<String, dynamic> headers;

  /// The body of the Network request.
  final dynamic body;

  /// The content type (MIME type) of the request.
  final String? contentType;

  /// The cookies sent with the request.
  final List<Cookie> cookies;

  /// The query parameters of the request.
  final Map<String, dynamic> queryParameters;

  /// List of file attachments (form data) if any.
  final List<InfospectFormDataFile>? formDataFiles;

  /// List of form data fields if any.
  final List<InfospectFormDataField>? formDataFields;

  final Uri url;

  final String method;

  /// Creates an instance of the `InfospectNetworkRequest` class.
  ///
  /// Parameters:
  /// - [size]: The size of the request data in bytes (default is 0).
  /// - [requestTime]: The timestamp when the request was made (default is the current time).
  /// - [headers]: The headers of the Network request (default is an empty map).
  /// - [body]: The body of the Network request (default is an empty string).
  /// - [contentType]: The content type (MIME type) of the request (default is an empty string).
  /// - [cookies]: The cookies sent with the request (default is an empty list).
  /// - [queryParameters]: The query parameters of the request (default is an empty map).
  /// - [formDataFiles]: List of file attachments (form data) if any (default is null).
  /// - [formDataFields]: List of form data fields if any (default is null).
  InfospectNetworkRequest({
    this.size = 0,
    DateTime? requestTime,
    this.headers = const <String, dynamic>{},
    this.body = "",
    this.contentType = "",
    this.cookies = const [],
    this.queryParameters = const <String, dynamic>{},
    this.formDataFiles,
    this.formDataFields,
    required this.method,
    required this.url,
  }) : time = requestTime ?? DateTime.now();

  InfospectNetworkRequest copyWith({
    int? size,
    DateTime? time,
    Map<String, dynamic>? headers,
    dynamic body,
    String? contentType,
    List<Cookie>? cookies,
    Map<String, dynamic>? queryParameters,
    List<InfospectFormDataFile>? formDataFiles,
    List<InfospectFormDataField>? formDataFields,
  }) {
    return InfospectNetworkRequest(
      method: method,
      url: url,
      size: size ?? this.size,
      requestTime: time ?? this.time,
      headers: headers ?? this.headers,
      body: body ?? this.body,
      contentType: contentType ?? this.contentType,
      cookies: cookies ?? this.cookies,
      queryParameters: queryParameters ?? this.queryParameters,
      formDataFiles: formDataFiles ?? this.formDataFiles,
      formDataFields: formDataFields ?? this.formDataFields,
    );
  }

  Map<String, dynamic> get bodyMap {
    if (body is String && body.toString().isNotEmpty) {
      try {
        return jsonDecode(body) as Map<String, dynamic>;
      } catch (_) {
        return {};
      }
    } else if (body is Map) {
      return (body as Map).cast<String, dynamic>();
    }
    return {};
  }

  /// Converts the `InfospectNetworkRequest` object into a Map representation.
  ///
  /// Returns a Map with the following key-value pairs:
  /// - 'size': The size of the request data in bytes.
  /// - 'time': The timestamp when the request was made (in microseconds since epoch).
  /// - 'headers': The headers of the Network request.
  /// - 'body': The body of the Network request.
  /// - 'contentType': The content type (MIME type) of the request.
  /// - 'cookies': The cookies sent with the request (represented as a list of cookie names).
  /// - 'queryParameters': The query parameters of the request.
  /// - 'formDataFiles': List of file attachments (form data) if any, represented as a list of Maps.
  /// - 'formDataFields': List of form data fields if any, represented as a list of Maps.
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'size': size,
      'time': time.microsecondsSinceEpoch,
      'headers': headers,
      'body': body,
      'contentType': contentType,
      'cookies': cookies.map((e) => e.name).toList(),
      'queryParameters': queryParameters,
      'formDataFiles': formDataFiles?.map((e) => e.toMap().cast<String, dynamic>()).toList(),
      'formDataFields': formDataFields?.map((e) => e.toMap().cast<String, dynamic>()).toList(),
    };
  }

  /// Creates an instance of the `InfospectNetworkRequest` class from a Map representation.
  ///
  /// Parameters:
  /// - [map]: A Map containing the key-value pairs representing the `InfospectNetworkRequest` object.
  ///
  /// Returns an instance of the `InfospectNetworkRequest` class with the data populated from the provided Map.
  factory InfospectNetworkRequest.fromMap(Map map) {
    List<T>? getList<T extends Object>(List<Map>? list) {
      if (list == null) return null;
      List<Object>? lists = [];
      if (T is InfospectFormDataFile) {
        if (list.isNotEmpty) {
          lists = list.map((e) => InfospectFormDataFile.fromMap(e)).toList();
        }
      }

      if (T is InfospectFormDataField) {
        if (list.isNotEmpty) {
          lists = list.map((e) => InfospectFormDataField.fromMap(e)).toList();
        }
      }

      return lists.cast<T>();
    }

    return InfospectNetworkRequest(
      method: map['method'],
      url: Uri.parse(map['url']),
      size: map['size'] ?? 0,
      requestTime: DateTime.fromMicrosecondsSinceEpoch(map['time'] ?? 0),
      headers: (map['headers'] as Map).cast<String, dynamic>(),
      body: map['body'] ?? "",
      contentType: map['contentType'] ?? "",
      cookies: (map['cookies'] as List<Object?>).map<Cookie>((e) => Cookie.fromSetCookieValue(e.toString())).toList(),
      queryParameters: (map['queryParameters'] as Map).cast<String, dynamic>(),
      formDataFiles: map['formDataFiles'] != null && map['formDataFiles'] is List
          ? getList<InfospectFormDataFile>((map['formDataFiles'] as List).cast<Map>())
          : null,
      formDataFields: map['formDataFields'] != null && map['formDataFields'] is List
          ? getList<InfospectFormDataField>((map['formDataFields'] as List).cast<Map>())
          : null,
    );
  }
}

/// Represents an Network call data for the Infospect application.
class InfospectNetworkCall extends Equatable {
  /// The unique identifier for the Network call.
  final int id;

  /// The timestamp when the Network call was created.
  final DateTime createdTime;

  /// The client information associated with the Network call.
  final String client;

  /// A flag indicating if the call is still in progress (loading) or completed.
  final bool loading;

  /// A flag indicating if the call is made over a secure (NetworkS) connection.
  final bool secure;

  /// The Network method used in the call (e.g., GET, POST, etc.).
  final String method;

  /// The endpoint (URL path) used in the Network call.
  final String endpoint;

  /// The server URL (domain) to which the call is made.
  final String server;

  /// The full URI (server + endpoint) used in the Network call.
  final String uri;

  /// The duration of the Network call in milliseconds.
  final int duration;

  /// The Network request data associated with the call.
  final InfospectNetworkRequest? request;

  /// The Network response data associated with the call.
  final InfospectNetworkResponse? response;

  /// The Network error data associated with the call (if any).
  final InfospectNetworkError? error;

  /// Creates an instance of the `InfospectNetworkCall` class.
  ///
  /// Parameters:
  /// - [id]: The unique identifier for the Network call.
  /// - [time]: The timestamp when the Network call was created (default is the current time).
  InfospectNetworkCall(this.id,
      {DateTime? time,
      String endpoint = '',
      this.client = '',
      this.loading = true,
      this.secure = false,
      this.method = '',
      this.server = '',
      this.uri = '',
      this.duration = 0,
      this.request,
      this.response,
      this.error})
      : createdTime = time ?? DateTime.now(),
        endpoint = endpoint.isEmpty ? "/" : endpoint;

  /// Converts the `InfospectNetworkCall` object into a Map representation.
  ///
  /// Returns a Map with the following key-value pairs:
  /// - 'id': The unique identifier for the Network call.
  /// - 'createdTime': The timestamp when the Network call was created (in microseconds since epoch).
  /// - 'client': The client information associated with the Network call.
  /// - 'loading': A flag indicating if the call is still in progress (loading) or completed.
  /// - 'secure': A flag indicating if the call is made over a secure (NetworkS) connection.
  /// - 'method': The Network method used in the call.
  /// - 'endpoint': The endpoint (URL path) used in the Network call.
  /// - 'server': The server URL (domain) to which the call is made.
  /// - 'uri': The full URI (server + endpoint) used in the Network call.
  /// - 'duration': The duration of the Network call in milliseconds.
  /// - 'request': The Map representation of the Network request data associated with the call.
  /// - 'response': The Map representation of the Network response data associated with the call.
  /// - 'error': The Map representation of the Network error data associated with the call (if any).
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'createdTime': createdTime.millisecondsSinceEpoch,
      'client': client,
      'loading': loading,
      'secure': secure,
      'method': method,
      'endpoint': endpoint,
      'server': server,
      'uri': uri,
      'duration': duration,
      'request': request?.toMap(),
      'response': response?.toMap(),
      'error': error?.toMap(),
    };
  }

  /// Creates an instance of the `InfospectNetworkCall` class from a Map representation.
  ///
  /// Parameters:
  /// - [map]: A Map containing the key-value pairs representing the `InfospectNetworkCall` object.
  ///
  /// Returns an instance of the `InfospectNetworkCall` class with the data populated from the provided Map.
  factory InfospectNetworkCall.fromMap(dynamic map) {
    return InfospectNetworkCall(
      map['id'] as int,
      time: DateTime.fromMillisecondsSinceEpoch(map['createdTime'] as int),
      client: map['client'] as String,
      loading: map['loading'] as bool,
      secure: map['secure'] as bool,
      method: map['method'] as String,
      endpoint: map['endpoint'] as String,
      server: map['server'] as String,
      uri: map['uri'] as String,
      duration: map['duration'] as int,
      request: map['request'] != null ? InfospectNetworkRequest.fromMap(map['request']) : null,
      response: map['response'] != null ? InfospectNetworkResponse.fromMap(map['response']) : null,
      error: map['error'] != null ? InfospectNetworkError.fromMap(map['error']) : null,
    );
  }

  @override
  List<Object?> get props {
    return [
      id,
      createdTime,
      client,
      loading,
      secure,
      method,
      endpoint,
      server,
      uri,
      duration,
      request,
      response,
      error,
    ];
  }

  InfospectNetworkCall copyWith({
    int? id,
    DateTime? createdTime,
    String? client,
    bool? loading,
    bool? secure,
    String? method,
    String? endpoint,
    String? server,
    String? uri,
    int? duration,
    InfospectNetworkRequest? request,
    InfospectNetworkResponse? response,
    InfospectNetworkError? error,
  }) {
    return InfospectNetworkCall(
      id ?? this.id,
      time: createdTime ?? this.createdTime,
      client: client ?? this.client,
      loading: loading ?? this.loading,
      secure: secure ?? this.secure,
      method: method ?? this.method,
      endpoint: endpoint ?? this.endpoint,
      server: server ?? this.server,
      uri: uri ?? this.uri,
      duration: duration ?? this.duration,
      request: request ?? this.request,
      response: response ?? this.response,
      error: error ?? this.error,
    );
  }

  String toJson() => json.encode(toMap());

  factory InfospectNetworkCall.fromJson(String source) =>
      InfospectNetworkCall.fromMap(json.decode(source) as Map<String, dynamic>);
}
