import 'package:recipehub/data/database/app_database.dart';
import 'package:recipehub/data/database/db_tables.dart';
import 'package:recipehub/data/models/recipe.dart';

class RecipeRepository {
  RecipeRepository({AppDatabase? database})
    : _database = database ?? AppDatabase.instance;

  final AppDatabase _database;

  Future<List<Recipe>> getAllRecipes() async {
    final db = await _database.database;
    final List<Map<String, Object?>> rows = await db.query(
      DbTables.recipes,
      orderBy: 'title COLLATE NOCASE ASC',
    );
    return rows.map(Recipe.fromMap).toList();
  }

  Future<Recipe?> getRecipeById(int recipeId) async {
    final db = await _database.database;
    final List<Map<String, Object?>> rows = await db.query(
      DbTables.recipes,
      where: 'id = ?',
      whereArgs: <Object?>[recipeId],
      limit: 1,
    );
    if (rows.isEmpty) {
      return null;
    }
    return Recipe.fromMap(rows.first);
  }
}
