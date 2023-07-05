import 'dart:convert';

import 'package:chatflutterapp/app.dart';
import 'package:chatflutterapp/models/chat.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final chats = await _loadChatList();

  runApp(App(chats: chats));
}

Future<List<Chat>> _loadChatList() async {
  final result = <Chat>[];
  final rawData =
      jsonDecode(await rootBundle.loadString('assets/data/bootcamp.json'));
  for (final item in rawData['data']) {
    result.add(Chat.fromJson(item));
  }
  return result;
}