import 'package:notes/data/db/dao/dao.dart';
import 'package:notes/data/model/note.dart';

class Repository {
  final dao = DaoOfDB();

  Future getAllNotes({String? query}) => dao.getNotes(query: query);

  Future insertNote(Note item) => dao.createNote(item);

  Future updateNote(Note item) => dao.updateNote(item);

  //Future queryHistoryRowCount(int id) => dao.queryHistoryRowCount(id);

  Future deleteNote(int id) => dao.deleteNote(id);

  Future deleteAllNotes() => dao.deleteAllNotes();

  //Future queryBookmarksRowCount(String url) => dao.queryBookmarksRowCount(url);
}
