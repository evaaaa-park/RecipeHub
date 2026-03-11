import 'package:recipehub/data/models/recipe.dart';

class RecipeMatchResult {
  const RecipeMatchResult({
    required this.recipe,
    required this.matchCount,
    required this.matchedIngredients,
  });

  final Recipe recipe;
  final int matchCount;
  final List<String> matchedIngredients;
}

class RecipeMatchService {
  const RecipeMatchService();

  List<RecipeMatchResult> matchRecipes({
    required List<Recipe> recipes,
    required List<String> selectedIngredients,
  }) {
    final Set<String> selected = selectedIngredients
        .map(_normalize)
        .where((value) => value.isNotEmpty)
        .toSet();
    if (selected.isEmpty) {
      return const <RecipeMatchResult>[];
    }

    final List<RecipeMatchResult> matches = <RecipeMatchResult>[];
    for (final Recipe recipe in recipes) {
      // Matching approach:
      // 1) Parse `cleaned_ingredients` into normalized ingredient tokens.
      // 2) Consider a match when either side contains the other to handle
      //    mild naming differences (e.g., "olive oil" vs "extra virgin olive oil").
      // 3) Sort descending by match count, then by title.
      final Set<String> recipeTokens = _extractRecipeTokens(
        recipe.cleanedIngredients,
      );

      final List<String> matched = <String>[];
      for (final String selectedIngredient in selected) {
        final bool isMatched = recipeTokens.any(
          (token) =>
              token == selectedIngredient ||
              token.contains(selectedIngredient) ||
              selectedIngredient.contains(token),
        );
        if (isMatched) {
          matched.add(selectedIngredient);
        }
      }

      if (matched.isNotEmpty) {
        matches.add(
          RecipeMatchResult(
            recipe: recipe,
            matchCount: matched.length,
            matchedIngredients: matched,
          ),
        );
      }
    }

    matches.sort((a, b) {
      final int byCount = b.matchCount.compareTo(a.matchCount);
      if (byCount != 0) {
        return byCount;
      }
      return a.recipe.title.toLowerCase().compareTo(b.recipe.title.toLowerCase());
    });
    return matches;
  }

  Set<String> _extractRecipeTokens(String cleanedIngredients) {
    final String normalizedList = cleanedIngredients
        .replaceAll('[', '')
        .replaceAll(']', '')
        .replaceAll("'", '')
        .trim();

    if (normalizedList.isEmpty) {
      return const <String>{};
    }

    final Iterable<String> pieces = normalizedList.split(',');
    return pieces.map(_normalize).where((value) => value.isNotEmpty).toSet();
  }

  String _normalize(String input) {
    final String lower = input.toLowerCase().trim();
    if (lower.isEmpty) {
      return '';
    }
    return lower.replaceAll(RegExp(r'[^a-z0-9 ]+'), ' ').replaceAll(
      RegExp(r'\s+'),
      ' ',
    ).trim();
  }
}
