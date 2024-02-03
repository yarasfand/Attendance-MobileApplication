import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AdminDatabaseHelper {
  static final AdminDatabaseHelper _instance = AdminDatabaseHelper._internal();

  factory AdminDatabaseHelper() => _instance;

  AdminDatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'pioneer.db');

    if (!await Directory(databasesPath).exists()) {
      await Directory(databasesPath).create(recursive: true);
    }

    // Close the existing database if it's open
    if (_database != null && _database!.isOpen) {
      await _database!.close();
    }

    try {
      Database db = await openDatabase(
        path,
        version: 1,
        onCreate: (db, version) async {
          await _createTable(db);
        },
      );

      // Ensure that the table creation is completed
      await _createTable(db);

      return db;
    } catch (e) {
      print('Error initializing database: $e');
      rethrow; // Rethrow the exception to propagate it further if needed
    }
  }

  Future<void> _createTable(Database db) async {
    try {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS admin (
          username TEXT UNIQUE,
          corporate_id TEXT
        )
      ''');
      print("Table created successfully admin");
    } catch (e) {
      print('Error creating table: $e');
      rethrow; // Rethrow the exception to propagate it further if needed
    }
  }

  Future<int> insertAdmin(Map<String, dynamic> adminData) async {
    Database db = await database;
    return await db.insert('admin', adminData,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> getAdmins() async {
    Database db = await database;
    return await db.query('admin');
  }

  Future<void> updateAdmin(Map<String, dynamic> adminData) async {
    Database db = await database;
    await db.update('admin', adminData,
        where: 'username = ?', whereArgs: [adminData['username']]);
  }

  Future<void> deleteAdmin(String username) async {
    Database db = await database;
    await db.delete('admin', where: 'username = ?', whereArgs: [username]);
  }

  Future<void> deleteAllAdmins() async {
    try {
      Database db = await database;
      await db.delete('admin');
      print('All data deleted from the admin table');
    } catch (e) {
      print('Error deleting all data from the admin table: $e');
    }
  }
}
