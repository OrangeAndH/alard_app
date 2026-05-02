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
  static const Color _cream = Color(0xFFF2EDE6);
  static const Color _olive = Color(0xFF55682A);
  static const Color _softButton = Color(0xFFF4ECD9);

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
            final buttonWidth = screenWidth < 360 ? screenWidth * 0.62 : 220.0;

            if (state.cartItems.isEmpty) {
              return _buildEmptyCart(
                context,
                horizontalPadding: horizontalPadding,
              );
            }

            return Column(
              children: [
                _buildTopBar(context),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(
                      horizontalPadding,
                      8,
                      horizontalPadding,
                      22,
                    ),
                    child: Column(
                      children: [
                        _buildSteps(activeStep: 'Cart'),
                        const SizedBox(height: 10),
                        _buildScreenTitle(),
                        const SizedBox(height: 14),
                        ...state.cartItems.map(
                          (item) => _buildCartItemCard(
                            context,
                            state,
                            item,
                            screenWidth: screenWidth,
                          ),
                        ),
                        const SizedBox(height: 22),
                        _buildCheckoutButton(
                          context,
                          state,
                          width: buttonWidth,
                        ),
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
                    Navigator.maybePop(context);
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

        return Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 4,
          children: [
            _stepText(
              'Cart',
              active: activeStep == 'Cart',
              fontSize: fontSize,
            ),
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
      style: TextStyle(
        color: _olive,
        fontSize: fontSize + 2,
        fontFamily: 'serif',
      ),
    );
  }

  Widget _buildScreenTitle() {
    return const Center(
      child: Text(
        'Shopping Cart',
        style: TextStyle(
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

  Widget _buildCartItemCard(
    BuildContext context,
    AppState state,
    CartItem item, {
    required double screenWidth,
  }) {
    final imageSize = screenWidth < 360 ? 54.0 : 60.0;
    final titleFont = screenWidth < 360 ? 10.5 : 11.5;
    final subFont = screenWidth < 360 ? 9.5 : 10.5;
    final priceFont = screenWidth < 360 ? 10.0 : 11.0;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.fromLTRB(12, 10, 10, 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
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
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.product.name.toUpperCase(),
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
                  _getProductSubText(item.product),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: _olive,
                    fontSize: subFont,
                    fontFamily: 'serif',
                  ),
                ),
                const SizedBox(height: 10),
                _buildQuantityControl(state, item),
              ],
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: screenWidth < 360 ? 48 : 60,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _formatMoney(item.lineTotal),
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: _olive,
                    fontSize: priceFont,
                    fontFamily: 'serif',
                  ),
                ),
                const SizedBox(height: 28),
                InkWell(
                  onTap: () {
                    state.removeFromCart(item.product.id);
                  },
                  child: Text(
                    'Remove',
                    style: TextStyle(
                      color: _olive,
                      fontSize: screenWidth < 360 ? 9.5 : 10.5,
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

  Widget _buildQuantityControl(AppState state, CartItem item) {
    return Container(
      width: 72,
      height: 22,
      decoration: BoxDecoration(
        color: _softButton,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _qtyButton(
            label: '-',
            onTap: () {
              state.decreaseQuantity(item.product.id);
            },
          ),
          Container(
            width: 1,
            height: 14,
            color: _olive.withOpacity(0.35),
          ),
          Expanded(
            child: Center(
              child: Text(
                item.quantity.toString(),
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 11,
                ),
              ),
            ),
          ),
          Container(
            width: 1,
            height: 14,
            color: _olive.withOpacity(0.35),
          ),
          _qtyButton(
            label: '+',
            onTap: () {
              state.increaseQuantity(item.product.id);
            },
          ),
        ],
      ),
    );
  }

  Widget _qtyButton({
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        width: 22,
        child: Center(
          child: Text(
            label,
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

  Widget _buildCheckoutButton(
    BuildContext context,
    AppState state, {
    required double width,
  }) {
    return Center(
      child: SizedBox(
        width: width,
        height: 34,
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ShippingScreen(
                  orderItems: _orderItemsToMap(state),
                  profileData: _getProfileData(state),
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
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              'Proceed To Checkout',
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'serif',
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyCart(
    BuildContext context, {
    required double horizontalPadding,
  }) {
    return Column(
      children: [
        _buildTopBar(context),
        Padding(
          padding: EdgeInsets.fromLTRB(
            horizontalPadding,
            10,
            horizontalPadding,
            0,
          ),
          child: Column(
            children: const [
              SizedBox(height: 6),
              Text(
                'Shopping Cart',
                style: TextStyle(
                  color: _olive,
                  fontSize: 20,
                  fontFamily: 'serif',
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 80),
              Text(
                'Your cart is empty',
                style: TextStyle(
                  color: _olive,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<Map<String, dynamic>> _orderItemsToMap(AppState state) {
    return state.cartItems.map((item) {
      return {
        'name': item.product.name,
        'subtitle': _getProductSubText(item.product),
        'price': item.product.price,
        'quantity': item.quantity,
        'image': item.product.image,
      };
    }).toList();
  }

  Map<String, String> _getProfileData(AppState state) {
    final user = state.currentUser;

    final name =
        (user?.name.trim().isNotEmpty == true) ? user!.name : 'Mohammed';

    final email = (user?.email.trim().isNotEmpty == true)
        ? user!.email
        : 'Mohammed@gmail.com';

    final phone =
        (user?.phone.trim().isNotEmpty == true && user?.phone != 'No phone added')
            ? user!.phone
            : '+970 593245879';

    final country =
        (user?.location.trim().isNotEmpty == true) ? user!.location : 'Palestine';

    return {
      'name': name,
      'email': email,
      'phone': phone,
      'country': country,
      'city': 'Nablus',
      'postalCode': '10115',
    };
  }

  String _getProductSubText(Product product) {
    if (product.weight.trim().isNotEmpty) {
      return '-${product.weight.toUpperCase()}';
    }

    if (product.subtitle.trim().isNotEmpty) {
      return '-${product.subtitle.toUpperCase()}';
    }

    return '';
  }

  String _formatMoney(double value) {
    if (value % 1 == 0) {
      return '${value.toStringAsFixed(0)} NIS';
    }

    return '${value.toStringAsFixed(2)} NIS';
  }
}