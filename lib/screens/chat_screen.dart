import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../models/chat_models.dart';
import '../providers/auth_provider.dart';
import '../providers/chat_provider.dart';
import '../services/chat_rtdb_service.dart';
import 'seller_store_screen.dart';
import '../utils/l10n_helpers.dart';
import '../widgets/app_network_image.dart';

const _kPurple = Color(0xFF7B42F6);

/// Kirim lewat [Navigator.pushNamed] `arguments:` agar header & kartu produk terisi.
class ChatRouteArgs {
  const ChatRouteArgs({
    required this.sellerName,
    this.sellerInitials = 'S',
    this.isOnline = true,
    this.threadId,
    this.productId,
    this.productTitle,
    this.productPrice,
    this.productImageUrl,
  });

  final String sellerName;
  final String sellerInitials;
  final bool isOnline;
  final String? threadId;
  final String? productId;
  final String? productTitle;
  final String? productPrice;
  final String? productImageUrl;

  bool get hasProduct =>
      productTitle != null &&
      productTitle!.isNotEmpty;

  static ChatRouteArgs resolve(Object? raw) {
    if (raw is ChatRouteArgs) return raw;
    return const ChatRouteArgs(
      sellerName: 'Rizky Store',
      sellerInitials: 'RS',
    );
  }
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({
    super.key,
    this.args,
  });

  final ChatRouteArgs? args;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController =
      TextEditingController();
  final ScrollController _scrollController = ScrollController();

  String _searchQuery = '';
  String? _threadId;
  bool _openingThread = true;
  String? _headerSellerName;
  String? _headerInitials;

  ChatRouteArgs get _args =>
      widget.args ?? const ChatRouteArgs(sellerName: 'Seller');

