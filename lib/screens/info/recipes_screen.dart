import 'package:flutter/material.dart';

import '../../state/app_state_scope.dart';
import '../../theme/app_colors.dart';
import 'recipe_details_screen.dart';

// Re-export so existing code using RecipeItem from recipes_screen still works.
export 'recipe_details_screen.dart' show RecipeItem, RecipeDetailsScreen;

/// Grid-based recipes browser with search and category filtering.
/// Estimated lines: ~290
class RecipesScreen extends StatefulWidget {
  final VoidCallback? onGoHome;
  const RecipesScreen({super.key, this.onGoHome});

  @override
  State<RecipesScreen> createState() => _RecipesScreenState();
}

class _RecipesScreenState extends State<RecipesScreen> {
  static const Color _cardColor = Color(0xFFF4F0EA);
  static const Color _lightOlive = Color(0xFFE5ECCC);

  final TextEditingController _searchController = TextEditingController();
  bool _showSearch = false;
  String _query = '';
  String _selectedCategory = 'recipe_cat_all';

  static const List<String> _categories = [
    'recipe_cat_all', 'recipe_cat_olive_oil', 'recipe_cat_zaatar',
    'recipe_cat_sumac', 'recipe_cat_tahini', 'recipe_cat_freekeh',
    'recipe_cat_maftoul', 'recipe_cat_black_seed',
  ];

  List<RecipeItem> _buildRecipes(BuildContext context) {
    final s = AppStateScope.of(context);
    return [
      RecipeItem(
        title: s.t('recipe_1_title'), image: 'assets/10.png', duration: '5 min',
        cookingItems: ['Olive Oil', 'Zaatar'], description: s.t('recipe_1_desc'),
        ingredients: [s.t('recipe_1_ing_1'), s.t('recipe_1_ing_2'), s.t('recipe_1_ing_3'), s.t('recipe_1_ing_4')],
        steps: [s.t('recipe_1_step_1'), s.t('recipe_1_step_2'), s.t('recipe_1_step_3')],
      ),
      RecipeItem(
        title: s.t('recipe_2_title'), image: 'assets/11.png', duration: '10 min',
        cookingItems: ['Olive Oil', 'Sumac'], description: s.t('recipe_2_desc'),
        ingredients: [s.t('recipe_2_ing_1'), s.t('recipe_2_ing_2'), s.t('recipe_2_ing_3'), s.t('recipe_2_ing_4'), s.t('recipe_2_ing_5')],
        steps: [s.t('recipe_2_step_1'), s.t('recipe_2_step_2'), s.t('recipe_2_step_3'), s.t('recipe_2_step_4')],
      ),
      RecipeItem(
        title: s.t('recipe_3_title'), image: 'assets/12.png', duration: '8 min',
        cookingItems: ['Olive Oil', 'Zaatar'], description: s.t('recipe_3_desc'),
        ingredients: [s.t('recipe_3_ing_1'), s.t('recipe_3_ing_2'), s.t('recipe_3_ing_3'), s.t('recipe_3_ing_4')],
        steps: [s.t('recipe_3_step_1'), s.t('recipe_3_step_2'), s.t('recipe_3_step_3'), s.t('recipe_3_step_4')],
      ),
      RecipeItem(
        title: s.t('recipe_4_title'), image: 'assets/13.png', duration: '35 min',
        cookingItems: ['Olive Oil', 'Zaatar'], description: s.t('recipe_4_desc'),
        ingredients: [s.t('recipe_4_ing_1'), s.t('recipe_4_ing_2'), s.t('recipe_4_ing_3'), s.t('recipe_4_ing_4')],
        steps: [s.t('recipe_4_step_1'), s.t('recipe_4_step_2'), s.t('recipe_4_step_3'), s.t('recipe_4_step_4')],
      ),
    ];
  }

  String _categoryKey(String item) {
    const map = {
      'Olive Oil': 'recipe_cat_olive_oil', 'Zaatar': 'recipe_cat_zaatar',
      'Sumac': 'recipe_cat_sumac', 'Tahini': 'recipe_cat_tahini',
      'Freekeh': 'recipe_cat_freekeh', 'Maftoul': 'recipe_cat_maftoul',
      'Black Seed': 'recipe_cat_black_seed',
    };
    return map[item] ?? 'recipe_cat_all';
  }

