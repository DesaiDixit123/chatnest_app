import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'location_model.dart';  // Import the model class

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('locations.db');
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

  Future _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE locations (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT,
      latitude REAL,
      longitude REAL
    )
    ''');
  }

  // Insert a new location
  Future<int> createLocation(LocationModel location) async {
    final db = await instance.database;
    return await db.insert('locations', location.toMap());
  }

  // Get all locations
  Future<List<LocationModel>> getLocations() async {
    final db = await instance.database;
    final result = await db.query('locations');

    return result.map((json) => LocationModel.fromMap(json)).toList();
  }

  // Close the database
  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
