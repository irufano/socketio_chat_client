import 'package:chat_client/model/chat_one_to_one_model.dart';
import 'package:chat_client/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart';

class ChatOneToOneScreen extends StatefulWidget {
  final UserModel senderUser;
  final UserModel receiverUser;
  const ChatOneToOneScreen({
    Key? key,
    required this.senderUser,
    required this.receiverUser,
  }) : super(key: key);

  @override
  _ChatOneToOneScreenState createState() => _ChatOneToOneScreenState();
}

class _ChatOneToOneScreenState extends State<ChatOneToOneScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatOneToOneModel> _messages = [];

  void setStateIfMounted(f) {
    if (mounted) setState(f);
  }

  late Socket socket;

  @override
  void initState() {
    try {
      socket = io(
          'https://chat-service-complex-irufano.herokuapp.com/',
          OptionBuilder()
              .setTransports(['websocket']) // for Flutter or Dart VM
              .setQuery({'chatID': widget.senderUser.chatID}) // optional
              .disableAutoConnect()
              .build());

      socket.connect();

      socket.onConnectError((data) => debugPrint('error :' + data));

      socket.on('connect', (data) {
        debugPrint('connected');

        debugPrint(socket.query);

        debugPrint(socket.connected.toString());
      });

      socket.on('receive_message', (data) {
        // print(data);
        var message = ChatOneToOneModel.fromJson(data);
        setStateIfMounted(() {
          _messages.add(message);
        });
      });

      socket.onDisconnect((_) => debugPrint('disconnect'));
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Text(widget.receiverUser.name),
          backgroundColor: const Color(0xFF271160)),
      body: SafeArea(
        child: Container(
          color: const Color(0xFFEAEFF2),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Flexible(
                child: MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  child: ListView.builder(
                    controller: _scrollController,
                    physics: const BouncingScrollPhysics(),
                    reverse: _messages.isEmpty ? false : true,
                    itemCount: 1,
                    shrinkWrap: false,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.only(
                          top: 10,
                          left: 10,
                          right: 10,
                          bottom: 3,
                        ),
                        child: Column(
                          mainAxisAlignment: _messages.isEmpty
                              ? MainAxisAlignment.center
                              : MainAxisAlignment.start,
                          children: <Widget>[
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: _messages.map((message) {
                                  // ignore: avoid_print
                                  print(message);
                                  return ChatBubble(
                                    date: message.sentAt,
                                    message: message.message,
                                    isMe: message.receiverChatId ==
                                        widget.receiverUser.chatID,
                                  );
                                }).toList()),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
              Container(
                color: Colors.white,
                padding: const EdgeInsets.only(
                    bottom: 10, left: 20, right: 10, top: 5),
                child: Row(
                  children: <Widget>[
                    Flexible(
                      child: SizedBox(
                        child: TextField(
                          minLines: 1,
                          maxLines: 5,
                          controller: _messageController,
                          textCapitalization: TextCapitalization.sentences,
                          decoration: const InputDecoration.collapsed(
                            hintText: "Type a message",
                            hintStyle: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 43,
                      width: 42,
                      child: FloatingActionButton(
                        backgroundColor: const Color(0xFF271160),
                        onPressed: () async {
                          if (_messageController.text.trim().isNotEmpty) {
                            String message = _messageController.text.trim();

                            var data = ChatOneToOneModel(
                                message: message,
                                senderChatId: widget.senderUser.chatID,
                                receiverChatId: widget.receiverUser.chatID,
                                sentAt: DateTime.now()
                                    .toLocal()
                                    .toString()
                                    .substring(0, 16));
                            _messages.add(data);

                            socket.emit("send_message", data.toJson());

                            _messageController.clear();
                            setState(() {});
                          }
                        },
                        mini: true,
                        child: Transform.rotate(
                            angle: 5.79449,
                            child: const Icon(Icons.send, size: 20)),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ChatBubble extends StatefulWidget {
  final bool isMe;
  final String? message;
  final String? date;

  const ChatBubble({
    Key? key,
    required this.message,
    this.isMe = true,
    required this.date,
  }) : super(key: key);

  @override
  State<ChatBubble> createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Column(
        mainAxisAlignment:
            widget.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment:
            widget.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            margin: const EdgeInsets.symmetric(vertical: 5.0),
            constraints: BoxConstraints(maxWidth: size.width * .5),
            decoration: BoxDecoration(
              color: widget.isMe
                  ? const Color(0xFFE3D8FF)
                  : const Color(0xFFFFFFFF),
              borderRadius: widget.isMe
                  ? const BorderRadius.only(
                      topRight: Radius.circular(11),
                      topLeft: Radius.circular(11),
                      bottomRight: Radius.circular(0),
                      bottomLeft: Radius.circular(11),
                    )
                  : const BorderRadius.only(
                      topRight: Radius.circular(11),
                      topLeft: Radius.circular(11),
                      bottomRight: Radius.circular(11),
                      bottomLeft: Radius.circular(0),
                    ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  widget.message ?? '',
                  textAlign: TextAlign.start,
                  softWrap: true,
                  style:
                      const TextStyle(color: Color(0xFF2E1963), fontSize: 14),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 7),
                    child: Text(
                      widget.date ?? '',
                      textAlign: TextAlign.end,
                      style: const TextStyle(
                          color: Color(0xFF594097), fontSize: 9),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}