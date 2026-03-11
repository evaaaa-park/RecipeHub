import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipehub/app/routes.dart';
import 'package:recipehub/features/saved_recipes/saved_recipes_provider.dart';

class SavedRecipesScreen extends StatelessWidget {
  const SavedRecipesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Saved Recipes')),
      body: Consumer<SavedRecipesProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.errorMessage != null) {
            return Center(child: Text(provider.errorMessage!));
          }
          if (provider.savedRecipes.isEmpty) {
            return const Center(child: Text('No saved recipes yet'));
          }

          return ListView.builder(
            itemCount: provider.savedRecipes.length,
            itemBuilder: (context, index) {
              final saved = provider.savedRecipes[index];
              return ListTile(
                title: Text(saved.recipeTitle),
                subtitle: Text('Saved: ${saved.savedAt}'),
                onTap: () {
                  Navigator.of(
                    context,
                  ).pushNamed(AppRoutes.recipeDetail, arguments: saved.recipeId);
                },
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () => provider.unsaveRecipe(saved.recipeId),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
