import 'package:chat_client/model/user_model.dart';
import 'package:chat_client/private_chat/chat_stream.dart';
import 'package:chat_client/private_chat/private_chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

class OnlineUserScreen extends StatefulWidget {
  final UserModel currentUser;

  const OnlineUserScreen({
    Key? key,
    required this.currentUser,
  }) : super(key: key);

  @override
  State<OnlineUserScreen> createState() => _OnlineUserScreenState();
}

class _OnlineUserScreenState extends State<OnlineUserScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    chatStream.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Online User'),
        backgroundColor: const Color(0xFF271160),
      ),
      body: StreamBuilder<List<UserModel>>(
          stream: chatStream.onlineUsers,
          builder: (context, snapshot) {
            if (snapshot.data != null) {
              var listUser = snapshot.data;

              var me = listUser?.firstWhereOrNull(
                  (user) => user.userId == widget.currentUser.userId);
              if (me == null) return const SizedBox();
              listUser?.remove(me);
              listUser?.insert(0, me);

              return ListView.separated(
                itemCount: (listUser?.length ?? 0),
                physics: const BouncingScrollPhysics(),
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  var user = listUser?[index];
                  return FriendItem(
                    imageUrl:
                        'https://cdn-icons-png.flaticon.com/512/3135/3135715.png',
                    name: user?.username ?? '-',
                    isMe: user?.userId == widget.currentUser.userId,
                    onTap: () {
                      chatStream.resetMessages();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PrivateChatScreen(
                                senderUser:
                                    chatStream.currentUserValue ?? UserModel(),
                                receiverUser: user ?? UserModel()),
                          ));
                    },
                  );
                },
              );
            }

            return const Center(child: CircularProgressIndicator());
          }),
    );
  }
}

class FriendItem extends StatefulWidget {
  final String imageUrl;
  final String name;
  final bool isMe;
  final Function() onTap;

  const FriendItem({
    Key? key,
    required this.imageUrl,
    required this.name,
    required this.isMe,
    required this.onTap,
  }) : super(key: key);

  @override
  State<FriendItem> createState() => _FriendItemState();
}

class _FriendItemState extends State<FriendItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.isMe
          ? () {
              const snackBar = SnackBar(
                content: Text(
                  "Can't chat with yourself !",
                  style: TextStyle(fontSize: 16),
                ),
                behavior: SnackBarBehavior.floating,
                backgroundColor: Color(0xFF271160),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
          : widget.onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  backgroundImage: Image.network(widget.imageUrl).image,
                  radius: 30,
                ),
                const Positioned(
                  right: 1,
                  bottom: 1,
                  child: Icon(
                    Icons.circle,
                    color: Colors.greenAccent,
                    size: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                widget.name,
                style: const TextStyle(fontSize: 18),
              ),
            ),
            widget.isMe
                ? const Text(
                    'You',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                    ),
                  )
                : const SizedBox(),
            // !widget.isMe
            //     ? const Padding(
            //         padding: EdgeInsets.only(left: 10.0),
            //         child: Icon(
            //           Icons.circle,
            //           color: Colors.deepPurpleAccent,
            //           size: 12,
            //         ),
            //       )
            //     : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
