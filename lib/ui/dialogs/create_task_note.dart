import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:notes/data/model/note.dart';
import 'package:notes/data/utils/extensions.dart';
import 'package:notes/data/utils/localization.dart';
import 'package:notes/ui/main/home.dart';
import 'package:notes/ui/provider/prefsprovider.dart';
import 'package:notes/ui/widgets/chips_list.dart';
import 'package:notes/ui/widgets/platform_button.dart';
import 'package:notes/ui/widgets/platform_textfield.dart';
import 'package:notes/ui/widgets/ripple.dart';
import 'package:notes/ui/widgets/selected_checkbox.dart';
import 'package:provider/provider.dart';

class CreateTaskNoteDialog extends StatefulWidget {
  final Note? note;

  const CreateTaskNoteDialog({
    Key? key,
    this.note
  }) : super(key: key);

  @override
  _CreateTaskNoteDialogState createState() => _CreateTaskNoteDialogState();
}

class _CreateTaskNoteDialogState extends State<CreateTaskNoteDialog> {
  final TextEditingController _titleController = TextEditingController();

  Note get note => widget.note!;

  int _selectedIndex = 0;

  void Function(void Function())? _setIndexState, _setActiveState, _setItemsState;

  List<Item> items = [];

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

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PreferenceProvider>(context);
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: SingleChildScrollView(
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(16),
            topLeft: Radius.circular(16)
          ),
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom
            ),
            child: Wrap(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      dialogLine,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if(widget.note != null)
                            getIconButton(
                              child: const Icon(
                                Icons.delete_outline_rounded,
                                size: 24,
                                color: Colors.grey,
                              ),
                              context: context,
                              onTap: () async{
                                await notesBloc.deleteItemByID(widget.note!.id!);
                                Navigator.pop(context);
                              }
                            ),
                          if(widget.note == null)
                          const SizedBox(width: 40),
                          Text(
                            AppLocalizations.of(context, 'task_note'),
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          getIconButton(
                            child: const Icon(
                              Icons.close,
                              size: 24,
                              color: Colors.grey,
                            ),
                            context: context,
                            onTap: () {
                              Navigator.pop(context);
                            }
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 32),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppLocalizations.of(context, 'priority'),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700
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
                              const SizedBox(height: 32),
                            ],
                          ),
                          Text(
                            AppLocalizations.of(context, 'title'),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700
                            ),
                          ),
                          const SizedBox(height: 8),
                          PlatformTextField(
                            controller: _titleController,
                            showClear: false,
                            isForNotes: true,
                            maxLines: 1,
                            hintText: AppLocalizations.of(context, 'typehint')
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
                                  _setItemsState!((){
                                    items.add(Item(
                                      title: "New task ${items.length}",
                                      desc: "",
                                      isDone: false
                                    ));
                                  });
                                },
                                child: Icon(
                                  Icons.add,
                                  size: 32,
                                  color: HexColor.fromHex(provider.color!),
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
                          const SizedBox(height: 32),
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: PlatformButton(
                              fontSize: 20,
                              onPressed: () async =>
                              widget.note != null ?
                              await _updateNote() :
                              await _createNewNote(),
                              text: widget.note == null ?
                              AppLocalizations.of(context, 'add') :
                              AppLocalizations.of(context, 'save'),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
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
      items.forEach((element) {
        debugPrint("${element.title}, ${element.isDone}");
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }
}

class TaskItem extends StatelessWidget {
  final Item? task;
  final Function? changeActive;
  final Function? removeItem;

  const TaskItem({
    Key? key,
    this.task,
    this.changeActive,
    this.removeItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Theme.of(context).brightness == Brightness.light ?
            Colors.black : Colors.white,
            width: 0.7
          )
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              SelectedCheckBox(
                isSelected: task!.isDone,
                onTap: () => changeActive!(),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task!.title!,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if(task!.desc!.trim().isNotEmpty)
                    Text(
                      task!.desc!,
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 4),
              getIconButton(
                child: const Icon(
                  Icons.delete_outline_rounded,
                  size: 24,
                  color: Colors.grey,
                ),
                context: context,
                onTap: () => removeItem!()
              ),
              const SizedBox(width: 2),
            ],
          ),
        ),
      ),
    );
  }
}
