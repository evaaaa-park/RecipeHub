import 'package:recipehub/data/database/app_database.dart';
import 'package:recipehub/data/database/db_tables.dart';
import 'package:recipehub/data/models/ingredient.dart';

class IngredientRepository {
  IngredientRepository({AppDatabase? database})
    : _database = database ?? AppDatabase.instance;

  final AppDatabase _database;

  Future<List<Ingredient>> getAllIngredients() async {
    final db = await _database.database;
    final List<Map<String, Object?>> rows = await db.query(
      DbTables.ingredients,
      orderBy: 'name COLLATE NOCASE ASC',
    );
    return rows.map(Ingredient.fromMap).toList();
  }

  Future<List<Ingredient>> searchIngredients(String query) async {
    final String cleaned = query.trim();
    if (cleaned.isEmpty) {
      return getAllIngredients();
    }

    final db = await _database.database;
    final List<Map<String, Object?>> rows = await db.query(
      DbTables.ingredients,
      where: 'name LIKE ?',
      whereArgs: <Object?>['%$cleaned%'],
      orderBy: 'name COLLATE NOCASE ASC',
    );
    return rows.map(Ingredient.fromMap).toList();
  }

  Future<List<Ingredient>> getIngredientsByIds(List<int> ingredientIds) async {
    if (ingredientIds.isEmpty) {
      return const <Ingredient>[];
    }

    final db = await _database.database;
    final String placeholders = List<String>.filled(ingredientIds.length, '?')
        .join(',');
    final List<Map<String, Object?>> rows = await db.query(
      DbTables.ingredients,
      where: 'id IN ($placeholders)',
      whereArgs: ingredientIds.cast<Object?>(),
      orderBy: 'name COLLATE NOCASE ASC',
    );
    return rows.map(Ingredient.fromMap).toList();
  }
}
