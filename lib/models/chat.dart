import 'package:flutter/material.dart';

@immutable
class Chat {
  final String userName;
  final String? lastMessage;
  final int? date;
  final String? userAvatar;
  final int countUnreadMessages;
  final bool isOnline;

  const Chat({
    required this.userName,
    this.lastMessage,
    this.date,
    this.userAvatar,
    this.countUnreadMessages = 0,
    required this.isOnline
  });

  factory Chat.fromJson(Map<String, dynamic> map) {
    return Chat(
      userName: map['userName'] ?? '',
      lastMessage: map['lastMessage'] ?? '',
      date: map['date'] ?? 0,
      userAvatar: map['userAvatar'] != null
          ? 'assets/avatars/${map['userAvatar']}'
          : null,
      countUnreadMessages: map['countUnreadMessages']?.toInt() ?? 0,
      isOnline: map['isOnline']
    );
  }
}
