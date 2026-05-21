import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/inbox_thread.dart';
import '../providers/inbox_messages_provider.dart';
import '../utils/l10n_helpers.dart';

/// Satu percakapan — bubble seperti WhatsApp.
class NotificationChatScreen extends StatefulWidget {
  const NotificationChatScreen({
    super.key,
    required this.threadId,
  });

  final String threadId;

  static const route = '/notification-chat';

  @override
  State<NotificationChatScreen> createState() => _NotificationChatScreenState();
}

class _NotificationChatScreenState extends State<NotificationChatScreen> {
  final _input = TextEditingController();
  final _scroll = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<InboxMessagesProvider>().markThreadRead(widget.threadId);
    });
  }

  @override
  void dispose() {
    _input.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _scrollBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.animateTo(
          _scroll.position.maxScrollExtent + 80,
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final loc = context.l10n;
    return Consumer<InboxMessagesProvider>(
      builder: (context, inbox, _) {
        final thread = inbox.threadById(widget.threadId);
        if (thread == null) {
          return Scaffold(
            appBar: AppBar(title: Text(loc.messages)),
            body: Center(child: Text(loc.conversationNotFound)),
          );
        }

        return Scaffold(
          backgroundColor: const Color(0xFFECE5DD),
          appBar: AppBar(
            backgroundColor: const Color(0xFF075E54),
            foregroundColor: Colors.white,
            titleSpacing: 0,
            title: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white24,
                  child: Text(
                    thread.avatarLetter.isNotEmpty
                        ? thread.avatarLetter[0].toUpperCase()
                        : '?',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        thread.title,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        loc.onlineStatus,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            actions: [
              if (thread.routeOnOpen != null)
                IconButton(
                  icon: const Icon(Icons.open_in_new_rounded),
                  tooltip: loc.openRelatedPage,
                  onPressed: () {
                    Navigator.pushNamed(context, thread.routeOnOpen!);
                  },
                ),
            ],
          ),
          body: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  controller: _scroll,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                  itemCount: thread.messages.length,
                  itemBuilder: (context, i) {
                    final m = thread.messages[i];
                    return _Bubble(message: m);
                  },
                ),
              ),
              Container(
                color: const Color(0xFFF0F0F0),
                padding: EdgeInsets.only(
                  left: 8,
                  right: 8,
                  top: 6,
                  bottom: MediaQuery.paddingOf(context).bottom + 6,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _input,
                        minLines: 1,
                        maxLines: 4,
                        decoration: InputDecoration(
                          hintText: loc.typeMessage,
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    CircleAvatar(
                      backgroundColor: const Color(0xFF075E54),
                      child: IconButton(
                        icon: const Icon(Icons.send_rounded, color: Colors.white),
                        onPressed: () {
                          final t = _input.text.trim();
                          if (t.isEmpty) return;
                          inbox.sendReply(thread.id, t);
                          _input.clear();
                          _scrollBottom();
                          setState(() {});
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Bubble extends StatelessWidget {
  const _Bubble({
    required this.message,
  });

  final InboxMessage message;

  String _time(DateTime d) {
    final h = d.hour.toString().padLeft(2, '0');
    final m = d.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  @override
  Widget build(BuildContext context) {
    final outbound = message.isOutbound;
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment:
            outbound ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!outbound) const SizedBox(width: 4),
          Flexible(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: outbound
                    ? const Color(0xFFDCF8C6)
                    : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(10),
                  topRight: const Radius.circular(10),
                  bottomLeft: Radius.circular(outbound ? 10 : 2),
                  bottomRight: Radius.circular(outbound ? 2 : 10),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      message.text,
                      style: TextStyle(
                        fontSize: 15,
                        height: 1.35,
                        color: outbound ? Colors.black87 : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _time(message.sentAt),
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (outbound) const SizedBox(width: 4),
        ],
      ),
    );
  }
}
