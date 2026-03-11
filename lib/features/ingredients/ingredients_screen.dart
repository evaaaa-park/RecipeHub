import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipehub/features/ingredients/ingredients_provider.dart';
import 'package:recipehub/features/my_fridge/my_fridge_provider.dart';

class IngredientsScreen extends StatefulWidget {
  const IngredientsScreen({super.key});

  @override
  State<IngredientsScreen> createState() => _IngredientsScreenState();
}

class _IngredientsScreenState extends State<IngredientsScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ingredients')),
      body: Consumer2<IngredientsProvider, MyFridgeProvider>(
        builder: (context, ingredientsProvider, fridgeProvider, _) {
          return Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(12),
                child: TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: 'Search ingredients',
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: ingredientsProvider.search,
                ),
              ),
              if (ingredientsProvider.isLoading)
                const Expanded(
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (ingredientsProvider.errorMessage != null)
                Expanded(
                  child: Center(child: Text(ingredientsProvider.errorMessage!)),
                )
              else
                Expanded(
                  child: ListView.builder(
                    itemCount: ingredientsProvider.ingredients.length,
                    itemBuilder: (context, index) {
                      final ingredient = ingredientsProvider.ingredients[index];
                      return ListTile(
                        title: Text(ingredient.name),
                        subtitle: Text(ingredient.category),
                        trailing: IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () async {
                            await fridgeProvider.addIngredient(ingredient);
                            if (!context.mounted) {
                              return;
                            }
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('${ingredient.name} added to My Fridge'),
                              ),
                            );
                          },
                        ),
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
