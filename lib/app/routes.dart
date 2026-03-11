import 'package:flutter/material.dart';

class AppRoutes {
  static const String dashboard = '/dashboard';
  static const String ingredients = '/ingredients';
  static const String myFridge = '/my-fridge';
  static const String savedRecipes = '/saved-recipes';
  static const String recipeResults = '/recipe-results';
  static const String recipeDetail = '/recipe-detail';
  static const String settings = '/settings';

  static Map<String, WidgetBuilder> get routes => <String, WidgetBuilder>{
        dashboard: (_) => const _RouteShell(title: 'Dashboard'),
        ingredients: (_) => const _RouteShell(title: 'Ingredients'),
        myFridge: (_) => const _RouteShell(title: 'My Fridge'),
        savedRecipes: (_) => const _RouteShell(title: 'Saved Recipes'),
        recipeResults: (_) => const _RouteShell(title: 'Recipe Results'),
        recipeDetail: (_) => const _RouteShell(title: 'Recipe Detail'),
        settings: (_) => const _RouteShell(title: 'Settings'),
      };
}

class _RouteShell extends StatelessWidget {
  const _RouteShell({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Text(
          '$title screen shell',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
