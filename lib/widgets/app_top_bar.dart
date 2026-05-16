import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Reusable top bar for checkout and shop screens.
///
/// Replaces the duplicated top bar found in:
///   cart_screen, shipping_screen, payment_screen, shop_screen,
///   trader_shop_screen, product_detail_screen
///
/// Estimated lines: ~90
class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  /// Called when the leading back button is tapped.
  /// If null, the back button is hidden.
  final VoidCallback? onBack;

  /// Widgets rendered on the trailing (end) side of the bar.
  final List<Widget> trailingActions;

  /// Height of the bar. Defaults to 60.
  final double barHeight;

  const AppTopBar({
    super.key,
    this.onBack,
    this.trailingActions = const [],
    this.barHeight = 60,
  });

  @override
  Size get preferredSize => Size.fromHeight(barHeight);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final buttonSize = (width * 0.11).clamp(38.0, 46.0);

        return Container(
          height: barHeight,
          width: double.infinity,
          color: AppColors.cream,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // ── Centre: Logo ──────────────────────────────────────
              Center(
                child: Image.asset(
                  'assets/321.png',
                  height: 38,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return const Text(
                      "AL'ARD",
                      style: TextStyle(
                        color: AppColors.olive,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },
                ),
              ),

              // ── Leading: Back Button ──────────────────────────────
              if (onBack != null)
                PositionedDirectional(
                  start: 4,
                  child: IconButton(
                    onPressed: onBack,
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

              // ── Trailing: Action Buttons ──────────────────────────
              if (trailingActions.isNotEmpty)
                PositionedDirectional(
                  end: 4,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: trailingActions,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
