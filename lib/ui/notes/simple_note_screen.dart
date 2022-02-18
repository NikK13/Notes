import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notes/data/model/note.dart';
import 'package:notes/data/utils/app.dart';
import 'package:notes/data/utils/appnavigator.dart';
import 'package:notes/data/utils/extensions.dart';
import 'package:notes/data/utils/localization.dart';
import 'package:notes/ui/main/home.dart';
import 'package:notes/ui/widgets/chips_list.dart';

class SimpleNoteScreen extends StatefulWidget {
  final Note? note;

  const SimpleNoteScreen({Key? key, this.note}) : super(key: key);

  @override
  _SimpleNoteScreenState createState() => _SimpleNoteScreenState();
}

class _SimpleNoteScreenState extends State<SimpleNoteScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  Note get note => widget.note!;

  int _selectedIndex = 0;

  void Function(void Function())? _setIndexState;

  String? locale;

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
                          AppLocalizations.of(context, 'simple_note'),
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
                            const SizedBox(height: 22),
                            TextField(
                              controller: _descController,
                              cursorColor: Colors.black,
                              minLines: 1,
                              maxLines: 10,
                              style: const TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 16
                              ),
                              keyboardType: TextInputType.multiline,
                              textInputAction: TextInputAction.newline,
                              textCapitalization: TextCapitalization.sentences,
                              decoration: InputDecoration(
                                hintText: AppLocalizations.of(context, 'hint_desc'),
                                hintStyle: const TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey,
                                  fontSize: 16
                                ),
                                border: InputBorder.none,
                              ),
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
