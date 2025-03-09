import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:typed_data';

class DatabaseHelper {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDB();
    return _database!;
  }

  Future<Database> initDB() async {
    String path = join(await getDatabasesPath(), 'user_images.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute("""
          CREATE TABLE user_images (
            id TEXT PRIMARY KEY,
            image_data BLOB
          )
        """);
      },
    );
  }

  // Insert or update user image
  Future<void> insertOrUpdateImage(String userId, Uint8List imageBytes) async {
    final db = await database;
    await db.insert(
      'user_images',
      {'id': userId, 'image_data': imageBytes},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Get image by user ID
  Future<Uint8List?> getImage(String userId) async {
    final db = await database;
    final List<Map<String, dynamic>> result =
        await db.query('user_images', where: 'id = ?', whereArgs: [userId]);

    if (result.isNotEmpty) {
      return result.first['image_data'] as Uint8List;
    }
    return null;
  }
}