  List<ChatMessage> _filterMessages(List<ChatMessage> messages) {
    final q = _searchQuery.trim().toLowerCase();
    if (q.isEmpty) return messages;
    return messages
        .where((m) => m.text.toLowerCase().contains(q))
        .toList();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _openThread());
  }

  Future<void> _openThread() async {
    final loc = context.l10n;
    final auth = context.read<AuthProvider>();
    if (!auth.isLoggedIn) {
      if (mounted) setState(() => _openingThread = false);
      return;
    }

    final chat = context.read<ChatProvider>();
    final id = _args.threadId ??
        await chat.openThreadWithSeller(
          sellerName: _args.sellerName,
          productId: _args.productId,
          productTitle: _args.productTitle,
        );

    if (!mounted) return;
    if (id == null) {
      final err = context.read<ChatProvider>().lastError;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            err != null && err.isNotEmpty
                ? err
                : loc.chatOpenFailed,
          ),
        ),
      );
    }
    if (id != null) {
      await context.read<ChatProvider>().refreshBuyerInbox();
      final meta = await ChatRtdbService.getThreadMeta(id);
      if (meta != null && mounted) {
        final uid = auth.uid;
        final headerName = uid != null && meta.buyerUid == uid
            ? meta.sellerName
            : meta.buyerName;
        final letter = headerName.isNotEmpty
            ? headerName.substring(0, 1).toUpperCase()
            : _args.sellerInitials;
        setState(() {
          _threadId = id;
          _openingThread = false;
          _headerSellerName = headerName;
          _headerInitials = letter.length >= 2
              ? '${headerName[0]}${headerName.split(' ').last[0]}'
                  .toUpperCase()
              : letter;
        });
        return;
      }
    }
    setState(() {
      _threadId = id;
      _openingThread = false;
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (!_scrollController.hasClients) return;
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOut,
    );
  }

  Future<void> _send() async {
    final t = _messageController.text.trim();
    final threadId = _threadId;
    if (t.isEmpty || threadId == null) return;
    _messageController.clear();
    final chat = context.read<ChatProvider>();
    final ok = await chat.sendMessage(
      threadId: threadId,
      text: t,
    );
    if (!mounted) return;
    if (!ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            chat.lastError ?? context.l10n.chatOpenFailed,
          ),
        ),
      );
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  Future<void> _pickAndSendImage() async {
    await Permission.photos.request();
    if (!mounted) return;

    final file = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 82,
    );
    if (file == null) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.l10n.chatImageComingSoon)),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  String _timeLabel(DateTime n) {
    return '${n.hour.toString().padLeft(2, '0')}.'
        '${n.minute.toString().padLeft(2, '0')}';
  }

  void _showMoreMenu(BuildContext context) {
    final loc = context.l10n;
    final seller = _args.sellerName;
    showModalBottomSheet<void>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.storefront_outlined),
              title: Text(loc.viewSellerStore),
              onTap: () {
                Navigator.pop(ctx);
                Navigator.pushNamed(
                  context,
                  SellerStoreScreen.route,
                  arguments: seller,
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.search_rounded),
              title: Text(loc.searchInChat),
              onTap: () {
                Navigator.pop(ctx);
                final qCtrl = TextEditingController(text: _searchQuery);
                showDialog<void>(
                  context: context,
                  builder: (dCtx) => AlertDialog(
                    title: Text(loc.searchMessages),
                    content: TextField(
                      controller: qCtrl,
                      autofocus: true,
                      decoration: InputDecoration(
                        hintText: loc.keywordHint,
                      ),
                      onSubmitted: (_) => Navigator.pop(dCtx),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          setState(() => _searchQuery = '');
                          Navigator.pop(dCtx);
                        },
                        child: Text(loc.reset),
                      ),
                      FilledButton(
                        onPressed: () {
                          setState(() => _searchQuery = qCtrl.text);
                          Navigator.pop(dCtx);
                        },
                        child: Text(loc.apply),
                      ),
                    ],
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: Text(loc.mediaAndPhotos),
              onTap: () {
                Navigator.pop(ctx);
                showModalBottomSheet<void>(
                  context: context,
                  builder: (mCtx) => SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(loc.noPhotosInChat),
                    ),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.notifications_off_outlined),
              title: Text(loc.muteChatNotif),
              onTap: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(loc.muteChatDemo)),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline_rounded),
              title: Text(loc.deleteConversation),
              onTap: () async {
                Navigator.pop(ctx);
                final ok = await showDialog<bool>(
                  context: context,
                  builder: (dCtx) => AlertDialog(
                    title: Text(loc.deleteConversationQ),
                    content: Text(loc.deleteHistoryHint),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(dCtx, false),
                        child: Text(loc.cancel),
                      ),
                      FilledButton(
                        onPressed: () => Navigator.pop(dCtx, true),
                        child: Text(loc.delete),
                      ),
                    ],
                  ),
                );
                if (ok == true && mounted) {
                  setState(() => _searchQuery = '');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(loc.chatHistoryLocalOnly)),
                  );
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.flag_outlined),
              title: Text(loc.reportConversation),
              onTap: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(loc.reportSentDemo)),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.block_rounded),
              title: Text(loc.blockSeller),
              onTap: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(loc.blockSellerDemo)),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = context.l10n;
    final a = _args;
    final auth = context.watch<AuthProvider>();

    if (!auth.isLoggedIn) {
      return Scaffold(
        appBar: AppBar(title: Text(a.sellerName)),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  loc.signInToChat,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: () => Navigator.pushNamed(context, '/login'),
                  child: Text(loc.signIn),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F5),
      body: Column(
        children: [
          _ChatHeader(
            sellerName: _headerSellerName ?? a.sellerName,
            initials: _headerInitials ?? a.sellerInitials,
            isOnline: a.isOnline,
            onMore: () => _showMoreMenu(context),
          ),
          if (a.hasProduct)
            _ProductContextStrip(
              productId: a.productId,
              title: a.productTitle!,
              price: a.productPrice ?? '',
              imageUrl: a.productImageUrl,
            ),
          Expanded(
            child: _openingThread
                ? const Center(child: CircularProgressIndicator())
                : _threadId == null
                    ? Center(child: Text(loc.chatOpenFailed))
                    : StreamBuilder<List<ChatMessage>>(
                    stream: ChatRtdbService.watchMessages(_threadId!),
                    builder: (context, snap) {
                      final uid = context.watch<AuthProvider>().uid;
                      final all = snap.data ?? const <ChatMessage>[];
                      final visible = _filterMessages(all);
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (snap.hasData) _scrollToBottom();
                      });

                      return ListView.builder(
                        controller: _scrollController,
                        padding:
                            const EdgeInsets.fromLTRB(16, 16, 16, 8),
                        itemCount: visible.isEmpty ? 2 : visible.length + 1,
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            return _DateChip(label: loc.today);
                          }
                          if (visible.isEmpty && index == 1) {
                            return Padding(
                              padding: const EdgeInsets.all(32),
                              child: Center(
                                child: Text(
                                  _searchQuery.trim().isEmpty
                                      ? loc.chatStartHint
                                      : loc.noSearchInChat,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ),
                            );
                          }
                          final m = visible[index - 1];
                          return _ChatBubble(
                            text: m.text,
                            isMe: uid != null && m.senderUid == uid,
                            time: _timeLabel(m.sentAt),
                          );
                        },
                      );
                    },
                  ),
          ),
          _ComposerBar(
            controller: _messageController,
            onSend: _send,
            onPickImage: _pickAndSendImage,
          ),
        ],
      ),
    );
  }
}

