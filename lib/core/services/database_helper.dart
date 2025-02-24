// lib/features/home/data/datasource/local/favorite_database.dart
import 'package:shping_test/features/home/data/entities/photo.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('favorites.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
          CREATE TABLE favorites (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            photoId TEXT UNIQUE,
            url TEXT,
            smallUrl TEXT,
            title TEXT,
            photographer TEXT,
            description TEXT,
            likes INTEGER,
            createdAt TEXT,
            tags TEXT,
            source TEXT,
            photoProfile TEXT
          )
          ''');
  }

  Future<bool> isFavorite(String photoId) async {
    final db = await database;
    final result = await db.query(
      'favorites',
      where: 'photoId = ?',
      whereArgs: [photoId],
    );
    return result.isNotEmpty;
  }

  Future<Photo> insertFavorite(Photo photo) async {
    final db = await database;
    // Convert tags to a comma-separated string for storage
    final tagsString = photo.tags.join(',');

    final favoriteMap = {
      'photoId': photo.id,
      'url': photo.url,
      'smallUrl': photo.smallUrl,
      'title': photo.title,
      'photoProfile': photo.photoProfile,
      'photographer': photo.photographer,
      'description': photo.description,
      'source': photo.source,
      'createdAt': photo.createdAt.toIso8601String(),
      'tags': tagsString,
      'likes': photo.likes,
    };

    await db.insert(
      'favorites',
      favoriteMap,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return photo;
  }

  Future<int> removeFavorite(String photoId) async {
    final db = await database;
    return await db.delete(
      'favorites',
      where: 'photoId = ?',
      whereArgs: [photoId],
    );
  }

  Future<List<Photo>> getAllFavorites(String source) async {
    final db = await database;
    final result = await db.query(
      'favorites',
      where: 'source = ?',
      whereArgs: [source],
    );
    return result.map((map) {
      // Convert tags string back to list
      final tagsString = map['tags'] as String? ?? '';
      final tags = tagsString.isNotEmpty ? tagsString.split(',') : <String>[];

      return Photo(
        id: map['photoId'] as String,
        url: map['url'] as String,
        smallUrl: map['smallUrl'] as String,
        title: map['title'] as String,
        photographer: map['photographer'] as String,
        description: map['description'] as String,
        likes: map['likes'] as int? ?? 0,
        createdAt: DateTime.parse(map['createdAt'] as String),
        tags: tags,
        source: map['source'] as String,
        photoProfile: map['photoProfile'] as String,
      );
    }).toList();
  }
}
