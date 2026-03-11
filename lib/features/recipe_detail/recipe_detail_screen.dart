import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipehub/core/constants/app_assets.dart';
import 'package:recipehub/data/models/recipe.dart';
import 'package:recipehub/data/repositories/recipe_repository.dart';
import 'package:recipehub/features/saved_recipes/saved_recipes_provider.dart';

class RecipeDetailScreen extends StatelessWidget {
  const RecipeDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Object? args = ModalRoute.of(context)?.settings.arguments;
    final int? recipeId = _parseRecipeId(args);

    if (recipeId == null) {
      return const Scaffold(
        body: Center(child: Text('Recipe id is missing')),
      );
    }

    final RecipeRepository recipeRepository = context.read<RecipeRepository>();

    return Scaffold(
      appBar: AppBar(title: const Text('Recipe Detail')),
      body: FutureBuilder<Recipe?>(
        future: recipeRepository.getRecipeById(recipeId),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          final Recipe? recipe = snapshot.data;
          if (recipe == null) {
            return const Center(child: Text('Recipe not found'));
          }

          return Consumer<SavedRecipesProvider>(
            builder: (context, savedProvider, _) {
              final bool isSaved = savedProvider.isSaved(recipe.id);
              return ListView(
                padding: const EdgeInsets.all(12),
                children: <Widget>[
                  Text(recipe.title, style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 12),
                  Image.asset(
                    '${AppAssets.imageDirectory}${recipe.imageName}.jpg',
                    height: 220,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const SizedBox(
                        height: 220,
                        child: Center(child: Text('Image unavailable')),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  FilledButton.icon(
                    onPressed: () async {
                      if (isSaved) {
                        await savedProvider.unsaveRecipe(recipe.id);
                      } else {
                        await savedProvider.saveRecipe(recipe);
                      }
                    },
                    icon: Icon(isSaved ? Icons.bookmark_remove : Icons.bookmark_add),
                    label: Text(isSaved ? 'Unsave Recipe' : 'Save Recipe'),
                  ),
                  const SizedBox(height: 16),
                  Text('Ingredients', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text(recipe.ingredientsRaw),
                  const SizedBox(height: 16),
                  Text('Instructions', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text(recipe.instructions),
                ],
              );
            },
          );
        },
      ),
    );
  }

  int? _parseRecipeId(Object? args) {
    if (args is int) {
      return args;
    }
    if (args is String) {
      return int.tryParse(args);
    }
    return null;
  }
}
