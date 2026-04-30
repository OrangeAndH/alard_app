import 'package:flutter/material.dart';
import 'app_state.dart';
import 'app_state_scope.dart';
import 'cart_screen.dart';
import 'product_detail_screen.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  String _selectedCategory = 'All';
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    final categories = state.productCategories;

    if (!categories.contains(_selectedCategory)) {
      _selectedCategory = 'All';
    }

    final products = state.filteredProducts(
      category: _selectedCategory,
      query: _searchQuery,
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF7F3EE),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(state),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildPromoBanner(),
                    const SizedBox(height: 18),
                    _buildCategoryChips(categories),
                    const SizedBox(height: 18),

                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Product catalog',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF4E5C1E),
                            ),
                          ),
                        ),
                        Text(
                          '${products.length} items',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    if (!state.productsLoaded)
                      const Padding(
                        padding: EdgeInsets.only(bottom: 12),
                        child: Text(
                          'Loading local catalog. Showing backup products for now.',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black45,
                          ),
                        ),
                      ),

                    if (products.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 48),
                        child: Center(
                          child: Text(
                            'No products found',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                      )
                    else
                      GridView.builder(
                        itemCount: products.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 14,
                          crossAxisSpacing: 12,
                          childAspectRatio: 0.67,
                        ),
                        itemBuilder: (context, index) {
                          return _buildProductCard(products[index], state);
                        },
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(AppState state) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Al'Ard Shop",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4E5C1E),
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Authentic Palestinian products',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),

              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const CartScreen(),
                    ),
                  );
                },
                child: Stack(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE9E1D5),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(Icons.shopping_cart_outlined),
                    ),

                    if (state.cartCount > 0)
                      Positioned(
                        right: 0,
                        top: 0,
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
              ),
            ],
          ),

          const SizedBox(height: 14),

          TextField(
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
            decoration: InputDecoration(
              hintText: 'Search products, weights, categories',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: const Color(0xFFF1ECE5),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPromoBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF56632C),
            Color(0xFFCEB04B),
          ],
        ),
      ),
      child: const Text(
        'Serving Palestinian flavors on the world’s table',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          height: 1.25,
        ),
      ),
    );
  }

  Widget _buildCategoryChips(List<String> categories) {
    return SizedBox(
      height: 42,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = _selectedCategory == category;

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedCategory = category;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 18),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF56632C)
                    : const Color(0xFFF1ECE5),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Center(
                child: Text(
                  category,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductCard(Product product, AppState state) {
    final isFav = state.isFavorite(product.id);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductDetailScreen(product: product),
          ),
        ).then((_) => setState(() {}));
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
}