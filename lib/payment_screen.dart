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
  static const Color _cream = Color(0xFFF2EDE6);
  static const Color _olive = Color(0xFF55682A);
  static const Color _border = Color(0xFF6B7A35);
  static const Color _line = Color(0xFFE3DACE);

  late Map<String, String> _profileData;

  String _payment = 'Pay when deliver';
  bool _saveAddress = true;
  bool _billingSame = true;

  final List<Map<String, String>> _countries = const [
    {'name': 'Palestine', 'flag': '🇵🇸'},
    {'name': 'Germany', 'flag': '🇩🇪'},
    {'name': 'United States', 'flag': '🇺🇸'},
    {'name': 'United Arab Emirates', 'flag': '🇦🇪'},
    {'name': 'Saudi Arabia', 'flag': '🇸🇦'},
    {'name': 'European Union', 'flag': '🇪🇺'},
  ];

  double get _vat => widget.subtotal * 0.0135;
  double get _total => widget.subtotal + widget.shippingFee + _vat;

  bool get _isStandard => widget.shippingTitle == 'Standard International';

  bool get _isExpress =>
      widget.shippingTitle == 'Express' ||
      widget.shippingTitle == 'Express International';

  @override
  void initState() {
    super.initState();

    _profileData = {
      'name': widget.profileData['name'] ?? 'Mohammed',
      'email': widget.profileData['email'] ?? 'Mohammed@gmail.com',
      'phone': widget.profileData['phone'] ?? '+970 593245879',
      'country': widget.profileData['country'] ?? 'Palestine',
      'city': widget.profileData['city'] ?? 'Nablus',
      'postalCode': widget.profileData['postalCode'] ?? '10115',
      'address': widget.profileData['address'] ?? '',
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final screenWidth = constraints.maxWidth;
            final horizontalPadding = screenWidth < 360 ? 18.0 : 22.0;

            return Column(
              children: [
                _buildTopBar(context),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(
                      horizontalPadding,
                      8,
                      horizontalPadding,
                      24,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSteps(activeStep: 'Payment'),
                        const SizedBox(height: 18),
                        _sectionTitle('1. Shipping Address'),
                        const SizedBox(height: 10),
                        _addressBox(),
                        const SizedBox(height: 7),
                        _countryRow(),
                        const SizedBox(height: 6),
                        _cityRow(),
                        const SizedBox(height: 6),
                        _postalRow(),
                        const SizedBox(height: 12),
                        _checkRow(
                          value: _saveAddress,
                          text: 'Save this address',
                          onTap: () {
                            setState(() {
                              _saveAddress = !_saveAddress;
                            });
                          },
                        ),
                        const Divider(height: 26, color: _line),
                        _sectionTitle('2. Delivery Method'),
                        const SizedBox(height: 10),
                        _deliveryReadOnlyBox(),
                        const SizedBox(height: 16),
                        _sectionTitle('3. Payment Method'),
                        const SizedBox(height: 10),
                        _paymentBox(),
                        const Divider(height: 26, color: _line),
                        _checkRow(
                          value: _billingSame,
                          text: 'Billing Address',
                          onTap: () {
                            setState(() {
                              _billingSame = !_billingSame;
                            });
                          },
                        ),
                        const SizedBox(height: 5),
                        _sameAsShippingBadge(),
                        const SizedBox(height: 24),
                        _totalRow(),
                        const SizedBox(height: 26),
                        _placeOrderButton(context, screenWidth),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final barHeight = (width * 0.23).clamp(76.0, 100.0);
        final logoHeight = (width * 0.16).clamp(50.0, 72.0);
        final iconSize = (width * 0.085).clamp(28.0, 36.0);
        final buttonSize = (width * 0.12).clamp(40.0, 48.0);

        return Container(
          height: barHeight,
          width: double.infinity,
          color: _cream,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Center(
                child: Image.asset(
                  'assets/alard_icon.png',
                  height: logoHeight,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) {
                    return const Text(
                      "AL'ARD",
                      style: TextStyle(
                        color: _olive,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },
                ),
              ),
              Positioned(
                left: 8,
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints.tightFor(
                    width: buttonSize,
                    height: buttonSize,
                  ),
                  icon: Icon(
                    Icons.arrow_back_rounded,
                    color: Colors.black,
                    size: iconSize,
                  ),
                ),
              ),
              Positioned(
                right: 8,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {},
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints.tightFor(
                        width: buttonSize,
                        height: buttonSize,
                      ),
                      icon: Icon(
                        Icons.search_rounded,
                        color: Colors.black,
                        size: iconSize,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.popUntil(context, (route) => route.isFirst);
                      },
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints.tightFor(
                        width: buttonSize,
                        height: buttonSize,
                      ),
                      icon: Icon(
                        Icons.shopping_cart_outlined,
                        color: Colors.black,
                        size: iconSize - 2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSteps({
    required String activeStep,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final fontSize = (width * 0.034).clamp(12.0, 14.0);

        return Center(
          child: Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 4,
            children: [
              _stepText('Cart', active: activeStep == 'Cart', fontSize: fontSize),
              _stepDivider(fontSize),
              _stepText(
                'Shipping',
                active: activeStep == 'Shipping',
                fontSize: fontSize,
              ),
              _stepDivider(fontSize),
              _stepText(
                'Payment',
                active: activeStep == 'Payment',
                fontSize: fontSize,
              ),
              _stepDivider(fontSize),
              _stepText(
                'Review',
                active: activeStep == 'Review',
                fontSize: fontSize,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _stepText(
    String text, {
    required bool active,
    required double fontSize,
  }) {
    double lineWidth = 34;

    if (text == 'Shipping') lineWidth = 52;
    if (text == 'Payment') lineWidth = 50;
    if (text == 'Review') lineWidth = 42;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: _olive,
            fontSize: fontSize,
            fontFamily: 'serif',
            fontWeight: active ? FontWeight.w700 : FontWeight.w400,
          ),
        ),
        const SizedBox(height: 2),
        Container(
          height: 2,
          width: active ? lineWidth : 0,
          color: active ? _olive : Colors.transparent,
        ),
      ],
    );
  }

  Widget _stepDivider(double fontSize) {
    return Text(
      '—',
      textAlign: TextAlign.center,
      style: TextStyle(
        color: _olive,
        fontSize: fontSize + 2,
        fontFamily: 'serif',
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

  Widget _addressBox() {
    final name = _profileData['name'] ?? 'Mohammed';
    final email = _profileData['email'] ?? 'Mohammed@gmail.com';
    final phone = _profileData['phone'] ?? '+970 593245879';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 11, 12, 10),
      decoration: _outlineBox(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: _olive,
                    fontSize: 14,
                    fontFamily: 'serif',
                  ),
                ),
                Text(
                  email,
                  style: const TextStyle(
                    color: _olive,
                    fontSize: 13,
                    fontFamily: 'serif',
                  ),
                ),
                const Divider(
                  height: 8,
                  color: _line,
                ),
                Text(
                  phone,
                  style: const TextStyle(
                    color: _olive,
                    fontSize: 15,
                    fontFamily: 'serif',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          InkWell(
            onTap: _showEditAddressDialog,
            borderRadius: BorderRadius.circular(20),
            child: const Padding(
              padding: EdgeInsets.all(6),
              child: Icon(
                Icons.edit_outlined,
                color: _olive,
                size: 19,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _countryRow() {
    final country = _profileData['country'] ?? 'Palestine';

    return Container(
      height: 31,
      padding: const EdgeInsets.symmetric(horizontal: 11),
      decoration: _outlineBox(radius: 9),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '${_countryFlag(country)}  $country',
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: _olive,
                fontSize: 14,
                fontFamily: 'serif',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _cityRow() {
    final city = _profileData['city'] ?? 'Nablus';

    return Container(
      height: 31,
      padding: const EdgeInsets.symmetric(horizontal: 11),
      decoration: _outlineBox(radius: 9),
      alignment: Alignment.centerLeft,
      child: Text(
        city,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          color: _olive,
          fontSize: 14,
          fontFamily: 'serif',
        ),
      ),
    );
  }

  Widget _postalRow() {
    final postalCode = _profileData['postalCode'] ?? '10115';

    return Container(
      height: 31,
      padding: const EdgeInsets.symmetric(horizontal: 11),
      decoration: _outlineBox(radius: 9),
      child: Row(
        children: [
          Text(
            postalCode,
            style: const TextStyle(
              color: _olive,
              fontSize: 14,
              fontFamily: 'serif',
            ),
          ),
          const Spacer(),
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
              style: TextStyle(
                color: _olive,
                fontSize: 11,
                fontFamily: 'serif',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _checkRow({
    required bool value,
    required String text,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Icon(
            value ? Icons.check_box : Icons.check_box_outline_blank,
            color: _olive,
            size: 18,
          ),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(
              color: _olive,
              fontSize: 14,
              fontFamily: 'serif',
            ),
          ),
        ],
      ),
    );
  }

  Widget _deliveryReadOnlyBox() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5),
      decoration: _outlineBox(),
      child: Column(
        children: [
          _deliveryReadOnlyLine(
            title: 'Express International',
            price: 100,
            selected: _isExpress,
          ),
          const Padding(
            padding: EdgeInsets.only(left: 34, right: 16),
            child: Divider(height: 1, color: _line),
          ),
          _deliveryReadOnlyLine(
            title: 'Standard International',
            price: 50,
            selected: _isStandard,
          ),
        ],
      ),
    );
  }

  Widget _deliveryReadOnlyLine({
    required String title,
    required double price,
    required bool selected,
  }) {
    return SizedBox(
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
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: _olive,
                fontSize: 15,
                fontFamily: 'serif',
              ),
            ),
          ),
          Text(
            '${price.toStringAsFixed(0)} NIS',
            style: const TextStyle(
              color: _olive,
              fontSize: 13,
              fontFamily: 'serif',
            ),
          ),
          const SizedBox(width: 18),
        ],
      ),
    );
  }

  Widget _paymentBox() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6),
      decoration: _outlineBox(),
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
            Expanded(
              child: Text(
                value,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: _olive,
                  fontSize: 15,
                  fontFamily: 'serif',
                ),
              ),
            ),
            if (trailing != null) trailing,
            const SizedBox(width: 18),
          ],
        ),
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

  Widget _totalRow() {
    return Row(
      children: [
        const Text(
          'Total:',
          style: TextStyle(
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
        ),
        const Spacer(),
        Flexible(
          child: Text(
            '${_total.toStringAsFixed(2)} NIS',
            textAlign: TextAlign.right,
            overflow: TextOverflow.ellipsis,
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
          ),
        ),
      ],
    );
  }

  Widget _placeOrderButton(BuildContext context, double screenWidth) {
    final width = screenWidth < 360 ? screenWidth * 0.58 : 198.0;

    return Center(
      child: SizedBox(
        width: width,
        height: 35,
        child: ElevatedButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Order placed successfully'),
                duration: Duration(milliseconds: 900),
              ),
            );

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => ReviewScreen(
                  orderItems: widget.orderItems,
                  profileData: _profileData,
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
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              'Place Order',
              style: TextStyle(
                fontSize: 18,
                fontFamily: 'serif',
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showEditAddressDialog() {
    final fullName = _profileData['name'] ?? '';
    final nameParts = fullName.trim().split(RegExp(r'\s+'));

    final firstNameController = TextEditingController(
      text: nameParts.isNotEmpty ? nameParts.first : '',
    );
    final lastNameController = TextEditingController(
      text: nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '',
    );
    final addressController = TextEditingController(
      text: _profileData['address'] ?? '',
    );
    final cityController = TextEditingController(
      text: _profileData['city'] ?? '',
    );
    final postalController = TextEditingController(
      text: _profileData['postalCode'] ?? '',
    );

    String selectedCountry = _countries.any(
      (country) => country['name'] == (_profileData['country'] ?? ''),
    )
        ? (_profileData['country'] ?? 'Palestine')
        : 'Palestine';

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) {
        final screenWidth = MediaQuery.of(dialogContext).size.width;
        final dialogWidth = screenWidth < 700 ? screenWidth * 0.92 : 620.0;

        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 24,
              ),
              child: Container(
                width: dialogWidth,
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 14),
                decoration: BoxDecoration(
                  color: _cream,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          const Expanded(
                            child: Text(
                              'Edit Shipping Address',
                              style: TextStyle(
                                color: _olive,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pop(dialogContext);
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(4),
                              child: Icon(
                                Icons.close,
                                color: Colors.black,
                                size: 24,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _countryDropdownField(
                        value: selectedCountry,
                        onChanged: (value) {
                          setDialogState(() {
                            selectedCountry = value;
                          });
                        },
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _addressFormField(
                              controller: firstNameController,
                              hint: 'First Name',
                              centerText: true,
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: _addressFormField(
                              controller: lastNameController,
                              hint: 'Last Name',
                              centerText: true,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _addressFormField(
                        controller: addressController,
                        hint: 'Address',
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _addressFormField(
                              controller: cityController,
                              hint: 'City',
                              centerText: true,
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: _addressFormField(
                              controller: postalController,
                              hint: 'Postal Code',
                              centerText: true,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      SizedBox(
                        width: 180,
                        height: 34,
                        child: ElevatedButton(
                          onPressed: () {
                            final firstName = firstNameController.text.trim();
                            final lastName = lastNameController.text.trim();

                            setState(() {
                              _profileData = {
                                ..._profileData,
                                'name': [firstName, lastName]
                                    .where((part) => part.isNotEmpty)
                                    .join(' ')
                                    .trim(),
                                'country': selectedCountry,
                                'address': addressController.text.trim(),
                                'city': cityController.text.trim(),
                                'postalCode': postalController.text.trim(),
                              };

                              if ((_profileData['name'] ?? '').isEmpty) {
                                _profileData['name'] = 'Mohammed';
                              }

                              if ((_profileData['city'] ?? '').isEmpty) {
                                _profileData['city'] = 'Nablus';
                              }

                              if ((_profileData['postalCode'] ?? '').isEmpty) {
                                _profileData['postalCode'] = '10115';
                              }
                            });

                            Navigator.pop(dialogContext);
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
                            'Save Address',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _countryDropdownField({
    required String value,
    required ValueChanged<String> onChanged,
  }) {
    return SizedBox(
      height: 48,
      child: DropdownButtonFormField<String>(
        value: value,
        isExpanded: true,
        icon: const Icon(
          Icons.keyboard_arrow_down_rounded,
          color: _olive,
        ),
        dropdownColor: _cream,
        decoration: InputDecoration(
          filled: true,
          fillColor: _background,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: _border,
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: _border,
              width: 1.2,
            ),
          ),
        ),
        items: _countries.map((country) {
          return DropdownMenuItem<String>(
            value: country['name'],
            child: Row(
              children: [
                Text(
                  country['flag']!,
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    country['name']!,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: _olive,
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
        onChanged: (value) {
          if (value == null) return;
          onChanged(value);
        },
      ),
    );
  }

  Widget _addressFormField({
    required TextEditingController controller,
    required String hint,
    bool centerText = false,
  }) {
    return SizedBox(
      height: 48,
      child: TextField(
        controller: controller,
        textAlign: centerText ? TextAlign.center : TextAlign.start,
        style: const TextStyle(
          color: _olive,
          fontSize: 15,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(
            color: _olive,
            fontSize: 15,
          ),
          filled: true,
          fillColor: _background,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: _border,
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: _border,
              width: 1.2,
            ),
          ),
        ),
      ),
    );
  }

  BoxDecoration _outlineBox({double radius = 9}) {
    return BoxDecoration(
      border: Border.all(color: _border),
      borderRadius: BorderRadius.circular(radius),
    );
  }

  String _countryFlag(String country) {
    final lower = country.toLowerCase();

    if (lower.contains('palestine')) return '🇵🇸';
    if (lower.contains('germany')) return '🇩🇪';
    if (lower.contains('usa') || lower.contains('united states')) return '🇺🇸';
    if (lower.contains('uae') || lower.contains('emirates')) return '🇦🇪';
    if (lower.contains('ksa') || lower.contains('saudi')) return '🇸🇦';
    if (lower.contains('europe') || lower.contains('european')) return '🇪🇺';

    return '🌍';
  }
}