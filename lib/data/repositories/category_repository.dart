import 'package:recipehub/data/database/app_database.dart';
import 'package:recipehub/data/database/db_tables.dart';
import 'package:recipehub/data/models/category.dart';

class CategoryRepository {
  CategoryRepository({AppDatabase? database})
    : _database = database ?? AppDatabase.instance;

  final AppDatabase _database;

  Future<List<Category>> getAllCategories() async {
    final db = await _database.database;
    final List<Map<String, Object?>> rows = await db.query(
      DbTables.categories,
      orderBy: 'name COLLATE NOCASE ASC',
    );
    return rows.map(Category.fromMap).toList();
  }
}
