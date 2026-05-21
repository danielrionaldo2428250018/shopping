import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/app_branding.dart';
import '../l10n/app_localizations.dart';
import '../models/inbox_thread.dart';
import '../providers/inbox_messages_provider.dart';
import '../services/app_notifications.dart';
import 'notification_chat_screen.dart';

/// Daftar percakapan seperti WhatsApp + izin notifikasi (FCM seperti fasum).
class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({
    super.key,
  });

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  static const _kPermIntro = 'notification_permission_intro_v1';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _maybeAskNotificationPermission());
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
      backgroundColor: const Color(0xFFF5F5F5),
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
      body: Consumer<InboxMessagesProvider>(
        builder: (context, inbox, _) {
          final list = inbox.threads;
          if (list.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.notifications_none_outlined,
                      size: 56,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      loc.noConversations,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      loc.inboxEmptyHint,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          return ListView.separated(
            itemCount: list.length,
            separatorBuilder: (_, __) => Divider(height: 1, color: Colors.grey.shade200),
            itemBuilder: (context, i) {
              final t = list[i];
              return _ThreadTile(
                thread: t,
                timeLabel: _timeLabel(t.lastAt),
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    NotificationChatScreen.route,
                    arguments: t.id,
                  );
                },
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
