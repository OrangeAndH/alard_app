import 'package:flutter/material.dart';

import '../../state/app_state.dart';
import '../../state/app_state_scope.dart';
import '../../theme/app_colors.dart';
import '../../widgets/checkout_bottom_nav.dart';
import '../../widgets/checkout_step_bar.dart';
import '../../widgets/feedback_card.dart';
import '../../widgets/order_summary_card.dart';

/// Final step in the checkout flow.
/// Shows a confirmed order summary, search bar, product highlights, and
/// customer feedback — then returns the user to the main app via CheckoutBottomNav.
/// Estimated lines: ~230
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

  // ── Static data ───────────────────────────────────────────────────
  static const List<_PopularItem> _popularItems = [
    _PopularItem(
      title: 'Olive Pickle Variety',
      image: 'assets/img/palestinian_green_olives_in_various_sizes.png',
    ),
    _PopularItem(
      title: 'Extra virgin olive oil',
      image: 'assets/img/elegant_olive_oil_collection_display.png',
    ),
    _PopularItem(
      title: 'Nablus Soap',
      image: 'assets/img/premium_nabulsi_soap_product_display.png',
    ),
    _PopularItem(
      title: "Premium Za'atar Blend",
      image: 'assets/img/premium_palestinian_za_atar_packaging_display.png',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final hPad = screenWidth < 360 ? 8.0 : 10.0;

    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: const CheckoutBottomNav(),
      body: SafeArea(
        child: Column(
          children: [
            _topLogo(context, state),
            Expanded(
              child: ListView(
                padding: EdgeInsets.fromLTRB(hPad, 0, hPad, 18),
                children: [
                  const SizedBox(height: 4),
                  _stepBar(state),
                  const SizedBox(height: 16),
                  OrderSummaryCard(
                    orderItems: orderItems,
                    subtotal: subtotal,
                    shippingFee: shippingFee,
                    shippingTitle: shippingTitle,
                    vat: vat,
                    total: total,
                    paymentMethod: paymentMethod,
                  ),
                  const SizedBox(height: 16),
                  _searchBar(context, state),
                  const SizedBox(height: 10),
                  _heroBanner(state),
                  const SizedBox(height: 12),
                  _sectionTitle(
                    title: state.t('product_best_seller'),
                    onTap: () {
                      state.setSelectedIndex(1);
                      Navigator.popUntil(context, (r) => r.isFirst);
                    },
                  ),
                  const SizedBox(height: 8),
                  _popularRow(context),
                  const SizedBox(height: 16),
                  _sectionTitle(
                    title: state.t('feedback_customer_feedback'),
                    onTap: () {
                      state.setSelectedIndex(3);
                      Navigator.popUntil(context, (r) => r.isFirst);
                    },
                  ),
                  const SizedBox(height: 8),
                  _feedbackGrid(),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _stepBar(AppState state) {
    return CheckoutStepBar(
      activeStep: 3,
      labels: [
        state.t('step_cart'),
        state.t('step_shipping'),
        state.t('step_payment'),
        state.t('step_review'),
      ],
    );
  }

  Widget _topLogo(BuildContext context, AppState state) {
    return Container(
      height: 48,
      width: double.infinity,
      color: AppColors.cream,
      child: Stack(
        children: [
          Center(
            child: Image.asset(
              'assets/321.png',
              height: 38,
              fit: BoxFit.contain,
              errorBuilder: (_, _, _) => const Text(
                "AL'ARD",
                style: TextStyle(
                    fontSize: 16,
                    color: AppColors.olive,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          PositionedDirectional(
            end: 8,
            top: 4,
            child: IconButton(
              onPressed: () {
                state.setSelectedIndex(0);
                Navigator.popUntil(context, (r) => r.isFirst);
              },
              icon: const Icon(Icons.home_outlined,
                  color: AppColors.olive, size: 28),
            ),
          ),
        ],
      ),
    );
  }

  Widget _searchBar(BuildContext context, AppState state) {
    return Container(
      height: 38,
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.olive),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.20),
              blurRadius: 4,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          const SizedBox(width: 8),
          const Icon(Icons.search_rounded, size: 21),
          const SizedBox(width: 7),
          Expanded(
            child: Text(state.t('shop_search_hint'),
                style: const TextStyle(
                    color: AppColors.olive, fontSize: 14, fontFamily: 'serif')),
          ),
          const Icon(Icons.mic_none_rounded, size: 22),
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
            child: Image.asset('assets/photo2.png', fit: BoxFit.cover),
          ),
          Container(height: 145, color: Colors.black.withValues(alpha: 0.18)),
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
                  shadows: [Shadow(color: Colors.black87, blurRadius: 4)],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle({required String title, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: AppColors.olive,
                  fontSize: 19,
                  fontFamily: 'serif',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Icon(Icons.adaptive.arrow_forward, color: AppColors.olive, size: 30),
          ],
        ),
      ),
    );
  }

  Widget _popularRow(BuildContext context) {
    return SizedBox(
      height: 142,
      child: Row(
        children: _popularItems.map((item) {
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: _PopularCard(
                item: item,
                onAdd: () => ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${item.title} added to cart'),
                    duration: const Duration(milliseconds: 900),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _feedbackGrid() {
    const items = [
      FeedbackCard(flag: '🇬🇧', name: 'Louis', country: 'UK',
          text: 'The gift set is perfect for any special occasion', stars: 5),
      FeedbackCard(flag: '🇩🇪', name: 'Jasmin', country: 'Germany',
          text: "The Za'atar is incredibly aromatic and tasty", stars: 5),
      FeedbackCard(flag: '🇵🇸', name: 'Sarah', country: 'Palestine',
          text: 'Amazing products!', stars: 5),
      FeedbackCard(flag: '🇺🇸', name: 'Ahmed', country: 'USA',
          text: 'Rich flavor and authentic Palestinian quality', stars: 5),
    ];
    return Column(
      children: [
        Row(children: [
          Expanded(child: items[0]),
          const SizedBox(width: 28),
          Expanded(child: items[1]),
        ]),
        const SizedBox(height: 10),
        Row(children: [
          Expanded(child: items[2]),
          const SizedBox(width: 28),
          Expanded(child: items[3]),
        ]),
      ],
    );
  }
}

// ── Private helpers ──────────────────────────────────────────────────────────

class _PopularItem {
  final String title;
  final String image;
  const _PopularItem({required this.title, required this.image});
}

class _PopularCard extends StatelessWidget {
  final _PopularItem item;
  final VoidCallback onAdd;
  const _PopularCard({required this.item, required this.onAdd});

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
              errorBuilder: (_, _, _) => const Icon(
                  Icons.image_not_supported_outlined,
                  color: Colors.black38,
                  size: 30),
            ),
          ),
          const SizedBox(height: 3),
          Text(item.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Colors.black, fontSize: 8.5, fontFamily: 'serif')),
          const SizedBox(height: 2),
          const Text('★★★★★',
              style: TextStyle(
                  color: AppColors.gold, fontSize: 8.5, letterSpacing: -1)),
          SizedBox(
            height: 21,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onAdd,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.olive,
                foregroundColor: Colors.white,
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
              ),
              child: const FittedBox(
                fit: BoxFit.scaleDown,
                child: Text('Add', style: TextStyle(fontSize: 9)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}