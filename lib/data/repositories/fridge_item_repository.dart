import 'package:recipehub/data/database/app_database.dart';
import 'package:recipehub/data/database/db_tables.dart';
import 'package:recipehub/data/models/fridge_item.dart';

class FridgeItemRepository {
  FridgeItemRepository({AppDatabase? database})
    : _database = database ?? AppDatabase.instance;

  final AppDatabase _database;

  Future<List<FridgeItem>> getAllFridgeItems() async {
    final db = await _database.database;
    final List<Map<String, Object?>> rows = await db.query(
      DbTables.fridgeItems,
      orderBy: 'ingredient_name COLLATE NOCASE ASC',
    );
    return rows.map(FridgeItem.fromMap).toList();
  }
}
