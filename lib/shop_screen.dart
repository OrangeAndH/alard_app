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
    {'name': 'store_Palestine', 'flag': '🇵🇸'},
    {'name': 'store_Germany', 'flag': '🇩🇪'},
    {'name': 'store_USA', 'flag': '🇺🇸'},
    {'name': 'store_UK', 'flag': '🇬🇧'},
    {'name': 'store_UAE', 'flag': '🇦🇪'},
    {'name': 'store_KSA', 'flag': '🇸🇦'},
    {'name': 'store_France', 'flag': '🇫🇷'},
    {'name': 'store_Canada', 'flag': '🇨🇦'},
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
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Text(
                                  state.t('shop_catalog_loading_backup'),
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
                                      Text(
                                        state.t('shop_no_products'),
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.black54,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      TextButton(
                                        onPressed: _clearFilters,
                                        child: Text(
                                          state.t('shop_show_all'),
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
              PositionedDirectional(
                start: 4,
                child: IconButton(
                  onPressed: _goBackToHome,
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
              PositionedDirectional(
                end: 4,
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
                      icon: const Icon(
                        Icons.shopping_cart_outlined,
                        color: Colors.black,
                        size: 28,
                      ),
                    ),
                    if (state.cartCount > 0)
                      PositionedDirectional(
                        end: 2,
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
    final state = AppStateScope.of(context);
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
            state.t('home_our_products'),
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
            state.t('shop_heritage_subtitle'),
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
    final state = AppStateScope.of(context);
    return Row(
      children: [
        Expanded(
          child: _smallFilterButton(
            icon: Icons.filter_alt_outlined,
            label: _selectedCategory == 'All'
                ? state.t('shop_filter_category')
                : state.t(_selectedCategory),
            onTap: () => _showCategoryPicker(categories),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _smallFilterButton(
            icon: Icons.language_rounded,
            label: state.t(_selectedCountry),
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
          backgroundColor: Colors.white.withValues(alpha: 0.76),
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
    final state = AppStateScope.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: _cream,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _olive.withValues(alpha: 0.35),
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
              '${state.t('shop_showing_results')} "$_searchQuery"',
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
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              child: Text(
                state.t('shop_clear'),
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
          color: Colors.white,
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
                    PositionedDirectional(
                      start: 0,
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
                        child: Text(
                          state.t('shop_best'),
                          style: const TextStyle(
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
              state.t(product.name),
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
                state.t(product.subtitle),
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
            Text(
              state.t('shop_regular_price'),
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
                      content: Text(state.t('product_added_to_cart')),
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
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    state.t('shop_add_to_cart'),
                    style: const TextStyle(
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



  void _showCategoryPicker(List<String> categories) {
    final state = AppStateScope.of(context);
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
                Text(
                  state.t('shop_filter_category'),
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
                                    state.t(category),
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
    final state = AppStateScope.of(context);
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
                Text(
                  state.t('home_change_location'),
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
                              state.t(country['name']!),
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