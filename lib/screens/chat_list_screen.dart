import 'package:flutter/material.dart';

import '../utils/l10n_helpers.dart';
import 'chat_screen.dart';

class ChatListScreen
    extends StatelessWidget {

  const ChatListScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final loc = context.l10n;

    final chats = <({String name, String initials, String message, String time})>[];

    return Scaffold(

      backgroundColor:
          const Color(0xFFF5F5F5),

      appBar: AppBar(

        backgroundColor:
            Colors.white,

        elevation: 0,

        centerTitle: true,

        title: Text(
          loc.chats,

          style: const TextStyle(
            color: Colors.black,
            fontWeight:
                FontWeight.bold,
          ),
        ),
      ),

      body: chats.isEmpty
          ? Center(
              child: Text(loc.noChats),
            )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: chats.length,
        itemBuilder: (context, index) {
          final chat = chats[index];

          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.grey.shade100),
            ),
            child: ListTile(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/chat',
                  arguments: ChatRouteArgs(
                    sellerName: chat.name,
                    sellerInitials: chat.initials,
                  ),
                );
              },
              contentPadding: const EdgeInsets.all(16),
              leading: CircleAvatar(
                radius: 30,
                backgroundColor: const Color(0xFFE4D7FF),
                child: Text(
                  chat.initials,
                  style: const TextStyle(
                    color: Color(0xFF7F3DFF),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              title: Text(
                chat.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  chat.message,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              trailing: Text(
                chat.time,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 12,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
