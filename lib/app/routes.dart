import 'package:flutter/material.dart';
import 'package:recipehub/features/dashboard/dashboard_screen.dart';
import 'package:recipehub/features/ingredients/ingredients_screen.dart';
import 'package:recipehub/features/my_fridge/my_fridge_screen.dart';
import 'package:recipehub/features/recipe_detail/recipe_detail_screen.dart';
import 'package:recipehub/features/recipe_results/recipe_results_screen.dart';
import 'package:recipehub/features/saved_recipes/saved_recipes_screen.dart';
import 'package:recipehub/features/settings/settings_screen.dart';

class AppRoutes {
  static const String dashboard = '/dashboard';
  static const String ingredients = '/ingredients';
  static const String myFridge = '/my-fridge';
  static const String savedRecipes = '/saved-recipes';
  static const String recipeResults = '/recipe-results';
  static const String recipeDetail = '/recipe-detail';
  static const String settings = '/settings';

  static Map<String, WidgetBuilder> get routes => <String, WidgetBuilder>{
        dashboard: (_) => const DashboardScreen(),
        ingredients: (_) => const IngredientsScreen(),
        myFridge: (_) => const MyFridgeScreen(),
        savedRecipes: (_) => const SavedRecipesScreen(),
        recipeResults: (_) => const RecipeResultsScreen(),
        recipeDetail: (_) => const RecipeDetailScreen(),
        settings: (_) => const SettingsScreen(),
      };
}
