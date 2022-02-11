import 'dart:async';

import 'package:notes/data/db/database/db.dart';
import 'package:notes/data/model/note.dart';

class DaoOfDB {
  final dbProvider = DatabaseProvider.dbProvider;

  Future<int> createNote(Note item) async {
    final db = await dbProvider.database;
    var result = db!.insert(table, item.toJson());
    return result;
  }

  Future<List<Note>> getNotes({List<String>? columns, String? query}) async {
    final db = await dbProvider.database;

    late List<Map<String, dynamic>> result;
    if (query != null) {
      if (query.isNotEmpty) {
        result = await db!.query(table,
          columns: columns,
          where: 'date LIKE ?',
          whereArgs: ["%$query%"]);
      }
    } else {
      result = await db!.query(table, columns: columns);
    }

    List<Note> items = result.isNotEmpty
        ? result.map((item) => Note.fromJson(item)).toList()
        : [];
    return items;
  }

  /*Future<int> queryHistoryRowCount(int rowID) async {
    final db = await dbProvider.database;
    //return Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $table WHERE id LIKE %?%') [rowID]);
    var res = await db!
        .rawQuery("SELECT * FROM $table WHERE id LIKE '%$rowID%'");
    return res.isNotEmpty ? 1 : 0;
  }

  Future<int> queryBookmarksRowCount(String url) async {
    final db = await dbProvider.database;
    //return Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $table WHERE id LIKE %?%') [rowID]);
    var res = await db!.rawQuery("SELECT * FROM $secondTable WHERE url LIKE '%$url%'");
    return res.isNotEmpty ? 1 : 0;
  }*/

  Future<int> deleteNote(int id) async {
    final db = await dbProvider.database;
    var result = await db!.delete(table, where: 'id = ?', whereArgs: [id]);

    return result;
  }

  Future<int> updateNote(Note note) async {
    final db = await dbProvider.database;
    //var result = await db!.delete(table, where: 'id = ?', whereArgs: [id]);

    return await db!.update(
      table, {
        "title": note.title,
        "desc": note.desc,
        "date": DateTime.now().millisecondsSinceEpoch,
        "category": note.category,
        "priority": note.priority,
        "image": note.image,
        "items": Note.encodeItems(note.items!),
      },
      where: 'id = ?',
      whereArgs: [note.id]
    );
  }

  //We are not going to use this in the demo
  Future deleteAllNotes() async {
    final db = await dbProvider.database;
    //final table = 'History';
    var result = await db!.delete(
      table,
    );
    //DELETE FROM SQLITE_SEQUENCE WHERE NAME = '" + TABLE_NAME + "'"
    await db.rawQuery("DELETE FROM SQLITE_SEQUENCE WHERE NAME = 'Notes'");
    return result;
  }
}
