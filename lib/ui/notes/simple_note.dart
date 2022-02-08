import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notes/data/model/note.dart';
import 'package:notes/data/utils/extensions.dart';
import 'package:notes/data/utils/localization.dart';
import 'package:notes/ui/bloc/notes_bloc.dart';
import 'package:notes/ui/provider/prefsprovider.dart';
import 'package:notes/ui/widgets/platform_button.dart';
import 'package:notes/ui/widgets/platform_textfield.dart';
import 'package:provider/provider.dart';

class SimpleNotePage extends StatefulWidget {
  final Note? note;
  final NotesBloc? notesBloc;

  const SimpleNotePage({Key? key, this.note, this.notesBloc}) : super(key: key);

  @override
  _SimpleNotePageState createState() => _SimpleNotePageState();
}

class _SimpleNotePageState extends State<SimpleNotePage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  Note get note => widget.note!;

  late String locale;

  @override
  void initState() {
    _titleController.text = (widget.note != null ? widget.note!.title! : "");
    _descController.text = (widget.note != null ? widget.note!.desc! : "");

    if(widget.note != null){
      debugPrint("${widget.note!.toJson()}");
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<PreferenceProvider>(context);
    locale = Localizations.localeOf(context).languageCode.contains("ru")
      ? "kk:mm" : "hh:mm a";
    return Hero(
      tag: widget.note ?? "",
      child: Material(
        type: MaterialType.transparency,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(
                top: 32,
                left: 16,
                right: 16,
                bottom: 8,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.note == null ? AppLocalizations.of(context, 'createnote') :
                          AppLocalizations.of(context, 'editnote'),
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w700
                          ),
                        ),
                      ),
                      if(widget.note != null)
                        Row(
                          children: [
                            const SizedBox(width: 8),
                            InkWell(
                              onTap: () async{
                                await widget.notesBloc!.deleteItemByID(widget.note!.id!);
                                Navigator.pop(context);
                              },
                              child: Icon(
                                Icons.delete_forever,
                                size: 32,
                                color: HexColor.fromHex(_provider.color!),
                              ),
                            )
                          ],
                        )
                    ],
                  ),
                  const SizedBox(height: 32),
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
                  Text(
                    AppLocalizations.of(context, 'desc'),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: PlatformTextField(
                      controller: _descController,
                      isForNotes: true,
                      showClear: false,
                      hintText: AppLocalizations.of(context, 'typehint'),
                      isExpanded: true
                    ),
                  ),
                  const SizedBox(height: 16),
                  if(widget.note != null)
                    Column(
                      children: [
                        Text(
                          "${AppLocalizations.of(context, 'lastedit')}: "
                          "${DateFormat('dd MMM, yyyy, $locale')
                          .format(DateTime.fromMillisecondsSinceEpoch(widget.note!.date!))}",
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
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
                  const SizedBox(height: 4),
                ],
              ),
            ),
          ),
        ),
      )
    );
  }

  Future _updateNote() async{
    final title = _titleController.text.trim();
    final desc = _descController.text.trim();
    if(title.isNotEmpty && desc.isNotEmpty){
      await widget.notesBloc!.updateItem(
        Note(
          id: note.id,
          title: title,
          desc: desc,
          date: DateTime.now().millisecondsSinceEpoch,
          category: note.category,
          priority: note.priority,
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
      await widget.notesBloc!.addItem(
        Note(
          title: title,
          desc: desc,
          date: DateTime.now().millisecondsSinceEpoch,
          category: "default",
          priority: "low",
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
