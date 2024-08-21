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

    return await openDatabase(path, version: 2, onCreate: _createDB, onUpgrade: _onUpgrade);
  }

  // Create the database schema
  Future _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE users (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      email TEXT NOT NULL UNIQUE,
      password TEXT NOT NULL,
      otp TEXT
    )
    ''');
  }

  // Upgrade the database schema when the version is incremented
  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
      ALTER TABLE users ADD COLUMN otp TEXT
      ''');
    }
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

  // Retrieve a user by email only (for OTP verification)
  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    final db = await instance.database;
    final result = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );

    if (result.isNotEmpty) {
      return result.first;
    } else {
      return null;
    }
  }

  // Update a user's password in the database
  Future<void> updateUserPassword(String email, String newPassword) async {
    final db = await instance.database;
    final result = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );

    if (result.isNotEmpty) {
      final userId = result.first['id'];
      await db.update(
        'users',
        {'password': newPassword},
        where: 'id = ?',
        whereArgs: [userId],
      );
    } else {
      throw Exception('User not found');
    }
  }

  // Update the OTP for a user
  Future<void> updateUserOtp(String email, String otp) async {
    final db = await instance.database;
    final result = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );

    if (result.isNotEmpty) {
      final userId = result.first['id'];
      await db.update(
        'users',
        {'otp': otp},
        where: 'id = ?',
        whereArgs: [userId],
      );
    } else {
      throw Exception('User not found');
    }
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
