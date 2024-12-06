import 'dart:convert';
import 'dart:io';

import 'package:equatable/equatable.dart';

class NetworkFormDataFile extends Equatable {
  final String? fileName;
  final String contentType;
  final int length;

  const NetworkFormDataFile(this.fileName, this.contentType, this.length);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'fileName': fileName,
      'contentType': contentType,
      'length': length,
    };
  }

  factory NetworkFormDataFile.fromMap(Map map) {
    return NetworkFormDataFile(
      map['fileName'] as String?,
      map['contentType'] as String,
      map['length'] as int,
    );
  }

  @override
  List<Object?> get props => [fileName, contentType, length];
}

class NetworkFormDataField extends Equatable {
  final String name;
  final String value;

  const NetworkFormDataField(this.name, this.value);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'value': value,
    };
  }

  factory NetworkFormDataField.fromMap(Map map) {
    return NetworkFormDataField(
      map['name'] as String,
      map['value'] as String,
    );
  }

  @override
  List<Object?> get props => [name, value];
}

class NetworkNetworkError {
  final dynamic error;

  final StackTrace? stackTrace;

  const NetworkNetworkError({
    this.error,
    this.stackTrace,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'error': error.toString(),
      'stackTrace': stackTrace?.toString(),
    };
  }

  factory NetworkNetworkError.fromMap(Map map) {
    return NetworkNetworkError(
      error: map['error'] as dynamic,
      stackTrace: map['stackTrace'] != null
          ? StackTrace.fromString(map['stackTrace'])
          : null,
    );
  }
}

class NetworkNetworkResponse {
  final int? status;

  final int size;

  final DateTime time;

  final dynamic body;

  final Map<String, String>? headers;

  NetworkNetworkResponse({
    this.status,
    this.size = 0,
    DateTime? responseTime,
    this.body = '',
    this.headers,
  }) : time = responseTime ?? DateTime.now();

  NetworkNetworkResponse copyWith({
    int? status,
    int? size,
    DateTime? time,
    dynamic body,
    Map<String, String>? headers,
  }) {
    return NetworkNetworkResponse(
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

  factory NetworkNetworkResponse.fromMap(Map map) {
    return NetworkNetworkResponse(
      status: map['status'] != null ? map['status'] as int : null,
      size: map['size'] ?? 0,
      responseTime: DateTime.fromMicrosecondsSinceEpoch(map['time']),
      body: map['body'] as dynamic,
      headers: (map['headers'] as Map?)?.cast<String, String>(),
    );
  }
}

class NetworkNetworkRequest {
  final int size;

  final DateTime time;

  final Map<String, dynamic> headers;

  final dynamic body;

  final String? contentType;

  final List<Cookie> cookies;

  final Map<String, dynamic> queryParameters;

  final List<NetworkFormDataFile>? formDataFiles;

  final List<NetworkFormDataField>? formDataFields;

  final Uri url;

  final String method;

  NetworkNetworkRequest({
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

  NetworkNetworkRequest copyWith({
    int? size,
    DateTime? time,
    Map<String, dynamic>? headers,
    dynamic body,
    String? contentType,
    List<Cookie>? cookies,
    Map<String, dynamic>? queryParameters,
    List<NetworkFormDataFile>? formDataFiles,
    List<NetworkFormDataField>? formDataFields,
  }) {
    return NetworkNetworkRequest(
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

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'size': size,
      'time': time.microsecondsSinceEpoch,
      'headers': headers,
      'body': body,
      'url': url.toString(),
      'contentType': contentType,
      'cookies': cookies.map((e) => e.name).toList(),
      'queryParameters': queryParameters,
      'formDataFiles':
          formDataFiles?.map((e) => e.toMap().cast<String, dynamic>()).toList(),
      'formDataFields': formDataFields
          ?.map((e) => e.toMap().cast<String, dynamic>())
          .toList(),
    };
  }

  factory NetworkNetworkRequest.fromMap(Map map) {
    List<T>? getList<T extends Object>(List<Map>? list) {
      if (list == null) return null;
      List<Object>? lists = [];
      if (T is NetworkFormDataFile) {
        if (list.isNotEmpty) {
          lists = list.map((e) => NetworkFormDataFile.fromMap(e)).toList();
        }
      }

      if (T is NetworkFormDataField) {
        if (list.isNotEmpty) {
          lists = list.map((e) => NetworkFormDataField.fromMap(e)).toList();
        }
      }

      return lists.cast<T>();
    }

    return NetworkNetworkRequest(
      method: map['method'] ?? '',
      url: Uri.parse(map['url']),
      size: map['size'] ?? 0,
      requestTime: DateTime.fromMicrosecondsSinceEpoch(map['time'] ?? 0),
      headers: (map['headers'] as Map).cast<String, dynamic>(),
      body: map['body'] ?? "",
      contentType: map['contentType'] ?? "",
      cookies: (map['cookies'] as List<Object?>)
          .map<Cookie>((e) => Cookie.fromSetCookieValue(e.toString()))
          .toList(),
      queryParameters: (map['queryParameters'] as Map).cast<String, dynamic>(),
      formDataFiles:
          map['formDataFiles'] != null && map['formDataFiles'] is List
              ? getList<NetworkFormDataFile>(
                  (map['formDataFiles'] as List).cast<Map>())
              : null,
      formDataFields:
          map['formDataFields'] != null && map['formDataFields'] is List
              ? getList<NetworkFormDataField>(
                  (map['formDataFields'] as List).cast<Map>())
              : null,
    );
  }
}

class NetworkNetworkCall {
  final int id;

  final DateTime createdTime;

  final String client;

  final bool loading;

  final bool secure;

  final String method;

  final String endpoint;

  final String server;

  final String uri;

  final int duration;

  final NetworkNetworkRequest? request;

  final NetworkNetworkResponse? response;

  final NetworkNetworkError? error;

  NetworkNetworkCall(this.id,
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

  factory NetworkNetworkCall.fromMap(dynamic map) {
    return NetworkNetworkCall(
      map['id'] as int,
      time: DateTime.fromMillisecondsSinceEpoch((map['createdTime']??0) as int),
      client:( map['client'] ?? "")as String,
      loading: (map['loading']??true) as bool,
      secure: (map['secure']??false) as bool,
      method: (map['method']??"") as String,
      endpoint: (map['endpoint']??"") as String,
      server: (map['server']??"") as String,
      uri: (map['uri']??"") as String,
      duration:int.tryParse(map['duration']??"")??0,
      request: map['request'] != null
          ? NetworkNetworkRequest.fromMap(map['request'])
          : null,
      response: map['response'] != null
          ? NetworkNetworkResponse.fromMap(map['response'])
          : null,
      error: map['error'] != null
          ? NetworkNetworkError.fromMap(map['error'])
          : null,
    );
  }

  NetworkNetworkCall copyWith({
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
    NetworkNetworkRequest? request,
    NetworkNetworkResponse? response,
    NetworkNetworkError? error,
  }) {
    return NetworkNetworkCall(
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

  factory NetworkNetworkCall.fromJson(dynamic source) =>
      NetworkNetworkCall.fromMap((source) as Map<String, dynamic>);

  @override
  bool operator ==(Object other) {
    if (other is! NetworkNetworkCall) {
      return false;
    }
    if (id == other.id &&
        request?.url == other.request?.url &&
        request?.time == other.request?.time) {
      return true;
    }
    if (identical(this, other)) return true;
    return super == other;
  }

  @override
  int get hashCode {
    return id.hashCode ^ request.hashCode;
  }
}
