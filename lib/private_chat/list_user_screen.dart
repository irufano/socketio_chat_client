import 'package:chat_client/model/user_model.dart';
import 'package:chat_client/private_chat/chat_stream.dart';
import 'package:chat_client/private_chat/online_user_screen.dart';
import 'package:flutter/material.dart';

class ListUserScreen extends StatefulWidget {
  const ListUserScreen({Key? key}) : super(key: key);

  @override
  State<ListUserScreen> createState() => _ListUserScreenState();
}

class _ListUserScreenState extends State<ListUserScreen> {
  @override
  void initState() {
    chatStream.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Choose User'),
        backgroundColor: const Color(0xFF271160),
      ),
      body: StreamBuilder<List<UserModel>>(
          stream: chatStream.availableUsers,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: (context, index) {
                var user = snapshot.data?[index];
                return User(
                  imageUrl:
                      'https://cdn-icons-png.flaticon.com/512/3135/3135715.png',
                  name: user?.username ?? '-',
                  onTap: () {
                    chatStream.onUserSelected(user ?? UserModel());
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => OnlineUserScreen(
                                  currentUser: user ?? UserModel(),
                                )));
                  },
                );
              },
            );
          }),
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
