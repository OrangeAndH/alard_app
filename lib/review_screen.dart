import 'package:flutter/material.dart';

class ReviewScreen extends StatelessWidget {
  final List<Map<String, dynamic>> orderItems;
  final Map<String, String> profileData;
  final double subtotal;
  final double shippingFee;
  final String shippingTitle;
  final double vat;
  final double total;
  final String paymentMethod;

  const ReviewScreen({
    super.key,
    required this.orderItems,
    required this.profileData,
    required this.subtotal,
    required this.shippingFee,
    required this.shippingTitle,
    required this.vat,
    required this.total,
    required this.paymentMethod,
  });

  static const Color _background = Color(0xFFF7F3EE);
  static const Color _olive = Color(0xFF55682A);
  static const Color _cream = Color(0xFFF2EDE6);
  static const Color _card = Color(0xFFF0E6DC);
  static const Color _line = Color(0xFFD9D0C3);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      bottomNavigationBar: _bottomNav(context),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 430),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(14, 8, 14, 22),
              children: [
                _steps(),
                const SizedBox(height: 10),
                _searchBar(),
                const SizedBox(height: 14),
                _hero(),
                const SizedBox(height: 14),
                _sectionHeader('Order Review'),
                const SizedBox(height: 8),
                _orderItems(),
                const SizedBox(height: 14),
                _shippingInfo(),
                const SizedBox(height: 14),
                _paymentInfo(),
                const SizedBox(height: 14),
                _summary(),
                const SizedBox(height: 18),
                _doneButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _steps() {
    return Center(
      child: RichText(
        text: const TextSpan(
          style: TextStyle(color: _olive, fontSize: 13, fontFamily: 'serif'),
          children: [
            TextSpan(text: 'Cart — Shipping — Payment — '),
            TextSpan(
              text: 'Review',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                decoration: TextDecoration.underline,
                decorationThickness: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _searchBar() {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: _olive),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: const Row(
        children: [
          SizedBox(width: 8),
          Icon(Icons.search, size: 22, color: Colors.black),
          SizedBox(width: 7),
          Expanded(
            child: Text(
              'search for products...',
              style: TextStyle(
                color: _olive,
                fontSize: 14,
                fontFamily: 'serif',
              ),
            ),
          ),
          Icon(Icons.mic_none_rounded, color: Colors.black, size: 22),
          SizedBox(width: 10),
        ],
      ),
    );
  }

  Widget _hero() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(2),
      child: Stack(
        children: [
          SizedBox(
            height: 145,
            width: double.infinity,
            child: Image.asset(
              'assets/photo2.png',
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) {
                return Container(
                  color: const Color(0xFFD8CDBE),
                  child: const Icon(
                    Icons.landscape_outlined,
                    color: _olive,
                    size: 48,
                  ),
                );
              },
            ),
          ),
          Container(
            height: 145,
            color: Colors.black.withOpacity(0.16),
          ),
          const Positioned.fill(
            child: Center(
              child: Text(
                'Taste Authentic\nPalestinian Heritage',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 23,
                  height: 1.5,
                  fontFamily: 'serif',
                  shadows: [
                    Shadow(
                      color: Colors.black87,
                      blurRadius: 4,
                      offset: Offset(1, 2),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              color: _olive,
              fontSize: 20,
              fontFamily: 'serif',
              fontWeight: FontWeight.w600,
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
        const Icon(Icons.chevron_right_rounded, color: _olive, size: 28),
      ],
    );
  }

  Widget _orderItems() {
    return Column(
      children: orderItems.map((item) {
        final name = item['name']?.toString() ?? '';
        final subtitle = item['subtitle']?.toString() ?? '';
        final image = item['image']?.toString() ?? '';
        final quantity = item['quantity'] as int? ?? 1;
        final price = item['price'] as double? ?? 0.0;

        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(9),
          decoration: BoxDecoration(
            color: _card,
            borderRadius: BorderRadius.circular(9),
          ),
          child: Row(
            children: [
              Container(
                width: 54,
                height: 58,
                color: _cream,
                child: Image.asset(
                  image,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) {
                    return const Icon(
                      Icons.image_not_supported_outlined,
                      color: Colors.black38,
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name.toUpperCase(),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: _olive,
                        fontSize: 12,
                        fontFamily: 'serif',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: _olive,
                        fontSize: 10,
                        fontFamily: 'serif',
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Qty: $quantity',
                      style: const TextStyle(
                        color: _olive,
                        fontSize: 11,
                        fontFamily: 'serif',
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '${(price * quantity).toStringAsFixed(0)} NIS',
                style: const TextStyle(
                  color: _olive,
                  fontSize: 12,
                  fontFamily: 'serif',
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _shippingInfo() {
    return _infoCard(
      title: 'Shipping Address',
      lines: [
        profileData['name'] ?? '',
        profileData['email'] ?? '',
        profileData['phone'] ?? '',
        '${profileData['city'] ?? ''}, ${profileData['country'] ?? ''}',
        'Postal Code: ${profileData['postalCode'] ?? ''}',
      ],
    );
  }

  Widget _paymentInfo() {
    return _infoCard(
      title: 'Payment & Delivery',
      lines: [
        'Payment: $paymentMethod',
        'Delivery: $shippingTitle',
      ],
    );
  }

  Widget _infoCard({
    required String title,
    required List<String> lines,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(9),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: _olive,
              fontSize: 15,
              fontFamily: 'serif',
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 7),
          ...lines.map(
            (line) => Padding(
              padding: const EdgeInsets.only(bottom: 3),
              child: Text(
                line,
                style: const TextStyle(
                  color: _olive,
                  fontSize: 12,
                  fontFamily: 'serif',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _summary() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(9),
      ),
      child: Column(
        children: [
          _summaryRow('Subtotal', '${subtotal.toStringAsFixed(2)} NIS'),
          const SizedBox(height: 7),
          _summaryRow('Shipping', '${shippingFee.toStringAsFixed(0)} NIS'),
          const SizedBox(height: 7),
          _summaryRow('VAT', '${vat.toStringAsFixed(2)} NIS'),
          const Divider(height: 18, color: _line),
          _summaryRow('Total', '${total.toStringAsFixed(2)} NIS', large: true),
        ],
      ),
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
              fontSize: large ? 16 : 13,
              fontFamily: 'serif',
              fontWeight: large ? FontWeight.w700 : FontWeight.w400,
            ),
          ),
        ),
        Text(
          right,
          style: TextStyle(
            color: _olive,
            fontSize: large ? 16 : 13,
            fontFamily: 'serif',
            fontWeight: large ? FontWeight.w700 : FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _doneButton(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 190,
        height: 35,
        child: ElevatedButton(
          onPressed: () {
            Navigator.popUntil(context, (route) => route.isFirst);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: _olive,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text(
            'Finish',
            style: TextStyle(
              fontSize: 17,
              fontFamily: 'serif',
            ),
          ),
        ),
      ),
    );
  }

  Widget _bottomNav(BuildContext context) {
    return Container(
      height: 74,
      color: _cream,
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavIcon(icon: Icons.home_outlined, label: 'Home'),
          _NavIcon(icon: Icons.shopping_bag_outlined, label: 'Shop'),
          _NavIcon(icon: Icons.receipt_long_outlined, label: 'Recipes', circular: true),
          _NavIcon(icon: Icons.feedback_outlined, label: 'Feedback'),
          _NavIcon(icon: Icons.person_outline, label: 'Profile'),
        ],
      ),
    );
  }
}

class _NavIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool circular;

  const _NavIcon({
    required this.icon,
    required this.label,
    this.circular = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 58,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: circular ? 33 : 30,
            width: circular ? 33 : 30,
            decoration: circular
                ? BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.black, width: 1.4),
                  )
                : null,
            child: Icon(
              icon,
              size: circular ? 22 : 28,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}