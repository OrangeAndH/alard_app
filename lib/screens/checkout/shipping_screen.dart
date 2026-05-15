import 'package:flutter/material.dart';

import '../../state/app_state.dart';
import '../../state/app_state_scope.dart';
import '../../widgets/store_dialog.dart';
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
  static const Color _cream = Color(0xFFF2EDE6);
  static const Color _olive = Color(0xFF55682A);
  static const Color _line = Color(0xFFE3DACE);
  static const Color _softButton = Color(0xFFF4ECD9);

  String _deliveryTitle = 'Standard International';
  double _shippingFee = 50;

  double get _vat => 2.54;
  double get _total => widget.subtotal + _shippingFee + _vat;

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    return Scaffold(
      backgroundColor: _background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final screenWidth = constraints.maxWidth;
            final horizontalPadding = screenWidth < 360 ? 10.0 : 14.0;

            return Column(
              children: [
                _buildTopBar(context),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(
                      horizontalPadding,
                      8,
                      horizontalPadding,
                      18,
                    ),
                    child: Column(
                      children: [
                        _buildSteps(state, activeStep: 'step_shipping'),
                        const SizedBox(height: 10),
                        _buildScreenTitle(state),
                        const SizedBox(height: 12),
                        ...widget.orderItems.map(
                          (item) => _buildReadOnlyItemCard(
                            item,
                            state,
                            screenWidth: screenWidth,
                          ),
                        ),
                        const SizedBox(height: 10),
                        _buildLocationRow(state),
                        const SizedBox(height: 8),
                        _buildDeliveryOptions(state),
                        const SizedBox(height: 18),
                        _buildOrderSummary(state),
                        const SizedBox(height: 16),
                        _buildTrustSection(state),
                        const SizedBox(height: 10),
                        _buildContinueButton(context, state, screenWidth),
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
                  icon: Icon(
                    Icons.adaptive.arrow_back,
                    color: Colors.black,
                    size: 30,
                  ),
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

        return Wrap(
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
      style: TextStyle(
        color: _olive,
        fontSize: fontSize + 2,
        fontFamily: 'serif',
      ),
    );
  }

  Widget _buildScreenTitle(AppState state) {
    return Center(
      child: Text(
        AppStateScope.of(context).t('checkout_shipping'),
        style: const TextStyle(
          color: _olive,
          fontSize: 20,
          fontFamily: 'serif',
          fontWeight: FontWeight.w500,
          shadows: [
            Shadow(
              color: Colors.black26,
              blurRadius: 2,
              offset: Offset(0.5, 0.8),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReadOnlyItemCard(
    Map<String, dynamic> item,
    AppState state, {
    required double screenWidth,
  }) {
    final name = item['name']?.toString() ?? '';
    final subtitle = item['subtitle']?.toString() ?? '';
    final image = item['image']?.toString() ?? '';
    final quantity = item['quantity'] as int? ?? 1;
    final price = (item['price'] as num?)?.toDouble() ?? 0.0;
    final lineTotal = price * quantity;

    final imageSize = screenWidth < 360 ? 54.0 : 60.0;
    final titleFont = screenWidth < 360 ? 10.5 : 11.5;
    final subFont = screenWidth < 360 ? 9.5 : 10.5;
    final priceFont = screenWidth < 360 ? 10.0 : 11.0;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.fromLTRB(12, 10, 10, 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: imageSize,
            height: imageSize + 8,
            decoration: BoxDecoration(
              color: _cream,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Image.asset(
                image,
                fit: BoxFit.contain,
                errorBuilder: (_, _, _) {
                  return const Icon(
                    Icons.image_not_supported_outlined,
                    color: Colors.black38,
                  );
                },
              ),
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
                  style: TextStyle(
                    color: _olive,
                    fontSize: titleFont,
                    fontFamily: 'serif',
                    fontWeight: FontWeight.w500,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: _olive,
                    fontSize: subFont,
                    fontFamily: 'serif',
                  ),
                ),
                const SizedBox(height: 10),
                _quantityDisplay(quantity),
              ],
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: screenWidth < 360 ? 48 : 62,
            child: Text(
              state.getFormattedPrice(lineTotal),
              textAlign: TextAlign.right,
              style: TextStyle(
                color: _olive,
                fontSize: priceFont,
                fontFamily: 'serif',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _quantityDisplay(int quantity) {
    return Container(
      width: 48,
      height: 22,
      decoration: BoxDecoration(
        color: _softButton,
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: Alignment.center,
      child: Text(
        quantity.toString(),
        style: const TextStyle(
          color: Colors.black,
          fontSize: 11,
        ),
      ),
    );
  }

  Widget _buildLocationRow(AppState state) {
    final country = state.currentStore;
    final flag = state.currentStoreFlag;

    return Row(
      children: [
        const Icon(
          Icons.location_on,
          size: 17,
          color: Colors.black,
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            '${state.t('checkout_delivering_to')}: ${state.t('store_$country')} $flag',
            style: const TextStyle(
              color: _olive,
              fontSize: 12,
              fontFamily: 'serif',
            ),
          ),
        ),
        InkWell(
          onTap: () => showStoreDialog(context),
          child: Text(
            state.t('checkout_change_location'),
            style: const TextStyle(
              color: _olive,
              fontSize: 10.5,
              fontFamily: 'serif',
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDeliveryOptions(AppState state) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: _olive, width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          _deliveryLine(
            title: 'Standard International',
            days: '5-7 days',
            price: 50,
            state: state,
          ),
          const Divider(height: 1, color: _line),
          _deliveryLine(
            title: 'Express',
            days: '2-3 days',
            price: 100,
            state: state,
          ),
        ],
      ),
    );
  }

  Widget _deliveryLine({
    required String title,
    required String days,
    required double price,
    required AppState state,
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
        height: 30,
        child: Row(
          children: [
            const SizedBox(width: 8),
            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: _olive,
              size: 17,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Row(
                children: [
                  Flexible(
                    child: Text(
                      title,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: _olive,
                        fontSize: 12,
                        fontFamily: 'serif',
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    days,
                    style: const TextStyle(
                      color: _olive,
                      fontSize: 9.5,
                      fontFamily: 'serif',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              state.getFormattedPrice(price),
              style: const TextStyle(
                color: _olive,
                fontSize: 12,
                fontFamily: 'serif',
              ),
            ),
            const SizedBox(width: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderSummary(AppState state) {
    return Column(
      children: [
        _summaryRow(
          left: state.t('checkout_order_summary'),
          right: state.getFormattedPrice(widget.subtotal),
          large: true,
        ),
        const Divider(height: 16, color: _line),
        _summaryRow(
          left: '${state.t('checkout_subtotal')}: ${state.getFormattedPrice(widget.subtotal)}',
          right: state.getFormattedPrice(widget.subtotal),
        ),
        const SizedBox(height: 7),
        _summaryRow(
          left: '${state.t('checkout_shipping_fee')}: ${state.getFormattedPrice(_shippingFee)}',
          right: state.getFormattedPrice(_shippingFee),
        ),
        const SizedBox(height: 7),
        _summaryRow(
          left: '${state.t('checkout_vat')}: ${state.getFormattedPrice(_vat)}',
          right: state.getFormattedPrice(_vat),
        ),
        const Divider(height: 16, color: _line),
        _summaryRow(
          left: '${state.t('checkout_total')}:',
          right: state.getFormattedPrice(_total),
          large: true,
        ),
      ],
    );
  }

  Widget _summaryRow({
    required String left,
    required String right,
    bool large = false,
  }) {
    return Row(
      children: [
        Expanded(
          child: Text(
            left,
            style: TextStyle(
              color: _olive,
              fontSize: large ? 13.5 : 11.5,
              fontFamily: 'serif',
              fontWeight: large ? FontWeight.w500 : FontWeight.w400,
            ),
          ),
        ),
        Text(
          right,
          style: TextStyle(
            color: _olive,
            fontSize: large ? 13.5 : 11.5,
            fontFamily: 'serif',
            fontWeight: large ? FontWeight.w500 : FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildTrustSection(AppState state) {
    return Column(
      children: [
        Row(
          children: [
            Icon(Icons.check, color: Colors.black, size: 16),
            SizedBox(width: 4),
            Expanded(
              child: Text(
                state.t('checkout_authentic'),
                style: const TextStyle(
                  color: _olive,
                  fontSize: 13,
                  fontFamily: 'serif',
                ),
              ),
            ),
            Icon(Icons.check, color: Colors.black, size: 16),
            SizedBox(width: 4),
            Expanded(
              child: Text(
                state.t('checkout_secure_shipping'),
                style: const TextStyle(
                  color: _olive,
                  fontSize: 13,
                  fontFamily: 'serif',
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(Icons.check, color: Colors.black, size: 16),
            SizedBox(width: 4),
            Expanded(
              child: Text(
                state.t('checkout_sustainable'),
                style: const TextStyle(
                  color: _olive,
                  fontSize: 13,
                  fontFamily: 'serif',
                ),
              ),
            ),
            const Icon(
              Icons.eco_outlined,
              color: _olive,
              size: 28,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildContinueButton(
    BuildContext context,
    AppState state,
    double screenWidth,
  ) {
    final width = screenWidth < 360 ? screenWidth * 0.64 : 220.0;

    return Center(
      child: SizedBox(
        width: width,
        height: 34,
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => PaymentScreen(
                  orderItems: widget.orderItems,
                  profileData: widget.profileData,
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
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              state.t('checkout_continue_payment'),
              style: const TextStyle(
                fontSize: 14,
                fontFamily: 'serif',
              ),
            ),
          ),
        ),
      ),
    );
  }

}
