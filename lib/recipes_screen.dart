import 'package:flutter/material.dart';

class RecipesScreen extends StatefulWidget {
  const RecipesScreen({super.key});

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
  String _selectedCookingItem = 'All';

  static const List<String> _cookingItems = [
    'All',
    'Olive Oil',
    'Zaatar',
    'Sumac',
    'Tahini',
    'Freekeh',
    'Maftoul',
    'Black Seed',
  ];

  static final List<RecipeItem> _recipes = [
    RecipeItem(
      title: 'Olive Oil & Zaatar Bread Dip',
      image: 'assets/10.png',
      duration: '5 min',
      cookingItems: [
        'Olive Oil',
        'Zaatar',
      ],
      description:
          'A quick Palestinian-style dip made with extra virgin olive oil and zaatar. It is simple, authentic, and perfect with fresh bread.',
      ingredients: [
        '4 tbsp Al’Ard Extra Virgin Olive Oil',
        '2 tbsp Palestinian Zaatar',
        'Fresh bread for serving',
        'Optional: sesame seeds',
      ],
      steps: [
        'Pour the olive oil into a shallow serving bowl.',
        'Add zaatar on top and mix lightly.',
        'Serve immediately with fresh bread.',
      ],
    ),
    RecipeItem(
      title: 'Palestinian Sumac Salad',
      image: 'assets/11.png',
      duration: '10 min',
      cookingItems: [
        'Olive Oil',
        'Sumac',
      ],
      description:
          'A fresh Palestinian salad with chopped vegetables, herbs, olive oil, and sumac for a bright tangy flavor.',
      ingredients: [
        '2 cucumbers, chopped',
        '2 tomatoes, chopped',
        'Fresh parsley',
        '2 tbsp Al’Ard Olive Oil',
        '1 tsp Palestinian sumac',
        'Salt to taste',
      ],
      steps: [
        'Chop all vegetables and place them in a bowl.',
        'Add parsley, salt, and sumac.',
        'Drizzle olive oil over the salad.',
        'Mix well and serve fresh.',
      ],
    ),
    RecipeItem(
      title: 'Zaatar Eggs Breakfast',
      image: 'assets/12.png',
      duration: '8 min',
      cookingItems: [
        'Olive Oil',
        'Zaatar',
      ],
      description:
          'A warm breakfast recipe using eggs, olive oil, and zaatar for a simple Palestinian-inspired morning dish.',
      ingredients: [
        '2 eggs',
        '1 tbsp Al’Ard Olive Oil',
        '1 tsp Palestinian Zaatar',
        'Salt and pepper',
        'Bread for serving',
      ],
      steps: [
        'Heat olive oil in a small pan.',
        'Add the eggs and cook gently.',
        'Sprinkle zaatar, salt, and pepper.',
        'Serve hot with bread.',
      ],
    ),
    RecipeItem(
      title: 'Zaatar Roasted Chicken',
      image: 'assets/13.png',
      duration: '35 min',
      cookingItems: [
        'Olive Oil',
        'Zaatar',
      ],
      description:
          'A rich roasted chicken recipe flavored with olive oil, zaatar, lemon, and herbs.',
      ingredients: [
        'Chicken pieces',
        '3 tbsp Al’Ard Olive Oil',
        '2 tbsp Palestinian Zaatar',
        'Lemon juice',
        'Salt and pepper',
        'Potatoes, optional',
      ],
      steps: [
        'Mix olive oil, zaatar, lemon juice, salt, and pepper.',
        'Coat the chicken well with the mixture.',
        'Place in a baking tray with potatoes.',
        'Bake until golden and fully cooked.',
      ],
    ),
  ];

  List<RecipeItem> get _filteredRecipes {
    final search = _query.trim().toLowerCase();
    final selectedItem = _selectedCookingItem.trim().toLowerCase();

    return _recipes.where((recipe) {
      final title = recipe.title.toLowerCase();
      final duration = recipe.duration.toLowerCase();
      final description = recipe.description.toLowerCase();
      final ingredients = recipe.ingredients.join(' ').toLowerCase();
      final cookingItems = recipe.cookingItems.join(' ').toLowerCase();

      final matchesSearch = search.isEmpty ||
          title.contains(search) ||
          duration.contains(search) ||
          description.contains(search) ||
          ingredients.contains(search) ||
          cookingItems.contains(search);

      final matchesCookingItem = selectedItem == 'all' ||
          recipe.cookingItems.any(
            (item) => item.toLowerCase() == selectedItem,
          );

      return matchesSearch && matchesCookingItem;
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(14, 6, 14, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.eco_outlined,
                          color: _olive,
                          size: 22,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            "Recipes using Al'Ard Products",
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
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
                      GridView.builder(
                        itemCount: recipes.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 14,
                          mainAxisSpacing: 16,
                          childAspectRatio: 0.62,
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

  Widget _buildHeader() {
    return SizedBox(
      height: 80,
      width: double.infinity,
      child: Stack(
        children: [
          Center(
            child: Image.asset(
              'assets/321.png',
              height: 56,
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

          Positioned(
            top: 14,
            right: 10,
            child: IconButton(
              onPressed: () {
                setState(() {
                  _showSearch = !_showSearch;

                  if (!_showSearch) {
                    _query = '';
                    _selectedCookingItem = 'All';
                    _searchController.clear();
                  }
                });
              },
              icon: Icon(
                _showSearch ? Icons.close_rounded : Icons.search_rounded,
                size: 34,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
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
          hintText: 'Search recipes...',
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
                  color: isSelected ? _olive : _olive.withOpacity(0.25),
                ),
              ),
              child: Center(
                child: Text(
                  item,
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
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 18),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.search_off_rounded,
            size: 52,
            color: Colors.black38,
          ),
          const SizedBox(height: 12),
          const Text(
            'No recipes found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Try Olive Oil, Zaatar, Sumac, Tahini, or Freekeh.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.black.withOpacity(0.55),
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
      MaterialPageRoute(
        builder: (_) => RecipeDetailsScreen(recipe: recipe),
      ),
    );
  }
}

class _RecipeCard extends StatelessWidget {
  final RecipeItem recipe;
  final VoidCallback onOpen;

  const _RecipeCard({
    required this.recipe,
    required this.onOpen,
  });

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
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.black87,
                    ),
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
                  child: const Text(
                    'View recipe',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
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
}

class RecipeDetailsScreen extends StatelessWidget {
  final RecipeItem recipe;

  const RecipeDetailsScreen({
    super.key,
    required this.recipe,
  });

  static const Color _background = Color(0xFFF7F3EE);
  static const Color _olive = Color(0xFF55682A);
  static const Color _card = Color(0xFFF1ECE5);

  @override
  Widget build(BuildContext context) {
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
                                Icons.restaurant_menu,
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
                    const Text(
                      'Ingredients',
                      style: TextStyle(
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
                              child: Icon(
                                Icons.circle,
                                size: 8,
                                color: _olive,
                              ),
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
                    const Text(
                      'Steps',
                      style: TextStyle(
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
    return Container(
      height: 74,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 24,
              color: Colors.black87,
            ),
          ),
          const Expanded(
            child: Text(
              'Recipe details',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
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