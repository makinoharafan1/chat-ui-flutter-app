import 'package:chatflutterapp/models/chat.dart';
import 'package:chatflutterapp/ui/chats_page.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  final List<Chat> chats;

  const App({super.key, required this.chats});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: ChatsPage(
        chats: chats,
      ),
    );
  }
}
