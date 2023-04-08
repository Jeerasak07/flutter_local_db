import 'package:flutter_localdb/models/note.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';

class NotesDBHandler {
  final databaseName = "notes.db";
  final tableName = "notes";

  final fieldMap = {
    "id": "INTEGER PRIMARY KEY AUTOINCREMENT",
    "title": "BLOB",
    "content": "BLOB",
    "date_created": "INTEGER",
    "date_last_edited": "INTEGER",
  };

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await initDB();
    return _database!;
  }

  initDB() async {
    var path = await getDatabasesPath();
    var dbPath = join(path, 'notes.db');
    Database dbConnection = await openDatabase(dbPath, version: 1,
        onCreate: (Database db, int version) async {
      print("executing create query from onCreate callback");
      await db.execute(_buildCreateQuery());
    });

    await dbConnection.execute(_buildCreateQuery());
    _buildCreateQuery();
    return dbConnection;
  }

  String _buildCreateQuery() {
    String query = "CREATE TABLE IF NOT EXISTS ";
    query += tableName;
    query += "(";
    fieldMap.forEach((column, field) {
      print("$column : $field");
      query += "$column $field,";
    });

    query = query.substring(0, query.length - 1);
    query += " )";

    return query;
  }

  Future<int> insertNote(Note note, bool isNew) async {
    final Database db = await database;

    await db.insert(
      'notes',
      isNew ? note.toMap(false) : note.toMap(true),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    if (isNew) {
      var one =
          await db.query("notes", orderBy: "date_last_edited desc", limit: 1);
      int latestId = one.first["id"] as int;
      return latestId;
    }
    return note.id;
  }

  Future<List<Map<String, dynamic>>> selectAllNotes() async {
    final Database db = await database;
    var data = await db
        .query("notes", orderBy: "date_last_edited desc", whereArgs: [0]);

    return data;
  }
}
