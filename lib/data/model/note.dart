import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:notes/ui/bloc/notes_bloc.dart';
import 'package:notes/ui/notes/simple_note.dart';
import 'package:notes/ui/widgets/ripple.dart';

class Item{
  String? title;
  bool? isDone;

  Item({
    this.title,
    this.isDone,
  });

  static Map<String, dynamic> toMap(Item item) => {
    "title": item.title,
    "isDone": item.isDone
  };

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      title: json['title'],
      isDone: json['isDone']
    );
  }
}

class Note{
  final int? id;
  final String? title;
  final String? desc;
  final String? category;
  final String? priority;
  final Uint8List? image;
  final List<Item>? items;
  final int? date;

  Note({
    this.id,
    required this.title,
    required this.desc,
    required this.category,
    required this.priority,
    required this.image,
    required this.items,
    required this.date
  });

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "desc": desc,
    "category": category,
    "priority": priority,
    "image": image,
    "items": encodeItems(items!),
    "date": date,
  };

  static String encodeItems(List<Item> list) => json.encode(
    list.map<Map<String, dynamic>>((item) => Item.toMap(item)).toList()
  );

  static List<Item> decodeItems(String items) =>
    (json.decode(items) as List<dynamic>).map<Item>((item) => Item.fromJson(item)).toList();

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'] as int?,
      title: json['title'] as String?,
      desc: json['desc'] as String?,
      category: json['category'] as String?,
      priority: json['priority'] as String?,
      image: json['image'] as Uint8List?,
      items: decodeItems(json['items']),
      date: json['date'] as int?,
    );
  }
}

class NoteItem extends StatelessWidget {
  final Note? note;
  final NotesBloc? notesBloc;

  const NoteItem({Key? key, this.note, this.notesBloc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: note!,
      child: Ripple(
        onTap: (){
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (_, __, ___) => SimpleNotePage(notesBloc: notesBloc, note: note),
              transitionDuration: const Duration(milliseconds: 250),
            ),
          );
        },
        radius: 16,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).brightness == Brightness.light ?
              Colors.black : Colors.white,
              width: 0.75
            ),
            borderRadius: BorderRadius.circular(16)
          ),
          child: Padding(
            padding: const EdgeInsets.only(
              left: 16, right: 16,
              top: 16, bottom: 8
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  note!.title!,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.start,
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: Text(
                    note!.desc!,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey
                    ),
                    textAlign: TextAlign.start,
                  ),
                )
              ],
            )
          ),
        ),
      ),
    );
  }
}
