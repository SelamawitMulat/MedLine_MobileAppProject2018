import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AppDatabase {
  static const _dbName = 'medline.db';
  static const _dbVersion = 3;
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
    // Creating tables
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
    await _ensureVisitSummariesTable(db);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // This will run the table checks if migrating from version 1 or 2
    await _ensureUsersTable(db);
    await _ensureVisitSummariesTable(db);
  }

  Future<void> _ensureUsersTable(Database db) async {
    final tableInfo = await db.rawQuery('PRAGMA table_info(users)');
    final existingColumns = tableInfo.map((c) => c['name'] as String).toSet();

    if (existingColumns.isEmpty) {
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
    } else {
      final needed = {'username', 'role', 'name', 'email', 'isLoggedIn'};
      for (var col in needed) {
        if (!existingColumns.contains(col)) {
          await db.execute('ALTER TABLE users ADD COLUMN $col TEXT');
        }
      }
    }
  }

  Future<void> _ensureVisitSummariesTable(Database db) async {
    final tableInfo =
        await db.rawQuery('PRAGMA table_info(visit_summaries_cache)');
    final existingColumns = tableInfo.map((c) => c['name'] as String).toSet();

    if (existingColumns.isEmpty) {
      await db.execute('''
        CREATE TABLE visit_summaries_cache (
          appointmentId TEXT PRIMARY KEY,
          patientName TEXT,
          doctorName TEXT,
          date TEXT,
          timeSlot TEXT,
          diagnosis TEXT,
          prescription TEXT
        )
      ''');
    } else {
      final needed = {
        'patientName',
        'doctorName',
        'date',
        'timeSlot',
        'diagnosis',
        'prescription'
      };
      for (var col in needed) {
        if (!existingColumns.contains(col)) {
          await db.execute(
              'ALTER TABLE visit_summaries_cache ADD COLUMN $col TEXT');
        }
      }
    }
  }

  // --- Helper Methods ---

  Future<void> insert(String table, Map<String, dynamic> data) async {
    final db = await database;
    await db.insert(table, data, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> getAll(String table) async {
    final db = await database;
    return await db.query(table);
  }

  Future<Map<String, dynamic>?> getSingle(String table,
      {String? where, List<dynamic>? whereArgs}) async {
    final db = await database;
    final results =
        await db.query(table, where: where, whereArgs: whereArgs, limit: 1);
    return results.isNotEmpty ? results.first : null;
  }

  Future<void> clearTable(String table) async {
    final db = await database;
    await db.delete(table);
  }

  Future<void> delete(String table,
      {String? where, List<dynamic>? whereArgs}) async {
    final db = await database;
    await db.delete(table, where: where, whereArgs: whereArgs);
  }
}
