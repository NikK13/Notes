import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notes/data/model/note.dart';
import 'package:notes/data/utils/app.dart';
import 'package:notes/data/utils/extensions.dart';
import 'package:notes/data/utils/localization.dart';
import 'package:notes/ui/dialogs/new_item_dialog.dart';
import 'package:notes/ui/main/home.dart';
import 'package:notes/ui/widgets/chips_list.dart';
import 'package:notes/ui/widgets/task_item.dart';

class TasksNoteScreen extends StatefulWidget {
  final Note? note;

  const TasksNoteScreen({Key? key, this.note}) : super(key: key);

  @override
  _TasksNoteScreenState createState() => _TasksNoteScreenState();
}

class _TasksNoteScreenState extends State<TasksNoteScreen> {
  final TextEditingController _titleController = TextEditingController();

  Note get note => widget.note!;

  int _selectedIndex = 0;

  void Function(void Function())? _setIndexState, _setItemsState;

  List<Item> items = [];

  String? locale;

  @override
  void initState() {
    _titleController.text = (widget.note != null ? widget.note!.title! : "");

    if(widget.note != null){
      _selectedIndex = getIndexByPriority(note.priority!);
      items.addAll(note.items!);
    }
    super.initState();
  }

  changeActiveState(Item item){
    _setItemsState!(() {
      item.isDone = !item.isDone!;
    });
  }

  deleteItemFromList(int index){
    _setItemsState!(() {
      items.removeAt(index);
    });
  }

  createNewItemInList(String title, [String? desc]){
    _setItemsState!((){
      items.add(Item(
        title: title,
        desc: desc ?? "",
        isDone: false
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    //final provider = Provider.of<PreferenceProvider>(context);
    locale ??= Localizations.localeOf(context).languageCode.contains("ru") ?
    "kk:mm" : "hh:mm a";
    return Hero(
      tag: widget.note ?? "",
      child: Scaffold(
        body: SafeArea(
          child: GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(16),
                topLeft: Radius.circular(16)
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                  bottom: 16, top: 24,
                  left: 16, right: 16
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: (){
                            Navigator.pop(context);
                          },
                          child: Icon(
                            App.platform == "ios" ?
                            Icons.arrow_back_ios :
                            Icons.arrow_back,
                            size: 32,
                            color: accent(context),
                          ),
                        ),
                        Text(
                          AppLocalizations.of(context, 'task_note'),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        GestureDetector(
                          onTap: () async{
                            widget.note != null ?
                            await _updateNote() :
                            await _createNewNote();
                          },
                          child: Icon(
                            Icons.check,
                            size: 32,
                            color: accent(context),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 16),
                                  child: Text(
                                    AppLocalizations.of(context, 'priority'),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                StatefulBuilder(
                                  builder: (_, setItem){
                                    _setIndexState = setItem;
                                    return SingleChildScrollView(
                                      child: ChipsList(
                                        index: _selectedIndex,
                                        color: getColorByPriority(getPriorityByIndex(_selectedIndex)),
                                        func: (selected, index) {
                                          _setIndexState!((){
                                            if (selected) {
                                              _selectedIndex = index;
                                            }
                                          });
                                        },
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                            if(widget.note != null)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    DateFormat(
                                      'dd MMMM, yyyy, $locale',
                                      Localizations.localeOf(context).toLanguageTag()
                                    ).format(DateTime.fromMillisecondsSinceEpoch(widget.note!.date!)),
                                    style: const TextStyle(
                                      fontSize: 13
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                ],
                              ),
                            TextField(
                              controller: _titleController,
                              cursorColor: Colors.black,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 22
                              ),
                              keyboardType: TextInputType.name,
                              textInputAction: TextInputAction.done,
                              textCapitalization: TextCapitalization.sentences,
                              decoration: InputDecoration(
                                hintText: AppLocalizations.of(context, 'hint_title'),
                                hintStyle: const TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey,
                                  fontSize: 22
                                ),
                                border: InputBorder.none,
                              ),
                            ),
                            const SizedBox(height: 32),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  AppLocalizations.of(context, 'tasks'),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700
                                  ),
                                ),
                                GestureDetector(
                                  onTap: (){
                                    showModalBottomSheet(
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(16),
                                          topRight: Radius.circular(16)
                                        )
                                      ),
                                      context: context,
                                      constraints: getDialogConstraints(context),
                                      isScrollControlled: true,
                                      isDismissible: false,
                                      builder: (context) => NewItemDialog(
                                        addNewItem: createNewItemInList,
                                      )
                                    );
                                  },
                                  child: Icon(
                                    Icons.add,
                                    size: 32,
                                    color: accent(context),
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: 4),
                            StatefulBuilder(
                              builder: (_, setItem){
                                _setItemsState = setItem;
                                return ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: items.length,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index){
                                    return TaskItem(
                                      task: items[index],
                                      changeActive: () => changeActiveState(items[index]),
                                      removeItem: () => deleteItemFromList(index),
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future _updateNote() async{
    final title = _titleController.text.trim();
    if(title.isNotEmpty && items.isNotEmpty){
      await notesBloc.updateItem(
        Note(
          id: note.id,
          title: title,
          desc: "",
          date: DateTime.now().millisecondsSinceEpoch,
          category: note.category,
          priority: getPriorityByIndex(_selectedIndex),
          image: note.image,
          items: items,
        )
      );
      Navigator.pop(context);
    }
  }

  Future _createNewNote() async{
    final title = _titleController.text.trim();
    if(title.isNotEmpty && items.isNotEmpty){
      await notesBloc.addItem(
        Note(
          title: title,
          desc: "",
          date: DateTime.now().millisecondsSinceEpoch,
          category: "tasks",
          priority: getPriorityByIndex(_selectedIndex),
          image: Uint8List.fromList([]),
          items: items
        )
      );
      Navigator.pop(context);
    }
    else{
      for (var element in items) {
        debugPrint("${element.title}, ${element.isDone}");
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }
}
