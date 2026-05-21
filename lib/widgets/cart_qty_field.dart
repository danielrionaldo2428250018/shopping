import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../providers/cart_provider.dart';

/// Jumlah barang bisa diketik atau pakai ±.
class CartQtyField extends StatefulWidget {
  const CartQtyField({
    super.key,
    required this.productId,
    required this.quantity,
    required this.maxStock,
    required this.cart,
    this.accent = const Color(0xFF7B42F6),
  });

  final String productId;
  final int quantity;
  final int maxStock;
  final CartProvider cart;
  final Color accent;

  @override
  State<CartQtyField> createState() => _CartQtyFieldState();
}

class _CartQtyFieldState extends State<CartQtyField> {
  late TextEditingController _ctrl;
  final _focus = FocusNode();

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(text: '${widget.quantity}');
  }

  @override
  void didUpdateWidget(CartQtyField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_focus.hasFocus && oldWidget.quantity != widget.quantity) {
      _ctrl.text = '${widget.quantity}';
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _applyParsed() {
    final raw = _ctrl.text.trim();
    var n = int.tryParse(raw);
    if (n == null || n < 1) n = 1;
    if (n > widget.maxStock) n = widget.maxStock;
    _ctrl.text = '$n';
    widget.cart.setQuantity(widget.productId, n);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF3EEFF),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            visualDensity: VisualDensity.compact,
            onPressed: () {
              widget.cart.setQuantity(
                widget.productId,
                widget.quantity - 1,
              );
            },
            icon: const Icon(Icons.remove, size: 18),
            color: widget.accent,
          ),
          SizedBox(
            width: 44,
            child: TextField(
              controller: _ctrl,
              focusNode: _focus,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(4),
              ],
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              decoration: const InputDecoration(
                isDense: true,
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 8),
              ),
              onSubmitted: (_) => _applyParsed(),
              onEditingComplete: _applyParsed,
            ),
          ),
          IconButton(
            visualDensity: VisualDensity.compact,
            onPressed: widget.quantity >= widget.maxStock
                ? null
                : () {
                    widget.cart.setQuantity(
                      widget.productId,
                      widget.quantity + 1,
                    );
                  },
            icon: const Icon(Icons.add, size: 18),
            color: widget.accent,
          ),
        ],
      ),
    );
  }
}
