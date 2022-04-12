import 'dart:convert';

List<UserModel> listUserModelFromJson(data) =>
    List<UserModel>.from(data.map((x) => UserModel.fromJson(x)));
// List<UserModel>.from(json.decode(str).map((x) => UserModel.fromJson(x)));

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  UserModel({
    this.userId,
    this.username,
    this.chatId,
  });

  String? userId;
  String? username;
  String? chatId;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        userId: json["userId"],
        username: json["username"],
        chatId: json["chatId"],
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "username": username,
        "chatId": chatId,
      };
}
