import 'package:flutter/material.dart';

class RecipeResultsScreen extends StatelessWidget {
  const RecipeResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recipe Results')),
      body: const Center(
        child: Text('Recipe Results screen shell'),
      ),
    );
  }
}
