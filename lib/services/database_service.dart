import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'package:flutter/services.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._internal();
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'food_menu.db');

    // Check if database exists
    bool exists = await databaseExists(path);

    if (!exists) {
      // If not, copy the database from assets
      ByteData data = await rootBundle.load('assets/db/food_menu.db');
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // Write the byte data to the file
      await File(path).writeAsBytes(bytes, flush: true);
    }
    return await openDatabase(path, version: 1);
  }

  Future<void> replaceDatabase() async {
    String path = join(await getDatabasesPath(), 'food_menu.db');

    // Delete the old database
    if (await databaseExists(path)) {
      await deleteDatabase(path);
    }

    // Copy the new database from assets
    ByteData data = await rootBundle.load('assets/db/food_menu.db');
    List<int> bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    await File(path).writeAsBytes(bytes, flush: true);
  }

  // Future _onCreate(Database db, int version) async {
  //   await db.execute('''
  //   CREATE TABLE food (
  //     id INTEGER PRIMARY KEY AUTOINCREMENT,
  //     name TEXT,
  //     description TEXT
  //   )
  //   ''');
  // }

  // ฐาน table กับ ข้อมูลภายใน table
  // Future _onUpgrade(Database db, int oldversion, int newversion) async {
  //   if (oldversion < 2) {
  //     await db.execute('''
  //   CREATE TABLE food (
  //     id INTEGER PRIMARY KEY AUTOINCREMENT,
  //     name TEXT,
  //     description TEXT
  //   )
  //   ''');
  //   }
  // }

  Future<int> insertFood(
      // เพิ่มข้อมูล
      String name,
      String dec) async {
    Database db = await database;
    return await db.insert('food', {'name': name, 'description': dec});
  }

  Future<List<Map<String, dynamic>>> getfood() async {
    Database db = await database;
    return await db.query('food');
  }
}
