import 'package:flutter/material.dart';

import 'payment_screen.dart';

class ShippingScreen extends StatefulWidget {
  final List<Map<String, dynamic>> orderItems;
  final Map<String, String> profileData;
  final double subtotal;

  const ShippingScreen({
    super.key,
    required this.orderItems,
    required this.profileData,
    required this.subtotal,
  });

  @override
  State<ShippingScreen> createState() => _ShippingScreenState();
}

class _ShippingScreenState extends State<ShippingScreen> {
  static const Color _background = Color(0xFFF7F3EE);
  static const Color _olive = Color(0xFF55682A);
  static const Color _border = Color(0xFF6B7A35);
  static const Color _line = Color(0xFFD9D0C3);

  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _countryController;
  late TextEditingController _cityController;
  late TextEditingController _postalController;

  String _deliveryTitle = 'Express International';
  double _shippingFee = 100;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(text: widget.profileData['name'] ?? 'Mohammed');
    _emailController = TextEditingController(text: widget.profileData['email'] ?? 'Mohammed@gmail.com');
    _phoneController = TextEditingController(text: widget.profileData['phone'] ?? '+970 593245879');
    _countryController = TextEditingController(text: widget.profileData['country'] ?? 'Palestine');
    _cityController = TextEditingController(text: widget.profileData['city'] ?? 'Nablus');
    _postalController = TextEditingController(text: widget.profileData['postalCode'] ?? '10115');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _countryController.dispose();
    _cityController.dispose();
    _postalController.dispose();
    super.dispose();
  }

  double get _vat => widget.subtotal * 0.0135;
  double get _total => widget.subtotal + _shippingFee + _vat;

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
                _sectionTitle('1. Shipping Address'),
                const SizedBox(height: 10),
                _addressCard(),
                const SizedBox(height: 8),
                _singleField(_countryController, suffix: Icons.chevron_right_rounded),
                const SizedBox(height: 8),
                _singleField(_cityController, suffix: Icons.chevron_right_rounded),
                const SizedBox(height: 8),
                _postalField(),
                const SizedBox(height: 12),
                const Row(
                  children: [
                    Icon(Icons.check_box, color: _olive, size: 18),
                    SizedBox(width: 6),
                    Text(
                      'Save this address',
                      style: TextStyle(color: _olive, fontSize: 14, fontFamily: 'serif'),
                    ),
                  ],
                ),
                const Divider(height: 30, color: _line),
                _sectionTitle('2. Delivery Method'),
                const SizedBox(height: 10),
                _deliveryBox(),
                const SizedBox(height: 28),
                _totalRow(),
                const SizedBox(height: 26),
                _continueButton(),
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
            TextSpan(text: 'Cart — '),
            TextSpan(
              text: 'Shipping',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                decoration: TextDecoration.underline,
                decorationThickness: 2,
              ),
            ),
            TextSpan(text: ' — Payment — Review'),
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

  Widget _addressCard() {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 11, 18, 10),
      decoration: _boxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _simpleTextField(_nameController),
          _simpleTextField(_emailController),
          const Divider(height: 8, color: _line),
          _simpleTextField(_phoneController),
        ],
      ),
    );
  }

  Widget _simpleTextField(TextEditingController controller) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: _olive, fontSize: 14, fontFamily: 'serif'),
      decoration: const InputDecoration(
        isDense: true,
        border: InputBorder.none,
        contentPadding: EdgeInsets.zero,
      ),
    );
  }

  Widget _singleField(TextEditingController controller, {IconData? suffix}) {
    return Container(
      height: 31,
      padding: const EdgeInsets.symmetric(horizontal: 11),
      decoration: _boxDecoration(radius: 9),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              style: const TextStyle(color: _olive, fontSize: 14, fontFamily: 'serif'),
              decoration: const InputDecoration(
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.only(bottom: 2),
              ),
            ),
          ),
          if (suffix != null)
            Icon(
              suffix,
              color: _olive,
              size: 26,
            ),
        ],
      ),
    );
  }

  Widget _postalField() {
    return Container(
      height: 31,
      padding: const EdgeInsets.symmetric(horizontal: 11),
      decoration: _boxDecoration(radius: 9),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _postalController,
              style: const TextStyle(color: _olive, fontSize: 14, fontFamily: 'serif'),
              decoration: const InputDecoration(
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.only(bottom: 2),
              ),
            ),
          ),
          Container(
            height: 21,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              border: Border.all(color: _border),
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: const Text(
              'Postal Code',
              style: TextStyle(color: _olive, fontSize: 11, fontFamily: 'serif'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _deliveryBox() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5),
      decoration: _boxDecoration(radius: 9),
      child: Column(
        children: [
          _deliveryLine(
            title: 'Express International',
            price: 100,
          ),
          const Padding(
            padding: EdgeInsets.only(left: 34, right: 16),
            child: Divider(height: 1, color: _line),
          ),
          _deliveryLine(
            title: 'Standard International',
            price: 50,
          ),
        ],
      ),
    );
  }

  Widget _deliveryLine({
    required String title,
    required double price,
  }) {
    final selected = _deliveryTitle == title;

    return InkWell(
      onTap: () {
        setState(() {
          _deliveryTitle = title;
          _shippingFee = price;
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
            Expanded(
              child: Text(
                title,
                style: const TextStyle(color: _olive, fontSize: 15, fontFamily: 'serif'),
              ),
            ),
            Text(
              '${price.toStringAsFixed(0)} NIS',
              style: const TextStyle(color: _olive, fontSize: 13, fontFamily: 'serif'),
            ),
            const SizedBox(width: 18),
          ],
        ),
      ),
    );
  }

  Widget _totalRow() {
    return Row(
      children: [
        const Text(
          'Total:',
          style: TextStyle(
            color: _olive,
            fontSize: 20,
            fontFamily: 'serif',
          ),
        ),
        const Spacer(),
        Text(
          '${_total.toStringAsFixed(2)} NIS',
          style: const TextStyle(
            color: _olive,
            fontSize: 20,
            fontFamily: 'serif',
          ),
        ),
      ],
    );
  }

  Widget _continueButton() {
    return Center(
      child: SizedBox(
        width: 200,
        height: 35,
        child: ElevatedButton(
          onPressed: () {
            final updatedProfile = {
              'name': _nameController.text,
              'email': _emailController.text,
              'phone': _phoneController.text,
              'country': _countryController.text,
              'city': _cityController.text,
              'postalCode': _postalController.text,
            };

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => PaymentScreen(
                  orderItems: widget.orderItems,
                  profileData: updatedProfile,
                  subtotal: widget.subtotal,
                  shippingFee: _shippingFee,
                  shippingTitle: _deliveryTitle,
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
            'Continue To Payment',
            style: TextStyle(fontSize: 15, fontFamily: 'serif'),
          ),
        ),
      ),
    );
  }

  BoxDecoration _boxDecoration({double radius = 9}) {
    return BoxDecoration(
      border: Border.all(color: _border),
      borderRadius: BorderRadius.circular(radius),
    );
  }
}