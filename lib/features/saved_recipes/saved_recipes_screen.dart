import 'package:flutter/material.dart';

class SavedRecipesScreen extends StatelessWidget {
  const SavedRecipesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Saved Recipes')),
      body: const Center(
        child: Text('Saved Recipes screen shell'),
      ),
    );
  }
}
