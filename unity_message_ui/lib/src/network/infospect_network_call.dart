class UnityMessageModel {
  final Map<String, dynamic> messageData;
  final bool isSendMessage;
  final int timeSpan;

  UnityMessageModel({
    required this.messageData,
    required this.isSendMessage,
    int? timeSpan,
  }) : timeSpan = timeSpan ?? DateTime.now().millisecondsSinceEpoch;

  factory UnityMessageModel.fromJson(Map<dynamic, dynamic> json) {
    return UnityMessageModel(
      messageData:
          (json['messageData'] as Map<dynamic, dynamic>).map<String, dynamic>(
        (k, v) => MapEntry(k.toString(), v),
      ),
      isSendMessage: json['isSendMessage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'messageData': messageData,
      'isSendMessage': isSendMessage,
      'timeSpan': timeSpan,
    };
  }
}
