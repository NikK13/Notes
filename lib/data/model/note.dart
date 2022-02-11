import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:notes/data/utils/extensions.dart';
import 'package:notes/ui/dialogs/create_simple_note.dart';
import 'package:notes/ui/dialogs/create_task_note.dart';
import 'package:notes/ui/widgets/ripple.dart';
import 'package:notes/ui/widgets/selected_checkbox.dart';

class Item{
  String? title;
  String? desc;
  bool? isDone;

  Item({
    this.title,
    this.isDone,
    this.desc
  });

  static Map<String, dynamic> toMap(Item item) => {
    "title": item.title,
    "isDone": item.isDone,
    "desc": item.desc
  };

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      title: json['title'],
      isDone: json['isDone'],
      desc: json['desc']
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

  const NoteItem({Key? key, this.note}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: note!,
      child: Ripple(
        onTap: (){
          showModalBottomSheet(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16)
              )
            ),
            constraints: getDialogConstraints(context),
            context: context,
            isScrollControlled: true,
            isDismissible: false,
            builder: (context){
              if(note!.category! == "default"){
                return CreateSimpleNoteDialog(note: note!);
              }
              else{
                return CreateTaskNoteDialog(note: note!);
              }
            }
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
            padding: EdgeInsets.only(
              left: 16, right: 16,
              top: 16, bottom: note!.category! == "default" ? 8 :
                (note!.category! == "tasks") ? 10 : 8
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        note!.title!,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.start,
                        maxLines: 1,
                      ),
                    ),
                    /*Container(
                      width: 16, height: 16,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: getColorByPriority(note!.priority!)
                      ),
                    )*/
                  ],
                ),
                const SizedBox(height: 8),
                if(note!.category! == "default")
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
                ),
                if(note!.category! == "tasks")
                Expanded(
                  child: ListView(
                    //physics: const NeverScrollableScrollPhysics(),
                    children: note!.items!.asMap().map((index, value){
                      final item = note!.items![index];
                      return MapEntry(index, getTaskView(item));
                    }).values.toList(),
                  )
                ),
              ],
            )
          ),
        ),
      ),
    );
  }

  Widget getTaskView(Item item){
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 2
      ),
      child: Row(
        children: [
          SelectedCheckBox(
            isSelected: item.isDone,
            onTap: (){},
            size: 14,
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              item.title!,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
              maxLines: 1,
            ),
          )
        ],
      ),
    );
  }
}
