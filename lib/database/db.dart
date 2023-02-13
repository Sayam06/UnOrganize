import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqlite_api.dart';

class DB {
  static Future<sql.Database> database() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(path.join(dbPath, "User.db"), onCreate: (db, version) {
      return db.execute("CREATE TABLE tasks(id TEXT, name TEXT, date TEXT, priority TEXT, pending INTEGER, completed INTEGER)");
    }, version: 1);
  }

  static Future<void> insertIntoTable(String tableName, Map<String, Object> data) async {
    final db = await DB.database();
    db.insert(tableName, data, conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }

  static Future<void> changeStatus(String tableName, String id, String status) async {
    final db = await DB.database();
    db.execute("UPDATE $tableName SET completed='$status' WHERE id='$id';");
  }

  static Future<void> deleteTask(String tableName, String id) async {
    final db = await DB.database();
    db.execute("DELETE FROM $tableName WHERE id='$id';");
  }

  static Future<List> getData(String table) async {
    final db = await DB.database();
    return db.query(table);
  }

  // static Future<void> deleteTx(String id, String tableName) async {
  //   final db = await DB.database();
  //   return await db.execute("DELETE FROM $tableName WHERE ID = '$id'");
  // }
  // static Future<void> updateData(String amount, String note, String category, String type) async {
  //   final db = await DB.database();
  //   db.execute(sql)
  // }
}
