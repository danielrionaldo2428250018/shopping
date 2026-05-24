import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/app_branding.dart';
import '../l10n/app_localizations.dart';
import '../models/chat_inbox_mode.dart';
import '../models/chat_models.dart';
import '../models/inbox_thread.dart';
import '../providers/auth_provider.dart';
import '../providers/chat_provider.dart';
import '../providers/inbox_messages_provider.dart';
import 'chat_screen.dart';
import '../services/app_notifications.dart';
import 'notification_chat_screen.dart';

/// Daftar percakapan seperti WhatsApp + izin notifikasi (FCM seperti fasum).
class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({
    super.key,
    this.mode = ChatInboxMode.buyer,
  });

  /// [ChatInboxMode.buyer] dari profil pembeli; [ChatInboxMode.seller] dari profil toko.
  final ChatInboxMode mode;

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  static const _kPermIntro = 'notification_permission_intro_v1';
  bool _syncingChats = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshSellerChatsIfNeeded();
      _maybeAskNotificationPermission();
    });
  }

  Future<void> _reloadChats() async {
    if (!mounted) return;
    setState(() => _syncingChats = true);
    await context.read<ChatProvider>().refreshSellerInbox();
    if (!mounted) return;
    setState(() => _syncingChats = false);
    final err = context.read<ChatProvider>().lastError;
    if (err != null && err.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(err)),
      );
    }
  }

  Future<void> _refreshSellerChatsIfNeeded() async {
    if (!mounted) return;
    if (widget.mode != ChatInboxMode.seller) return;
    final auth = context.read<AuthProvider>();
    if (!auth.isLoggedIn) return;
    await _reloadChats();
  }

  Future<void> _maybeAskNotificationPermission() async {
    if (!mounted) return;
    final loc = AppLocalizations.of(context);
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    if (prefs.getBool(_kPermIntro) == true) return;

    final go = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: Text(loc.notificationPermissionTitle),
        content: Text(
          loc.notificationPermissionBody(AppBranding.appName),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(loc.later),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(loc.continueRequestPermission),
          ),
        ],
      ),
    );

    if (!mounted) return;

    await prefs.setBool(_kPermIntro, true);
    if (!mounted) return;

    if (go == true) {
      await Permission.notification.request();
      await requestFcmNotificationPermission();
    }
  }

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
    final loc = AppLocalizations.of(context);
    return Scaffold(
            appBar: AppBar(
        backgroundColor: const Color(0xFF075E54),
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          loc.messages,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded),
            onPressed: () => Navigator.pushNamed(context, '/search'),
          ),
          PopupMenuButton<String>(
            onSelected: (v) async {
              if (v == 'perm') {
                final messenger = ScaffoldMessenger.of(context);
                await Permission.notification.request();
                await requestFcmNotificationPermission();
                if (!context.mounted) return;
                messenger.showSnackBar(
                  SnackBar(content: Text(loc.notificationRequestSent)),
                );
              }
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                value: 'perm',
                child: Text(loc.requestNotificationAgain),
              ),
            ],
          ),
        ],
      ),
      body: Consumer2<ChatProvider, InboxMessagesProvider>(
        builder: (context, chat, inbox, _) {
          final mode = widget.mode;
          final chats = chat.threadsForMode(mode);
          final notifs = mode == ChatInboxMode.buyer
              ? inbox.threads
                  .where((t) => !t.id.startsWith('rtdb-chat-'))
                  .toList()
              : <InboxThread>[];

          if (!chat.isReady) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  chat.lastError ?? loc.chatOpenFailed,
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          if (chats.isEmpty && notifs.isEmpty) {
            final auth = context.watch<AuthProvider>();
            final isSellerView = mode == ChatInboxMode.seller;
            final err = chat.lastError;
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_syncingChats)
                      const Padding(
                        padding: EdgeInsets.only(bottom: 16),
                        child: CircularProgressIndicator(),
                      )
                    else
                      Icon(
                        Icons.chat_bubble_outline,
                        size: 56,
                        color: Colors.grey.shade400,
                      ),
                    const SizedBox(height: 12),
                    Text(
                      _syncingChats ? loc.chatSyncing : loc.noConversations,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      isSellerView
                          ? loc.sellerChatSyncHint
                          : loc.buyerChatEmptyHint,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    if (err != null && err.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Text(
                        err,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.red.shade700,
                        ),
                      ),
                    ],
                    if (auth.isLoggedIn && isSellerView) ...[
                      const SizedBox(height: 16),
                      FilledButton.icon(
                        onPressed: _syncingChats ? null : _reloadChats,
                        icon: const Icon(Icons.refresh_rounded),
                        label: Text(loc.reloadChats),
                      ),
                    ],
                  ],
                ),
              ),
            );
          }

          return ListView(
            children: [
              if (chats.isNotEmpty) ...[
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                  child: Text(
                    _sectionTitle(loc, mode),
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ),
                ...chats.map((t) => _ChatThreadTile(
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
                            sellerInitials:
                                chat.initialsFor(t.sellerName),
                            productId: t.productId,
                            productTitle: t.productTitle,
                          ),
                        );
                      },
                    )),
              ],
              if (notifs.isNotEmpty) ...[
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
                  child: Text(
                    loc.notificationsSection,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ),
                ...notifs.map(
                  (t) => Column(
                    children: [
                      _ThreadTile(
                        thread: t,
                        timeLabel: _timeLabel(t.lastAt),
                        onTap: () {
                          final chatId =
                              inbox.chatThreadIdFromInboxId(t.id);
                          if (chatId != null) {
                            ChatThreadMeta? meta;
                            for (final c in chats) {
                              if (c.id == chatId) {
                                meta = c;
                                break;
                              }
                            }
                            if (meta != null) {
                              Navigator.pushNamed(
                                context,
                                '/chat',
                                arguments: ChatRouteArgs(
                                  threadId: meta.id,
                                  sellerName: meta.sellerName,
                                  sellerInitials:
                                      chat.initialsFor(meta.sellerName),
                                  productId: meta.productId,
                                  productTitle: meta.productTitle,
                                ),
                              );
                              return;
                            }
                          }
                          Navigator.pushNamed(
                            context,
                            NotificationChatScreen.route,
                            arguments: t.id,
                          );
                        },
                      ),
                      Divider(height: 1, color: Colors.grey.shade200),
                    ],
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _ChatThreadTile extends StatelessWidget {
  const _ChatThreadTile({
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
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: const Color(0xFFE4D7FF),
                child: Text(
                  initials,
                  style: const TextStyle(
                    color: Color(0xFF7F3DFF),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            displayName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Text(
                          timeLabel,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      thread.lastMessage.isNotEmpty
                          ? thread.lastMessage
                          : '—',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ThreadTile extends StatelessWidget {
  const _ThreadTile({
    required this.thread,
    required this.timeLabel,
    required this.onTap,
  });

  final InboxThread thread;
  final String timeLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final accent = Color(thread.accentArgb ?? 0xFFC47844);
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: accent.withValues(alpha: 0.2),
                child: Text(
                  thread.avatarLetter.isNotEmpty
                      ? thread.avatarLetter[0].toUpperCase()
                      : '?',
                  style: TextStyle(
                    color: accent,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            thread.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Text(
                          timeLabel,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            thread.preview,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ),
                        if (thread.hasUnread)
                          Container(
                            margin: const EdgeInsets.only(left: 8),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 7,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF25D366),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${thread.unreadCount}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String _sectionTitle(AppLocalizations loc, ChatInboxMode mode) {
  switch (mode) {
    case ChatInboxMode.buyer:
      return loc.buyerMessages;
    case ChatInboxMode.seller:
      return loc.sellerStoreMessages;
    case ChatInboxMode.all:
      return loc.messages;
  }
}
