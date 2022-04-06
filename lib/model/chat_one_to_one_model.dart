class ChatOneToOneModel {
  ChatOneToOneModel({
    required this.message,
    required this.senderChatId,
    required this.receiverChatId,
    required this.sentAt,
  });

  String message;
  String senderChatId;
  String receiverChatId;
  String sentAt;

  factory ChatOneToOneModel.fromJson(Map<String, dynamic> json) =>
      ChatOneToOneModel(
        message: json["message"],
        senderChatId: json["senderChatID"],
        receiverChatId: json["receiverChatID"],
        sentAt: json["sentAt"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "senderChatID": senderChatId,
        "receiverChatID": receiverChatId,
        "sentAt": sentAt,
      };
}
