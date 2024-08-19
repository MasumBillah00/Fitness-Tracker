import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class LoginDatabaseHelper {
  // Singleton instance of LoginDatabaseHelper
  static final LoginDatabaseHelper instance = LoginDatabaseHelper._init();

  static Database? _database;

  // Private constructor
  LoginDatabaseHelper._init();

  // Getter for the database
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('app.db');
    return _database!;
  }

  // Initialize the database
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  // Create the database schema
  Future _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE users (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      email TEXT NOT NULL UNIQUE,
      password TEXT NOT NULL
    )
    ''');
  }

  // Check if the user with the same email already exists
  Future<bool> userExists(String email) async {
    final db = await instance.database;
    final result = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );
    return result.isNotEmpty;
  }

  // Insert a new user into the database
  Future<void> insertUser(String email, String password) async {
    final db = await instance.database;

    // Check if the user already exists
    if (await userExists(email)) {
      throw Exception('User already exists');
    }

    await db.insert('users', {'email': email, 'password': password});
  }

  // Retrieve a user from the database based on email and password
  Future<Map<String, dynamic>?> getUser(String email, String password) async {
    final db = await instance.database;
    final result = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );

    if (result.isNotEmpty) {
      return result.first;
    } else {
      return null;
    }
  }

  // Update a user's password in the database
  Future<void> updateUserPassword(int id, String newPassword) async {
    final db = await instance.database;
    await db.update(
      'users',
      {'password': newPassword},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Delete a user from the database
  Future<void> deleteUser(int id) async {
    final db = await instance.database;
    await db.delete(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Close the database connection
  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
