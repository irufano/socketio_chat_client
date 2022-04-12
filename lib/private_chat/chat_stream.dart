import 'dart:developer';

import 'package:chat_client/model/private_chat_model.dart';
import 'package:chat_client/model/user_model.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';
import 'package:socket_io_client/socket_io_client.dart';

class ChatStream {
  late Socket socket;

  final _availableUsers = BehaviorSubject<List<UserModel>>();
  final _onlineUsers = BehaviorSubject<List<UserModel>>();
  final _currentUser = BehaviorSubject<UserModel?>();
  final _messages = BehaviorSubject<List<PrivateChatModel>>();

  Stream<List<UserModel>> get availableUsers => _availableUsers.stream;
  Stream<List<UserModel>> get onlineUsers => _onlineUsers.stream;
  Stream<UserModel?> get currentUser => _currentUser.stream;
  Stream<List<PrivateChatModel>> get messages => _messages.stream;

  List<UserModel>? get onlineUsersValue => _onlineUsers.valueOrNull;
  UserModel? get currentUserValue => _currentUser.valueOrNull;

  init() {
    try {
      socket = io(
          'https://chat-service-complex-irufano.herokuapp.com/',
          OptionBuilder()
              .setTransports(['websocket']) // for Flutter or Dart VM
              .disableAutoConnect()
              .build());

      socket.connect();

      socket.onConnectError((data) => log('error :' + data.toString()));
      socket.onDisconnect((_) => log('disconnect'));
      socket.on('connect', (data) {
        debugPrint('connected');
        debugPrint(socket.connected.toString());
      });

      socket.on('available-users', (data) {
        var users = listUserModelFromJson(data);
        debugPrint("avaiable count : ${users.length}");
        _availableUsers.sink.add(users);
      });

      socket.on('online-users', (data) {
        var users = listUserModelFromJson(data);
        var currentUserOnline =
            users.firstWhereOrNull((x) => x.userId == currentUserValue?.userId);
        log('current user : $currentUserOnline');
        if (currentUserOnline != null) _currentUser.sink.add(currentUserOnline);

        debugPrint("online count : ${users.length}");
        _onlineUsers.sink.add(users);
      });

      socket.on('receive-message', (data) {
        List<PrivateChatModel> listMessage =
            _messages.hasValue ? _messages.value : [];
        var message = PrivateChatModel.fromJson(data);
        listMessage.add(message);
        _messages.sink.add(listMessage);

        // update online users
        updateHasNewMessageFromChat(message, true);
      });

      socket.on("socket-id", (id) {
        log(id);
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  onUserSelected(UserModel user) {
    try {
      _currentUser.sink.add(user);
      socket.emit("user-connect", user.toJson());
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  updateHasNewMessage(UserModel user) {
    try {
      // update online users
      var onlines = onlineUsersValue ?? [];
      var indexReceiver = onlines.indexWhere((u) => u.chatId == user.chatId);
      onlines[indexReceiver].hasNewMessage = false;
      _onlineUsers.sink.add(onlines);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  updateHasNewMessageFromChat(PrivateChatModel message, bool value) {
    try {
      // update online users
      var onlines = onlineUsersValue ?? [];
      var indexReceiver =
          onlines.indexWhere((u) => u.chatId == message.fromChatId);
      onlines[indexReceiver].hasNewMessage = value;
      _onlineUsers.sink.add(onlines);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  disconnect() {
    try {
      if (currentUserValue == null) return;
      socket.emit("user-disconnect", currentUserValue?.toJson());
      _currentUser.sink.add(null);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  sendMessage(PrivateChatModel message) {
    try {
      debugPrint(message.toJson().toString());
      List<PrivateChatModel> listMessage =
          _messages.hasValue ? _messages.value : [];
      listMessage.add(message);
      _messages.sink.add(listMessage);
      socket.emit("send-message", message.toJson());
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  resetMessages() {
    try {
      _messages.sink.add([]);
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}

final chatStream = ChatStream();
