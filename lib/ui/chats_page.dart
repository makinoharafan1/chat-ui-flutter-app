import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:chatflutterapp/models/chat.dart';
import 'package:chatflutterapp/utils/generate_gradient_color.dart';
import 'package:chatflutterapp/utils/timestamp_to_date.dart';



class ChatsPage extends StatefulWidget {
  final List<Chat> chats;

  const ChatsPage({Key? key, required this.chats}) : super(key: key);

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  List<Chat> filteredChats = [];
  TextEditingController searchController = TextEditingController();
  bool isSearching = false;
  bool isDarkMode = false;
  late Color randomColor;

  @override
  void initState() {
    super.initState();
    _filterChats('');
    randomColor = generateRandomColor();
    initializeDateFormatting();
  }

  void _filterChats(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredChats = widget.chats
            .where((chat) => chat.lastMessage != '')
            .toList();
      } else {
        filteredChats = widget.chats
            .where((chat) {
              final lastMessage = chat.lastMessage?.toLowerCase() ?? '';
              final userName = chat.userName.toLowerCase();
              final searchQuery = query.toLowerCase();
              return lastMessage.contains(searchQuery) || userName.contains(searchQuery);
            })
            .toList();
      }
      filteredChats.sort((a, b) => (b.date ?? 0).compareTo(a.date ?? 0));
    });
  }

  void _toggleDarkMode() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: Scaffold(
        backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
        appBar: AppBar(
          elevation: 8,
          leading: PopupMenuButton(
            icon: const Icon(Icons.menu),
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  child: ListTile(
                    leading: const Icon(Icons.dark_mode),
                    title: const Text('Сменить тему'),
                    onTap: _toggleDarkMode,
                  ),
                ),
              ];
            },
          ),
          title: isSearching
              ? TextField(
                  controller: searchController,
                  onChanged: (value) {
                    _filterChats(value);
                  },
                  decoration: const InputDecoration(
                    hintText: 'Поиск',
                    border: InputBorder.none,
                  ),
                  style: const TextStyle(color: Colors.white),
                )
              : const Text(
                  'Мессенджер',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
          actions: <Widget>[
            IconButton(
              icon: isSearching ? const Icon(Icons.clear) : const Icon(Icons.search),
              color: Colors.white,
              onPressed: () {
                setState(() {
                  if (isSearching) {
                    searchController.clear();
                    _filterChats('');
                  }
                  isSearching = !isSearching;
                });
              },
            ),
          ],
        ),
        body: ListView.builder(
          itemCount: filteredChats.length,
          itemBuilder: (context, index) {
            final chat = filteredChats[index];

            late String subtitle;
            subtitle = chat.lastMessage!;

            final lastMessageDate = DateTime.fromMillisecondsSinceEpoch(chat.date ?? 0);
            final currentDate = DateTime.now();

            late String date;

            if (chat.date == 0) {
              date = "";
            }
            else {
              date = timestampToDate(lastMessageDate, currentDate);
            }
            
            return Column(
              children: [
                ListTile(
                  tileColor: isDarkMode ? Colors.grey[700] : Colors.white,
                  title: Text(chat.userName),
                  subtitle: Text(
                    subtitle,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        date,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      if (chat.countUnreadMessages > 0)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            chat.countUnreadMessages.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                  leading: Stack(
                    children: [
                      CircleAvatar(
                        backgroundImage:
                        chat.userAvatar != null ? AssetImage('${chat.userAvatar}') : null,
                        child: chat.userAvatar == null
                            ? Text(
                          chat.userName.substring(0, 1).toUpperCase(),
                          style: const TextStyle(fontSize: 20),
                        )
                            : null,
                      ),
                      if (chat.userAvatar == null)
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  randomColor,
                                  const Color.fromARGB(255, 191, 174, 174),
                                ],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                chat.userName.substring(0, 1).toUpperCase(),
                                style: const TextStyle(fontSize: 20, color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      if (chat.isOnline)
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const Divider(
                  height: 1,
                  indent: 1,
                  thickness: 2,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
