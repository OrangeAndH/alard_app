import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Reusable checkout progress step bar.
///
/// Used on Cart, Shipping, Payment, and Review screens.
/// Previously duplicated in all 4 screens with a broken Arabic check.
///
/// [activeStep] is 0-indexed:
///   0 = Cart, 1 = Shipping, 2 = Payment, 3 = Review
///
/// Estimated lines: ~90
class CheckoutStepBar extends StatelessWidget {
  final int activeStep;
  final List<String> labels;

  const CheckoutStepBar({
    super.key,
    required this.activeStep,
    required this.labels,
  }) : assert(labels.length == 4, 'CheckoutStepBar requires exactly 4 labels');

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final fontSize = (width * 0.034).clamp(12.0, 14.0);

        return Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 4,
          children: [
            _stepItem(labels[0], active: activeStep == 0, fontSize: fontSize),
            _divider(fontSize),
            _stepItem(labels[1], active: activeStep == 1, fontSize: fontSize),
            _divider(fontSize),
            _stepItem(labels[2], active: activeStep == 2, fontSize: fontSize),
            _divider(fontSize),
            _stepItem(labels[3], active: activeStep == 3, fontSize: fontSize),
          ],
        );
      },
    );
  }

  Widget _stepItem(String text, {required bool active, required double fontSize}) {
    // Underline width is proportional to font size × an estimated char count,
    // not hard-coded to English strings (fixes the Arabic RTL bug).
    final underlineWidth = active ? (fontSize * text.length * 0.62).clamp(30.0, 80.0) : 0.0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.olive,
            fontSize: fontSize,
            fontFamily: 'serif',
            fontWeight: active ? FontWeight.w700 : FontWeight.w400,
          ),
        ),
        const SizedBox(height: 2),
        if (active)
          Container(
            height: 2,
            width: underlineWidth,
            color: AppColors.olive,
          ),
      ],
    );
  }

  Widget _divider(double fontSize) {
    return Text(
      '—',
      textAlign: TextAlign.center,
      style: TextStyle(
        color: AppColors.olive,
        fontSize: fontSize + 2,
        fontFamily: 'serif',
      ),
    );
  }
}
