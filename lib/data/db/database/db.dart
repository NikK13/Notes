import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

const table = 'Notes';
const columnId = 'id';
const columnTitle = 'title';
const columnDesc = 'desc';
const columnDate = 'date';
const columnImage = 'image';
const columnItems = 'items';
const columnCategory = 'category';
const columnPriority = 'priority';

class DatabaseProvider {
  static final DatabaseProvider dbProvider = DatabaseProvider();
  Database? _database;
  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await createDatabase();
    return _database;
  }

  createDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    //"ReactiveTodo.db is our database instance name
    String path = join(documentsDirectory.path, "ReactiveDB.db");
    var database = await openDatabase(path,
        version: 1, onCreate: initDB, onUpgrade: onUpgrade);
    return database;
  }

  //This is optional, and only used for changing DB schema migrations
  void onUpgrade(Database database, int oldVersion, int newVersion) {
    if (newVersion > oldVersion) {}
  }

  void initDB(Database database, int version) async {
    await database.execute('''
      CREATE TABLE $table (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnTitle TEXT NOT NULL,
        $columnDesc TEXT NOT NULL,
        $columnPriority TEXT NOT NULL,
        $columnItems TEXT NOT NULL,
        $columnDate INTEGER NOT NULL,
        $columnCategory TEXT NOT NULL,
        $columnImage BLOB NOT NULL
      )
      ''');
  }
}
