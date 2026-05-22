import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:med_line/core/database/tables.dart';

class AppDatabase {
  static final AppDatabase _instance = AppDatabase._internal();
  factory AppDatabase() => _instance;
  AppDatabase._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'medline.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE ${Tables.userSession} (
            id TEXT PRIMARY KEY,
            username TEXT,
            password TEXT,
            role TEXT,
            name TEXT,
            email TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE ${Tables.appointmentsCache} (
            id TEXT PRIMARY KEY,
            doctorId TEXT,
            patientId TEXT,
            date TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE ${Tables.visitSummariesCache} (
            id TEXT PRIMARY KEY,
            appointmentId TEXT,
            summary TEXT
          )
        ''');
      },
    );
  }

  Future<int> insert(String table, Map<String, dynamic> data) async {
    final db = await database;
    return await db.insert(table, data, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<Map<String, dynamic>?> getSingle(String table) async {
    final db = await database;
    final result = await db.query(table, limit: 1);
    return result.isNotEmpty ? result.first : null;
  }

  Future<List<Map<String, dynamic>>> getAll(String table) async {
    final db = await database;
    return await db.query(table);
  }

  Future<int> delete(String table, {String? where, List<Object?>? whereArgs}) async {
    final db = await database;
    return await db.delete(table, where: where, whereArgs: whereArgs);
  }

  Future<int> clearTable(String table) async {
    final db = await database;
    return await db.delete(table);
  }
}