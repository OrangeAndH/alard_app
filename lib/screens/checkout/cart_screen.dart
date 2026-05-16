import 'dart:async';
import 'package:flutter/material.dart';

import '../../state/app_state.dart';
import '../../state/app_state_scope.dart';
import '../../theme/app_colors.dart';
import '../../widgets/checkout_step_bar.dart';
import '../auth/login_screen.dart';
import 'shipping_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  // Colors are centralised in AppColors — no local declarations needed.
  Timer? _qtyTimer;

  @override
  void dispose() {
    _qtyTimer?.cancel();
    super.dispose();
  }

  void _startContinuousQty(AppState state, String cartKey, bool increase) {
    _qtyTimer?.cancel();
    _qtyTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (increase) {
        state.increaseQuantity(cartKey);
      } else {
        state.decreaseQuantity(cartKey);
      }
    });
  }

  void _stopContinuousQty() {
    _qtyTimer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final screenWidth = constraints.maxWidth;
            final horizontalPadding = screenWidth < 360 ? 10.0 : 14.0;
            final buttonWidth = screenWidth < 360 ? screenWidth * 0.62 : 220.0;

            if (state.cartItems.isEmpty) {
              return _buildEmptyCart(
                context,
                state,
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
                        _buildSteps(state, activeStep: 'step_cart'),
                        const SizedBox(height: 10),
                        _buildScreenTitle(state),
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
        final barHeight = (width * 0.16).clamp(56.0, 70.0);
        final buttonSize = (width * 0.11).clamp(38.0, 46.0);

        return Container(
          height: barHeight,
          width: double.infinity,
          color: AppColors.cream,
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
                        color: AppColors.olive,
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
                    Navigator.maybePop(context);
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

  Widget _buildSteps(AppState state, {required String activeStep}) {
    final stepIndex = {
      'step_cart': 0,
      'step_shipping': 1,
      'step_payment': 2,
      'step_review': 3,
    }[activeStep] ?? 0;

    return CheckoutStepBar(
      activeStep: stepIndex,
      labels: [
        state.t('step_cart'),
        state.t('step_shipping'),
        state.t('step_payment'),
        state.t('step_review'),
      ],
    );
  }

  Widget _buildScreenTitle(AppState state) {
    return Center(
      child: Text(
        state.t('step_cart'),
        style: const TextStyle(
          color: AppColors.olive,
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
              color: AppColors.cream,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Image.asset(
                item.product.image,
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
                  item.product.name.toUpperCase(),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppColors.olive,
                    fontSize: titleFont,
                    fontFamily: 'serif',
                    fontWeight: FontWeight.w500,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _getProductSubText(item),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppColors.olive,
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
                  state.getFormattedPrice(item.lineTotal),
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: AppColors.olive,
                    fontSize: priceFont,
                    fontFamily: 'serif',
                  ),
                ),
                const SizedBox(height: 28),
                InkWell(
                  onTap: () {
                    state.removeFromCart(item.cartKey);
                  },
                  child: Text(
                    state.t('ui_delete'),
                    style: TextStyle(
                      color: AppColors.olive,
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
        color: AppColors.softButton,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _qtyButton(
            label: '-',
            onTap: () {
              state.decreaseQuantity(item.cartKey);
            },
            onLongPressStart: () => _startContinuousQty(state, item.cartKey, false),
            onLongPressEnd: _stopContinuousQty,
          ),
          Container(
            width: 1,
            height: 14,
            color: AppColors.olive.withValues(alpha: 0.35),
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
            color: AppColors.olive.withValues(alpha: 0.35),
          ),
          _qtyButton(
            label: '+',
            onTap: () {
              state.increaseQuantity(item.cartKey);
            },
            onLongPressStart: () => _startContinuousQty(state, item.cartKey, true),
            onLongPressEnd: _stopContinuousQty,
          ),
        ],
      ),
    );
  }

  Widget _qtyButton({
    required String label,
    required VoidCallback onTap,
    required VoidCallback onLongPressStart,
    required VoidCallback onLongPressEnd,
  }) {
    return GestureDetector(
      onLongPressStart: (_) => onLongPressStart(),
      onLongPressEnd: (_) => onLongPressEnd(),
      onLongPressCancel: onLongPressEnd,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          width: 22,
          child: Center(
            child: Text(
              label,
              style: const TextStyle(
                color: AppColors.olive,
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
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
            if (!state.isLoggedIn) {
              _showLoginPrompt(context);
              return;
            }
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
            backgroundColor: AppColors.olive,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              state.t('checkout_shipping'),
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

  Widget _buildEmptyCart(
    BuildContext context,
    AppState state, {
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
            children: [
              const SizedBox(height: 6),
              Text(
                state.t('step_cart'),
                style: const TextStyle(
                  color: AppColors.olive,
                  fontSize: 20,
                  fontFamily: 'serif',
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 80),
              Text(
                state.t('shop_no_products'),
                style: const TextStyle(
                  color: AppColors.olive,
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
        'subtitle': _getProductSubText(item),
        // item.price already reflects trader discount via AppState._getEffectivePrice
        'price': item.price,
        'quantity': item.quantity,
        'image': item.product.image,
        'variant': item.selectedVariant?.size,
      };
    }).toList();
  }

  Map<String, String> _getProfileData(AppState state) {
    final user = state.currentUser;
    return {
      'name': user?.name.trim().isNotEmpty == true ? user!.name : '',
      'email': user?.email.trim().isNotEmpty == true ? user!.email : '',
      'phone': (user?.phone.trim().isNotEmpty == true &&
              user?.phone != 'No phone added')
          ? user!.phone
          : '',
      'country': user?.location.trim().isNotEmpty == true
          ? user!.location
          : state.currentStore,
      'city': '',
      'postalCode': '',
    };
  }

  String _getProductSubText(CartItem item) {
    if (item.selectedVariant != null) {
      return item.selectedVariant!.size.toUpperCase();
    }

    final product = item.product;
    if (product.weight.trim().isNotEmpty) {
      return product.weight.toUpperCase();
    }

    if (product.subtitle.trim().isNotEmpty) {
      return '-${product.subtitle.toUpperCase()}';
    }

    return '';
  }

  void _showLoginPrompt(BuildContext context) {
    final state = AppStateScope.of(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.lock_outline_rounded,
              size: 48,
              color: Color(0xFF7A8D2F),
            ),
            const SizedBox(height: 16),
            Text(
              state.t('ui_login_required'),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              state.t('ui_login_required_body'),
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const LoginScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7A8D2F),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    state.t('ui_go_to_login'),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(
                state.t('ui_maybe_later'),
                style: const TextStyle(color: Colors.black45),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
