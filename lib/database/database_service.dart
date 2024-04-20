
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart';
import 'package:assigment1/key_value_model.dart';

class DatabaseService {
  static const int _version = 1;
  static const String _dbName = "Pairs.db";

  static Future<void> createTable(sql.Database database) async {
    try {
      await database.execute('''
        CREATE TABLE key_values (
          id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
          key TEXT,
          value TEXT
        )
      ''');
    } catch (e) {
      print('Error creating table: $e');
      rethrow;
    }
  }

  static Future<sql.Database> getDb() async {
    try {
      return sql.openDatabase(
        join(
          await sql.getDatabasesPath(),
          _dbName,
        ),
        version: _version,
        onCreate: (sql.Database database, int version) async {
          await createTable(database);
        },
      );
    } catch (e) {
      print('Error opening database: $e');
      rethrow;
    }
  }

  static Future<int> addKeyValues(String key, String value) async {
    try {
      final db = await DatabaseService.getDb();
      final keyValuePair = KeyValueModel(key: key, value: value);
      final data = keyValuePair.toMap();
      final id = db.insert(
        'key_values',
        data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace,
      );
      return id;
    } catch (e) {
      print('Error adding key-value pair: $e');
      rethrow;
    }
  }

  static Future<List<Map<String, dynamic>>> getItems() async {
    try {
      final db = await DatabaseService.getDb();
      return db.query('key_values', orderBy: "id");
    } catch (e) {
      print('Error getting items: $e');
      rethrow;
    }
  }

  static Future<void> deleteItem(int id) async{
    try{
        final db = await DatabaseService.getDb();
        await db.delete('key_values', where:"id=?", whereArgs: [id]);
    }catch(e){
      print('Error getting items: $e');
      rethrow;
    }
  }

  static Future<int> updateItem(int id, String key, String value) async{
    try{
      final db = await DatabaseService.getDb();
      final keyValuePair = KeyValueModel(key: key, value: value);
      final data = keyValuePair.toMap();

      final result = await db.update('key_values', data, where:"id=?", whereArgs: [id]);
      return result; //return no of changes made
    }catch(e){
      print('Error getting items: $e');
      rethrow;
    }
  }
}

