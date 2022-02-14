import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:notes/data/model/note.dart';
import 'package:notes/data/utils/app.dart';
import 'package:notes/data/utils/extensions.dart';
import 'package:notes/data/utils/localization.dart';
import 'package:notes/ui/dialogs/notes_menu_dialog.dart';
import 'package:notes/ui/main/home.dart';
import 'package:notes/ui/widgets/chips_list.dart';
import 'package:notes/ui/widgets/platform_button.dart';
import 'package:notes/ui/widgets/platform_textfield.dart';

class CreateSimpleNoteDialog extends StatefulWidget {
  final Note? note;
  final bool? isFromImport;

  const CreateSimpleNoteDialog({
    Key? key,
    this.note,
    this.isFromImport
  }) : super(key: key);

  @override
  _CreateSimpleNoteDialogState createState() => _CreateSimpleNoteDialogState();
}

class _CreateSimpleNoteDialogState extends State<CreateSimpleNoteDialog> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  Note get note => widget.note!;
  bool get isImported => widget.isFromImport!;

  int _selectedIndex = 0;

  void Function(void Function())? _setIndexState;

  @override
  void initState() {
    _titleController.text = (widget.note != null ? widget.note!.title! : "");
    _descController.text = (widget.note != null ? widget.note!.desc! : "");

    if(widget.note != null){
      _selectedIndex = getIndexByPriority(note.priority!);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(16),
            topLeft: Radius.circular(16)
          ),
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom
            ),
            child: SingleChildScrollView(
              /*physics: App.platform == "ios" ? const BouncingScrollPhysics() :
                const AlwaysScrollableScrollPhysics(),*/
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
                            getIconButton(
                              child: Icon(
                                App.platform == "ios" ?
                                Icons.arrow_back_ios_rounded :
                                Icons.arrow_back,
                                size: 24,
                                color: Colors.grey,
                              ),
                              context: context,
                              onTap: () {
                                Navigator.pop(context);
                              }
                            ),
                            Text(
                              AppLocalizations.of(context, 'simple_note'),
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if(isImported && widget.note != null)
                            getIconButton(
                              child: const Icon(
                                Icons.save,
                                size: 24,
                                color: Colors.grey,
                              ),
                              context: context,
                              onTap: () async{
                                final newNote = Note(
                                  title: note.title,
                                  desc: note.desc,
                                  category: note.category,
                                  priority: note.priority,
                                  image: note.image,
                                  items: note.items,
                                  date: note.date
                                );
                                await notesBloc.addItem(newNote);
                                Navigator.pop(context);
                              }
                            ),
                            if(!isImported && widget.note != null)
                            getIconButton(
                              child: const Icon(
                                Icons.more_vert,
                                size: 24,
                                color: Colors.grey,
                              ),
                              context: context,
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
                                  builder: (context) => NotesMenuDialog(
                                    note: note,
                                  )
                                );
                              }
                            ),
                            if(widget.note == null)
                            const SizedBox(width: 40)
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
                                          if(!isImported){
                                            _setIndexState!((){
                                              if (selected) {
                                                _selectedIndex = index;
                                              }
                                            });
                                          }
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
                              hintText: AppLocalizations.of(context, 'typehint'),
                              enabled: !isImported,
                            ),
                            const SizedBox(height: 32),
                            Text(
                              AppLocalizations.of(context, 'desc'),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700
                              ),
                            ),
                            const SizedBox(height: 8),
                            PlatformTextField(
                              controller: _descController,
                              isForNotes: true,
                              showClear: false,
                              minLines: 5,
                              maxLines: 5,
                              hintText: AppLocalizations.of(context, 'typehint'),
                              isExpanded: false,
                              inputAction: TextInputAction.newline,
                              enabled: !isImported,
                            ),
                            const SizedBox(height: 16),
                            if(!isImported)
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
      ),
    );
  }

  Future _updateNote() async{
    final title = _titleController.text.trim();
    final desc = _descController.text.trim();
    if(title.isNotEmpty && desc.isNotEmpty){
      await notesBloc.updateItem(
        Note(
          id: note.id,
          title: title,
          desc: desc,
          date: DateTime.now().millisecondsSinceEpoch,
          category: note.category,
          priority: getPriorityByIndex(_selectedIndex),
          image: note.image,
          items: note.items,
        )
      );
      Navigator.pop(context);
    }
  }

  Future _createNewNote() async{
    final title = _titleController.text.trim();
    final desc = _descController.text.trim();
    if(title.isNotEmpty && desc.isNotEmpty){
      await notesBloc.addItem(
        Note(
          title: title,
          desc: desc,
          date: DateTime.now().millisecondsSinceEpoch,
          category: "default",
          priority: getPriorityByIndex(_selectedIndex),
          image: Uint8List.fromList([]),
          items: []
        )
      );
      Navigator.pop(context);
    }
    else{
      debugPrint("Empty");
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }
}
