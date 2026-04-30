import 'package:flutter/material.dart';

import 'Discover_our_Story.dart';
import 'app_state.dart';
import 'app_state_scope.dart';
import 'cart_screen.dart';
import 'product_detail_screen.dart';
import 'shop_screen.dart';
import 'why_alard_screen.dart';

class HomeScreen extends StatefulWidget {
  final void Function({
    String category,
    String query,
  })? onGoToShopFilter;

  const HomeScreen({
    super.key,
    this.onGoToShopFilter,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedStore = 'Germany';

  static const Color _background = Color(0xFFF7F3EE);
  static const Color _cream = Color(0xFFF2EDE6);
  static const Color _olive = Color(0xFF55682A);
  static const Color _locationGreen = Color(0xFFA5BA1E);
  static const Color _gold = Color(0xFFD6B341);
  static const Color _darkBlue = Color(0xFF0E1A39);
  static const Color _softBorder = Color(0xFFE6DED2);
  static const Color _whyFrameBackground = Color(0xFFF1E9DE);

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    final products = _homeProducts(state.products);

    return Scaffold(
      backgroundColor: _background,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(context, state),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeroSection(context),
                    _buildLocationBar(context),
                    const SizedBox(height: 8),
                    _buildSectionHeader(
                      title: 'Our Products',
                      onTap: () {
                        _goToShopFilter(
                          category: 'All',
                          query: '',
                        );
                      },
                    ),
                    const SizedBox(height: 6),
                    _buildProductsRow(context, products),
                    const SizedBox(height: 12),
                    _buildSectionHeader(
                      title: "Why Al'Ard ?",
                      onTap: _goToWhyAlard,
                    ),
                    const SizedBox(height: 6),
                    _buildWhyAlardFrame(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _goToShopFilter({
    required String category,
    required String query,
  }) {
    if (widget.onGoToShopFilter != null) {
      widget.onGoToShopFilter!(
        category: category,
        query: query,
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ShopScreen(
          initialCategory: category,
          initialQuery: query,
        ),
      ),
    );
  }

  void _goToWhyAlard() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const WhyAlardScreen(),
      ),
    );
  }

  List<Product> _homeProducts(List<Product> products) {
    final wantedIds = [
      'olive-oil-glass-500ml',
      'zaatar-packaging',
      'dried-sage',
      'olive-pickle-variety',
    ];

    final selected = <Product>[];

    for (final id in wantedIds) {
      final index = products.indexWhere((product) => product.id == id);
      if (index != -1) {
        selected.add(products[index]);
      }
    }

    for (final product in products) {
      if (selected.length >= 4) break;

      final exists = selected.any((item) => item.id == product.id);
      if (!exists) {
        selected.add(product);
      }
    }

    return selected;
  }

  Widget _buildTopBar(BuildContext context, AppState state) {
    return Container(
      height: 84,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: const BoxDecoration(
        color: _cream,
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFE2DAD0),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              _showHomeMenu(context);
            },
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints.tightFor(
              width: 42,
              height: 42,
            ),
            icon: const Icon(
              Icons.menu_rounded,
              size: 38,
              color: _darkBlue,
            ),
          ),
          const Spacer(),
          Image.asset(
            'assets/alard_icon.png',
            height: 62,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) {
              return const Text(
                "AL'ARD",
                style: TextStyle(
                  fontSize: 21,
                  color: _olive,
                  fontWeight: FontWeight.bold,
                ),
              );
            },
          ),
          const Spacer(),
          IconButton(
            onPressed: () {},
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints.tightFor(
              width: 42,
              height: 42,
            ),
            icon: const Icon(
              Icons.search_rounded,
              size: 38,
              color: Colors.black,
            ),
          ),
          Stack(
            clipBehavior: Clip.none,
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
                constraints: const BoxConstraints.tightFor(
                  width: 40,
                  height: 42,
                ),
                icon: const Icon(
                  Icons.shopping_cart_outlined,
                  size: 34,
                  color: Colors.black,
                ),
              ),
              if (state.cartCount > 0)
                Positioned(
                  right: -2,
                  top: 1,
                  child: Container(
                    height: 18,
                    width: 18,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: _olive,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      state.cartCount.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
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

  void _showHomeMenu(BuildContext context) {
    final menuItems = [
      _MenuFilter(
        title: 'Home page',
        category: 'All',
        query: '',
        closeOnly: true,
      ),
      _MenuFilter(
        title: 'Gifts',
        category: 'Gift Boxes',
        query: '',
      ),
      _MenuFilter(
        title: 'Palestinian olive oil',
        category: 'Olive Oil',
        query: '',
      ),
      _MenuFilter(
        title: 'Green pickled olives',
        category: 'Pickles',
        query: 'olive',
      ),
      _MenuFilter(
        title: 'Nabulsi Cheese',
        category: 'Dairy',
        query: 'Nabulsi Cheese',
      ),
      _MenuFilter(
        title: 'Mixed thyme and medicinal herbs',
        category: 'Herbs & Spices',
        query: '',
      ),
      _MenuFilter(
        title: 'Premium tahini paste',
        category: 'Tahini & Halawa',
        query: 'tahini',
      ),
      _MenuFilter(
        title: 'Palestinian hot sauce',
        category: 'Herbs & Spices',
        query: 'chili',
      ),
      _MenuFilter(
        title: 'Freekeh and maftoul',
        category: 'Grains',
        query: '',
      ),
      _MenuFilter(
        title: 'Black seed - Qizha',
        category: 'Natural Products',
        query: 'black seed',
      ),
      _MenuFilter(
        title: 'Nabulsi soap',
        category: 'Soap & Care',
        query: '',
      ),
    ];

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Menu',
      barrierColor: Colors.black.withOpacity(0.15),
      transitionDuration: const Duration(milliseconds: 180),
      pageBuilder: (dialogContext, animation, secondaryAnimation) {
        return Align(
          alignment: Alignment.centerLeft,
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.86,
              height: double.infinity,
              color: const Color(0xFFF7F3EE),
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

                        if (item.closeOnly) return;

                        Future.delayed(
                          const Duration(milliseconds: 120),
                          () {
                            _goToShopFilter(
                              category: item.category,
                              query: item.query,
                            );
                          },
                        );
                      },
                      child: Container(
                        height: isHeader ? 53 : 56,
                        width: double.infinity,
                        color: isHeader
                            ? const Color(0xFFEDE5DD)
                            : const Color(0xFFF7F3EE),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          item.title,
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

  Widget _buildHeroSection(BuildContext context) {
    return SizedBox(
      height: 202,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/photo2.png',
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) {
              return Container(
                color: const Color(0xFFD4C7B4),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.landscape_outlined,
                  color: _olive,
                  size: 54,
                ),
              );
            },
          ),
          Container(
            color: Colors.black.withOpacity(0.18),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 34),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "From Palestine's ancient\nolive trees, we offer products\nto complement your dishes",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                    fontWeight: FontWeight.w800,
                    height: 1.18,
                    shadows: [
                      Shadow(
                        color: Colors.black54,
                        blurRadius: 4,
                        offset: Offset(1, 2),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const DiscoverOurStory(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: _gold,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 9,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: const Text(
                    'Discover our Story',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationBar(BuildContext context) {
    return Container(
      height: 31,
      color: _locationGreen,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          const Icon(
            Icons.location_on,
            color: Colors.black,
            size: 19,
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              'delivering to : $selectedStore',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              _showStoreDialog(context);
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 4),
              minimumSize: const Size(0, 28),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Text(
              'Change location',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          InkWell(
            onTap: () {
              _showStoreDialog(context);
            },
            child: const Icon(
              Icons.skip_next,
              color: Colors.black,
              size: 18,
            ),
          ),
        ],
      ),
    );
  }

  void _showStoreDialog(BuildContext context) {
    final stores = [
      _StoreChoice(flag: '🇺🇸', name: "Al'ard USA", value: 'USA'),
      _StoreChoice(flag: '🇸🇦', name: "Al'ard KSA", value: 'KSA'),
      _StoreChoice(flag: '🇦🇪', name: "Al'ard UAE", value: 'UAE'),
      _StoreChoice(flag: '🇵🇸', name: "Al'ard Palestine", value: 'Palestine'),
      _StoreChoice(flag: '🇪🇺', name: "Al'ard Europe", value: 'Europe'),
    ];

    showDialog(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.white,
          insetPadding: const EdgeInsets.symmetric(horizontal: 22),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(2),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 22, 12, 18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Select your store',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    fontFamily: 'serif',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 14),
                for (final store in stores) ...[
                  _buildStoreChoice(
                    store: store,
                    onTap: () {
                      setState(() {
                        selectedStore = store.value;
                      });
                      Navigator.pop(dialogContext);
                    },
                  ),
                  const SizedBox(height: 4),
                ],
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.black,
                    side: const BorderSide(
                      color: Colors.black54,
                      width: 1,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  child: const Text(
                    'Close',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStoreChoice({
    required _StoreChoice store,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        decoration: BoxDecoration(
          color: const Color(0xFFEFEFEF),
          border: Border.all(
            color: Colors.black54,
            width: 0.8,
          ),
        ),
        child: Row(
          children: [
            Text(
              store.flag,
              style: const TextStyle(fontSize: 27),
            ),
            const SizedBox(width: 12),
            Text(
              store.name,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 17,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader({
    required String title,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              color: _olive,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const Spacer(),
          InkWell(
            onTap: onTap,
            child: const Padding(
              padding: EdgeInsets.all(4),
              child: Icon(
                Icons.skip_next,
                color: Colors.black,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductsRow(
    BuildContext context,
    List<Product> products,
  ) {
    return SizedBox(
      height: 166,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        scrollDirection: Axis.horizontal,
        itemCount: products.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          return _buildProductCard(context, products[index]);
        },
      ),
    );
  }

  Widget _buildProductCard(BuildContext context, Product product) {
    return SizedBox(
      width: 78,
      child: Column(
        children: [
          Expanded(
            child: InkWell(
              borderRadius: BorderRadius.circular(4),
              onTap: () => _openProductDetails(context, product),
              child: Column(
                children: [
                  Container(
                    height: 78,
                    width: 78,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: Color(0xFFE9E3D9),
                    ),
                    child: Hero(
                      tag: product.id,
                      child: Image.asset(
                        product.image,
                        height: 74,
                        width: 74,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) {
                          return const Icon(
                            Icons.image_outlined,
                            color: Colors.black26,
                            size: 36,
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _shortName(product),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xFF5E5436),
                      fontSize: 8.5,
                      fontWeight: FontWeight.w500,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _homePrice(product),
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: _olive,
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 27,
            width: 78,
            child: ElevatedButton(
              onPressed: () => _openProductDetails(context, product),
              style: ElevatedButton.styleFrom(
                elevation: 0,
                padding: EdgeInsets.zero,
                backgroundColor: _olive,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              child: const Text(
                'View details',
                maxLines: 1,
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

  void _openProductDetails(BuildContext context, Product product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProductDetailScreen(
          product: product,
        ),
      ),
    );
  }

  String _shortName(Product product) {
    switch (product.id) {
      case 'olive-oil-glass-500ml':
        return 'Virgin olive oil\n1 liter plastic';

      case 'zaatar-packaging':
        return '1KG Premium\nPalestinian Zaatar';

      case 'dried-sage':
        return '100g Dried Sage\nfrom the Mountains of Palestine';

      case 'olive-pickle-variety':
        return '220g Local Palestinian\nGreen Olives';

      default:
        if (product.subtitle.trim().isEmpty) {
          return product.name;
        }
        return '${product.name}\n${product.subtitle}';
    }
  }

  String _homePrice(Product product) {
    if (product.price <= 0) return 'Quote';

    final price = product.price.toStringAsFixed(0);

    if (product.displayPrice.contains('NIS') ||
        product.displayPrice.contains('₪')) {
      return '$price NIS';
    }

    return product.displayPrice;
  }

  Widget _buildWhyAlardFrame(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;

        final frameHeight = (screenWidth * 0.34).clamp(122.0, 138.0);
        final innerWidth = screenWidth - 16;

        final naturalWidth = (screenWidth * 0.31).clamp(112.0, 126.0);
        final gap = (screenWidth * 0.015).clamp(5.0, 7.0);

        final imageCardWidth =
            ((innerWidth - naturalWidth - (gap * 2)) / 2).clamp(105.0, 135.0);

        final imageHeight = (frameHeight * 0.56).clamp(68.0, 78.0);
        final imageTitleFont = (screenWidth * 0.035).clamp(12.5, 14.5);
        final miniTextFont = (screenWidth * 0.024).clamp(8.8, 9.6);

        return Container(
          height: frameHeight,
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
          decoration: const BoxDecoration(
            color: _whyFrameBackground,
          ),
          child: Row(
            children: [
              _buildNaturalOliveOilCard(
                context,
                width: naturalWidth,
                fontSize: miniTextFont,
              ),
              SizedBox(width: gap),
              _buildWhyImageCard(
                context,
                width: imageCardWidth,
                imageHeight: imageHeight,
                titleFont: imageTitleFont,
                imagePath: 'assets/palestinian_breakfast.png',
                title: 'Palestinian\nBreakfast',
              ),
              SizedBox(width: gap),
              _buildWhyImageCard(
                context,
                width: imageCardWidth,
                imageHeight: imageHeight,
                titleFont: imageTitleFont,
                imagePath: 'assets/olive_oil_dip.png',
                title: 'Olive Oil Dip',
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNaturalOliveOilCard(
    BuildContext context, {
    required double width,
    required double fontSize,
  }) {
    return InkWell(
      onTap: _goToWhyAlard,
      borderRadius: BorderRadius.circular(8),
      child: SizedBox(
        width: width,
        child: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: _MiniInfoBox(
                      icon: Icons.eco_outlined,
                      line1: '100%',
                      line2: 'Natural',
                      fontSize: fontSize,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: _MiniInfoBox(
                      icon: Icons.local_drink_outlined,
                      line1: 'Premium',
                      line2: 'Olive Oil',
                      fontSize: fontSize,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _TinyWhyIcon(icon: Icons.spa_outlined),
                _TinyWhyIcon(icon: Icons.eco_outlined),
                _TinyWhyIcon(icon: Icons.grass_outlined),
                _TinyWhyIcon(icon: Icons.park_outlined),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWhyImageCard(
    BuildContext context, {
    required double width,
    required double imageHeight,
    required double titleFont,
    required String imagePath,
    required String title,
  }) {
    return InkWell(
      onTap: _goToWhyAlard,
      borderRadius: BorderRadius.circular(8),
      child: SizedBox(
        width: width,
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                width: double.infinity,
                height: imageHeight,
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) {
                    return Container(
                      color: const Color(0xFFE9E1D5),
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.image_not_supported_outlined,
                        color: Colors.black38,
                        size: 28,
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 6),
            Expanded(
              child: Text(
                title,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: const Color(0xFF3F2F1F),
                  fontSize: titleFont,
                  fontWeight: FontWeight.w800,
                  height: 1.05,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniInfoBox extends StatelessWidget {
  final IconData icon;
  final String line1;
  final String line2;
  final double fontSize;

  const _MiniInfoBox({
    required this.icon,
    required this.line1,
    required this.line2,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFAF6EF),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: _HomeScreenState._softBorder,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 4),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: _HomeScreenState._olive,
            size: fontSize + 9,
          ),
          const SizedBox(height: 2),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              line1,
              maxLines: 1,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: const Color(0xFF3F2F1F),
                fontSize: fontSize,
                fontWeight: FontWeight.w800,
                height: 1.0,
              ),
            ),
          ),
          const SizedBox(height: 1),
          Text(
            line2,
            maxLines: 2,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: const Color(0xFF3F2F1F),
              fontSize: fontSize,
              fontWeight: FontWeight.w700,
              height: 1.0,
            ),
          ),
        ],
      ),
    );
  }
}

class _TinyWhyIcon extends StatelessWidget {
  final IconData icon;

  const _TinyWhyIcon({
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      size: 16,
      color: const Color(0xFFC9BF9D),
    );
  }
}

class _StoreChoice {
  final String flag;
  final String name;
  final String value;

  const _StoreChoice({
    required this.flag,
    required this.name,
    required this.value,
  });
}

class _MenuFilter {
  final String title;
  final String category;
  final String query;
  final bool closeOnly;

  const _MenuFilter({
    required this.title,
    required this.category,
    required this.query,
    this.closeOnly = false,
  });
}