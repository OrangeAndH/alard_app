import 'package:flutter/material.dart';

import 'app_state.dart';
import 'app_state_scope.dart';
import 'shipping_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  static const Color _background = Color(0xFFF7F3EE);
  static const Color _olive = Color(0xFF55682A);
  static const Color _cream = Color(0xFFF2EDE6);
  static const Color _line = Color(0xFFD9D0C3);

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    final items = state.cartItems;

    return Scaffold(
      backgroundColor: _background,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 430),
            child: items.isEmpty ? _emptyCart(context) : _cartBody(context, state),
          ),
        ),
      ),
    );
  }

  Widget _cartBody(BuildContext context, AppState state) {
    final subtotal = state.subtotal;
    final shipping = 50.0;
    final vat = subtotal * 0.0135;
    final total = subtotal + shipping + vat;

    return Column(
      children: [
        _titleBar(context),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
            children: [
              ...state.cartItems.map(
                (item) => _cartItem(context, state, item),
              ),
              const SizedBox(height: 8),
              _locationRow(),
              const SizedBox(height: 8),
              _deliveryPreview(),
              const SizedBox(height: 22),
              _orderSummary(
                subtotal: subtotal,
                shipping: shipping,
                vat: vat,
                total: total,
              ),
              const SizedBox(height: 18),
              _trustBadges(),
              const SizedBox(height: 4),
              const Align(
                alignment: Alignment.centerRight,
                child: Icon(
                  Icons.eco_outlined,
                  color: _olive,
                  size: 42,
                ),
              ),
              const SizedBox(height: 8),
              _checkoutButton(context, state),
            ],
          ),
        ),
      ],
    );
  }

  Widget _titleBar(BuildContext context) {
    return SizedBox(
      height: 54,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(
                Icons.arrow_back_rounded,
                size: 30,
                color: Colors.black,
              ),
            ),
          ),
          const Center(
            child: Text(
              'Shopping Cart',
              style: TextStyle(
                color: _olive,
                fontSize: 23,
                fontFamily: 'serif',
                fontWeight: FontWeight.w500,
                shadows: [
                  Shadow(
                    color: Colors.black26,
                    blurRadius: 3,
                    offset: Offset(1, 1),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _cartItem(BuildContext context, AppState state, CartItem item) {
    return Container(
      height: 84,
      margin: const EdgeInsets.only(bottom: 11),
      padding: const EdgeInsets.fromLTRB(12, 10, 10, 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.92),
        borderRadius: BorderRadius.circular(9),
      ),
      child: Row(
        children: [
          Container(
            width: 58,
            height: 64,
            decoration: BoxDecoration(
              color: _cream,
              borderRadius: BorderRadius.circular(3),
            ),
            child: Image.asset(
              item.product.image,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) {
                return const Icon(
                  Icons.image_not_supported_outlined,
                  color: Colors.black38,
                );
              },
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.product.name.toUpperCase(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: _olive,
                      fontSize: 11,
                      fontFamily: 'serif',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    _productSize(item.product),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: _olive,
                      fontSize: 10,
                      fontFamily: 'serif',
                    ),
                  ),
                  const Spacer(),
                  _quantityControl(state, item),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 58,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _money(item.lineTotal),
                  style: const TextStyle(
                    color: _olive,
                    fontSize: 10,
                    fontFamily: 'serif',
                  ),
                ),
                const Spacer(),
                InkWell(
                  onTap: () => state.removeFromCart(item.product.id),
                  child: const Text(
                    'Remove',
                    style: TextStyle(
                      color: _olive,
                      fontSize: 10,
                      fontFamily: 'serif',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _quantityControl(AppState state, CartItem item) {
    return Container(
      height: 18,
      width: 72,
      decoration: BoxDecoration(
        color: const Color(0xFFF7F0E5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          _qtyButton(
            '-',
            onTap: () => state.decreaseQuantity(item.product.id),
          ),
          Expanded(
            child: Text(
              item.quantity.toString(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 11,
              ),
            ),
          ),
          _qtyButton(
            '+',
            onTap: () => state.increaseQuantity(item.product.id),
          ),
        ],
      ),
    );
  }

  Widget _qtyButton(String text, {required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        width: 22,
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              color: _olive,
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }

  Widget _locationRow() {
    return const Row(
      children: [
        Icon(
          Icons.location_on,
          color: Colors.black,
          size: 19,
        ),
        SizedBox(width: 2),
        Expanded(
          child: Text(
            'Delivering to: Palestine 🇵🇸',
            style: TextStyle(
              color: _olive,
              fontSize: 12,
              fontFamily: 'serif',
            ),
          ),
        ),
        Text(
          'change location',
          style: TextStyle(
            color: _olive,
            fontSize: 10,
            fontFamily: 'serif',
          ),
        ),
      ],
    );
  }

  Widget _deliveryPreview() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: _olive, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Column(
        children: [
          _DeliveryPreviewRow(
            title: 'Standard International',
            days: '5-7 days',
            price: '50 NIS',
          ),
          Divider(height: 1, color: _line),
          _DeliveryPreviewRow(
            title: 'Express',
            days: '2-3 days',
            price: '100 NIS',
          ),
        ],
      ),
    );
  }

  Widget _orderSummary({
    required double subtotal,
    required double shipping,
    required double vat,
    required double total,
  }) {
    return Column(
      children: [
        _summaryRow('Order Summary', _money(subtotal), large: true),
        const Divider(height: 14),
        _summaryRow('Subtotal: ${_money(subtotal)}', _money(subtotal)),
        const SizedBox(height: 8),
        _summaryRow('Shipping: ${_money(shipping)}', _money(shipping)),
        const SizedBox(height: 8),
        _summaryRow('Vat: ${vat.toStringAsFixed(2)} NIS', '${vat.toStringAsFixed(2)} NIS'),
        const Divider(height: 14),
        _summaryRow('Total:', '${total.toStringAsFixed(2)} NIS', large: true),
      ],
    );
  }

  Widget _summaryRow(String left, String right, {bool large = false}) {
    return Row(
      children: [
        Expanded(
          child: Text(
            left,
            style: TextStyle(
              color: _olive,
              fontSize: large ? 13 : 11,
              fontFamily: 'serif',
              fontWeight: large ? FontWeight.w500 : FontWeight.w400,
            ),
          ),
        ),
        Text(
          right,
          style: TextStyle(
            color: _olive,
            fontSize: large ? 13 : 11,
            fontFamily: 'serif',
            fontWeight: large ? FontWeight.w500 : FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _trustBadges() {
    return const Column(
      children: [
        Row(
          children: [
            Icon(Icons.check, color: Colors.black, size: 16),
            SizedBox(width: 4),
            Text(
              '100% Authentic',
              style: TextStyle(color: _olive, fontSize: 13, fontFamily: 'serif'),
            ),
            Spacer(),
            Icon(Icons.check, color: Colors.black, size: 16),
            SizedBox(width: 4),
            Text(
              'Secure Global Shipping',
              style: TextStyle(color: _olive, fontSize: 13, fontFamily: 'serif'),
            ),
          ],
        ),
        SizedBox(height: 8),
        Row(
          children: [
            Icon(Icons.check, color: Colors.black, size: 16),
            SizedBox(width: 4),
            Text(
              'Sustainably Packed',
              style: TextStyle(color: _olive, fontSize: 13, fontFamily: 'serif'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _checkoutButton(BuildContext context, AppState state) {
    return Center(
      child: SizedBox(
        width: 220,
        height: 34,
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ShippingScreen(
                  orderItems: _itemsToMaps(state),
                  profileData: _profileDataFromState(state),
                  subtotal: state.subtotal,
                ),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: _olive,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(7),
            ),
          ),
          child: const Text(
            'Proceed To Checkout',
            style: TextStyle(
              fontSize: 14,
              fontFamily: 'serif',
            ),
          ),
        ),
      ),
    );
  }

  Widget _emptyCart(BuildContext context) {
    return Column(
      children: [
        _titleBar(context),
        const Expanded(
          child: Center(
            child: Text(
              'Your cart is empty',
              style: TextStyle(
                color: _olive,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<Map<String, dynamic>> _itemsToMaps(AppState state) {
    return state.cartItems.map((item) {
      return {
        'name': item.product.name,
        'subtitle': _productSize(item.product),
        'price': item.product.price,
        'quantity': item.quantity,
        'image': item.product.image,
      };
    }).toList();
  }

  Map<String, String> _profileDataFromState(AppState state) {
    final user = state.currentUser;

    final name = user?.name.trim().isNotEmpty == true ? user!.name : 'Mohammed';
    final email = user?.email.trim().isNotEmpty == true ? user!.email : 'Mohammed@gmail.com';
    final phone = user?.phone.trim().isNotEmpty == true && user?.phone != 'No phone added'
        ? user!.phone
        : '+970 593245879';
    final country = user?.location.trim().isNotEmpty == true ? user!.location : 'Palestine';

    return {
      'name': name,
      'email': email,
      'phone': phone,
      'country': country,
      'city': 'Nablus',
      'postalCode': '10115',
    };
  }

  String _productSize(Product product) {
    if (product.weight.trim().isNotEmpty) return '-${product.weight.toUpperCase()}';
    if (product.subtitle.trim().isNotEmpty) return '-${product.subtitle.toUpperCase()}';
    return '';
  }

  String _money(double value) {
    if (value <= 0) return 'Quote';
    final hasDecimals = value % 1 != 0;
    return '${hasDecimals ? value.toStringAsFixed(2) : value.toStringAsFixed(0)} NIS';
  }
}

class _DeliveryPreviewRow extends StatelessWidget {
  final String title;
  final String days;
  final String price;

  const _DeliveryPreviewRow({
    required this.title,
    required this.days,
    required this.price,
  });

  static const Color _olive = Color(0xFF55682A);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 28,
      child: Row(
        children: [
          const SizedBox(width: 8),
          const Icon(Icons.radio_button_off, color: _olive, size: 17),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(color: _olive, fontSize: 12, fontFamily: 'serif'),
          ),
          const SizedBox(width: 5),
          Text(
            days,
            style: const TextStyle(color: _olive, fontSize: 9, fontFamily: 'serif'),
          ),
          const Spacer(),
          Text(
            price,
            style: const TextStyle(color: _olive, fontSize: 12, fontFamily: 'serif'),
          ),
          const SizedBox(width: 10),
        ],
      ),
    );
  }
}