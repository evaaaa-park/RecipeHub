import 'package:flutter/material.dart';

import 'routes.dart';
import 'theme.dart';

class RecipeHubApp extends StatelessWidget {
  const RecipeHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RecipeHub',
      debugShowCheckedModeBanner: false,
      theme: buildRecipeHubTheme(),
      initialRoute: AppRoutes.dashboard,
      routes: AppRoutes.routes,
      onUnknownRoute: (_) => MaterialPageRoute<void>(
        builder: (_) => const Scaffold(
          body: Center(child: Text('Route not found')),
        ),
      ),
    );
  }
}