  List<RecipeItem> _filtered(BuildContext context) {
    final search = _query.trim().toLowerCase();
    return _buildRecipes(context).where((r) {
      final matchesSearch = search.isEmpty ||
          r.title.toLowerCase().contains(search) ||
          r.description.toLowerCase().contains(search) ||
          r.ingredients.join(' ').toLowerCase().contains(search);
      final matchesCat = _selectedCategory == 'recipe_cat_all' ||
          r.cookingItems.any((i) => _categoryKey(i) == _selectedCategory);
      return matchesSearch && matchesCat;
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    final recipes = _filtered(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _header(context),
            if (_showSearch) ...[
              _searchBar(state),
              _categoryChips(state),
            ],
            Expanded(
              child: RefreshIndicator(
                color: AppColors.olive,
                backgroundColor: _cardColor,
                onRefresh: () async {
                  await Future.delayed(const Duration(seconds: 1));
                  setState(() {});
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(14, 6, 14, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.restaurant_rounded, color: AppColors.olive, size: 22),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              state.t('recipes_title'),
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(fontWeight: FontWeight.w800, color: Colors.black87),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      if (recipes.isEmpty)
                        _emptyState(state)
                      else
                        LayoutBuilder(builder: (ctx, c) {
                          final iw = (c.maxWidth - 14) / 2;
                          final ar = iw / (iw / 1.15 + 150);
                          return GridView.builder(
                            itemCount: recipes.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 14,
                              mainAxisSpacing: 16,
                              childAspectRatio: ar,
                            ),
                            itemBuilder: (ctx, i) => _RecipeCard(
                              recipe: recipes[i],
                              onOpen: () => Navigator.push(ctx,
                                  MaterialPageRoute(builder: (_) =>
                                      RecipeDetailsScreen(recipe: recipes[i]))),
                            ),
                          );
                        }),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _header(BuildContext context) {
    return LayoutBuilder(builder: (context, c) {
      final w = c.maxWidth;
      final h = (w * 0.16).clamp(56.0, 70.0);
      final s = (w * 0.11).clamp(38.0, 46.0);
      return Container(
        height: h,
        color: AppColors.background,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Center(
              child: Image.asset('assets/321.png', height: 38, fit: BoxFit.contain,
                  errorBuilder: (_, _, _) => const Text("AL'ARD",
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.olive))),
            ),
            PositionedDirectional(
              start: 4,
              child: IconButton(
                onPressed: () {
                  if (widget.onGoHome != null) {
                    widget.onGoHome!();
                  } else if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  }
                },
                padding: EdgeInsets.zero,
                constraints: BoxConstraints.tightFor(width: s, height: s),
                icon: Icon(Icons.adaptive.arrow_back, size: 28, color: Colors.black87),
              ),
            ),
            PositionedDirectional(
              end: 4,
              child: IconButton(
                onPressed: () {
                  setState(() {
                    _showSearch = !_showSearch;
                    if (!_showSearch) {
                      _query = '';
                      _selectedCategory = 'recipe_cat_all';
                      _searchController.clear();
                    }
                  });
                },
                padding: EdgeInsets.zero,
                constraints: BoxConstraints.tightFor(width: s, height: s),
                icon: Icon(_showSearch ? Icons.close_rounded : Icons.search_rounded,
                    size: 28, color: Colors.black87),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _searchBar(dynamic state) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 0, 14, 8),
      child: TextField(
        controller: _searchController,
        autofocus: true,
        onChanged: (v) => setState(() => _query = v),
        decoration: InputDecoration(
          hintText: state.t('recipes_search_hint'),
          prefixIcon: const Icon(Icons.search_rounded),
          suffixIcon: _query.trim().isEmpty
              ? null
              : IconButton(
                  onPressed: () => setState(() { _query = ''; _searchController.clear(); }),
                  icon: const Icon(Icons.clear_rounded)),
          filled: true,
          fillColor: const Color(0xFFF1ECE5),
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
        ),
      ),
    );
  }

  Widget _categoryChips(dynamic state) {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final item = _categories[i];
          final isSelected = _selectedCategory == item;
          return GestureDetector(
            onTap: () => setState(() => _selectedCategory = item),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.olive : _lightOlive,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                    color: isSelected ? AppColors.olive : AppColors.olive.withValues(alpha: 0.25)),
              ),
              child: Center(
                child: Text(state.t(item),
                    style: TextStyle(
                        color: isSelected ? Colors.white : AppColors.olive,
                        fontWeight: FontWeight.w800,
                        fontSize: 13)),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _emptyState(dynamic state) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 18),
      decoration: BoxDecoration(color: _cardColor, borderRadius: BorderRadius.circular(18)),
      child: Column(
        children: [
          const Icon(Icons.search_off_rounded, size: 52, color: Colors.black38),
          const SizedBox(height: 12),
          Text(state.t('recipes_no_results'),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.black87)),
          const SizedBox(height: 6),
          Text(state.t('recipes_try_items'),
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.black.withValues(alpha: 0.55), height: 1.4)),
        ],
      ),
    );
  }
}

// ── Recipe Card ─────────────────────────────────────────────────────────────

class _RecipeCard extends StatelessWidget {
  final RecipeItem recipe;
  final VoidCallback onOpen;
  const _RecipeCard({required this.recipe, required this.onOpen});

  static const Color _cardColor = Color(0xFFF4F0EA);
  static const Color _softBeige = Color(0xFFE9E1D5);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onOpen,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        decoration: BoxDecoration(color: _cardColor, borderRadius: BorderRadius.circular(18)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
              child: AspectRatio(
                aspectRatio: 1.15,
                child: Image.asset(recipe.image, width: double.infinity, fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => Container(
                        color: _softBeige,
                        child: const Center(child: Icon(Icons.restaurant_menu, size: 42, color: Colors.black38)))),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 4),
              child: Text(recipe.title, maxLines: 2, overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.black87)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  const Icon(Icons.access_time_filled, size: 17, color: Colors.black87),
                  const SizedBox(width: 6),
                  Text(recipe.duration, style: const TextStyle(fontSize: 13, color: Colors.black87)),
                ],
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
              child: SizedBox(
                width: double.infinity,
                height: 36,
                child: ElevatedButton(
                  onPressed: onOpen,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.olive,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(AppStateScope.of(context).t('recipes_view_button'),
                        style: const TextStyle(fontWeight: FontWeight.w700)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
