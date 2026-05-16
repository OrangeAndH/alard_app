import 'package:flutter/material.dart';

import '../../state/app_state_scope.dart';
import '../../theme/app_colors.dart';

import '../../models/content_models.dart';
/// Full-screen recipe detail view pushed from RecipesScreen.
/// Estimated lines: ~185
class RecipeDetailsScreen extends StatelessWidget {
  final RecipeItem recipe;
  const RecipeDetailsScreen({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(context, state),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(22),
                        child: recipe.image.startsWith('http')
                            ? Image.network(
                                recipe.image,
                                width: double.infinity,
                                height: 240,
                                fit: BoxFit.cover,
                                errorBuilder: (_, _, _) => _errorPlaceholder(),
                              )
                            : Image.asset(
                                recipe.image,
                                width: double.infinity,
                                height: 240,
                                fit: BoxFit.cover,
                                errorBuilder: (_, _, _) => _errorPlaceholder(),
                              ),
                      ),
                    const SizedBox(height: 16),
                    Text(
                      recipe.title.get(state.locale.languageCode),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.access_time_filled,
                            size: 18, color: AppColors.olive),
                        const SizedBox(width: 6),
                        Text(
                          recipe.duration,
                          style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.olive),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.cream,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        recipe.description.get(state.locale.languageCode),
                        style: const TextStyle(
                            fontSize: 15, height: 1.5, color: Colors.black87),
                      ),
                    ),
                    const SizedBox(height: 18),
                    _sectionTitle(state.t('recipes_ingredients')),
                    const SizedBox(height: 10),
                    ...recipe.ingredients.map(
                      (item) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(top: 5),
                              child: Icon(Icons.circle,
                                  size: 8, color: AppColors.olive),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(item.get(state.locale.languageCode),
                                  style: const TextStyle(
                                      fontSize: 15, height: 1.4)),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    _sectionTitle(state.t('recipes_steps')),
                    const SizedBox(height: 10),
                    ...List.generate(recipe.steps.length, (i) => Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.cream,
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
                              color: AppColors.olive,
                              shape: BoxShape.circle,
                            ),
                            child: Text('${i + 1}',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700)),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(recipe.steps[i].get(state.locale.languageCode),
                                style: const TextStyle(
                                    fontSize: 15,
                                    height: 1.5,
                                    color: Colors.black87)),
                          ),
                        ],
                      ),
                    )),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 19,
        fontWeight: FontWeight.w800,
        color: AppColors.olive,
      ),
    );
  }

  Widget _buildTopBar(BuildContext context, dynamic state) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final barHeight = (width * 0.16).clamp(56.0, 70.0);
        final buttonSize = (width * 0.11).clamp(38.0, 46.0);

        return Container(
          height: barHeight,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                padding: EdgeInsets.zero,
                constraints:
                    BoxConstraints.tightFor(width: buttonSize, height: buttonSize),
                icon: Icon(Icons.adaptive.arrow_back,
                    size: 28, color: Colors.black87),
              ),
              const Spacer(),
              Text(
                state.t('recipe_details_title'),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.olive,
                ),
              ),
              const Spacer(),
              SizedBox(width: buttonSize),
            ],
          ),
        );
      },
    );
  }
  Widget _errorPlaceholder() {
    return Container(
      height: 240,
      color: AppColors.whyFrameBackground,
      child: const Center(
        child: Icon(Icons.restaurant_rounded, size: 50, color: Colors.black38),
      ),
    );
  }
}
