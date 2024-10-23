import 'package:myapp/models/found_object.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'sncf_objets_trouves.db');
    return await openDatabase(
      path,
      version: 2,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE viewed_objects (
            id TEXT PRIMARY KEY,
            station_name TEXT,
            object_type TEXT,
            date TEXT,
            nature TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE recent_searches (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            station_name TEXT,
            object_type TEXT,
            date_min TEXT,
            date_max TEXT,
            only_new INTEGER
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          // Ajoute la colonne only_new si elle n'existe pas
          await db.execute(
              'ALTER TABLE recent_searches ADD COLUMN only_new INTEGER DEFAULT 0');
        }
      },
    );
  }

  // Insérer un objet consulté
  Future<void> insertViewedObject(FoundObject object) async {
    final db = await database;
    await db.insert('viewed_objects', {
      'id': object.getUniqueId(),
      'station_name': object.stationName,
      'object_type': object.type,
      'date': object.date.toIso8601String(),
      'nature': object.nature,
    });
  }

  // Vérifier si un objet a déjà été consulté
  Future<bool> isObjectViewed(FoundObject object) async {
    final db = await database;
    final result = await db.query(
      'viewed_objects',
      where: 'id = ?',
      whereArgs: [object.getUniqueId()],
    );
    return result.isNotEmpty;
  }

  // Récupérer les IDs des objets déjà consultés
  Future<List<String>> getViewedObjectIds() async {
    final db = await database;
    final List<Map<String, dynamic>> result =
        await db.query('viewed_objects', columns: ['id']);
    return result.map((row) => row['id'] as String).toList();
  }

  // Insérer une recherche récente
  Future<void> insertRecentSearch({
    required String stationName,
    required String objectType,
    required DateTime? dateMin,
    required DateTime? dateMax,
    required bool onlyNew,
  }) async {
    final db = await database;
    await db.insert('recent_searches', {
      'station_name': stationName,
      'object_type': objectType,
      'date_min': dateMin?.toIso8601String(),
      'date_max': dateMax?.toIso8601String(),
      'only_new': onlyNew ? 1 : 0,
    });
  }

  // Récupérer les recherches récentes
  Future<List<Map<String, dynamic>>> getRecentSearches() async {
    final db = await database;
    return await db.query('recent_searches', orderBy: 'id DESC');
  }
}
