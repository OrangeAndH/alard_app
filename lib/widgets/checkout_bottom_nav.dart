import 'package:flutter/material.dart';

import '../../state/app_state_scope.dart';

/// Shared bottom nav bar used on the ReviewScreen checkout flow.
/// It allows the user to navigate to any main tab from within checkout.
/// Estimated lines: ~80
class CheckoutBottomNav extends StatelessWidget {
  const CheckoutBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
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
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
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
            context: context,
            label: state.t('nav_home'),
            icon: Icons.home_outlined,
            activeIcon: Icons.home,
            index: 0,
            selectedColor: selectedColor,
            unselectedColor: unselectedColor,
          ),
          _navItem(
            context: context,
            label: state.t('nav_shop'),
            icon: Icons.shopping_bag_outlined,
            activeIcon: Icons.shopping_bag,
            index: 1,
            selectedColor: selectedColor,
            unselectedColor: unselectedColor,
          ),
          _imageNavItem(
            context: context,
            label: state.t('nav_recipes'),
            imagePath: 'assets/recipes.png',
            index: 2,
            selectedColor: selectedColor,
            unselectedColor: unselectedColor,
          ),
          _navItem(
            context: context,
            label: state.t('nav_feedback'),
            icon: Icons.feedback_outlined,
            activeIcon: Icons.feedback,
            index: 3,
            selectedColor: selectedColor,
            unselectedColor: unselectedColor,
          ),
          _navItem(
            context: context,
            label: state.t('nav_profile'),
            icon: Icons.person_outline,
            activeIcon: Icons.person,
            index: 4,
            selectedColor: selectedColor,
            unselectedColor: unselectedColor,
          ),
        ],
      ),
    );
  }

  Widget _navItem({
    required BuildContext context,
    required String label,
    required IconData icon,
    required IconData activeIcon,
    required int index,
    required Color selectedColor,
    required Color unselectedColor,
  }) {
    final state = AppStateScope.of(context);
    final isSelected = state.selectedIndex == index;
    return GestureDetector(
      onTap: () {
        state.setSelectedIndex(index);
        Navigator.popUntil(context, (route) => route.isFirst);
      },
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
    required BuildContext context,
    required String label,
    required String imagePath,
    required int index,
    required Color selectedColor,
    required Color unselectedColor,
  }) {
    final state = AppStateScope.of(context);
    final isSelected = state.selectedIndex == index;
    return GestureDetector(
      onTap: () {
        state.setSelectedIndex(index);
        Navigator.popUntil(context, (route) => route.isFirst);
      },
      child: SizedBox(
        width: 70,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(2),
              decoration: isSelected
                  ? BoxDecoration(
                      border: Border.all(color: selectedColor, width: 1.5),
                      borderRadius: BorderRadius.circular(10),
                    )
                  : null,
              child: Image.asset(
                imagePath,
                width: 28,
                height: 28,
                fit: BoxFit.contain,
                errorBuilder: (_, _, _) => Icon(
                  Icons.restaurant_rounded,
                  color: isSelected ? selectedColor : unselectedColor,
                  size: 28,
                ),
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
