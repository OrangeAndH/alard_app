import 'package:flutter/material.dart';

import 'Discover_our_Story.dart';
import 'app_state.dart';
import 'app_state_scope.dart';
import 'cart_screen.dart';
import 'product_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);

    final whyAlardItems = [
      {
        'title': '100% Natural',
        'desc':
            'All products are made from natural Palestinian ingredients without artificial additives.',
        'icon': Icons.eco_outlined,
      },
      {
        'title': 'Premium Olive Oil',
        'desc':
            'High-quality extra virgin olive oil sourced from traditional Palestinian olive trees.',
        'icon': Icons.opacity_outlined,
      },
      {
        'title': 'Support Palestinian Farmers',
        'desc':
            'Every purchase helps support local farmers and strengthens the Palestinian agricultural community.',
        'icon': Icons.people_alt_outlined,
      },
      {
        'title': 'Authentic Palestinian Taste',
        'desc':
            "Traditional recipes like za'atar, sumac, and olive oil that represent the rich heritage of Palestine.",
        'icon': Icons.restaurant_menu_outlined,
      },
      {
        'title': 'Eco-Friendly Production',
        'desc':
            'Products are produced using sustainable and environmentally friendly practices.',
        'icon': Icons.recycling_outlined,
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF7F3EE),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTopBar(context, state),
              const SizedBox(height: 8),
              _buildHeroSection(context),
              const SizedBox(height: 18),

              _buildSectionTitle('Featured Products'),
              const SizedBox(height: 12),
              _buildProductsGrid(context, state),

              const SizedBox(height: 22),
              _buildSectionTitle("Why Al'Ard?"),
              const SizedBox(height: 12),
              _buildWhyAlardList(whyAlardItems),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context, AppState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.menu, size: 28),
          ),
          const Spacer(),
          Image.asset(
            'assets/alard_icon.png',
            height: 50,
            errorBuilder: (context, error, stackTrace) {
              return const Text(
                "AL'ARD",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF5D6B1F),
                ),
              );
            },
          ),
          const Spacer(),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search, size: 28),
          ),
          Stack(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CartScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.shopping_cart_outlined, size: 28),
              ),
              if (state.cartCount > 0)
                Positioned(
                  right: 4,
                  top: 4,
                  child: CircleAvatar(
                    radius: 9,
                    backgroundColor: const Color(0xFF7A8D2F),
                    child: Text(
                      state.cartCount.toString(),
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: SizedBox(
          height: 170,
          width: double.infinity,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                'assets/photo2.png',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(color: const Color(0xFFD8D2C8));
                },
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.12),
                      Colors.black.withOpacity(0.28),
                    ],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "From Palestine's ancient\nolive trees, we offer products\nto elevate your dishes",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 19,
                        fontWeight: FontWeight.w700,
                        height: 1.25,
                      ),
                    ),
                    const SizedBox(height: 14),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const DiscoverOurStory(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFCEB04B),
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                      ),
                      child: const Text('Discover our Story'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 23,
          fontWeight: FontWeight.bold,
          color: Color(0xFF4E5C1E),
        ),
      ),
    );
  }

  Widget _buildProductsGrid(BuildContext context, AppState state) {
    final products = state.products;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: GridView.builder(
        itemCount: products.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 14,
          crossAxisSpacing: 12,
          childAspectRatio: 0.67,
        ),
        itemBuilder: (context, index) {
          final product = products[index];
          return _buildHomeProductCard(context, product, state);
        },
      ),
    );
  }

  Widget _buildHomeProductCard(
    BuildContext context,
    Product product,
    AppState state,
  ) {
    final isFav = state.isFavorite(product.id);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductDetailScreen(product: product),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xFFF3EFE8),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Center(
                    child: Hero(
                      tag: product.id,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Image.asset(
                          product.image,
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) => const Icon(
                            Icons.image,
                            size: 50,
                            color: Colors.black26,
                          ),
                        ),
                      ),
                    ),
                  ),

                  if (isFav)
                    Positioned(
                      top: 4,
                      right: 4,
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.favorite_rounded,
                          size: 16,
                          color: Color(0xFFD64F4F),
                        ),
                      ),
                    ),

                  if (product.isBestSeller)
                    Positioned(
                      top: 4,
                      left: 4,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFCEB04B),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'Best',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            Text(
              product.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),

            Text(
              product.subtitle,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black54,
              ),
            ),

            const SizedBox(height: 8),

            Row(
              children: [
                const Icon(
                  Icons.star_rounded,
                  color: Color(0xFFCEB04B),
                  size: 18,
                ),
                const SizedBox(width: 4),
                Text(product.rating.toString()),
                const Spacer(),
                Flexible(
                  child: Text(
                    product.displayPrice,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.end,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF56632C),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFE5ECCC),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.touch_app_rounded,
                    size: 15,
                    color: Color(0xFF56632C),
                  ),
                  SizedBox(width: 5),
                  Text(
                    'View Details',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF56632C),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWhyAlardList(List<Map<String, dynamic>> items) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: items.map((item) {
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFF1EDE6),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE4EAD0),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    item['icon'] as IconData,
                    color: const Color(0xFF6B7A2B),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['title'] as String,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item['desc'] as String,
                        style: const TextStyle(
                          fontSize: 13,
                          height: 1.3,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}