import 'package:flutter/material.dart';

import '../../state/app_state_scope.dart';
import '../../theme/app_colors.dart';
import '../../widgets/checkout_step_bar.dart';
import '../../state/app_state.dart';

/// Shared order-summary card used on ReviewScreen.
/// Estimated lines: ~80
class OrderSummaryCard extends StatelessWidget {
  final List<Map<String, dynamic>> orderItems;
  final double subtotal;
  final double shippingFee;
  final String shippingTitle;
  final double vat;
  final double total;
  final String paymentMethod;

  const OrderSummaryCard({
    super.key,
    required this.orderItems,
    required this.subtotal,
    required this.shippingFee,
    required this.shippingTitle,
    required this.vat,
    required this.total,
    required this.paymentMethod,
  });

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.cream),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            state.t('checkout_order_summary'),
            style: const TextStyle(
              color: AppColors.olive,
              fontSize: 18,
              fontFamily: 'serif',
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          if (orderItems.isNotEmpty) ...[
            ...orderItems.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      '${item['quantity'] ?? 1}x ${item['name'] ?? 'Product'}'
                      '${item['variant'] != null ? " (${item['variant']})" : ""}',
                      style: const TextStyle(fontSize: 14, fontFamily: 'serif'),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    state.getFormattedPrice(item['price'] ?? 0.0),
                    style: const TextStyle(fontSize: 14, fontFamily: 'serif'),
                  ),
                ],
              ),
            )),
            const Divider(color: AppColors.cream),
          ],
          _row(state.t('checkout_subtotal'), state.getFormattedPrice(subtotal)),
          _row(shippingTitle, state.getFormattedPrice(shippingFee)),
          _row(state.t('checkout_vat'), state.getFormattedPrice(vat)),
          const Divider(color: AppColors.cream),
          _row(state.t('checkout_total'), state.getFormattedPrice(total), bold: true),
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

  Widget _row(String label, String value, {bool bold = false}) {
    final style = TextStyle(
      color: AppColors.olive,
      fontSize: bold ? 16 : 14,
      fontFamily: 'serif',
      fontWeight: bold ? FontWeight.bold : FontWeight.normal,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: style),
          Text(value, style: style),
        ],
      ),
    );
  }
}

/// Reusable step bar wrapper that maps string step keys to indices.
/// Estimated lines: ~25
class CheckoutStepBarWrapper extends StatelessWidget {
  final AppState state;
  final String activeStep;

  const CheckoutStepBarWrapper({
    super.key,
    required this.state,
    required this.activeStep,
  });

  @override
  Widget build(BuildContext context) {
    final stepIndex = {
      'step_cart': 0,
      'step_shipping': 1,
      'step_payment': 2,
      'step_review': 3,
    }[activeStep] ?? 3;

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
}
