import 'package:flutter/material.dart';
import 'chat_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const RegScreen(),
    );
  }
}

class RegScreen extends StatefulWidget {
  const RegScreen({Key? key}) : super(key: key);

  @override
  _RegScreenState createState() => _RegScreenState();
}

class _RegScreenState extends State<RegScreen> {
  final TextEditingController _nameController = TextEditingController();
  bool _isLoading = false;

  void startChat() {
    if (_nameController.text.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });
      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          _isLoading = false;
        });
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChatScreen(
                      username: _nameController.text.trim(),
                    )));
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: const Color(0xFFEAEFF2),
          height: size.height,
          width: size.width,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Flexible(
                  child:  SizedBox(
                    width: size.width * 0.80,
                    child: TextField(
                      controller: _nameController,
                      cursorColor: Colors.black,
                      autofocus: false,
                      style: const TextStyle(fontSize: 18),
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.go,
                      maxLength: 20,
                      decoration: const InputDecoration(
                        labelText: 'Name',
                        hintText: 'Enter your username',
                        hintStyle: TextStyle(fontSize: 15),
                        labelStyle:
                            TextStyle(fontSize: 15, color: Color(0xFF271160)),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF271160))),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF271160))),
                        disabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF271160))),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 30),
                  width: size.width * 0.80,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: const Color(0xFF271160)),
                    onPressed: startChat,
                    child: _isLoading
                        ? Transform.scale(
                            scale: 0.7,
                            child: const CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                                strokeWidth: 2.5),
                          )
                        : const Text('Start Chat',
                            style:
                                TextStyle(fontSize: 17, color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
