import 'package:flutter/material.dart';

import '../../state/app_state.dart';
import '../../state/app_state_scope.dart';
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
  String? _selectedCardId;
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
    final state = AppStateScope.of(context);
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
                        _buildSteps(state, activeStep: 'step_payment'),
                        const SizedBox(height: 18),
                        _sectionTitle('1. ${state.t('personal_personal_details')}'),
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
                          text: state.t('addr_save'), // I should add this key or use existing
                          onTap: () {
                            setState(() {
                              _saveAddress = !_saveAddress;
                            });
                          },
                        ),
                        const Divider(height: 26, color: _line),
                        _sectionTitle('2. ${state.t('checkout_delivery_method')}'),
                        const SizedBox(height: 10),
                        _deliveryReadOnlyBox(state),
                        const SizedBox(height: 16),
                        _sectionTitle('3. ${state.t('checkout_payment')}'),
                        const SizedBox(height: 10),
                        _paymentBox(state),
                        const Divider(height: 26, color: _line),
                        _checkRow(
                          value: _billingSame,
                          text: state.t('checkout_billing_address'),
                          onTap: () {
                            setState(() {
                              _billingSame = !_billingSame;
                            });
                          },
                        ),
                        const SizedBox(height: 5),
                        _sameAsShippingBadge(),
                        const SizedBox(height: 24),
                        _totalRow(state),
                        const SizedBox(height: 26),
                        _placeOrderButton(context, state, screenWidth),
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
        final barHeight = (width * 0.16).clamp(56.0, 70.0);
        final buttonSize = (width * 0.11).clamp(38.0, 46.0);

        return Container(
          height: barHeight,
          width: double.infinity,
          color: _cream,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Center(
                child: Image.asset(
                  'assets/321.png',
                  height: 38,
                  fit: BoxFit.contain,
                  errorBuilder: (_, _, _) {
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
              PositionedDirectional(
                start: 8,
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints.tightFor(
                    width: buttonSize,
                    height: buttonSize,
                  ),
                  icon: const Icon(
                    Icons.arrow_back_rounded,
                    color: Colors.black,
                    size: 30,
                  ),
                ),
              ),
              PositionedDirectional(
                end: 8,
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
                      icon: const Icon(
                        Icons.search_rounded,
                        color: Colors.black,
                        size: 28,
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
                      icon: const Icon(
                        Icons.shopping_cart_outlined,
                        color: Colors.black,
                        size: 28,
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

  Widget _buildSteps(
    AppState state, {
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
              _stepText(state.t('step_cart'), active: activeStep == 'step_cart', fontSize: fontSize),
              _stepDivider(fontSize),
              _stepText(
                state.t('step_shipping'),
                active: activeStep == 'step_shipping',
                fontSize: fontSize,
              ),
              _stepDivider(fontSize),
              _stepText(
                state.t('step_payment'),
                active: activeStep == 'step_payment',
                fontSize: fontSize,
              ),
              _stepDivider(fontSize),
              _stepText(
                state.t('step_review'),
                active: activeStep == 'step_review',
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
        if (active)
          Container(
            height: 2,
            width: lineWidth,
            color: _olive,
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

  Widget _deliveryReadOnlyBox(AppState state) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5),
      decoration: _outlineBox(),
      child: Column(
        children: [
          _deliveryReadOnlyLine(
            title: 'Express International',
            price: 100,
            selected: _isExpress,
            state: state,
          ),
          const Padding(
            padding: EdgeInsets.only(left: 34, right: 16),
            child: Divider(height: 1, color: _line),
          ),
          _deliveryReadOnlyLine(
            title: 'Standard International',
            price: 50,
            selected: _isStandard,
            state: state,
          ),
        ],
      ),
    );
  }

  Widget _deliveryReadOnlyLine({
    required String title,
    required double price,
    required bool selected,
    required AppState state,
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
            state.getFormattedPrice(price),
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

  Widget _paymentBox(AppState state) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6),
      decoration: _outlineBox(),
      child: Column(
        children: [
          _paymentLine(
            state: state,
            value: 'Credit Card',
            onTap: () => _showCardSelection(state),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_payment == 'Credit Card' && _selectedCardId != null)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Text(
                      '**** ${state.savedCards.firstWhere((c) => c.id == _selectedCardId).cardNumber?.substring((state.savedCards.firstWhere((c) => c.id == _selectedCardId).cardNumber?.length ?? 4) - 4) ?? "Card"}',
                      style: const TextStyle(
                        color: _olive,
                        fontSize: 12,
                        fontFamily: 'serif',
                      ),
                    ),
                  ),
                const Text(
                  'VISA',
                  style: TextStyle(
                    color: _olive,
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 34, right: 16),
            child: Divider(height: 1, color: _line),
          ),
          _paymentLine(state: state, value: 'Pay when deliver'),
          const Padding(
            padding: EdgeInsets.only(left: 34, right: 16),
            child: Divider(height: 1, color: _line),
          ),
          _paymentLine(state: state, value: 'Card on delivery'),
        ],
      ),
    );
  }

  Widget _paymentLine({
    required AppState state,
    required String value,
    VoidCallback? onTap,
    Widget? trailing,
  }) {
    final selected = _payment == value;

    return InkWell(
      onTap: () {
        setState(() {
          _payment = value;
        });
        if (onTap != null && value == 'Credit Card') {
          onTap();
        }
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
            ?trailing,
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

  Widget _totalRow(AppState state) {
    return Row(
      children: [
        Text(
          '${state.t('checkout_total')}:',
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
        const Spacer(),
        Flexible(
          child: Text(
            state.getFormattedPrice(_total),
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

  Widget _placeOrderButton(
    BuildContext context,
    AppState state,
    double screenWidth,
  ) {
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
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              state.t('checkout_place_order'),
              style: const TextStyle(
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
        initialValue: value,
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
  void _showCardSelection(AppState state) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              state.t('profile_payment_methods'),
              style: const TextStyle(
                color: _olive,
                fontSize: 18,
                fontFamily: 'serif',
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            if (state.savedCards.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Center(
                  child: Text(
                    state.t('pay_no_cards'),
                    style: const TextStyle(color: Colors.black45),
                  ),
                ),
              )
            else
              ...state.savedCards.map((card) => _buildCardOption(card)),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  _showAddCardDialog(state);
                },
                icon: const Icon(Icons.add, size: 18),
                label: Text(state.t('pay_add_new')),
                style: OutlinedButton.styleFrom(
                  foregroundColor: _olive,
                  side: const BorderSide(color: _olive),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardOption(PaymentMethod card) {
    final isSelected = _selectedCardId == card.id;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedCardId = card.id;
          _payment = 'Credit Card';
        });
        Navigator.pop(context);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? _olive : _line,
            width: isSelected ? 1.5 : 1,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: isSelected ? _olive : Colors.black26,
              size: 20,
            ),
            const SizedBox(width: 12),
            const Icon(Icons.credit_card, color: _olive),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Visa **** ${card.cardNumber?.substring((card.cardNumber?.length ?? 4) - 4) ?? ""}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    '${AppStateScope.of(context).t('pay_expires')} ${card.expiryMonth}/${card.expiryYear}',
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddCardDialog(AppState state) {
    final numberController = TextEditingController();
    final nameController = TextEditingController();
    final expiryController = TextEditingController();
    final cvvController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          state.t('pay_add_new'),
          style: const TextStyle(color: _olive, fontFamily: 'serif'),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDialogField(
                state.t('pay_card_number'),
                numberController,
                TextInputType.number,
              ),
              const SizedBox(height: 12),
              _buildDialogField(
                state.t('pay_card_holder'),
                nameController,
                TextInputType.name,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildDialogField(
                      state.t('pay_expiry'),
                      expiryController,
                      TextInputType.datetime,
                      hint: 'MM/YY',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildDialogField(
                      state.t('pay_cvv'),
                      cvvController,
                      TextInputType.number,
                      hint: '123',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(state.t('ui_cancel'), style: const TextStyle(color: Colors.black54)),
          ),
          ElevatedButton(
            onPressed: () {
              if (numberController.text.isNotEmpty) {
                final expiryParts = expiryController.text.split('/');
                final month = expiryParts.isNotEmpty ? expiryParts[0] : '12';
                final year = expiryParts.length > 1 ? expiryParts[1] : '26';

                final newCard = PaymentMethod(
                  id: 'card_${DateTime.now().millisecondsSinceEpoch}',
                  title: 'Visa',
                  subtitle: '**** ${numberController.text.substring(numberController.text.length.clamp(0, 4))}',
                  cardNumber: numberController.text,
                  cardHolderName: nameController.text,
                  expiryMonth: month,
                  expiryYear: year,
                  cvv: cvvController.text,
                );

                state.addPaymentMethod(newCard);
                setState(() {
                  _selectedCardId = newCard.id;
                  _payment = 'Credit Card';
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Card added successfully')),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _olive,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: Text(state.t('ui_add')),
          ),
        ],
      ),
    );
  }

  Widget _buildDialogField(
    String label,
    TextEditingController controller,
    TextInputType type, {
    String? hint,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: _olive),
        ),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          keyboardType: type,
          decoration: InputDecoration(
            hintText: hint,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: _olive),
            ),
          ),
        ),
      ],
    );
  }
}
