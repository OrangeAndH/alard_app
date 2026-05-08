import 'package:flutter/material.dart';

import 'app_state.dart';
import 'app_state_scope.dart';
import 'feedback_screen.dart';
import 'shop_screen.dart';

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
  static const Color _cream = Color(0xFFF2EDE6);
  static const Color _olive = Color(0xFF55682A);

  static const List<_PopularItem> _popularItems = [
    _PopularItem(
      title: 'Olive Pickle Variety',
      image: 'assets/catalog_images/olive_pickle_variety_on_display.png',
    ),
    _PopularItem(
      title: 'Extra virgin olive oil',
      image: 'assets/catalog_images/olive_oil_collection_on_display.png',
    ),
    _PopularItem(
      title: 'Nablus Soap',
      image: 'assets/catalog_images/premium_nabulsi_soap_and_liquid_set.png',
    ),
    _PopularItem(
      title: 'Premium Za’atar Blend',
      image: 'assets/catalog_images/premium_palestinian_za_atar_blends_lineup.png',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      bottomNavigationBar: _bottomNav(context),
      body: SafeArea(
        child: Builder(
          builder: (context) {
            final state = AppStateScope.of(context);
            final screenWidth = MediaQuery.of(context).size.width;
            final horizontalPadding = screenWidth < 360 ? 8.0 : 10.0;

            return Column(
              children: [
                _buildTopLogo(context),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.fromLTRB(
                      horizontalPadding,
                      0,
                      horizontalPadding,
                      18,
                    ),
                    children: [
                      const SizedBox(height: 4),
                      _buildSteps(state, context, activeStep: 'step_review'),
                      const SizedBox(height: 16),
                      _orderSummary(state),
                      const SizedBox(height: 16),
                      _searchBar(context),
                      const SizedBox(height: 10),
                      _heroBanner(state),
                      const SizedBox(height: 12),
                      _sectionTitle(
                        title: state.t('product_best_seller'),
                        onTap: () {
                          state.setSelectedIndex(1);
                          Navigator.popUntil(context, (route) => route.isFirst);
                        },
                      ),
                      const SizedBox(height: 8),
                      _popularProductsRow(context, _popularItems),
                      const SizedBox(height: 16),
                      _sectionTitle(
                        title: state.t('feedback_customer_feedback'),
                        onTap: () {
                          state.setSelectedIndex(3);
                          Navigator.popUntil(context, (route) => route.isFirst);
                        },
                      ),
                      const SizedBox(height: 8),
                      _feedbackGrid(),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildTopLogo(BuildContext context) {
    final state = AppStateScope.of(context);
    return Container(
      height: 48,
      width: double.infinity,
      color: _cream,
      child: Stack(
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
                    fontSize: 16,
                    color: _olive,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
          ),
          PositionedDirectional(
            end: 8,
            top: 4,
            child: IconButton(
              onPressed: () {
                state.setSelectedIndex(0);
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              icon: const Icon(
                Icons.home_outlined,
                color: _olive,
                size: 28,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSteps(
    AppState state,
    BuildContext context, {
    required String activeStep,
  }) {
    final width = MediaQuery.of(context).size.width;
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
  }

  Widget _stepText(
    String text, {
    required bool active,
    required double fontSize,
  }) {
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
            width: fontSize * 3,
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

  Widget _searchBar(BuildContext context) {
    return Container(
      height: 38,
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: _olive),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.20),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const SizedBox(width: 8),
          const Icon(
            Icons.search_rounded,
            size: 21,
            color: Colors.black,
          ),
          const SizedBox(width: 7),
          Expanded(
            child: Text(
              AppStateScope.of(context).t('shop_search_hint'),
              style: const TextStyle(
                color: _olive,
                fontSize: 14,
                fontFamily: 'serif',
              ),
            ),
          ),
          const Icon(
            Icons.mic_none_rounded,
            color: Colors.black,
            size: 22,
          ),
          const SizedBox(width: 10),
        ],
      ),
    );
  }

  Widget _heroBanner(AppState state) {
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
            ),
          ),
          Container(
            height: 145,
            color: Colors.black.withValues(alpha: 0.18),
          ),
          Positioned.fill(
            child: Center(
              child: Text(
                state.t('home_hero_text'),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
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

  Widget _sectionTitle({
    required String title,
    required VoidCallback onTap,
  }) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              color: _olive,
              fontSize: 19,
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
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Padding(
            padding: const EdgeInsets.all(3),
            child: Icon(
              Icons.adaptive.arrow_forward,
              color: _olive,
              size: 30,
            ),
          ),
        ),
      ],
    );
  }

  Widget _popularProductsRow(
    BuildContext context,
    List<_PopularItem> popularItems,
  ) {
    return SizedBox(
      height: 142,
      child: Row(
        children: popularItems.map((item) {
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: _PopularProductCard(
                item: item,
                onAdd: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${item.title} added to cart'),
                      duration: const Duration(milliseconds: 900),
                    ),
                  );
                },
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _feedbackGrid() {
    return const Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _FeedbackCard(
                flag: '🇬🇧',
                name: 'Louis',
                text: 'The gift set is perfect for any special occasion',
              ),
            ),
            SizedBox(width: 28),
            Expanded(
              child: _FeedbackCard(
                flag: '🇩🇪',
                name: 'Jasmin',
                text: 'The Za’atar is incredibly aromatic and tasty',
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _FeedbackCard(
                flag: '🇵🇸',
                name: 'Sarah',
                text: 'Amazing products !',
              ),
            ),
            SizedBox(width: 28),
            Expanded(
              child: _FeedbackCard(
                flag: '🇺🇸',
                name: 'Ahmed',
                text: 'Rich flavor and authentic Palestinian quality',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _orderSummary(AppState state) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _cream),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            state.t('checkout_order_summary'),
            style: const TextStyle(
              color: _olive,
              fontSize: 18,
              fontFamily: 'serif',
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          if (orderItems.isNotEmpty) ...[
            ...orderItems.map((item) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${item['quantity'] ?? 1}x ${item['name'] ?? 'Product'}',
                      style: const TextStyle(fontSize: 14, fontFamily: 'serif'),
                    ),
                    Text(
                      state.getFormattedPrice(item['price'] ?? 0.0),
                      style: const TextStyle(fontSize: 14, fontFamily: 'serif'),
                    ),
                  ],
                ),
              );
            }),
            const Divider(color: _cream),
          ],
          _summaryRow(state.t('checkout_subtotal'), state.getFormattedPrice(subtotal)),
          _summaryRow(shippingTitle, state.getFormattedPrice(shippingFee)),
          _summaryRow(state.t('checkout_vat'), state.getFormattedPrice(vat)),
          const Divider(color: _cream),
          _summaryRow(state.t('checkout_total'), state.getFormattedPrice(total), isBold: true),
          const SizedBox(height: 12),
          Text(
            '${state.t('checkout_payment')}: $paymentMethod',
            style: const TextStyle(
              color: Colors.black54,
              fontSize: 12,
              fontFamily: 'serif',
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String formattedAmount, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: _olive,
              fontSize: isBold ? 16 : 14,
              fontFamily: 'serif',
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            formattedAmount,
            style: TextStyle(
              color: _olive,
              fontSize: isBold ? 16 : 14,
              fontFamily: 'serif',
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _bottomNav(BuildContext context) {
    final state = AppStateScope.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final bottomPadding = MediaQuery.paddingOf(context).bottom;
    final selectedColor = theme.colorScheme.primary;
    final unselectedColor = isDark ? Colors.white70 : Colors.black87;

    return Container(
      height: 85 + bottomPadding,
      padding: EdgeInsets.only(bottom: bottomPadding),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : const Color(0xFFF3EEE7),
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black54 : Colors.black12,
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navItem(
            label: state.t('nav_home'),
            icon: Icons.home_outlined,
            activeIcon: Icons.home,
            isSelected: state.selectedIndex == 0,
            selectedColor: selectedColor,
            unselectedColor: unselectedColor,
            onTap: () {
              state.setSelectedIndex(0);
              Navigator.popUntil(context, (route) => route.isFirst);
            },
          ),
          _navItem(
            label: state.t('nav_shop'),
            icon: Icons.shopping_bag_outlined,
            activeIcon: Icons.shopping_bag,
            isSelected: state.selectedIndex == 1,
            selectedColor: selectedColor,
            unselectedColor: unselectedColor,
            onTap: () {
              state.setSelectedIndex(1);
              Navigator.popUntil(context, (route) => route.isFirst);
            },
          ),
          _imageNavItem(
            label: state.t('nav_recipes'),
            imagePath: 'assets/recipes.png',
            isSelected: state.selectedIndex == 2,
            selectedColor: selectedColor,
            unselectedColor: unselectedColor,
            onTap: () {
              state.setSelectedIndex(2);
              Navigator.popUntil(context, (route) => route.isFirst);
            },
          ),
          _navItem(
            label: state.t('nav_feedback'),
            icon: Icons.feedback_outlined,
            activeIcon: Icons.feedback,
            isSelected: state.selectedIndex == 3,
            selectedColor: selectedColor,
            unselectedColor: unselectedColor,
            onTap: () {
              state.setSelectedIndex(3);
              Navigator.popUntil(context, (route) => route.isFirst);
            },
          ),
          _navItem(
            label: state.t('nav_profile'),
            icon: Icons.person_outline,
            activeIcon: Icons.person,
            isSelected: state.selectedIndex == 4,
            selectedColor: selectedColor,
            unselectedColor: unselectedColor,
            onTap: () {
              state.setSelectedIndex(4);
              Navigator.popUntil(context, (route) => route.isFirst);
            },
          ),
        ],
      ),
    );
  }

  Widget _navItem({
    required String label,
    required IconData icon,
    required IconData activeIcon,
    required bool isSelected,
    required Color selectedColor,
    required Color unselectedColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 70,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSelected ? activeIcon : icon,
              color: isSelected ? selectedColor : unselectedColor,
              size: 26,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? selectedColor : unselectedColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _imageNavItem({
    required String label,
    required String imagePath,
    required bool isSelected,
    required Color selectedColor,
    required Color unselectedColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 70,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(2),
              decoration: isSelected
                  ? BoxDecoration(
                      border: Border.all(
                        color: selectedColor,
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    )
                  : null,
              child: Image.asset(
                imagePath,
                width: 28,
                height: 28,
                fit: BoxFit.contain,
                errorBuilder: (_, _, _) {
                  return Icon(
                    Icons.restaurant_rounded,
                    color: isSelected ? selectedColor : unselectedColor,
                    size: 28,
                  );
                },
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? selectedColor : unselectedColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PopularItem {
  final String title;
  final String image;

  const _PopularItem({
    required this.title,
    required this.image,
  });
}

class _PopularProductCard extends StatelessWidget {
  final _PopularItem item;
  final VoidCallback onAdd;

  const _PopularProductCard({
    required this.item,
    required this.onAdd,
  });

  static const Color _olive = Color(0xFF55682A);
  static const Color _gold = Color(0xFFE0A323);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.fromLTRB(5, 6, 5, 5),
      child: Column(
        children: [
          Expanded(
            child: Image.asset(
              item.image,
              fit: BoxFit.contain,
              errorBuilder: (_, _, _) {
                return const Icon(
                  Icons.image_not_supported_outlined,
                  color: Colors.black38,
                  size: 30,
                );
              },
            ),
          ),
          const SizedBox(height: 3),
          Text(
            item.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 8.5,
              fontFamily: 'serif',
              height: 1.1,
            ),
          ),
          const SizedBox(height: 2),
          const Text(
            '★★★★★',
            style: TextStyle(
              color: _gold,
              fontSize: 8.5,
              letterSpacing: -1,
            ),
          ),
          SizedBox(
            height: 21,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onAdd,
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
                  AppStateScope.of(context).t('shop_add_to_cart'),
                  style: const TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FeedbackCard extends StatelessWidget {
  final String flag;
  final String name;
  final String text;

  const _FeedbackCard({
    required this.flag,
    required this.name,
    required this.text,
  });

  static const Color _olive = Color(0xFF55682A);
  static const Color _gold = Color(0xFFE0A323);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      padding: const EdgeInsets.fromLTRB(8, 6, 8, 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                flag,
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  name,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: _olive,
                    fontSize: 13,
                    fontFamily: 'serif',
                  ),
                ),
              ),
            ],
          ),
          const Text(
            '★★★★★',
            style: TextStyle(
              color: _gold,
              fontSize: 9,
              letterSpacing: -1,
            ),
          ),
          Expanded(
            child: Text(
              text,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: _olive,
                fontSize: 10,
                fontFamily: 'serif',
                height: 1.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool circular;
  final VoidCallback onTap;

  const _NavIcon({
    required this.icon,
    required this.label,
    required this.onTap,
    this.circular = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: SizedBox(
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
                size: circular ? 22 : 30,
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
      ),
    );
  }
}