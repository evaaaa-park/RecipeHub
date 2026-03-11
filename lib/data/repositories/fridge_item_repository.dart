import 'package:recipehub/data/database/app_database.dart';
import 'package:recipehub/data/database/db_tables.dart';
import 'package:recipehub/data/models/fridge_item.dart';
import 'package:sqflite/sqflite.dart';

class FridgeItemRepository {
  FridgeItemRepository({AppDatabase? database})
    : _database = database ?? AppDatabase.instance;

  final AppDatabase _database;

  Future<void> addIngredientToFridge({
    required int ingredientId,
    required String ingredientName,
    String? quantity,
    String? expiryDate,
    bool isSelected = false,
  }) async {
    final db = await _database.database;
    final String now = DateTime.now().toIso8601String();

    await db.insert(DbTables.fridgeItems, <String, Object?>{
      'ingredient_id': ingredientId,
      'ingredient_name': ingredientName.trim(),
      'quantity': _normalizeOptionalText(quantity),
      'expiry_date': _normalizeOptionalText(expiryDate),
      'is_selected': isSelected ? 1 : 0,
      'added_at': now,
    }, conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  Future<List<FridgeItem>> getAllFridgeItems() async {
    final db = await _database.database;
    final List<Map<String, Object?>> rows = await db.query(
      DbTables.fridgeItems,
      orderBy: 'ingredient_name COLLATE NOCASE ASC',
    );
    return rows.map(FridgeItem.fromMap).toList();
  }

  Future<List<FridgeItem>> getSelectedFridgeItems() async {
    final db = await _database.database;
    final List<Map<String, Object?>> rows = await db.query(
      DbTables.fridgeItems,
      where: 'is_selected = 1',
      orderBy: 'ingredient_name COLLATE NOCASE ASC',
    );
    return rows.map(FridgeItem.fromMap).toList();
  }

  Future<void> updateFridgeItem({
    required int ingredientId,
    String? quantity,
    String? expiryDate,
    bool? isSelected,
  }) async {
    final db = await _database.database;
    final Map<String, Object?> values = <String, Object?>{};

    if (quantity != null) {
      values['quantity'] = _normalizeOptionalText(quantity);
    }
    if (expiryDate != null) {
      values['expiry_date'] = _normalizeOptionalText(expiryDate);
    }
    if (isSelected != null) {
      values['is_selected'] = isSelected ? 1 : 0;
    }
    if (values.isEmpty) {
      return;
    }

    await db.update(
      DbTables.fridgeItems,
      values,
      where: 'ingredient_id = ?',
      whereArgs: <Object?>[ingredientId],
    );
  }

  Future<void> deleteIngredientFromFridge(int ingredientId) async {
    final db = await _database.database;
    await db.delete(
      DbTables.fridgeItems,
      where: 'ingredient_id = ?',
      whereArgs: <Object?>[ingredientId],
    );
  }
}

String? _normalizeOptionalText(String? value) {
  if (value == null) {
    return null;
  }
  final String cleaned = value.trim();
  return cleaned.isEmpty ? null : cleaned;
}
