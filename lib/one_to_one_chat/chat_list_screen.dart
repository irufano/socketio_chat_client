import 'package:chat_client/model/user_model.dart';
import 'package:chat_client/one_to_one_chat/chat_one_to_one_screen.dart';
import 'package:flutter/material.dart';

class ChatListScreen extends StatefulWidget {
  final UserModel currentUser;
  final List<UserModel> friends;

  const ChatListScreen({
    Key? key,
    required this.currentUser,
    required this.friends,
  }) : super(key: key);

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Friends'),
        backgroundColor: const Color(0xFF271160),
        actions: [
          Center(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(widget.currentUser.name),
          )),
        ],
      ),
      body: ListView.builder(
        itemCount: widget.friends.length,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          return FriendItem(
            imageUrl: 'https://cdn-icons-png.flaticon.com/512/3135/3135715.png',
            name: widget.friends[index].name,
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ChatOneToOneScreen(
                          senderUser: widget.currentUser,
                          receiverUser: widget.friends[index])));
            },
          );
        },
      ),
    );
  }
}

class FriendItem extends StatefulWidget {
  final String imageUrl;
  final String name;
  final Function() onTap;

  const FriendItem({
    Key? key,
    required this.imageUrl,
    required this.name,
    required this.onTap,
  }) : super(key: key);

  @override
  State<FriendItem> createState() => _FriendItemState();
}

class _FriendItemState extends State<FriendItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: Image.network(widget.imageUrl).image,
              radius: 30,
            ),
            const SizedBox(width: 10),
            Text(
              widget.name,
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
