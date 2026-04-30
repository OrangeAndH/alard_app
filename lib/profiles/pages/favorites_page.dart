import 'package:flutter/material.dart';
import '../../app_state.dart';
import '../../app_state_scope.dart';
import '../widgets/app_page_scaffold.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    final favorites = state.favoriteProducts;

    return AppPageScaffold(
      title: 'My Favorites',
      child: favorites.isEmpty
          ? _emptyState(context)
          : ListView.separated(
              itemCount: favorites.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final product = favorites[index];
                return _favoriteCard(
                  context,
                  product: product,
                  onRemove: () {
                    state.toggleFavorite(product);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${product.name} removed from favorites')),
                    );
                  },
                  onAddToCart: () {
                    state.addToCart(product);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${product.name} added to cart')),
                    );
                  },
                );
              },
            ),
    );
  }

  Widget _emptyState(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.favorite_border, size: 80, color: theme.colorScheme.primary.withOpacity(0.7)),
            const SizedBox(height: 16),
            Text('No favorites yet', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface), textAlign: TextAlign.center),
            const SizedBox(height: 10),
            Text('Add products to favorites from the Shop or Home page.', style: TextStyle(fontSize: 15, color: theme.colorScheme.onSurface.withOpacity(0.65)), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  Widget _favoriteCard(BuildContext context, {required Product product, required VoidCallback onRemove, required VoidCallback onAddToCart}) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: theme.cardColor, borderRadius: BorderRadius.circular(18)),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              product.image,
              width: 72,
              height: 72,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 72,
                height: 72,
                color: theme.scaffoldBackgroundColor,
                child: Icon(Icons.image_not_supported, color: theme.colorScheme.onSurface.withOpacity(0.5)),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: theme.colorScheme.onSurface)),
                const SizedBox(height: 4),
                Text(product.subtitle, style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.65))),
                const SizedBox(height: 8),
                Text('₪${product.price.toStringAsFixed(2)}', style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.bold, fontSize: 18)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            children: [
              IconButton(onPressed: onRemove, icon: const Icon(Icons.favorite, color: Colors.red), tooltip: 'Remove from favorites'),
              IconButton(onPressed: onAddToCart, icon: Icon(Icons.add_shopping_cart_outlined, color: theme.colorScheme.primary), tooltip: 'Add to cart'),
            ],
          ),
        ],
      ),
    );
  }
}