import 'package:chat_client/model/user_model.dart';
import 'package:chat_client/one_to_one_chat/chat_list_screen.dart';
import 'package:flutter/material.dart';

class ListUserScreen extends StatefulWidget {
  const ListUserScreen({Key? key}) : super(key: key);

  @override
  State<ListUserScreen> createState() => _ListUserScreenState();
}

class _ListUserScreenState extends State<ListUserScreen> {
  List<UserModel> users = [
    UserModel('Nano Nano', '1111'),
    UserModel('Pendekar Biru', '2222'),
    UserModel('Hot Hot Pop', '3333'),
    UserModel('Mentos', '4444'),
    UserModel('Jagoan Neon', '5555'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Choose User'),
        backgroundColor: const Color(0xFF271160),
      ),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          return User(
            imageUrl: 'https://cdn-icons-png.flaticon.com/512/3135/3135715.png',
            name: users[index].name,
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ChatListScreen(
                            currentUser: users[index],
                            friends: users
                                .where((user) =>
                                    user.chatID != users[index].chatID)
                                .toList(),
                          )));
            },
          );
        },
      ),
    );
  }
}

class User extends StatefulWidget {
  final String imageUrl;
  final String name;
  final Function() onTap;

  const User({
    Key? key,
    required this.imageUrl,
    required this.name,
    required this.onTap,
  }) : super(key: key);

  @override
  State<User> createState() => _UserState();
}

class _UserState extends State<User> {
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
