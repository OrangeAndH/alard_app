import 'package:flutter/material.dart';
import '../../state/app_state_scope.dart';

class RecipesScreen extends StatefulWidget {
  final VoidCallback? onGoHome;
  const RecipesScreen({super.key, this.onGoHome});

  @override
  State<RecipesScreen> createState() => _RecipesScreenState();
}

class _RecipesScreenState extends State<RecipesScreen> {
  static const Color _background = Color(0xFFF7F3EE);
  static const Color _cardColor = Color(0xFFF4F0EA);
  static const Color _olive = Color(0xFF55682A);
  static const Color _lightOlive = Color(0xFFE5ECCC);
  static const Color _softBeige = Color(0xFFE9E1D5);

  final TextEditingController _searchController = TextEditingController();

  bool _showSearch = false;
  String _query = '';
  String _selectedCookingItem = 'recipe_cat_all';

  static const List<String> _cookingItems = [
    'recipe_cat_all',
    'recipe_cat_olive_oil',
    'recipe_cat_zaatar',
    'recipe_cat_sumac',
    'recipe_cat_tahini',
    'recipe_cat_freekeh',
    'recipe_cat_maftoul',
    'recipe_cat_black_seed',
  ];

  static List<RecipeItem> _getTranslatedRecipes(BuildContext context) {
    final state = AppStateScope.of(context);
    return [
      RecipeItem(
        title: state.t('recipe_1_title'),
        image: 'assets/10.png',
        duration: '5 min',
        cookingItems: ['Olive Oil', 'Zaatar'],
        description: state.t('recipe_1_desc'),
        ingredients: [
          state.t('recipe_1_ing_1'),
          state.t('recipe_1_ing_2'),
          state.t('recipe_1_ing_3'),
          state.t('recipe_1_ing_4'),
        ],
        steps: [
          state.t('recipe_1_step_1'),
          state.t('recipe_1_step_2'),
          state.t('recipe_1_step_3'),
        ],
      ),
      RecipeItem(
        title: state.t('recipe_2_title'),
        image: 'assets/11.png',
        duration: '10 min',
        cookingItems: ['Olive Oil', 'Sumac'],
        description: state.t('recipe_2_desc'),
        ingredients: [
          state.t('recipe_2_ing_1'),
          state.t('recipe_2_ing_2'),
          state.t('recipe_2_ing_3'),
          state.t('recipe_2_ing_4'),
          state.t('recipe_2_ing_5'),
        ],
        steps: [
          state.t('recipe_2_step_1'),
          state.t('recipe_2_step_2'),
          state.t('recipe_2_step_3'),
          state.t('recipe_2_step_4'),
        ],
      ),
      RecipeItem(
        title: state.t('recipe_3_title'),
        image: 'assets/12.png',
        duration: '8 min',
        cookingItems: ['Olive Oil', 'Zaatar'],
        description: state.t('recipe_3_desc'),
        ingredients: [
          state.t('recipe_3_ing_1'),
          state.t('recipe_3_ing_2'),
          state.t('recipe_3_ing_3'),
          state.t('recipe_3_ing_4'),
        ],
        steps: [
          state.t('recipe_3_step_1'),
          state.t('recipe_3_step_2'),
          state.t('recipe_3_step_3'),
          state.t('recipe_3_step_4'),
        ],
      ),
      RecipeItem(
        title: state.t('recipe_4_title'),
        image: 'assets/13.png',
        duration: '35 min',
        cookingItems: ['Olive Oil', 'Zaatar'],
        description: state.t('recipe_4_desc'),
        ingredients: [
          state.t('recipe_4_ing_1'),
          state.t('recipe_4_ing_2'),
          state.t('recipe_4_ing_3'),
          state.t('recipe_4_ing_4'),
        ],
        steps: [
          state.t('recipe_4_step_1'),
          state.t('recipe_4_step_2'),
          state.t('recipe_4_step_3'),
          state.t('recipe_4_step_4'),
        ],
      ),
    ];
  }

  List<RecipeItem> get _filteredRecipes {
    final search = _query.trim().toLowerCase();

    return _getTranslatedRecipes(context).where((recipe) {
      final matchesSearch =
          search.isEmpty ||
          recipe.title.toLowerCase().contains(search) ||
          recipe.duration.toLowerCase().contains(search) ||
          recipe.description.toLowerCase().contains(search) ||
          recipe.ingredients.join(' ').toLowerCase().contains(search);

      final matchesCookingItem =
          _selectedCookingItem == 'recipe_cat_all' ||
          recipe.cookingItems.any((item) {
            // Map items to their keys for filtering consistency
            final key = _getCategoryKey(item);
            return key == _selectedCookingItem;
          });

      return matchesSearch && matchesCookingItem;
    }).toList();
  }

