import 'dart:async';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DBHelper {
  static Database? _db;
  static const String TABLE = 'users';
  static const String ID = 'id';
  static const String COMPANY_NAME = 'company_name';
  static const String CONTACT_PERSON_NAME = 'contact_person_name';
  static const String COMPANY_INDUSTRY = 'company_industry';
  static const String PHONE_NUMBER = 'phone_number';
  static const String EMAIL = 'email';
  static const String ADDRESS = 'address';
  static const String LOCATION = 'location';
  static const String COMPANY_SIZE = 'company_size';
  static const String PASSWORD = 'password';
  static const String LOGO_URL = 'logo_url';

  static Future<Database> getDb() async {
    if (_db == null) {
      io.Directory documentsDirectory =
          await getApplicationDocumentsDirectory();
      String path = join(documentsDirectory.path, 'users.db');
      _db = await openDatabase(path, version: 1, onCreate: _onCreate);
    }
    return _db!;
  }

  static void _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $TABLE (
        $ID INTEGER PRIMARY KEY,
        $COMPANY_NAME TEXT,
        $CONTACT_PERSON_NAME TEXT,
        $COMPANY_INDUSTRY TEXT,
        $PHONE_NUMBER TEXT,
        $EMAIL TEXT,
        $ADDRESS TEXT,
        $LOCATION TEXT,
        $COMPANY_SIZE TEXT,
        $PASSWORD TEXT)
    ''');
  }

  static Future<int> insertUser(Map<String, dynamic> user) async {
    Database db = await getDb();
    return await db.insert(TABLE, user);
  }

  static Future<Map<String, dynamic>> getUser(String email) async {
    Database db = await getDb();
    List<Map<String, dynamic>> users = await db.query(TABLE,
        where: '$EMAIL = ?', whereArgs: [email], limit: 1);
    if (users.length > 0) {
      return users[0];
    } else {
      return {};
    }
  }

  static Future<int> updateUser(Map<String, dynamic> user) async {
    Database db = await getDb();
    return await db.update(TABLE, user,
        where: '$EMAIL = ?', whereArgs: [user[EMAIL]]);
  }
}