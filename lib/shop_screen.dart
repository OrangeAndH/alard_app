import 'package:flutter/material.dart';

import 'app_state.dart';
import 'app_state_scope.dart';
import 'cart_screen.dart';
import 'product_detail_screen.dart';

class ShopScreen extends StatefulWidget {
  final String initialCategory;
  final String initialQuery;
  final VoidCallback? onGoHome;

  const ShopScreen({
    super.key,
    this.initialCategory = 'All',
    this.initialQuery = '',
    this.onGoHome,
  });

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  static const Color _background = Color(0xFFF7F3EE);
  static const Color _cream = Color(0xFFF2EDE6);
  static const Color _olive = Color(0xFF55682A);
  static const Color _gold = Color(0xFFE0A323);


  late String _selectedCategory;
  late String _searchQuery;
  late TextEditingController _searchController;

  String _selectedCountry = 'Palestine';

  final List<Map<String, String>> _countries = const [
    {'name': 'Palestine', 'flag': '🇵🇸'},
    {'name': 'Germany', 'flag': '🇩🇪'},
    {'name': 'United States', 'flag': '🇺🇸'},
    {'name': 'United Kingdom', 'flag': '🇬🇧'},
    {'name': 'United Arab Emirates', 'flag': '🇦🇪'},
    {'name': 'Saudi Arabia', 'flag': '🇸🇦'},
    {'name': 'France', 'flag': '🇫🇷'},
    {'name': 'Canada', 'flag': '🇨🇦'},
  ];

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.initialCategory;
    _searchQuery = widget.initialQuery;
    _searchController = TextEditingController(text: _searchQuery);
  }

  @override
  void didUpdateWidget(covariant ShopScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.initialCategory != widget.initialCategory ||
        oldWidget.initialQuery != widget.initialQuery) {
      setState(() {
        _selectedCategory = widget.initialCategory;
        _searchQuery = widget.initialQuery;
        _searchController.text = _searchQuery;
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _goBackToHome() {
    if (widget.onGoHome != null) {
      widget.onGoHome!();
      return;
    }

    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

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
      backgroundColor: _background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final pageWidth = constraints.maxWidth;
            final contentWidth = pageWidth > 430 ? 430.0 : pageWidth;
            final horizontalPadding = contentWidth < 360 ? 8.0 : 10.0;

            return Center(
              child: SizedBox(
                width: contentWidth,
                child: Column(
                  children: [
                    _buildTopBar(context, state),
                    Expanded(
                      child: RefreshIndicator(
                        color: _olive,
                        backgroundColor: _cream,
                        onRefresh: () async {
                          // Simulate network delay for frontend UX
                          await Future.delayed(const Duration(seconds: 1));
                          setState(() {});
                        },
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                        padding: EdgeInsets.fromLTRB(
                          horizontalPadding,
                          0,
                          horizontalPadding,
                          18,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 10),
                            _buildSearchBar(),
                            const SizedBox(height: 12),
                            _buildAvailabilityText(),
                            const SizedBox(height: 16),
                            _buildTrendingSearches(),
                            const SizedBox(height: 16),
                            _buildCategoriesRow(categories),
                            const SizedBox(height: 16),
                            if (!state.productsLoaded)
                              const Padding(
                                padding: EdgeInsets.only(bottom: 8),
                                child: Text(
                                  'Loading local catalog. Showing backup products for now.',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.black45,
                                  ),
                                ),
                              ),
                            if (products.isEmpty)
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 48),
                                child: Center(
                                  child: Column(
                                    children: [
                                      const Icon(
                                        Icons.search_off_rounded,
                                        size: 46,
                                        color: Colors.black38,
                                      ),
                                      const SizedBox(height: 10),
                                      const Text(
                                        'No products found',
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.black54,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      TextButton(
                                        onPressed: _clearFilters,
                                        child: const Text(
                                          'Show all products',
                                          style: TextStyle(
                                            color: _olive,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            else
                              _buildProductsWrap(
                                context: context,
                                state: state,
                                products: products,
                                contentWidth: contentWidth,
                              ),
                          ],
                        ),
                      ),
                    ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context, AppState state) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        final barHeight = (width * 0.16).clamp(56.0, 70.0);
        final buttonSize = (width * 0.11).clamp(38.0, 46.0);

        return Container(
          height: barHeight,
          width: double.infinity,
          color: _cream,
          child: Stack(
            alignment: Alignment.center,
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
                        color: _olive,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },
                ),
              ),
              Positioned(
                left: 4,
                child: IconButton(
                  onPressed: _goBackToHome,
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints.tightFor(
                    width: buttonSize,
                    height: buttonSize,
                  ),
                  icon: const Icon(
                    Icons.menu,
                    color: _olive,
                    size: 34,
                  ),
                ),
              ),
              Positioned(
                right: 4,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {},
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints.tightFor(
                        width: buttonSize,
                        height: buttonSize,
                      ),
                      icon: const Icon(
                        Icons.search_rounded,
                        color: Colors.black,
                        size: 28,
                      ),
                    ),
                    Stack(
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const CartScreen(),
                              ),
                            );
                          },
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints.tightFor(
                            width: buttonSize,
                            height: buttonSize,
                          ),
                          icon: const Icon(
                            Icons.shopping_cart_outlined,
                            color: Colors.black,
                            size: 28,
                          ),
                        ),
                        if (state.cartCount > 0)
                          Positioned(
                            right: 2,
                            top: 4,
                            child: Container(
                              height: 16,
                              width: 16,
                              alignment: Alignment.center,
                              decoration: const BoxDecoration(
                                color: _olive,
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                state.cartCount.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: _background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _olive, width: 1.0),
      ),
      child: Row(
        children: [
          const SizedBox(width: 12),
          const Icon(Icons.search, color: Colors.black, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'search for products...',
                hintStyle: TextStyle(color: Colors.black54, fontSize: 16),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              onChanged: (val) {
                setState(() {
                  _searchQuery = val;
                });
              },
            ),
          ),
          const Icon(Icons.mic_none, color: Colors.black, size: 22),
          const SizedBox(width: 12),
        ],
      ),
    );
  }

  Widget _buildAvailabilityText() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Available in Germany, United Kingdom, France, Canada, USA',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        SizedBox(width: 4),
        Icon(Icons.arrow_forward_ios, size: 10, color: Colors.black87),
      ],
    );
  }

  Widget _buildTrendingSearches() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tending Searches',
          style: TextStyle(
            color: _olive,
            fontSize: 15,
            fontWeight: FontWeight.w600,
            fontFamily: 'serif',
          ),
        ),
        const SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _trendingChip('Olive Oil'),
              const SizedBox(width: 12),
              _trendingChip('Zaatar'),
              const SizedBox(width: 12),
              _trendingChip('organic products'),
              const SizedBox(width: 12),
              _trendingChip('Gifts'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _trendingChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: _background,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 3,
            offset: Offset(0, 1),
          ),
          BoxShadow(
            color: Colors.white,
            blurRadius: 3,
            offset: Offset(-1, -1),
          ),
        ],
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: _olive,
          fontSize: 13,
        ),
      ),
    );
  }

  Widget _buildCategoriesRow(List<String> categories) {
    final displayCategories = categories.where((c) => c != 'All').toList();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: displayCategories.map((cat) {
          final isSelected = _selectedCategory == cat || (cat == 'Oil' && _selectedCategory == 'All');

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedCategory = cat;
                _searchQuery = '';
                _searchController.clear();
              });
            },
            child: Container(
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? _olive : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Text(
                    cat,
                    style: TextStyle(
                      color: isSelected ? Colors.white : _olive,
                      fontSize: 15,
                      fontFamily: 'serif',
                    ),
                  ),
                  if (cat == 'Organic') ...[
                    const SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 12,
                      color: isSelected ? Colors.white : _olive,
                    ),
                  ],
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildProductsWrap({
    required BuildContext context,
    required AppState state,
    required List<Product> products,
    required double contentWidth,
  }) {
    final spacing = contentWidth < 360 ? 8.0 : 10.0;
    final cardWidth = (contentWidth - 20 - spacing) / 2;

    return Wrap(
      spacing: spacing,
      runSpacing: 12,
      children: products.map((product) {
        return SizedBox(
          width: cardWidth,
          child: _buildProductCard(
            context: context,
            state: state,
            product: product,
            cardWidth: cardWidth,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildProductCard({
    required BuildContext context,
    required AppState state,
    required Product product,
    required double cardWidth,
  }) {

    final imageHeight = (cardWidth * 0.70).clamp(70.0, 112.0);
    final titleFont = cardWidth < 160 ? 8.2 : 9.2;
    final priceFont = cardWidth < 160 ? 8.2 : 8.8;

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductDetailScreen(product: product),
          ),
        ).then((_) => setState(() {}));
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.fromLTRB(6, 6, 6, 7),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.78),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            SizedBox(
              height: imageHeight,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Hero(
                      tag: product.id,
                      child: Image.asset(
                        product.image,
                        fit: BoxFit.contain,
                        errorBuilder: (_, _, _) {
                          return const Icon(
                            Icons.image_not_supported_outlined,
                            color: Colors.black38,
                            size: 34,
                          );
                        },
                      ),
                    ),
                  ),
                  if (product.isBestSeller)
                    Positioned(
                      left: 0,
                      top: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: _gold,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'Best',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 7,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              product.name,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.black,
                fontSize: titleFont,
                fontWeight: FontWeight.w800,
                height: 1.05,
              ),
            ),
            if (product.subtitle.trim().isNotEmpty) ...[
              const SizedBox(height: 1),
              Text(
                product.subtitle,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.black.withValues(alpha: 0.75),
                  fontSize: titleFont - 1,
                  height: 1.0,
                ),
              ),
            ],
            const SizedBox(height: 2),
            Text(
              state.getFormattedPrice(product.price),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.black,
                fontSize: priceFont,
                fontWeight: FontWeight.w800,
                height: 1.0,
              ),
            ),
            const SizedBox(height: 2),
            const Text(
              'regular price',
              style: TextStyle(
                color: Colors.black45,
                fontSize: 7,
                height: 1.0,
              ),
            ),

            SizedBox(
              width: double.infinity,
              height: 24,
              child: ElevatedButton(
                onPressed: () {
                  state.addToCart(product);
                  setState(() {});
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${product.name} added to cart'),
                      duration: const Duration(milliseconds: 800),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _olive,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    'ADD TO CART',
                    style: TextStyle(
                      fontSize: 8.5,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }



  // Removed modal pickers to match the new UI.

  void _clearFilters() {
    setState(() {
      _selectedCategory = 'All';
      _searchQuery = '';
      _searchController.clear();
    });
  }
}