  String _getCategoryKey(String item) {
    switch (item) {
      case 'Olive Oil':
        return 'recipe_cat_olive_oil';
      case 'Zaatar':
        return 'recipe_cat_zaatar';
      case 'Sumac':
        return 'recipe_cat_sumac';
      case 'Tahini':
        return 'recipe_cat_tahini';
      case 'Freekeh':
        return 'recipe_cat_freekeh';
      case 'Maftoul':
        return 'recipe_cat_maftoul';
      case 'Black Seed':
        return 'recipe_cat_black_seed';
      default:
        return 'recipe_cat_all';
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
    final recipes = _filteredRecipes;

    return Scaffold(
      backgroundColor: _background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            if (_showSearch) ...[
              _buildSearchBar(),
              _buildCookingItemsButtons(),
            ],
            Expanded(
              child: RefreshIndicator(
                color: _olive,
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
                          const Icon(
                            Icons.restaurant_rounded,
                            color: _olive,
                            size: 22,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              state.t('recipes_title'),
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.w800,
                                    color: Colors.black87,
                                  ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      if (recipes.isEmpty)
                        _buildEmptySearch()
                      else
                        LayoutBuilder(
                          builder: (context, constraints) {
                            final width = constraints.maxWidth;
                            final itemWidth = (width - 14) / 2;
                            // Calculate item height: image (aspect ratio 1.15) + text/button fixed heights + padding
                            final itemHeight = (itemWidth / 1.15) + 138;
                            final aspectRatio = itemWidth / itemHeight;

                            return GridView.builder(
                              itemCount: recipes.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 14,
                                    mainAxisSpacing: 16,
                                    childAspectRatio: aspectRatio,
                                  ),
                              itemBuilder: (context, index) {
                                final recipe = recipes[index];

                                return _RecipeCard(
                                  recipe: recipe,
                                  onOpen: () {
                                    _openRecipe(context, recipe);
                                  },
                                );
                              },
                            );
                          },
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
  }

  Widget _buildHeader() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final barHeight = (width * 0.16).clamp(56.0, 70.0);
        final buttonSize = (width * 0.11).clamp(38.0, 46.0);

        return Container(
          height: barHeight,
          width: double.infinity,
          color: _background,
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
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: _olive,
                      ),
                    );
                  },
                ),
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
                  constraints: BoxConstraints.tightFor(
                    width: buttonSize,
                    height: buttonSize,
                  ),
                  icon: Icon(
                    Icons.adaptive.arrow_back,
                    size: 28,
                    color: Colors.black87,
                  ),
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
                        _selectedCookingItem = 'recipe_cat_all';
                        _searchController.clear();
                      }
                    });
                  },
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints.tightFor(
                    width: buttonSize,
                    height: buttonSize,
                  ),
                  icon: Icon(
                    _showSearch ? Icons.close_rounded : Icons.search_rounded,
                    size: 28,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSearchBar() {
    final state = AppStateScope.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 0, 14, 8),
      child: TextField(
        controller: _searchController,
        autofocus: true,
        onChanged: (value) {
          setState(() {
            _query = value;
          });
        },
        decoration: InputDecoration(
          hintText: state.t('recipes_search_hint'),
          prefixIcon: const Icon(Icons.search_rounded),
          suffixIcon: _query.trim().isEmpty
              ? null
              : IconButton(
                  onPressed: () {
                    setState(() {
                      _query = '';
                      _searchController.clear();
                    });
                  },
                  icon: const Icon(Icons.clear_rounded),
                ),
          filled: true,
          fillColor: const Color(0xFFF1ECE5),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 12,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildCookingItemsButtons() {
    final state = AppStateScope.of(context);
    return SizedBox(
      height: 44,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        scrollDirection: Axis.horizontal,
        itemCount: _cookingItems.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final item = _cookingItems[index];
          final isSelected = _selectedCookingItem == item;

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedCookingItem = item;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: isSelected ? _olive : _lightOlive,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: isSelected ? _olive : _olive.withValues(alpha: 0.25),
                ),
              ),
              child: Center(
                child: Text(
                  state.t(item),
                  style: TextStyle(
                    color: isSelected ? Colors.white : _olive,
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptySearch() {
    final state = AppStateScope.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 18),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          const Icon(Icons.search_off_rounded, size: 52, color: Colors.black38),
          const SizedBox(height: 12),
          Text(
            state.t('recipes_no_results'),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            state.t('recipes_try_items'),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.black.withValues(alpha: 0.55),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  void _openRecipe(BuildContext context, RecipeItem recipe) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => RecipeDetailsScreen(recipe: recipe)),
    );
  }
}

class _RecipeCard extends StatelessWidget {
  final RecipeItem recipe;
  final VoidCallback onOpen;

  const _RecipeCard({required this.recipe, required this.onOpen});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onOpen,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        decoration: BoxDecoration(
          color: _RecipesScreenState._cardColor,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: onOpen,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(18),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(18),
                ),
                child: AspectRatio(
                  aspectRatio: 1.15,
                  child: Image.asset(
                    recipe.image,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) {
                      return Container(
                        color: _RecipesScreenState._softBeige,
                        child: const Center(
                          child: Icon(
                            Icons.restaurant_menu,
                            size: 42,
                            color: Colors.black38,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 4),
              child: Text(
                recipe.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  const Icon(
                    Icons.access_time_filled,
                    size: 17,
                    color: Colors.black87,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    recipe.duration,
                    style: const TextStyle(fontSize: 13, color: Colors.black87),
                  ),
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
                    backgroundColor: _RecipesScreenState._olive,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    AppStateScope.of(context).t('recipes_view_button'),
                    style: const TextStyle(fontWeight: FontWeight.w700),
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

class RecipeDetailsScreen extends StatelessWidget {
  final RecipeItem recipe;

  const RecipeDetailsScreen({super.key, required this.recipe});

  static const Color _background = Color(0xFFF7F3EE);
  static const Color _olive = Color(0xFF55682A);
  static const Color _card = Color(0xFFF1ECE5);

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    return Scaffold(
      backgroundColor: _background,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(22),
                      child: Image.asset(
                        recipe.image,
                        width: double.infinity,
                        height: 240,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) {
                          return Container(
                            height: 240,
                            color: const Color(0xFFE9E1D5),
                            child: const Center(
                              child: Icon(
                                Icons.restaurant_rounded,
                                size: 50,
                                color: Colors.black38,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      recipe.title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.access_time_filled,
                          size: 18,
                          color: _olive,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          recipe.duration,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: _olive,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: _card,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        recipe.description,
                        style: const TextStyle(
                          fontSize: 15,
                          height: 1.5,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      state.t('recipes_ingredients'),
                      style: const TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w800,
                        color: _olive,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ...recipe.ingredients.map(
                      (item) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(top: 5),
                              child: Icon(Icons.circle, size: 8, color: _olive),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                item,
                                style: const TextStyle(
                                  fontSize: 15,
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      state.t('recipes_steps'),
                      style: const TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w800,
                        color: _olive,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ...List.generate(recipe.steps.length, (index) {
                      return Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: _card,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 26,
                              height: 26,
                              alignment: Alignment.center,
                              decoration: const BoxDecoration(
                                color: _olive,
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                '${index + 1}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                recipe.steps[index],
                                style: const TextStyle(
                                  fontSize: 15,
                                  height: 1.5,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final state = AppStateScope.of(context);
        final width = constraints.maxWidth;
        final barHeight = (width * 0.16).clamp(56.0, 70.0);
        final buttonSize = (width * 0.11).clamp(38.0, 46.0);

        return Container(
          height: barHeight,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                padding: EdgeInsets.zero,
                constraints: BoxConstraints.tightFor(
                  width: buttonSize,
                  height: buttonSize,
                ),
                icon: Icon(
                  Icons.adaptive.arrow_back,
                  size: 30,
                  color: Colors.black87,
                ),
              ),
              Expanded(
                child: Text(
                  state.t('recipe_details_title'),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Colors.black87,
                  ),
                ),
              ),
              SizedBox(width: buttonSize),
            ],
          ),
        );
      },
    );
  }
}

class RecipeItem {
  final String title;
  final String image;
  final String duration;
  final List<String> cookingItems;
  final String description;
  final List<String> ingredients;
  final List<String> steps;

  const RecipeItem({
    required this.title,
    required this.image,
    required this.duration,
    required this.cookingItems,
    required this.description,
    required this.ingredients,
    required this.steps,
  });
}
