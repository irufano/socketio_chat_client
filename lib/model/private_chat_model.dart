class PrivateChatModel {
  PrivateChatModel({
    required this.message,
    required this.fromChatId,
    required this.toChatId,
    required this.sentAt,
  });

  String message;
  String fromChatId;
  String toChatId;
  String sentAt;

  factory PrivateChatModel.fromJson(Map<String, dynamic> json) =>
      PrivateChatModel(
        message: json["message"],
        fromChatId: json["fromChatId"],
        toChatId: json["toChatId"],
        sentAt: json["sentAt"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "fromChatId": fromChatId,
        "toChatId": toChatId,
        "sentAt": sentAt,
      };
}
