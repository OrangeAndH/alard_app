import 'package:flutter/material.dart';

class RecipesScreen extends StatelessWidget {
  const RecipesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final recipes = [
      RecipeModel(
        title: "Olive Oil & Zaatar Bread Dip",
        time: "5 min",
        imagePath: "assets/10.png",
        ingredients: const [
          "1/2 cup olive oil",
          "2 tbsp zaatar (thyme, sesame seeds, sumac mix)",
          "A pinch of salt",
          "Fresh pita bread for serving",
        ],
        instructions: const [
          "Pour the olive oil into a small shallow bowl.",
          "Add the zaatar and a pinch of salt.",
          "Lightly mix or leave layered for dipping.",
          "Serve with warm pita bread for dipping.",
        ],
      ),
      RecipeModel(
        title: "Palestinian Sumac Salad",
        time: "10 min",
        imagePath: "assets/11.png",
        ingredients: const [
          "2 cups chopped lettuce",
          "1 cup diced cucumber",
          "1 cup halved cherry tomatoes",
          "1/4 cup thinly sliced red onion",
          "2 tbsp sumac",
          "1/4 cup olive oil",
          "Juice of 1 lemon",
          "Salt to taste",
          "Optional: feta or white cheese",
        ],
        instructions: const [
          "In a large bowl, combine lettuce, cucumber, tomatoes, and onion.",
          "Add the sumac and toss well.",
          "Drizzle with olive oil and lemon juice.",
          "Season with salt and mix gently.",
          "Top with cheese if desired and serve immediately.",
        ],
      ),
      RecipeModel(
        title: "Zaatar Eggs",
        time: "10 min",
        imagePath: "assets/12.png",
        ingredients: const [
          "3 eggs",
          "2 tbsp olive oil",
          "1 tbsp zaatar",
          "A pinch of salt",
          "Yogurt or labneh (optional, for serving)",
          "Bread",
        ],
        instructions: const [
          "Heat olive oil in a pan over medium heat.",
          "Crack the eggs into the pan.",
          "Sprinkle zaatar and salt over the eggs.",
          "Cook until done to your preference.",
          "Serve with labneh or yogurt and bread.",
        ],
      ),
      RecipeModel(
        title: "Zaatar Roasted Chicken",
        time: "40 min",
        imagePath: "assets/13.png",
        ingredients: const [
          "1 kg chicken (pieces or whole)",
          "3 tbsp olive oil",
          "2 tbsp zaatar",
          "3 garlic cloves (minced)",
          "Juice of 1 lemon",
          "1 tsp salt",
          "1/2 tsp black pepper",
          "Potatoes (optional, chopped)",
        ],
        instructions: const [
          "Preheat oven to 200°C (400°F).",
          "In a bowl, mix olive oil, zaatar, garlic, lemon juice, salt, and pepper.",
          "Rub the mixture all over the chicken.",
          "Place chicken in a baking tray and add potatoes if using.",
          "Roast for 35–45 minutes until golden and fully cooked.",
          "Serve hot.",
        ],
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF7F3EE),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _RecipesTopBar(),
              const SizedBox(height: 6),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Icon(
                      Icons.spa_outlined,
                      color: Color(0xFF6B7A2B),
                      size: 18,
                    ),
                    SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        "Recipes using Al'Ard Products",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GridView.builder(
                  itemCount: recipes.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 14,
                    childAspectRatio: 0.70,
                  ),
                  itemBuilder: (context, index) {
                    final recipe = recipes[index];
                    return _RecipeCard(recipe: recipe);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RecipesTopBar extends StatelessWidget {
  const _RecipesTopBar();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.menu, size: 28),
          ),
          const Spacer(),
          Image.asset(
            'assets/2.png',
            height: 48,
            errorBuilder: (context, error, stackTrace) {
              return const Text(
                "AL'ARD",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF5D6B1F),
                ),
              );
            },
          ),
          const Spacer(),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search, size: 28),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.shopping_cart_outlined, size: 28),
          ),
        ],
      ),
    );
  }
}

class _RecipeCard extends StatelessWidget {
  final RecipeModel recipe;

  const _RecipeCard({required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFFF1EDE6),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 1.35,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.asset(
                recipe.imagePath,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.white,
                    child: const Center(
                      child: Icon(
                        Icons.image_outlined,
                        size: 46,
                        color: Colors.grey,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            recipe.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.access_time_filled, size: 16),
              const SizedBox(width: 4),
              Text(
                recipe.time,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => RecipeDetailsScreen(recipe: recipe),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6B7A2B),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22),
                ),
                padding: const EdgeInsets.symmetric(vertical: 10),
              ),
              child: const Text(
                'VIEW RECIPES',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RecipeDetailsScreen extends StatelessWidget {
  final RecipeModel recipe;

  const RecipeDetailsScreen({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F3EE),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _RecipesTopBar(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    const Icon(
                      Icons.spa_outlined,
                      color: Color(0xFF6B7A2B),
                      size: 18,
                    ),
                    const SizedBox(width: 6),
                    const Expanded(
                      child: Text(
                        "Recipes using Al'Ard Products",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: AspectRatio(
                    aspectRatio: 1.7,
                    child: Image.asset(
                      recipe.imagePath,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.white,
                          child: const Center(
                            child: Icon(
                              Icons.image_outlined,
                              size: 50,
                              color: Colors.grey,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  recipe.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Ingredients:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: recipe.ingredients.map((item) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Text(
                        '• $item',
                        style: const TextStyle(
                          fontSize: 15,
                          height: 1.35,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 16),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Instructions:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(recipe.instructions.length, (index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        '${index + 1}. ${recipe.instructions[index]}',
                        style: const TextStyle(
                          fontSize: 15,
                          height: 1.4,
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RecipeModel {
  final String title;
  final String time;
  final String imagePath;
  final List<String> ingredients;
  final List<String> instructions;

  const RecipeModel({
    required this.title,
    required this.time,
    required this.imagePath,
    required this.ingredients,
    required this.instructions,
  });
}