import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipehub/app/routes.dart';
import 'package:recipehub/features/ingredients/ingredients_provider.dart';
import 'package:recipehub/features/my_fridge/my_fridge_provider.dart';
import 'package:recipehub/features/saved_recipes/saved_recipes_provider.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          Consumer3<IngredientsProvider, MyFridgeProvider, SavedRecipesProvider>(
            builder: (context, ingredients, fridge, saved, _) {
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Local Data Snapshot', style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 8),
                      Text('Ingredients loaded: ${ingredients.ingredients.length}'),
                      Text('Fridge items: ${fridge.items.length}'),
                      Text('Saved recipes: ${saved.savedRecipes.length}'),
                    ],
                  ),
                ),
              );
            },
          ),
          const _NavTile(title: 'Ingredients', route: AppRoutes.ingredients),
          const _NavTile(title: 'My Fridge', route: AppRoutes.myFridge),
          const _NavTile(title: 'Saved Recipes', route: AppRoutes.savedRecipes),
          const _NavTile(title: 'Recipe Results', route: AppRoutes.recipeResults),
          const _NavTile(title: 'Settings', route: AppRoutes.settings),
        ],
      ),
    );
  }
}

class _NavTile extends StatelessWidget {
  const _NavTile({required this.title, required this.route});

  final String title;
  final String route;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(title),
        subtitle: Text(route),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => Navigator.of(context).pushNamed(route),
      ),
    );
  }
}
