import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/chat_models.dart';
import '../providers/auth_provider.dart';
import '../models/chat_inbox_mode.dart';
import '../providers/chat_provider.dart';
import '../utils/app_screen_style.dart';
import '../utils/l10n_helpers.dart';
import 'chat_screen.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  String _timeLabel(DateTime d) {
    final now = DateTime.now();
    final diff = now.difference(d);
    if (diff.inMinutes < 60) return '${diff.inMinutes.clamp(1, 59)} m';
    if (diff.inHours < 24) return '${diff.inHours} j';
    if (diff.inDays < 7) return '${diff.inDays} h';
    return '${d.day}/${d.month}';
  }

  @override
  Widget build(BuildContext context) {
    final loc = context.l10n;
    final auth = context.watch<AuthProvider>();
    final chat = context.watch<ChatProvider>();
    const mode = ChatInboxMode.all;
    final threads = chat.threadsForMode(mode);

    return Scaffold(
      backgroundColor: appScaffoldBackground(context),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          loc.chats,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: !auth.isLoggedIn
          ? Center(child: Text(loc.signInToChat))
          : threads.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.chat_bubble_outline,
                          size: 56,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          loc.noChats,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          loc.chatListEmptyHint,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: threads.length,
                  itemBuilder: (context, index) {
                    final t = threads[index];
                    return _ThreadTile(
                      thread: t,
                      displayName: chat.displayNameForThread(t, mode),
                      initials: chat.initialsFor(
                        chat.displayNameForThread(t, mode),
                      ),
                      timeLabel: _timeLabel(t.updatedAt),
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/chat',
                          arguments: ChatRouteArgs(
                            threadId: t.id,
                            sellerName: t.sellerName,
                            sellerInitials: chat.initialsFor(t.sellerName),
                            productId: t.productId,
                            productTitle: t.productTitle,
                          ),
                        );
                      },
                    );
                  },
                ),
    );
  }
}

class _ThreadTile extends StatelessWidget {
  const _ThreadTile({
    required this.thread,
    required this.displayName,
    required this.initials,
    required this.timeLabel,
    required this.onTap,
  });

  final ChatThreadMeta thread;
  final String displayName;
  final String initials;
  final String timeLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: appCardColor(context),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: appBorderColor(context)),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.all(14),
        leading: CircleAvatar(
          radius: 28,
          backgroundColor: const Color(0xFFE4D7FF),
          child: Text(
            initials,
            style: const TextStyle(
              color: Color(0xFF7F3DFF),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          displayName,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Text(
            thread.lastMessage.isNotEmpty
                ? thread.lastMessage
                : '—',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        trailing: Text(
          timeLabel,
          style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
        ),
      ),
    );
  }
}
