import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../models/app_models.dart';
import '../services/persistence_service.dart';
import 'currency_state.dart';

/// Owns the shopping cart: add, remove, quantity, subtotals, and order placement.
/// Estimated lines: ~115
class CartState {
  final List<CartItem> _cart = [];

  List<CartItem> get cartItems => _cart;
  List<CartItem> get cart => List.unmodifiable(_cart);
  int get cartCount => _cart.fold(0, (total, item) => total + item.quantity);

  // ── Init ─────────────────────────────────────────────────────────

  /// Loads previously persisted cart from SharedPreferences.
  Future<void> loadPersistedCart({required VoidCallback notify}) async {
    final items = await PersistenceService.loadCart();
    if (items.isNotEmpty) {
      _cart.addAll(items);
      notify();
    }
  }

  // ── Mutations ────────────────────────────────────────────────────

  void addToCart(
    Product product, {
    ProductVariant? variant,
    int quantity = 1,
    required VoidCallback notify,
  }) {
    final key =
        variant != null ? '${product.id}_${variant.id}' : product.id;
    final index = _cart.indexWhere((item) => item.cartKey == key);

    if (index != -1) {
      _cart[index].quantity += quantity;
    } else {
      _cart.add(
        CartItem(product: product, selectedVariant: variant, quantity: quantity),
      );
    }
    PersistenceService.saveCart(_cart);
    notify();
  }

  void removeFromCart(String cartKey, VoidCallback notify) {
    _cart.removeWhere((item) => item.cartKey == cartKey);
    PersistenceService.saveCart(_cart);
    notify();
  }

  void updateCartQuantity(String cartKey, int delta, VoidCallback notify) {
    final index = _cart.indexWhere((item) => item.cartKey == cartKey);
    if (index != -1) {
      _cart[index].quantity += delta;
      if (_cart[index].quantity <= 0) _cart.removeAt(index);
      PersistenceService.saveCart(_cart);
      notify();
    }
  }

  void decreaseQuantity(String cartKey, VoidCallback notify) =>
      updateCartQuantity(cartKey, -1, notify);

  void increaseQuantity(String cartKey, VoidCallback notify) =>
      updateCartQuantity(cartKey, 1, notify);

  void clearCart(VoidCallback notify) {
    _cart.clear();
    PersistenceService.clearCart();
    notify();
  }

  // ── Computed Totals ──────────────────────────────────────────────

  double cartSubtotal({required bool isTrader}) {
    return _cart.fold(0.0, (total, item) {
      final effective = CurrencyState.traderDiscount;
      final price = isTrader ? item.price * effective : item.price;
      return total + (price * item.quantity);
    });
  }

  double cartTotal({required bool isTrader}) {
    final sub = cartSubtotal(isTrader: isTrader);
    if (sub <= 0) return 0;
    return sub + CurrencyState.deliveryFee;
  }

  // ── Order Placement ──────────────────────────────────────────────

  Future<AppOrder?> placeOrder({
    required String name,
    required String phone,
    required String address,
    required String mailbox,
    required String note,
    required String paymentMethod,
    required bool isTrader,
  }) async {
    final orderId = 'ORD-${DateTime.now().millisecondsSinceEpoch}';
    final sub = cartSubtotal(isTrader: isTrader);
    final total = cartTotal(isTrader: isTrader);

    final orderData = <String, dynamic>{
      'id': orderId,
      'date': FieldValue.serverTimestamp(),
      'customerName': name,
      'phone': phone,
      'deliveryAddress': address,
      'mailboxAddress': mailbox,
      'note': note,
      'paymentMethod': paymentMethod,
      'status': 'Pending',
      'subtotal': sub,
      'delivery': CurrencyState.deliveryFee,
      'total': total,
      'items': _cart.map((item) => {
        'name': item.product.name,
        'subtitle': item.product.subtitle,
        'image': item.product.image,
        'price': item.price,
        'quantity': item.quantity,
        'variantSize': item.selectedVariant?.size,
      }).toList(),
    };

    try {
      await FirebaseFirestore.instance
          .collection('orders')
          .doc(orderId)
          .set(orderData);

      final newOrder = AppOrder(
        id: orderId,
        date: DateTime.now(),
        items: _cart.map((item) => OrderLine(
          productName: item.product.name,
          subtitle: item.product.subtitle,
          image: item.product.image,
          price: item.price,
          quantity: item.quantity,
          variantSize: item.selectedVariant?.size,
        )).toList(),
        customerName: name,
        phone: phone,
        deliveryAddress: address,
        mailboxAddress: mailbox,
        note: note,
        paymentMethod: paymentMethod,
        status: 'Pending',
        subtotal: sub,
        delivery: CurrencyState.deliveryFee,
        total: total,
      );

      _cart.clear();
      return newOrder;
    } catch (e) {
      debugPrint('Error placing order: $e');
      return null;
    }
  }
}
