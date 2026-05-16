import 'package:flutter/material.dart';

import '../../state/app_state.dart';
import '../../state/app_state_scope.dart';
import '../../widgets/store_dialog.dart';
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
  bool _billingSame = true;
  bool _showOrderSummary = false;
  bool _saveAddress = true;

  final _cardNumberController = TextEditingController();
  final _cardExpiryController = TextEditingController();
  final _cardSecurityController = TextEditingController();
  final _cardNameController = TextEditingController();
  final _discountController = TextEditingController();

  final List<Map<String, String>> _countries = const [
    {'name': 'Palestine', 'flag': '🇵🇸'},
    {'name': 'Germany', 'flag': '🇩🇪'},
    {'name': 'USA', 'flag': '🇺🇸'},
    {'name': 'UAE', 'flag': '🇦🇪'},
    {'name': 'KSA', 'flag': '🇸🇦'},
    {'name': 'Europe', 'flag': '🇪🇺'},
    {'name': 'UK', 'flag': '🇬🇧'},
    {'name': 'Canada', 'flag': '🇨🇦'},
    {'name': 'France', 'flag': '🇫🇷'},
    {'name': 'Malaysia', 'flag': '🇲🇾'},
    {'name': 'Chile', 'flag': '🇨🇱'},
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

    // Keep local country in sync with global store
    if (_profileData['country'] != state.currentStore) {
      _profileData['country'] = state.currentStore;
    }

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
                        _sectionTitle(
                          '1. ${state.t('personal_personal_details')}',
                        ),
                        const SizedBox(height: 10),
                        _addressBox(),
                        const SizedBox(height: 7),
                        _countryRow(state),
                        const SizedBox(height: 6),
                        _cityRow(),
                        const SizedBox(height: 6),
                        _postalRow(),
                        const SizedBox(height: 12),
                        _checkRow(
                          value: _saveAddress,
                          text: state.t(
                            'addr_save',
                          ), // I should add this key or use existing
                          onTap: () {
                            setState(() {
                              _saveAddress = !_saveAddress;
                            });
                          },
                        ),
                        const Divider(height: 26, color: _line),
                        _sectionTitle(
                          '2. ${state.t('checkout_delivery_method')}',
                        ),
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
                        const SizedBox(height: 18),
                        _buildOrderSummary(state),
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

  Widget _buildSteps(AppState state, {required String activeStep}) {
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
              _stepText(
                state.t('step_cart'),
                active: activeStep == 'step_cart',
                fontSize: fontSize,
              ),
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
        if (active) Container(height: 2, width: lineWidth, color: _olive),
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
          Shadow(color: Colors.black26, blurRadius: 3, offset: Offset(1, 1)),
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
                const Divider(height: 8, color: _line),
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
              child: Icon(Icons.edit_outlined, color: _olive, size: 19),
            ),
          ),
        ],
      ),
    );
  }

  Widget _countryRow(AppState state) {
    final country = state.currentStore;
    final flag = state.currentStoreFlag;

    return Container(
      height: 31,
      padding: const EdgeInsets.symmetric(horizontal: 11),
      decoration: _outlineBox(radius: 9),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '$flag  $country',
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
      decoration: _outlineBox(),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          _paymentLine(
            state: state,
            value: 'Credit Card',
            onTap: () => _showPaymentMethodsBottomSheet(state),
            trailing: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'VISA',
                  style: TextStyle(
                    color: _olive,
                    fontSize: 10,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(width: 8),
                Icon(Icons.credit_card, size: 20, color: _olive),
              ],
            ),
          ),
          const Divider(height: 1, color: _line),
          _paymentLine(state: state, value: 'Pay when deliver'),
          const Divider(height: 1, color: _line),
          _paymentLine(state: state, value: 'Card on delivery'),
        ],
      ),
    );
  }

  void _showPaymentMethodsBottomSheet(AppState state) {
    setState(() => _payment = 'Credit Card');
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              state.t('checkout_payment_methods'),
              style: const TextStyle(
                color: _olive,
                fontSize: 22,
                fontWeight: FontWeight.bold,
                fontFamily: 'serif',
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'pay no cards',
              style: TextStyle(color: Colors.black38, fontSize: 16),
            ),
            const SizedBox(height: 32),
            OutlinedButton(
              onPressed: () {
                Navigator.pop(context);
                _showAddCardDialog(state);
              },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: _olive),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
                minimumSize: const Size(double.infinity, 50),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.add, color: _olive),
                  const SizedBox(width: 8),
                  Text(
                    state.t('pay_add_new_method'),
                    style: const TextStyle(
                      color: _olive,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _showAddCardDialog(AppState state) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF0F0E8),
            borderRadius: BorderRadius.circular(24),
          ),
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    state.t('pay_add_new_method'),
                    style: const TextStyle(
                      color: _olive,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'serif',
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                _dialogLabel(state.t('pay_card_number')),
                const SizedBox(height: 8),
                _dialogField(hint: '', controller: _cardNumberController),
                const SizedBox(height: 16),
                _dialogLabel(state.t('pay_card_holder')),
                const SizedBox(height: 8),
                _dialogField(hint: '', controller: _cardNameController),
                const SizedBox(height: 16),
                _dialogLabel(state.t('Expiry_date')),
                const SizedBox(height: 8),
                _dialogField(hint: 'MM/YY', controller: _cardExpiryController),
                const SizedBox(height: 16),
                _dialogLabel('CVV'),
                const SizedBox(height: 8),
                _dialogField(
                  hint: 'Security Code',
                  controller: _cardSecurityController,
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        state.t('ui_cancel'),
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: () {
                        // Logic to save card would go here
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _olive,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(state.t('ui_add')),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _dialogLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: _olive,
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _dialogField({
    required String hint,
    required TextEditingController controller,
  }) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F0),
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: _olive),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.black26),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        ),
      ),
    );
  }

  Widget _buildOrderSummary(AppState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () => setState(() => _showOrderSummary = !_showOrderSummary),
          child: Row(
            children: [
              Icon(
                _showOrderSummary
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
                color: _olive,
              ),
              const SizedBox(width: 8),
              Text(
                state.t('checkout_order_summary'),
                style: const TextStyle(
                  color: _olive,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'serif',
                ),
              ),
              const Spacer(),
              if (!_showOrderSummary)
                Stack(
                  alignment: Alignment.center,
                  children: [
                    const Icon(
                      Icons.shopping_cart_outlined,
                      color: _olive,
                      size: 28,
                    ),
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.black,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '${widget.orderItems.length}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
        if (_showOrderSummary) ...[
          const SizedBox(height: 16),
          ...widget.orderItems.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Stack(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.black12),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            item['image'] ?? '',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        right: -2,
                        top: -2,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: Colors.black87,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '${item['quantity']}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['name'] ?? '',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        Text(
                          item['subtitle'] ?? '',
                          style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    state.getFormattedPrice(
                      (item['price'] as num).toDouble() *
                          (item['quantity'] as int),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7F7F7),
                    border: Border.all(color: Colors.black12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextField(
                    controller: _discountController,
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                    decoration: InputDecoration(
                      hintText: state.t('checkout_discount_code'),
                      hintStyle: const TextStyle(
                        color: Colors.black38,
                        fontSize: 14,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF5F5F5),
                    foregroundColor: Colors.black54,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: const BorderSide(color: Colors.black12),
                    ),
                  ),
                  child: Text(
                    state.t('checkout_apply'),
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _summaryRow(state.t('checkout_subtotal'), widget.subtotal, state),
          _summaryRow(state.t('checkout_shipping'), widget.shippingFee, state),
          const SizedBox(height: 8),
        ],
      ],
    );
  }

  Widget _summaryRow(String label, double amount, AppState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.black87)),
          Text(
            state.getFormattedPrice(amount),
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
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
        if (state.currentUser?.isTrader ?? false) {
          // logic here
        }
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
            if (trailing != null) ...[trailing],
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
          Icon(Icons.lock_outline, color: _olive, size: 14),
          SizedBox(width: 4),
          Text(
            'Same as shipping',
            style: TextStyle(color: _olive, fontSize: 10, fontFamily: 'serif'),
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
              style: const TextStyle(fontSize: 18, fontFamily: 'serif'),
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

    String selectedCountry =
        _countries.any(
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
          builder: (dialogContext, setDialogState) {
            final state = AppStateScope.of(context);
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

                              // Sync global store with the selected country in dialog
                              state.setCurrentStore(selectedCountry);
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
        icon: const Icon(Icons.keyboard_arrow_down_rounded, color: _olive),
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
            borderSide: const BorderSide(color: _border, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: _border, width: 1.2),
          ),
        ),
        items: _countries.map((country) {
          return DropdownMenuItem<String>(
            value: country['name'],
            child: Row(
              children: [
                Text(country['flag']!, style: const TextStyle(fontSize: 18)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    country['name']!,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: _olive, fontSize: 15),
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
        style: const TextStyle(color: _olive, fontSize: 15),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: _olive, fontSize: 15),
          filled: true,
          fillColor: _background,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: _border, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: _border, width: 1.2),
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
}
