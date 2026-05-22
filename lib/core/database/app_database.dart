import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AppDatabase {
  static const _dbName = 'medline.db';
  static const _dbVersion = 2;
  static Database? _database;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), _dbName);
    return await openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE appointments_cache (
        id TEXT PRIMARY KEY,
        patientId TEXT,
        doctorName TEXT,
        dateTime TEXT,
        bookingTimestamp TEXT
      )
    ''');

    await _ensureUsersTable(db);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await _ensureUsersTable(db);
    }
  }

  Future<void> _ensureUsersTable(Database db) async {
    final tableInfo = await db.rawQuery('PRAGMA table_info(users)');

    if (tableInfo.isEmpty) {
      await db.execute('''
        CREATE TABLE users (
          id TEXT PRIMARY KEY,
          username TEXT,
          name TEXT,
          email TEXT,
          role TEXT,
          isLoggedIn INTEGER
        )
      ''');
      return;
    }

    final existingColumns = tableInfo
        .map((column) => column['name']?.toString() ?? '')
        .where((name) => name.isNotEmpty)
        .toSet();

    if (!existingColumns.contains('username')) {
      await db.execute('ALTER TABLE users ADD COLUMN username TEXT');
    }
    if (!existingColumns.contains('role')) {
      await db.execute('ALTER TABLE users ADD COLUMN role TEXT');
    }
    if (!existingColumns.contains('name')) {
      await db.execute('ALTER TABLE users ADD COLUMN name TEXT');
    }
    if (!existingColumns.contains('email')) {
      await db.execute('ALTER TABLE users ADD COLUMN email TEXT');
    }
    if (!existingColumns.contains('isLoggedIn')) {
      await db.execute('ALTER TABLE users ADD COLUMN isLoggedIn INTEGER');
    }
  }

  Future<void> clearTable(String table) async {
    final db = await database;
    await db.delete(table);
  }

  Future<void> insert(String table, Map<String, dynamic> data) async {
    final db = await database;
    await db.insert(table, data, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> getAll(String table) async {
    final db = await database;
    return await db.query(table);
  }

  // Added helper to look up a single record directly
  Future<Map<String, dynamic>?> getSingle(String table,
      {String? where, List<dynamic>? whereArgs}) async {
    final db = await database;
    final results =
        await db.query(table, where: where, whereArgs: whereArgs, limit: 1);
    return results.isNotEmpty ? results.first : null;
  }

  Future<void> delete(String table,
      {String? where, List<dynamic>? whereArgs}) async {
    final db = await database;
    await db.delete(table, where: where, whereArgs: whereArgs);
  }
}
