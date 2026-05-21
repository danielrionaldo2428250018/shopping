import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/inbox_thread.dart';

/// Pesan / notifikasi gaya percakapan (WhatsApp), disimpan lokal.
class InboxMessagesProvider extends ChangeNotifier {
  InboxMessagesProvider(this._prefs) {
    _load();
  }

  final SharedPreferences _prefs;
  static const _kThreads = 'inbox_threads_v3';

  final List<InboxThread> _threads = [];

  List<InboxThread> get threads =>
      List.unmodifiable(_threads..sort((a, b) => b.lastAt.compareTo(a.lastAt)));

  int get unreadCount =>
      _threads.where((t) => t.hasUnread).length;

  void _load() {
    _prefs.remove('inbox_threads_v1');
    _prefs.remove('inbox_threads_v2');
    final s = _prefs.getString(_kThreads);
    _threads.clear();
    if (s != null && s.isNotEmpty) {
      try {
        _threads.addAll(inboxThreadsFromJson(s));
      } catch (_) {
        _prefs.remove(_kThreads);
      }
    }
    notifyListeners();
  }

  void _persist() {
    _prefs.setString(_kThreads, inboxThreadsToJson(_threads));
  }

  InboxThread? threadById(String id) {
    try {
      return _threads.firstWhere((t) => t.id == id);
    } catch (_) {
      return null;
    }
  }

  void sendReply(String threadId, String text) {
    final i = _threads.indexWhere((t) => t.id == threadId);
    if (i < 0) return;
    final t = _threads[i];
    final msg = InboxMessage(
      id: 'local-${DateTime.now().millisecondsSinceEpoch}',
      text: text.trim(),
      sentAt: DateTime.now(),
      isOutbound: true,
    );
    if (msg.text.isEmpty) return;
    _threads[i] = t.copyWith(
      messages: [...t.messages, msg],
    );
    _persist();
    notifyListeners();
  }

  void markThreadRead(String threadId) {
    final i = _threads.indexWhere((t) => t.id == threadId);
    if (i < 0) return;
    final t = _threads[i];
    _threads[i] = t.copyWith(unreadCount: 0);
    _persist();
    notifyListeners();
  }

  /// Kosongkan semua percakapan notifikasi.
  void clearAll() {
    _threads.clear();
    _prefs.remove(_kThreads);
    _prefs.remove('inbox_threads_v1');
    _prefs.remove('inbox_threads_v2');
    notifyListeners();
  }
}
