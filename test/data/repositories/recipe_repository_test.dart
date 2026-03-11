import 'package:flutter_test/flutter_test.dart';
import 'package:recipehub/data/models/recipe.dart';
import 'package:recipehub/data/repositories/recipe_repository.dart';
import 'package:recipehub/data/services/recipe_match_service.dart';

class _FakeRecipeRepository extends RecipeRepository {
  _FakeRecipeRepository(this._recipes);

  final List<Recipe> _recipes;

  @override
  Future<List<Recipe>> getAllRecipes() async => _recipes;
}

void main() {
  test('searchRecipesBySelectedIngredients returns repository-backed matches', () async {
    final repository = _FakeRecipeRepository(const <Recipe>[
      Recipe(
        id: 1,
        title: 'Tomato Pasta',
        ingredientsRaw: 'raw',
        instructions: 'cook',
        imageName: 'tomato-pasta',
        cleanedIngredients: "['tomato', 'garlic']",
      ),
      Recipe(
        id: 2,
        title: 'Fruit Bowl',
        ingredientsRaw: 'raw',
        instructions: 'mix',
        imageName: 'fruit-bowl',
        cleanedIngredients: "['apple', 'banana']",
      ),
    ]);

    final List<RecipeMatchResult> results =
        await repository.searchRecipesBySelectedIngredients(
      <String>['tomato'],
    );

    expect(results.length, 1);
    expect(results.first.recipe.title, 'Tomato Pasta');
  });
}
