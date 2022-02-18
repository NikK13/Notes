import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:notes/data/model/note.dart';
import 'package:notes/data/utils/extensions.dart';
import 'package:notes/data/utils/localization.dart';
import 'package:notes/ui/dialogs/create_task_note.dart';
import 'package:notes/ui/dialogs/delete_note_dialog.dart';
import 'package:notes/ui/main/home.dart';
import 'package:notes/ui/provider/prefsprovider.dart';
import 'package:notes/ui/widgets/ripple.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class NotesMenuDialog extends StatelessWidget {
  final Note? note;

  const NotesMenuDialog({Key? key, this.note}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PreferenceProvider>(context);
    return Wrap(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              dialogLine,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 40),
                  Text(
                    AppLocalizations.of(context, 'notes_menu'),
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
                children: [
                  const SizedBox(height: 16),
                  NoteMenuItem(
                    icon: Icons.delete_outline,
                    title: AppLocalizations.of(context, 'delete'),
                    color: HexColor.fromHex(provider.color!),
                    onTap: (){
                      Navigator.pop(context);
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
                        builder: (context) => DeleteNoteDialog(
                          deleteNote: () async{
                            await notesBloc.deleteItemByID(note!.id!);
                          },
                        )
                      );
                    },
                  ),
                  NoteMenuItem(
                    icon: Icons.share,
                    title: AppLocalizations.of(context, 'share'),
                    color: HexColor.fromHex(provider.color!),
                    onTap: () async{
                      final item = json.encode(note!.toJson());
                      String dir = (await getTemporaryDirectory()).path;
                      final File file = File("$dir/${note!.title}.note");
                      file.writeAsStringSync(item);
                      Share.shareFiles(["$dir/${note!.title}.note"]).then((value){
                        file.delete();
                      });
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class NoteMenuItem extends StatelessWidget {
  final IconData? icon;
  final String? title;
  final Function? onTap;
  final Color? color;

  const NoteMenuItem({
    Key? key,
    this.title,
    this.icon,
    this.onTap,
    this.color
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Ripple(
        onTap: () => onTap!(),
        radius: 16,
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
                Icon(
                  icon!,
                  size: 32,
                  color: color,
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: Text(
                    title!,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

