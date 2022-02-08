import 'dart:async';
import 'package:notes/data/db/repository/repository.dart';
import 'package:notes/data/model/note.dart';
import 'package:notes/ui/bloc/bloc.dart';
import 'package:rxdart/rxdart.dart';

class NotesBloc implements BaseBloc{
  final repository = Repository();
  final _items = BehaviorSubject<List<Note>?>();

  Stream<List<Note>?> get listStream => _items.stream;
  Function(List<Note>?) get loadList => _items.sink.add;

  NotesBloc(){
    getAllNotes();
  }

  getAllNotes({String? query}) async {
    await loadList(await (repository.getAllNotes(query: query)
    as Future<List<Note>?>));
  }

  addItem(Note item) async {
    await repository.insertNote(item);
    await getAllNotes();
  }

  updateItem(Note item) async {
    await repository.updateNote(item);
    await getAllNotes();
  }

  deleteItemByID(int id) async {
    await repository.deleteNote(id);
    await getAllNotes();
  }

  deleteAllItems() async {
    await repository.deleteAllNotes();
    await getAllNotes();
  }

  @override
  dispose() {
    _items.close();
  }
}
