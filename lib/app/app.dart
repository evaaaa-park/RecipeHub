import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipehub/data/repositories/repositories.dart';
import 'package:recipehub/data/services/local_seed_service.dart';
import 'package:recipehub/features/ingredients/ingredients_provider.dart';
import 'package:recipehub/features/my_fridge/my_fridge_provider.dart';
import 'package:recipehub/features/recipe_results/recipe_results_provider.dart';
import 'package:recipehub/features/saved_recipes/saved_recipes_provider.dart';
import 'package:recipehub/features/settings/settings_provider.dart';

import 'routes.dart';
import 'theme.dart';

class RecipeHubApp extends StatefulWidget {
  const RecipeHubApp({super.key});

  @override
  State<RecipeHubApp> createState() => _RecipeHubAppState();
}

class _RecipeHubAppState extends State<RecipeHubApp> {
  late final LocalSeedService _seedService;
  late final CategoryRepository _categoryRepository;
  late final IngredientRepository _ingredientRepository;
  late final RecipeRepository _recipeRepository;
  late final FridgeItemRepository _fridgeItemRepository;
  late final SavedRecipeRepository _savedRecipeRepository;
  late final Future<void> _seedFuture;

  @override
  void initState() {
    super.initState();
    _seedService = LocalSeedService();
    _categoryRepository = CategoryRepository();
    _ingredientRepository = IngredientRepository();
    _recipeRepository = RecipeRepository();
    _fridgeItemRepository = FridgeItemRepository();
    _savedRecipeRepository = SavedRecipeRepository();
    _seedFuture = _seedService.seedIfNeeded();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _seedFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: buildRecipeHubTheme(),
            home: const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        if (snapshot.hasError) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: buildRecipeHubTheme(),
            home: const Scaffold(
              body: Center(child: Text('Failed to initialize local data')),
            ),
          );
        }

        return MultiProvider(
          providers: [
            Provider<CategoryRepository>.value(value: _categoryRepository),
            Provider<IngredientRepository>.value(value: _ingredientRepository),
            Provider<RecipeRepository>.value(value: _recipeRepository),
            Provider<FridgeItemRepository>.value(value: _fridgeItemRepository),
            Provider<SavedRecipeRepository>.value(value: _savedRecipeRepository),
            ChangeNotifierProvider<SettingsProvider>(
              create: (_) => SettingsProvider()..loadSettings(),
            ),
            ChangeNotifierProvider<IngredientsProvider>(
              create: (_) => IngredientsProvider(
                ingredientRepository: _ingredientRepository,
                categoryRepository: _categoryRepository,
              )..loadInitialData(),
            ),
            ChangeNotifierProvider<MyFridgeProvider>(
              create: (_) => MyFridgeProvider(
                fridgeRepository: _fridgeItemRepository,
              )..loadFridgeItems(),
            ),
            ChangeNotifierProvider<SavedRecipesProvider>(
              create: (_) => SavedRecipesProvider(
                savedRecipeRepository: _savedRecipeRepository,
              )..loadSavedRecipes(),
            ),
            ChangeNotifierProvider<RecipeResultsProvider>(
              create: (_) => RecipeResultsProvider(
                recipeRepository: _recipeRepository,
                fridgeRepository: _fridgeItemRepository,
              ),
            ),
          ],
          child: Consumer<SettingsProvider>(
            builder: (context, settings, _) {
              return MaterialApp(
                title: 'RecipeHub',
                debugShowCheckedModeBanner: false,
                theme: buildRecipeHubTheme(),
                darkTheme: buildRecipeHubDarkTheme(),
                themeMode: settings.isDarkMode ? ThemeMode.dark : ThemeMode.light,
                initialRoute: AppRoutes.dashboard,
                routes: AppRoutes.routes,
                onUnknownRoute: (_) => MaterialPageRoute<void>(
                  builder: (_) => const Scaffold(
                    body: Center(child: Text('Route not found')),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
