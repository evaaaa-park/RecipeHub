import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipehub/app/routes.dart';
import 'package:recipehub/features/recipe_results/recipe_results_provider.dart';

class RecipeResultsScreen extends StatelessWidget {
  const RecipeResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recipe Results')),
      body: Consumer<RecipeResultsProvider>(
        builder: (context, provider, _) {
          return Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(12),
                child: FilledButton.icon(
                  onPressed: provider.isLoading
                      ? null
                      : provider.searchFromSelectedFridgeIngredients,
                  icon: const Icon(Icons.search),
                  label: const Text('Search with selected fridge ingredients'),
                ),
              ),
              if (provider.isLoading)
                const Expanded(
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (provider.errorMessage != null)
                Expanded(child: Center(child: Text(provider.errorMessage!)))
              else if (provider.noSelection)
                const Expanded(
                  child: Center(child: Text('Select at least one fridge ingredient')),
                )
              else if (provider.results.isEmpty)
                const Expanded(
                  child: Center(child: Text('No matching recipes yet')),
                )
              else
                Expanded(
                  child: ListView.builder(
                    itemCount: provider.results.length,
                    itemBuilder: (context, index) {
                      final result = provider.results[index];
                      return ListTile(
                        title: Text(result.recipe.title),
                        subtitle: Text(
                          'Matches: ${result.matchCount} (${result.matchedIngredients.join(', ')})',
                        ),
                        onTap: () {
                          Navigator.of(context).pushNamed(
                            AppRoutes.recipeDetail,
                            arguments: result.recipe.id,
                          );
                        },
                      );
                    },
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
