/// Metadata thread obrolan pembeli ↔ penjual (Realtime Database).
class ChatThreadMeta {
  const ChatThreadMeta({
    required this.id,
    required this.buyerUid,
    required this.buyerName,
    required this.sellerName,
    this.sellerUid,
    this.productId,
    this.productTitle,
    this.lastMessage = '',
    this.lastSenderUid,
    required this.updatedAt,
  });

  final String id;
  final String buyerUid;
  final String buyerName;
  final String sellerName;
  final String? sellerUid;
  final String? productId;
  final String? productTitle;
  final String lastMessage;
  final String? lastSenderUid;
  final DateTime updatedAt;

  factory ChatThreadMeta.fromRtdb(String id, Map<dynamic, dynamic> m) {
    DateTime parseTime(dynamic v) {
      if (v is int) return DateTime.fromMillisecondsSinceEpoch(v);
      if (v is String) return DateTime.tryParse(v) ?? DateTime.now();
      return DateTime.now();
    }

    return ChatThreadMeta(
      id: id,
      buyerUid: m['buyerUid'] as String? ?? '',
      buyerName: m['buyerName'] as String? ?? '',
      sellerName: m['sellerName'] as String? ?? '',
      sellerUid: m['sellerUid'] as String?,
      productId: m['productId'] as String?,
      productTitle: m['productTitle'] as String?,
      lastMessage: m['lastMessage'] as String? ?? '',
      lastSenderUid: m['lastSenderUid'] as String?,
      updatedAt: parseTime(m['updatedAt']),
    );
  }

  bool isUnreadForUid(String? uid) {
    if (uid == null || uid.isEmpty) return false;
    final last = lastSenderUid;
    if (last == null || last.isEmpty) return false;
    return last != uid;
  }

  Map<String, dynamic> toRtdbMap() => {
        'buyerUid': buyerUid,
        'buyerName': buyerName,
        'sellerName': sellerName,
        if (sellerUid != null) 'sellerUid': sellerUid,
        if (productId != null) 'productId': productId,
        if (productTitle != null) 'productTitle': productTitle,
        'lastMessage': lastMessage,
        if (lastSenderUid != null) 'lastSenderUid': lastSenderUid,
        'updatedAt': updatedAt.millisecondsSinceEpoch,
      };
}

/// Satu pesan dalam thread.
class ChatMessage {
  const ChatMessage({
    required this.id,
    required this.text,
    required this.senderUid,
    required this.senderName,
    required this.sentAt,
  });

  final String id;
  final String text;
  final String senderUid;
  final String senderName;
  final DateTime sentAt;

  factory ChatMessage.fromRtdb(String id, Map<dynamic, dynamic> m) {
    DateTime parseTime(dynamic v) {
      if (v is int) return DateTime.fromMillisecondsSinceEpoch(v);
      if (v is String) return DateTime.tryParse(v) ?? DateTime.now();
      return DateTime.now();
    }

    return ChatMessage(
      id: id,
      text: m['text'] as String? ?? '',
      senderUid: m['senderUid'] as String? ?? '',
      senderName: m['senderName'] as String? ?? '',
      sentAt: parseTime(m['sentAt']),
    );
  }

  Map<String, dynamic> toRtdbMap() => {
        'text': text,
        'senderUid': senderUid,
        'senderName': senderName,
        'sentAt': sentAt.millisecondsSinceEpoch,
      };
}
