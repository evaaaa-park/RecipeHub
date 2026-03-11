import 'package:flutter_test/flutter_test.dart';
import 'package:recipehub/data/models/recipe.dart';
import 'package:recipehub/data/services/recipe_match_service.dart';

void main() {
  const RecipeMatchService service = RecipeMatchService();

  const recipes = <Recipe>[
    Recipe(
      id: 1,
      title: 'Pasta',
      ingredientsRaw: 'raw',
      instructions: 'cook',
      imageName: 'pasta',
      cleanedIngredients: "['olive oil', 'tomato', 'garlic']",
    ),
    Recipe(
      id: 2,
      title: 'Salad',
      ingredientsRaw: 'raw',
      instructions: 'mix',
      imageName: 'salad',
      cleanedIngredients: "['lettuce', 'cucumber']",
    ),
  ];

  test('returns empty when selected ingredients are empty', () {
    final results = service.matchRecipes(
      recipes: recipes,
      selectedIngredients: const <String>[],
    );
    expect(results, isEmpty);
  });

  test('matches and sorts by match count', () {
    final results = service.matchRecipes(
      recipes: recipes,
      selectedIngredients: const <String>['tomato', 'olive oil', 'lettuce'],
    );

    expect(results.length, 2);
    expect(results.first.recipe.title, 'Pasta');
    expect(results.first.matchCount, 2);
    expect(results.last.recipe.title, 'Salad');
    expect(results.last.matchCount, 1);
  });
}
