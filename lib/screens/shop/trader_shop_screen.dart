import 'package:flutter/material.dart';

import '../../state/app_state.dart';
import '../../state/app_state_scope.dart';
import '../checkout/cart_screen.dart';
import 'product_detail_screen.dart';

class TraderShopScreen extends StatefulWidget {
  final String initialCategory;
  final String initialQuery;
  final VoidCallback? onGoHome;

  const TraderShopScreen({
    super.key,
    this.initialCategory = 'All',
    this.initialQuery = '',
    this.onGoHome,
  });

  @override
  State<TraderShopScreen> createState() => _TraderShopScreenState();
}

class _TraderShopScreenState extends State<TraderShopScreen> {
  static const Color _background = Color(0xFFF7F3EE);
  static const Color _cream = Color(0xFFF2EDE6);
  static const Color _olive = Color(0xFF55682A);
  static const Color _gold = Color(0xFFE0A323);


  late String _selectedCategory;
  late String _searchQuery;
  late TextEditingController _searchController;
  bool _isSearching = false;



  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.initialCategory;
    _searchQuery = widget.initialQuery;
    _searchController = TextEditingController(text: _searchQuery);
  }

  @override
  void didUpdateWidget(covariant TraderShopScreen oldWidget) {
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
                            if (_isSearching) ...[
                              _buildSearchBar(),
                              const SizedBox(height: 12),
                            ],
                            _buildAvailabilityText(),
                            const SizedBox(height: 16),
                            _buildCategoriesRow(categories),
                            const SizedBox(height: 16),
                            if (!state.productsLoaded)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Text(
                                  state.t('shop_catalog_loading_backup'),
                                  style: const TextStyle(
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
                                        style: const TextStyle(
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
    final barHeight = 60.0;
    final buttonSize = 42.0;

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
                  onPressed: () => _showHomeMenu(context),
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
              PositionedDirectional(
                end: 4,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _isSearching = !_isSearching;
                        });
                      },
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints.tightFor(
                        width: buttonSize,
                        height: buttonSize,
                      ),
                      icon: Icon(
                        _isSearching ? Icons.close_rounded : Icons.search_rounded,
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
                  ],
                ),
              ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 38,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(19),
                border: Border.all(color: _olive, width: 1.2),
              ),
              child: TextField(
                controller: _searchController,
                textAlignVertical: TextAlignVertical.center,
                style: const TextStyle(color: Colors.black, fontSize: 14),
                decoration: InputDecoration(
                  hintText: AppStateScope.of(context).t('shop_search_hint'),
                  hintStyle: const TextStyle(color: Colors.black54, fontSize: 14),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14),
                ),
                onChanged: (val) {
                  setState(() {
                    _searchQuery = val;
                  });
                },
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }

  Widget _buildAvailabilityText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          AppStateScope.of(context).t('shop_available_in'),
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(width: 4),
        Icon(Icons.adaptive.arrow_forward, size: 10, color: Colors.black87),
      ],
    );
  }


  Widget _buildCategoriesRow(List<String> categories) {
    final state = AppStateScope.of(context);
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
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? _olive : Colors.white,
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
                border: isSelected ? null : Border.all(color: _olive.withValues(alpha: 0.2)),
              ),
              child: Row(
                children: [
                  Text(
                    state.t(cat),
                    style: TextStyle(
                      color: isSelected ? Colors.white : _olive,
                      fontSize: 14,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                    ),
                  ),
                  if (cat == 'Organic') ...[
                    const SizedBox(width: 4),
                    Icon(
                      Icons.adaptive.arrow_forward,
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
            builder: (_) => ProductDetailScreen(
              product: product,
              heroTag: 'trader_shop_${product.id}',
            ),
          ),
        ).then((_) {
          if (mounted) setState(() {});
        });
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
                      tag: 'trader_shop_${product.id}',
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProductDetailScreen(product: product),
                    ),
                  ).then((_) {
                    if (mounted) setState(() {});
                  });
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
                    state.t('home_view_details'),
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

  void _clearFilters() {
    setState(() {
      _selectedCategory = 'All';
      _searchQuery = '';
      _searchController.clear();
    });
  }

  void _showHomeMenu(BuildContext context) {
    final state = AppStateScope.of(context);
    final menuItems = [
      {'title': state.t('menu_home'), 'category': 'All', 'query': '', 'closeOnly': true},
      {'title': state.t('menu_gifts'), 'category': 'Gift Boxes', 'query': ''},
      {'title': state.t('menu_olive_oil'), 'category': 'Olive Oil', 'query': ''},
      {'title': state.t('menu_pickled_olives'), 'category': 'Pickles', 'query': 'olive'},
      {'title': state.t('menu_cheese'), 'category': 'Dairy', 'query': 'Nabulsi Cheese'},
      {'title': state.t('menu_herbs'), 'category': 'Herbs & Spices', 'query': ''},
      {'title': state.t('menu_tahini'), 'category': 'Tahini & Halawa', 'query': 'tahini'},
      {'title': state.t('menu_hot_sauce'), 'category': 'Herbs & Spices', 'query': 'chili'},
      {'title': state.t('menu_grains'), 'category': 'Grains', 'query': ''},
      {'title': state.t('menu_black_seed'), 'category': 'Natural Products', 'query': 'black seed'},
      {'title': state.t('menu_soap'), 'category': 'Soap & Care', 'query': ''},
    ];

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: state.t('home_menu_barrier'),
      barrierColor: Colors.black.withValues(alpha: 0.15),
      transitionDuration: const Duration(milliseconds: 180),
      pageBuilder: (dialogContext, animation, secondaryAnimation) {
        return Align(
          alignment: AlignmentDirectional.centerStart,
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.86,
              height: double.infinity,
              color: _background,
              child: SafeArea(
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: menuItems.length,
                  itemBuilder: (context, index) {
                    final item = menuItems[index];
                    final isHeader = index == 0;

                    return InkWell(
                      onTap: () {
                        Navigator.pop(dialogContext);

                        if (item['closeOnly'] == true) return;

                        setState(() {
                          _selectedCategory = item['category'] as String;
                          _searchQuery = item['query'] as String;
                          _searchController.text = _searchQuery;
                        });
                      },
                      child: Container(
                        height: isHeader ? 53 : 56,
                        width: double.infinity,
                        color: isHeader
                            ? const Color(0xFFEDE5DD)
                            : _background,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        alignment: AlignmentDirectional.centerStart,
                        child: Text(
                          item['title'] as String,
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.black87,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(-1, 0),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );
      },
    );
  }
}