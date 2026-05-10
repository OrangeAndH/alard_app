import 'package:flutter/material.dart';
import '../../state/app_state.dart';
import '../../state/app_state_scope.dart';
import '../auth/login_screen.dart';
import '../checkout/cart_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen>
    with SingleTickerProviderStateMixin {
  int _quantity = 1;
  ProductVariant? _selectedVariant;
  late AnimationController _animController;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _animController, curve: Curves.elasticOut),
    );
    if (widget.product.variants != null && widget.product.variants!.isNotEmpty) {
      _selectedVariant = widget.product.variants!.first;
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _onFavoriteTap(AppState state) {
    if (!state.isLoggedIn) {
      _showLoginPrompt(context);
      return;
    }
    state.toggleFavorite(widget.product);
    if (state.isFavorite(widget.product.id)) {
      _animController.forward().then((_) => _animController.reverse());
    }
  }

  void _showLoginPrompt(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.lock_outline_rounded, size: 48, color: Color(0xFF7A8D2F)),
            const SizedBox(height: 16),
            const Text(
              'Login Required',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Please login to add favorites or place orders.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7A8D2F),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Go to Login', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Maybe Later', style: TextStyle(color: Colors.black45)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    final isFav = state.isFavorite(widget.product.id);
    final cartKey = _selectedVariant != null
        ? '${widget.product.id}_${_selectedVariant!.id}'
        : widget.product.id;
    final currentPrice = _selectedVariant?.price ?? widget.product.price;
    final screenHeight = MediaQuery.of(context).size.height;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F3EE),
      body: Stack(
        children: [
          // 1. Main Scrollable Content
          Positioned.fill(
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  // Header Section (Beige Background + Image)
                  Stack(
                    children: [
                      // Beige Background with rounded corners
                      Container(
                        height: screenHeight * 0.45,
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          color: Color(0xFFEEE8DC),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(36),
                            bottomRight: Radius.circular(36),
                          ),
                        ),
                      ),
                      // Product Image
                      Column(
                        children: [
                          SizedBox(height: MediaQuery.of(context).padding.top + 60),
                          SizedBox(
                            height: screenHeight * 0.30,
                            width: double.infinity,
                            child: Center(
                              child: Hero(
                                tag: state.selectedIndex == 0 
                                    ? 'home_${widget.product.id}' 
                                    : (state.currentUser?.isTrader == true 
                                        ? 'trader_shop_${widget.product.id}' 
                                        : 'shop_${widget.product.id}'),
                                child: Image.asset(
                                  widget.product.image,
                                  fit: BoxFit.contain,
                                  errorBuilder: (_, _, _) => const Icon(
                                    Icons.image_not_supported_outlined,
                                    size: 80,
                                    color: Colors.black26,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  // Content Section
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 140), // Large bottom padding for the fixed bar
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Badges
                        Row(
                          children: [
                            _badge(widget.product.category),
                            if (widget.product.isBestSeller) ...[
                              const SizedBox(width: 8),
                              _badge(
                                state.t('product_best_seller'),
                                bg: const Color(0xFFCEB04B),
                                fg: Colors.white,
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Title & Subtitle
                        Text(
                          state.t(widget.product.name),
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2D3112),
                            height: 1.1,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          state.t(widget.product.subtitle),
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Rating & Price
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.star_rounded, color: Color(0xFFCEB04B), size: 24),
                                const SizedBox(width: 4),
                                Text(
                                  widget.product.rating.toString(),
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF2D3112),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  '(${widget.product.ratingCount ?? 120} ${state.t('product_ratings_count')})',
                                  style: const TextStyle(fontSize: 14, color: Colors.black45),
                                ),
                              ],
                            ),
                            Text(
                              state.getFormattedPrice(currentPrice),
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF56632C),
                              ),
                            ),
                          ],
                        ),
                        
                        // Size Selection
                        if (widget.product.variants != null && widget.product.variants!.isNotEmpty) ...[
                          const SizedBox(height: 28),
                          Text(
                            state.t('product_select_size'),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2D3112),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 12,
                            runSpacing: 10,
                            children: widget.product.variants!.map((variant) {
                              final isSelected = _selectedVariant?.id == variant.id;
                              return ChoiceChip(
                                label: Text(variant.size),
                                selected: isSelected,
                                onSelected: (selected) {
                                  if (selected) {
                                    setState(() => _selectedVariant = variant);
                                  }
                                },
                                selectedColor: const Color(0xFF7A8D2F),
                                labelStyle: TextStyle(
                                  color: isSelected ? Colors.white : Colors.black87,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                ),
                                backgroundColor: const Color(0xFFE5ECCC),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  side: isSelected
                                      ? const BorderSide(color: Color(0xFF56632C), width: 1.5)
                                      : BorderSide.none,
                                ),
                              );
                            }).toList(),
                          ),
                        ],

                        const SizedBox(height: 28),
                        const Divider(color: Color(0xFFDDD6CC)),
                        const SizedBox(height: 20),

                        // About Section
                        Text(
                          state.t('product_about'),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2D3112),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          _getDescription(widget.product, state),
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.black87,
                            height: 1.6,
                          ),
                        ),

                        const SizedBox(height: 32),
                        // Quantity Section
                        Row(
                          children: [
                            Text(
                              state.t('product_quantity'),
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2D3112),
                              ),
                            ),
                            const Spacer(),
                            _quantityButton(
                              icon: Icons.remove,
                              onTap: () {
                                if (_quantity > 1) setState(() => _quantity--);
                              },
                            ),
                            Container(
                              constraints: const BoxConstraints(minWidth: 40),
                              alignment: Alignment.center,
                              child: Text(
                                '$_quantity',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2D3112),
                                ),
                              ),
                            ),
                            _quantityButton(
                              icon: Icons.add,
                              onTap: () => setState(() => _quantity++),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 2. Fixed Top Buttons (Back, Favorite, Cart)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    _circleButton(
                      icon: Icons.adaptive.arrow_back,
                      onTap: () => Navigator.pop(context),
                    ),
                    const Spacer(),
                    ScaleTransition(
                      scale: _scaleAnim,
                      child: _circleButton(
                        icon: isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                        iconColor: isFav ? const Color(0xFFD64F4F) : Colors.black87,
                        onTap: () => _onFavoriteTap(state),
                      ),
                    ),
                    const SizedBox(width: 12),
                    _circleButton(
                      icon: Icons.shopping_cart_outlined,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const CartScreen()),
                        );
                      },
                      badgeCount: state.cartCount,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 3. Fixed Bottom Bar (Price + Add to Cart)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.fromLTRB(
                20,
                16,
                20,
                bottomPadding + 16,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 15,
                    offset: const Offset(0, -4),
                  ),
                ],
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        state.t('product_total_price'),
                        style: const TextStyle(fontSize: 13, color: Colors.black45),
                      ),
                      Text(
                        state.getFormattedPrice(currentPrice * _quantity),
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF56632C),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        for (int i = 0; i < _quantity; i++) {
                          state.addToCart(widget.product, variant: _selectedVariant);
                        }
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              '$_quantity × ${state.t(widget.product.name)} ${state.t('product_added_to_cart')}',
                            ),
                            backgroundColor: const Color(0xFF56632C),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF7A8D2F),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 0,
                      ),
                      child: Text(
                        state.t('product_add_to_cart'),
                        style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _circleButton({
    required IconData icon,
    required VoidCallback onTap,
    Color iconColor = Colors.black87,
    int badgeCount = 0,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(icon, size: 24, color: iconColor),
          ),
          if (badgeCount > 0)
            Positioned(
              right: -2,
              top: -2,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Color(0xFF7A8D2F),
                  shape: BoxShape.circle,
                ),
                constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                child: Text(
                  '$badgeCount',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _badge(String label,
      {Color bg = const Color(0xFFE5ECCC),
      Color fg = const Color(0xFF56632C)}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: fg,
        ),
      ),
    );
  }

  Widget _quantityButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: const Color(0xFFE5ECCC),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, size: 18, color: const Color(0xFF56632C)),
      ),
    );
  }

  String _getDescription(Product product, dynamic state) {
    switch (product.category) {
      case 'Oil':
        return state.t('product_desc_oil');
      case 'Herbs':
        return state.t('product_desc_herbs');
      case 'Olives':
        return state.t('product_desc_olives');
      default:
        return state.t('product_desc_default');
    }
  }
}