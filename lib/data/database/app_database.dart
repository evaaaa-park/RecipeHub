import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

import 'db_tables.dart';

class AppDatabase {
  AppDatabase._();

  static final AppDatabase instance = AppDatabase._();

  static const String _databaseName = 'recipehub.db';
  static const int _databaseVersion = 1;

  Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _open();
    return _database!;
  }

  Future<Database> _open() async {
    final String dbPath = await getDatabasesPath();
    final String path = p.join(dbPath, _databaseName);
    return openDatabase(
      path,
      version: _databaseVersion,
      onConfigure: _onConfigure,
      onCreate: _onCreate,
    );
  }

  Future<void> _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON;');
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE ${DbTables.categories} (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT UNIQUE NOT NULL
      );
    ''');

    await db.execute('''
      CREATE TABLE ${DbTables.ingredients} (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT UNIQUE NOT NULL,
        category_name TEXT NOT NULL
      );
    ''');

    await db.execute('''
      CREATE TABLE ${DbTables.recipes} (
        id INTEGER PRIMARY KEY,
        title TEXT NOT NULL,
        ingredients_raw TEXT NOT NULL,
        instructions TEXT NOT NULL,
        image_name TEXT,
        cleaned_ingredients TEXT NOT NULL
      );
    ''');

    await db.execute('''
      CREATE TABLE ${DbTables.fridgeItems} (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        ingredient_id INTEGER NOT NULL,
        ingredient_name TEXT NOT NULL,
        quantity TEXT,
        expiry_date TEXT,
        is_selected INTEGER DEFAULT 0,
        added_at TEXT NOT NULL,
        UNIQUE(ingredient_id)
      );
    ''');

    await db.execute('''
      CREATE TABLE ${DbTables.savedRecipes} (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        recipe_id INTEGER NOT NULL,
        recipe_title TEXT NOT NULL,
        saved_at TEXT NOT NULL,
        UNIQUE(recipe_id)
      );
    ''');
  }

  Future<void> close() async {
    await _database?.close();
    _database = null;
  }
}
