import 'package:flutter/material.dart';

import '../../app_state.dart';
import '../../app_state_scope.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  static const Color _background = Color(0xFFF7F3EE);
  static const Color _cream = Color(0xFFF2EDE6);
  static const Color _olive = Color(0xFF55682A);
  static const Color _heart = Color(0xFF9A1111);

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    final favorites = state.favoriteProducts;
    final fallbackProducts = state.products.take(4).toList();
    final products = favorites.isNotEmpty ? favorites : fallbackProducts;

    return Scaffold(
      backgroundColor: _background,
      bottomNavigationBar: const _ProfileBottomNav(currentIndex: 4),
      body: SafeArea(
        child: Column(
          children: [
            _topBar(context),
            const SizedBox(height: 10),
            const Text(
              'My Favorites',
              style: TextStyle(
                color: Colors.black,
                fontSize: 22,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 14),
            Expanded(
              child: products.isEmpty
                  ? const Center(
                      child: Text(
                        'No favorites yet',
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.fromLTRB(42, 0, 42, 22),
                      itemCount: products.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 18,
                        crossAxisSpacing: 24,
                        childAspectRatio: 0.58,
                      ),
                      itemBuilder: (context, index) {
                        final product = products[index];

                        return _favoriteCard(
                          context,
                          product: product,
                          onHeart: () {
                            state.toggleFavorite(product);
                          },
                          onAdd: () {
                            state.addToCart(product);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content:
                                    Text('${product.name} added to cart'),
                                duration: const Duration(milliseconds: 900),
                              ),
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _topBar(BuildContext context) {
    return Container(
      height: 78,
      color: _cream,
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints.tightFor(
                width: 44,
                height: 44,
              ),
              icon: const Icon(
                Icons.arrow_back_rounded,
                color: Colors.black,
                size: 34,
              ),
            ),
          ),
          Center(
            child: Image.asset(
              'assets/alard_icon.png',
              height: 62,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) {
                return const Text(
                  "AL'ARD",
                  style: TextStyle(
                    color: _olive,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
          ),
          const Align(
            alignment: Alignment.centerRight,
            child: Icon(
              Icons.search_rounded,
              color: Colors.black,
              size: 34,
            ),
          ),
        ],
      ),
    );
  }

  Widget _favoriteCard(
    BuildContext context, {
    required Product product,
    required VoidCallback onHeart,
    required VoidCallback onAdd,
  }) {
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(7),
      ),
      child: Column(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: InkWell(
              onTap: onHeart,
              child: const Icon(
                Icons.favorite,
                color: _heart,
                size: 22,
              ),
            ),
          ),
          Expanded(
            child: Image.asset(
              product.image,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) {
                return const Icon(
                  Icons.image_not_supported_outlined,
                  color: Colors.black38,
                  size: 42,
                );
              },
            ),
          ),
          const SizedBox(height: 6),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              product.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 9,
                fontWeight: FontWeight.w900,
                height: 1.1,
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              product.subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 8,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Regular price',
              style: TextStyle(
                color: Colors.black,
                fontSize: 8,
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              product.displayPrice,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 9,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(height: 5),
          SizedBox(
            height: 22,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onAdd,
              style: ElevatedButton.styleFrom(
                backgroundColor: _olive,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Add To Cart',
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileBottomNav extends StatelessWidget {
  final int currentIndex;

  const _ProfileBottomNav({
    required this.currentIndex,
  });

  static const Color _cream = Color(0xFFF2EDE6);
  static const Color _olive = Color(0xFF55682A);

  @override
  Widget build(BuildContext context) {
    final items = [
      _BottomItem(Icons.home_outlined, 'Home'),
      _BottomItem(Icons.shopping_bag_outlined, 'Shop'),
      _BottomItem(Icons.receipt_long_outlined, 'Recipes', circular: true),
      _BottomItem(Icons.feedback_outlined, 'Feedback'),
      _BottomItem(Icons.person_outline, 'Profile'),
    ];

    return Container(
      height: 74,
      color: _cream,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (index) {
          final item = items[index];
          final active = currentIndex == index;

          return InkWell(
            onTap: () {
              if (index == 4) Navigator.pop(context);
            },
            child: SizedBox(
              width: 58,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: item.circular ? 33 : 30,
                    width: item.circular ? 33 : 30,
                    decoration: item.circular
                        ? BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: active ? _olive : Colors.black,
                              width: 1.4,
                            ),
                          )
                        : null,
                    child: Icon(
                      item.icon,
                      size: item.circular ? 22 : 28,
                      color: active ? _olive : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item.label,
                    style: TextStyle(
                      color: active ? _olive : Colors.black,
                      fontSize: 12,
                      fontWeight: active ? FontWeight.w800 : FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _BottomItem {
  final IconData icon;
  final String label;
  final bool circular;

  const _BottomItem(
    this.icon,
    this.label, {
    this.circular = false,
  });
}