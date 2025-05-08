import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:diabetes_predictor/JSON/users.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('diabetes_app.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, filePath);
    print('Database path: $path');
    return await openDatabase(
      path,
      version: 2,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        usrId INTEGER PRIMARY KEY AUTOINCREMENT,
        fullName TEXT NOT NULL,
        phoneNumber TEXT NOT NULL,
        email TEXT NOT NULL,
        usrPassword TEXT NOT NULL,
        bloodSugarLevel TEXT,
        profilePhotoPath TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE photos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userId INTEGER,
        photoPath TEXT NOT NULL,
        hasDiabetes INTEGER NOT NULL,
        confidence REAL NOT NULL,
        analysisDate TEXT NOT NULL,
        FOREIGN KEY (userId) REFERENCES users (usrId)
      )
    ''');
  }

  Future _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('DROP TABLE IF EXISTS users');
      await db.execute('DROP TABLE IF EXISTS photos');
      await _createDB(db, newVersion);
    }
  }

  Future<bool> authenticate(Users usr) async {
    final db = await database;
    var result = await db.rawQuery(
        "SELECT * FROM users WHERE email = ? AND usrPassword = ?",
        [usr.email, usr.password]);
    return result.isNotEmpty;
  }

  Future<int> createUser(Users usr) async {
    final db = await database;
    int id = await db.insert("users", usr.toMap());
    print('DatabaseHelper: createUser inserted user with ID = $id');
    return id;
  }

  Future<Users?> getUser(String phoneNumber) async {
    final db = await database;
    var res = await db.query("users",
        where: "phoneNumber = ?", whereArgs: [phoneNumber]);
    return res.isNotEmpty ? Users.fromMap(res.first) : null;
  }

  Future<Users?> getUserByEmail(String email) async {
    final db = await database;
    var res = await db.query("users", where: "email = ?", whereArgs: [email]);
    return res.isNotEmpty ? Users.fromMap(res.first) : null;
  }

  Future<int> updateUser(int id, Map<String, dynamic> userData) async {
    final db = await database;
    return await db.update(
      'users',
      userData,
      where: 'usrId = ?',
      whereArgs: [id],
    );
  }

  Future<int> createPhoto(Map<String, dynamic> photoData) async {
    final db = await database;
    return await db.insert('photos', photoData);
  }

  Future<List<Map<String, dynamic>>> getUserPhotos(int userId) async {
    final db = await database;
    return await db.query('photos', where: 'userId = ?', whereArgs: [userId]);
  }

  Future<List<Map<String, dynamic>>> getAllUsers() async {
    final db = await database;
    return await db.query('users');
  }

  Future<List<Map<String, dynamic>>> queryTable(String table) async {
    final db = await database;
    return await db.query(table);
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}