class _ChatHeader extends StatelessWidget {
  const _ChatHeader({
    required this.sellerName,
    required this.initials,
    required this.isOnline,
    required this.onMore,
  });

  final String sellerName;
  final String initials;
  final bool isOnline;
  final VoidCallback onMore;

  @override
  Widget build(BuildContext context) {
    final loc = context.l10n;
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF7F3DFF),
            Color(0xFFB388FF),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 12, 14),
          child: Row(
            children: [
              IconButton(
                style: IconButton.styleFrom(
                  foregroundColor: Colors.white,
                ),
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
              ),
              CircleAvatar(
                radius: 22,
                backgroundColor: Colors.white.withValues(alpha: 0.95),
                child: Text(
                  initials.length > 2
                      ? initials.substring(0, 2).toUpperCase()
                      : initials.toUpperCase(),
                  style: const TextStyle(
                    color: _kPurple,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      sellerName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isOnline
                                ? const Color(0xFF69F0AE)
                                : Colors.white54,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          isOnline ? loc.onlineStatus : loc.offlineStatus,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.95),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                style: IconButton.styleFrom(
                  foregroundColor: Colors.white,
                ),
                onPressed: onMore,
                icon: const Icon(Icons.more_horiz_rounded),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProductContextStrip extends StatelessWidget {
  const _ProductContextStrip({
    this.productId,
    required this.title,
    required this.price,
    this.imageUrl,
  });

  final String? productId;
  final String title;
  final String price;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 2,
      shadowColor: Colors.black26,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: imageUrl != null
                  ? AppNetworkImage(
                      url: imageUrl!,
                      width: 48,
                      height: 48,
                      fit: BoxFit.cover,
                    )
                  : _placeholderThumb(),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      height: 1.25,
                    ),
                  ),
                  if (price.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      price,
                      style: const TextStyle(
                        color: _kPurple,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            TextButton(
              onPressed: () {
                if (productId != null) {
                  Navigator.pushNamed(
                    context,
                    '/product-detail',
                    arguments: productId,
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(context.l10n.productNotLinked)),
                  );
                }
              },
              child: Text(context.l10n.details),
            ),
          ],
        ),
      ),
    );
  }

  Widget _placeholderThumb() {
    return Container(
      width: 48,
      height: 48,
      color: const Color(0xFFE8DEF8),
      child: const Icon(
        Icons.shopping_bag_outlined,
        color: _kPurple,
      ),
    );
  }
}

class _DateChip extends StatelessWidget {
  const _DateChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  const _ChatBubble({
    required this.text,
    required this.isMe,
    required this.time,
  });

  final String text;
  final bool isMe;
  final String time;

  @override
  Widget build(BuildContext context) {
    final bubbleColor =
        isMe ? const Color(0xFF7F3DFF) : Colors.white;
    final textColor = isMe ? Colors.white : Colors.black87;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.sizeOf(context).width * 0.78,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            decoration: BoxDecoration(
              color: bubbleColor,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(18),
                topRight: const Radius.circular(18),
                bottomLeft: Radius.circular(isMe ? 18 : 4),
                bottomRight: Radius.circular(isMe ? 4 : 18),
              ),
              boxShadow: isMe
                  ? null
                  : [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (text.isNotEmpty)
                  Text(
                    text,
                    style: TextStyle(
                      color: textColor,
                      height: 1.45,
                      fontSize: 14.5,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Padding(
            padding: EdgeInsets.only(
              left: isMe ? 0 : 6,
              right: isMe ? 6 : 0,
            ),
            child: Text(
              time,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey.shade600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ComposerBar extends StatelessWidget {
  const _ComposerBar({
    required this.controller,
    required this.onSend,
    required this.onPickImage,
  });

  final TextEditingController controller;
  final VoidCallback onSend;
  final VoidCallback onPickImage;

  @override
  Widget build(BuildContext context) {
    final loc = context.l10n;
    return Material(
      elevation: 8,
      color: Colors.white,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              IconButton(
                onPressed: onPickImage,
                style: IconButton.styleFrom(
                  backgroundColor: const Color(0xFFF3EEFF),
                  foregroundColor: _kPurple,
                ),
                icon: const Icon(Icons.add_photo_alternate_outlined),
                tooltip: loc.sendPhoto,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F7),
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: TextField(
                    controller: controller,
                    minLines: 1,
                    maxLines: 4,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      hintText: loc.typeMessage,
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                    ),
                    onSubmitted: (_) => onSend(),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                decoration: const BoxDecoration(
                  color: _kPurple,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  onPressed: onSend,
                  icon: const Icon(
                    Icons.send_rounded,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
