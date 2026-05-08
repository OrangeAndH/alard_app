import 'package:flutter/material.dart';

import 'app_state_scope.dart';
import 'feedback_screen.dart';
import 'home_screen.dart';
import 'profiles/profile_screen.dart';
import 'recipes_screen.dart';
import 'shop_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  String _shopCategory = 'All';
  String _shopQuery = '';
  int _shopRefreshKey = 0;

  void _goToHome() {
    setState(() {
      _selectedIndex = 0;
    });
  }

  void _goToShop({
    String category = 'All',
    String query = '',
  }) {
    setState(() {
      _shopCategory = category;
      _shopQuery = query;
      _shopRefreshKey++;
      _selectedIndex = 1;
    });
  }

  Widget _buildCurrentPage() {
    return IndexedStack(
      index: _selectedIndex,
      children: [
        HomeScreen(
          onGoToShopFilter: _goToShop,
        ),
        ShopScreen(
          key: ValueKey('shop-$_shopRefreshKey-$_shopCategory-$_shopQuery'),
          initialCategory: _shopCategory,
          initialQuery: _shopQuery,
          onGoHome: _goToHome,
        ),
        const RecipesScreen(),
        FeedbackScreen(
          onGoHome: _goToHome,
        ),
        const ProfileScreen(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final state = AppStateScope.of(context);

    return Scaffold(
      body: _buildCurrentPage(),
      bottomNavigationBar: Container(
        height: 85,
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
            _buildNavItem(
              index: 0,
              icon: Icons.home_outlined,
              activeIcon: Icons.home,
              label: state.t('nav_home'),
            ),
            _buildNavItem(
              index: 1,
              icon: Icons.shopping_bag_outlined,
              activeIcon: Icons.shopping_bag,
              label: state.t('nav_shop'),
            ),
            _buildImageNavItem(
              index: 2,
              imagePath: 'assets/recipes.png',
              label: state.t('nav_recipes'),
            ),
            _buildNavItem(
              index: 3,
              icon: Icons.feedback_outlined,
              activeIcon: Icons.feedback,
              label: state.t('nav_feedback'),
            ),
            _buildNavItem(
              index: 4,
              icon: Icons.person_outline,
              activeIcon: Icons.person,
              label: state.t('nav_profile'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
  }) {
    final theme = Theme.of(context);
    final isSelected = _selectedIndex == index;
    final isDark = theme.brightness == Brightness.dark;

    final selectedColor = theme.colorScheme.primary;
    final unselectedColor = isDark ? Colors.white70 : Colors.black87;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;

          if (index == 1) {
            _shopCategory = 'All';
            _shopQuery = '';
            _shopRefreshKey++;
          }
        });
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

  Widget _buildImageNavItem({
    required int index,
    required String imagePath,
    required String label,
  }) {
    final theme = Theme.of(context);
    final isSelected = _selectedIndex == index;
    final isDark = theme.brightness == Brightness.dark;

    final selectedColor = theme.colorScheme.primary;
    final unselectedColor = isDark ? Colors.white70 : Colors.black87;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
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
                    Icons.restaurant_menu,
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