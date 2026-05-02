import 'package:flutter/material.dart';

import 'review_screen.dart';

class PaymentScreen extends StatefulWidget {
  final List<Map<String, dynamic>> orderItems;
  final Map<String, String> profileData;
  final double subtotal;
  final double shippingFee;
  final String shippingTitle;

  const PaymentScreen({
    super.key,
    required this.orderItems,
    required this.profileData,
    required this.subtotal,
    required this.shippingFee,
    required this.shippingTitle,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  static const Color _background = Color(0xFFF7F3EE);
  static const Color _olive = Color(0xFF55682A);
  static const Color _border = Color(0xFF6B7A35);
  static const Color _line = Color(0xFFD9D0C3);

  String _payment = 'Pay when deliver';
  bool _billingSame = true;

  double get _vat => widget.subtotal * 0.0135;
  double get _total => widget.subtotal + widget.shippingFee + _vat;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 430),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(22, 8, 22, 24),
              children: [
                _steps(),
                const SizedBox(height: 18),
                _sectionTitle('3. Payment Method'),
                const SizedBox(height: 10),
                _paymentBox(),
                const Divider(height: 30, color: _line),
                _billingRow(),
                const SizedBox(height: 5),
                _sameAsShippingBadge(),
                const SizedBox(height: 26),
                _summary(),
                const SizedBox(height: 28),
                _placeOrderButton(),
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
            TextSpan(text: 'Cart — Shipping — '),
            TextSpan(
              text: 'Payment',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                decoration: TextDecoration.underline,
                decorationThickness: 2,
              ),
            ),
            TextSpan(text: ' — Review'),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: _olive,
        fontSize: 20,
        fontFamily: 'serif',
        shadows: [
          Shadow(
            color: Colors.black26,
            blurRadius: 3,
            offset: Offset(1, 1),
          ),
        ],
      ),
    );
  }

  Widget _paymentBox() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        border: Border.all(color: _border),
        borderRadius: BorderRadius.circular(9),
      ),
      child: Column(
        children: [
          _paymentLine(
            value: 'Credit Card',
            trailing: const Text(
              'VISA',
              style: TextStyle(
                color: _olive,
                fontSize: 13,
                fontWeight: FontWeight.w900,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 34, right: 16),
            child: Divider(height: 1, color: _line),
          ),
          _paymentLine(value: 'Pay when deliver'),
          const Padding(
            padding: EdgeInsets.only(left: 34, right: 16),
            child: Divider(height: 1, color: _line),
          ),
          _paymentLine(value: 'Card on delivery'),
        ],
      ),
    );
  }

  Widget _paymentLine({
    required String value,
    Widget? trailing,
  }) {
    final selected = _payment == value;

    return InkWell(
      onTap: () {
        setState(() {
          _payment = value;
        });
      },
      child: SizedBox(
        height: 31,
        child: Row(
          children: [
            const SizedBox(width: 18),
            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: _olive,
              size: 18,
            ),
            const SizedBox(width: 14),
            Text(
              value,
              style: const TextStyle(
                color: _olive,
                fontSize: 15,
                fontFamily: 'serif',
              ),
            ),
            const Spacer(),
            if (trailing != null) trailing,
            const SizedBox(width: 18),
          ],
        ),
      ),
    );
  }

  Widget _billingRow() {
    return InkWell(
      onTap: () {
        setState(() {
          _billingSame = !_billingSame;
        });
      },
      child: Row(
        children: [
          Icon(
            _billingSame ? Icons.check_box : Icons.check_box_outline_blank,
            color: _olive,
            size: 18,
          ),
          const SizedBox(width: 6),
          const Text(
            'Billing Address',
            style: TextStyle(
              color: _olive,
              fontSize: 14,
              fontFamily: 'serif',
            ),
          ),
        ],
      ),
    );
  }

  Widget _sameAsShippingBadge() {
    return Container(
      margin: const EdgeInsets.only(left: 28),
      height: 22,
      padding: const EdgeInsets.symmetric(horizontal: 9),
      decoration: BoxDecoration(
        border: Border.all(color: _border),
        borderRadius: BorderRadius.circular(11),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.lock_outline,
            color: _olive,
            size: 14,
          ),
          SizedBox(width: 4),
          Text(
            'Same as shipping',
            style: TextStyle(
              color: _olive,
              fontSize: 10,
              fontFamily: 'serif',
            ),
          ),
        ],
      ),
    );
  }

  Widget _summary() {
    return Column(
      children: [
        _summaryRow('Subtotal', '${widget.subtotal.toStringAsFixed(2)} NIS'),
        const SizedBox(height: 8),
        _summaryRow(widget.shippingTitle, '${widget.shippingFee.toStringAsFixed(0)} NIS'),
        const SizedBox(height: 8),
        _summaryRow('VAT', '${_vat.toStringAsFixed(2)} NIS'),
        const Divider(height: 24, color: _line),
        Row(
          children: [
            const Text(
              'Total:',
              style: TextStyle(color: _olive, fontSize: 20, fontFamily: 'serif'),
            ),
            const Spacer(),
            Text(
              '${_total.toStringAsFixed(2)} NIS',
              style: const TextStyle(color: _olive, fontSize: 20, fontFamily: 'serif'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _summaryRow(String left, String right) {
    return Row(
      children: [
        Expanded(
          child: Text(
            left,
            style: const TextStyle(color: _olive, fontSize: 13, fontFamily: 'serif'),
          ),
        ),
        Text(
          right,
          style: const TextStyle(color: _olive, fontSize: 13, fontFamily: 'serif'),
        ),
      ],
    );
  }

  Widget _placeOrderButton() {
    return Center(
      child: SizedBox(
        width: 198,
        height: 35,
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => ReviewScreen(
                  orderItems: widget.orderItems,
                  profileData: widget.profileData,
                  subtotal: widget.subtotal,
                  shippingFee: widget.shippingFee,
                  shippingTitle: widget.shippingTitle,
                  vat: _vat,
                  total: _total,
                  paymentMethod: _payment,
                ),
              ),
            );
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
            'Place Order',
            style: TextStyle(
              fontSize: 18,
              fontFamily: 'serif',
            ),
          ),
        ),
      ),
    );
  }
}