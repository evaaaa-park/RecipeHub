import 'package:flutter/material.dart';
import 'package:recipehub/app/routes.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const <Widget>[
          _NavTile(title: 'Ingredients', route: AppRoutes.ingredients),
          _NavTile(title: 'My Fridge', route: AppRoutes.myFridge),
          _NavTile(title: 'Saved Recipes', route: AppRoutes.savedRecipes),
          _NavTile(title: 'Recipe Results', route: AppRoutes.recipeResults),
          _NavTile(title: 'Recipe Detail', route: AppRoutes.recipeDetail),
          _NavTile(title: 'Settings', route: AppRoutes.settings),
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
