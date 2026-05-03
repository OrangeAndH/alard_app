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
  static const Color _softGreen = Color(0xFFE8EED2);

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
                      child: SingleChildScrollView(
                        padding: EdgeInsets.fromLTRB(
                          horizontalPadding,
                          0,
                          horizontalPadding,
                          18,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildHeroHeader(contentWidth),
                            const SizedBox(height: 8),
                            _buildFilterRow(categories),
                            const SizedBox(height: 10),
                            if (_searchQuery.trim().isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: _buildSearchResultBar(),
                              ),
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
        final logoHeight = (width * 0.11).clamp(28.0, 38.0);
        final iconSize = (width * 0.075).clamp(25.0, 31.0);
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
                  height: logoHeight,
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
                  icon: Icon(
                    Icons.arrow_back_rounded,
                    color: Colors.black,
                    size: iconSize,
                  ),
                ),
              ),
              Positioned(
                right: 4,
                child: Stack(
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
                      icon: Icon(
                        Icons.shopping_cart_outlined,
                        color: Colors.black,
                        size: iconSize - 2,
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
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeroHeader(double contentWidth) {
    final isSmall = contentWidth < 360;

    final titleFont = isSmall ? 31.0 : 36.0;
    final subtitleFont = isSmall ? 9.0 : 10.0;
    final headerHeight = isSmall ? 255.0 : 285.0;
    final imageHeight = isSmall ? 150.0 : 175.0;

    return Container(
      width: double.infinity,
      height: headerHeight,
      color: _background,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 6),
          Text(
            'Our Products',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _olive,
              fontSize: titleFont,
              fontWeight: FontWeight.w900,
              height: 0.95,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            "Al'Ard: Pure Authentic Palestinian\nHeritage - Available Worldwide",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _olive,
              fontSize: subtitleFont,
              fontWeight: FontWeight.w600,
              height: 1.08,
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            height: imageHeight,
            child: Image.asset(
              'assets/shop_screen.png',
              fit: BoxFit.contain,
              errorBuilder: (_, _, _) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  decoration: BoxDecoration(
                    color: _cream,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Image.asset(
                    'assets/photo2.png',
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) {
                      return const Center(
                        child: Icon(
                          Icons.image_not_supported_outlined,
                          color: Colors.black38,
                          size: 36,
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterRow(List<String> categories) {
    return Row(
      children: [
        Expanded(
          child: _smallFilterButton(
            icon: Icons.filter_alt_outlined,
            label: _selectedCategory == 'All'
                ? 'Filter by Product Category'
                : _selectedCategory,
            onTap: () => _showCategoryPicker(categories),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _smallFilterButton(
            icon: Icons.language_rounded,
            label: _selectedCountry,
            onTap: _showCountryPicker,
          ),
        ),
      ],
    );
  }

  Widget _smallFilterButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      height: 24,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          side: const BorderSide(color: Colors.black87, width: 0.8),
          foregroundColor: Colors.black,
          backgroundColor: Colors.white.withOpacity(0.76),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 12),
            const SizedBox(width: 3),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 8.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResultBar() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: _cream,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _olive.withOpacity(0.35),
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.search_rounded,
            color: _olive,
            size: 17,
          ),
          const SizedBox(width: 7),
          Expanded(
            child: Text(
              'Showing results for "$_searchQuery"',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: _olive,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          InkWell(
            onTap: _clearFilters,
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              child: Text(
                'Clear',
                style: TextStyle(
                  color: _olive,
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
        ],
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
    final quantity = _quantityForProduct(state, product);

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
          color: Colors.white.withOpacity(0.78),
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
                  color: Colors.black.withOpacity(0.75),
                  fontSize: titleFont - 1,
                  height: 1.0,
                ),
              ),
            ],
            const SizedBox(height: 2),
            Text(
              product.displayPrice,
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
            const SizedBox(height: 4),
            _quantityControls(
              state: state,
              product: product,
              quantity: quantity,
            ),
            const SizedBox(height: 5),
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

  Widget _quantityControls({
    required AppState state,
    required Product product,
    required int quantity,
  }) {
    return SizedBox(
      height: 18,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _tinyQtyButton(
            label: '-',
            onTap: quantity > 0
                ? () {
                    state.decreaseQuantity(product.id);
                    setState(() {});
                  }
                : null,
          ),
          Container(
            height: 16,
            width: 28,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: _softGreen,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              quantity.toString(),
              style: const TextStyle(
                color: Colors.black,
                fontSize: 9,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          _tinyQtyButton(
            label: '+',
            onTap: () {
              state.addToCart(product);
              setState(() {});
            },
          ),
        ],
      ),
    );
  }

  Widget _tinyQtyButton({
    required String label,
    required VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        height: 16,
        width: 18,
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: onTap == null ? Colors.black26 : Colors.black,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  int _quantityForProduct(AppState state, Product product) {
    for (final item in state.cartItems) {
      if (item.product.id == product.id) {
        return item.quantity;
      }
    }
    return 0;
  }

  void _showCategoryPicker(List<String> categories) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return SafeArea(
          top: false,
          child: Container(
            margin: const EdgeInsets.fromLTRB(14, 0, 14, 12),
            padding: const EdgeInsets.fromLTRB(14, 16, 14, 16),
            decoration: BoxDecoration(
              color: _cream,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Filter by Product Category',
                  style: TextStyle(
                    color: _olive,
                    fontSize: 18,
                    fontFamily: 'serif',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                Flexible(
                  child: SingleChildScrollView(
                    child: Column(
                      children: categories.map((category) {
                        final isSelected = _selectedCategory == category;

                        return InkWell(
                          onTap: () {
                            setState(() {
                              _selectedCategory = category;
                            });
                            Navigator.pop(sheetContext);
                          },
                          borderRadius: BorderRadius.circular(9),
                          child: Container(
                            height: 40,
                            margin: const EdgeInsets.only(bottom: 6),
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color:
                                  isSelected ? _background : Colors.transparent,
                              border: Border.all(
                                color: _olive,
                                width: isSelected ? 1.2 : 0.7,
                              ),
                              borderRadius: BorderRadius.circular(9),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    category,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: _olive,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                if (isSelected)
                                  const Icon(
                                    Icons.check_rounded,
                                    color: _olive,
                                    size: 20,
                                  ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showCountryPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return SafeArea(
          top: false,
          child: Container(
            margin: const EdgeInsets.fromLTRB(14, 0, 14, 12),
            padding: const EdgeInsets.fromLTRB(14, 16, 14, 16),
            decoration: BoxDecoration(
              color: _cream,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Select Country',
                  style: TextStyle(
                    color: _olive,
                    fontSize: 18,
                    fontFamily: 'serif',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                ..._countries.map((country) {
                  final isSelected = _selectedCountry == country['name'];

                  return InkWell(
                    onTap: () {
                      setState(() {
                        _selectedCountry = country['name']!;
                      });
                      Navigator.pop(sheetContext);
                    },
                    borderRadius: BorderRadius.circular(9),
                    child: Container(
                      height: 40,
                      margin: const EdgeInsets.only(bottom: 6),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: isSelected ? _background : Colors.transparent,
                        border: Border.all(
                          color: _olive,
                          width: isSelected ? 1.2 : 0.7,
                        ),
                        borderRadius: BorderRadius.circular(9),
                      ),
                      child: Row(
                        children: [
                          Text(
                            country['flag']!,
                            style: const TextStyle(fontSize: 18),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              country['name']!,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: _olive,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          if (isSelected)
                            const Icon(
                              Icons.check_rounded,
                              color: _olive,
                              size: 20,
                            ),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  void _clearFilters() {
    setState(() {
      _selectedCategory = 'All';
      _searchQuery = '';
      _searchController.clear();
    });
  }
}