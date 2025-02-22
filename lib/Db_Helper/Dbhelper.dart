import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static Database? _database;
  static final DBHelper instance = DBHelper._privateConstructor();

  DBHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'files.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE files (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            file_title TEXT NOT NULL,
            imagePath TEXT,                    
            filePath TEXT
          );
        ''');
      },
    );
  }

  Future<int> insertFile(
    String name,
    String fileTitle,
    String filePath,
    String imagePath,
  ) async {
    Database db = await database;
    return await db.insert('files', {
      'name': name,
      'file_title': fileTitle,
      'imagePath': imagePath,
      'filePath': filePath
    });
  }

  Future<List<Map<String, dynamic>>> getFiles() async {
    Database db = await database;
    return await db.query('files');
  }
}
