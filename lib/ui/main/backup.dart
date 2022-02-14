import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:notes/data/model/note.dart';
import 'package:notes/data/utils/app.dart';
import 'package:notes/data/utils/extensions.dart';
import 'package:notes/data/utils/localization.dart';
import 'package:notes/ui/dialogs/create_simple_note.dart';
import 'package:notes/ui/dialogs/create_task_note.dart';
import 'package:notes/ui/main/home.dart';
import 'package:notes/ui/provider/prefsprovider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class BackUpNotes extends StatefulWidget {
  const BackUpNotes({Key? key}) : super(key: key);

  @override
  _BackUpNotesState createState() => _BackUpNotesState();
}

class _BackUpNotesState extends State<BackUpNotes> {
  FilePickerResult? result;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PreferenceProvider>(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 48
                      ),
                      child: SvgPicture.asset(
                        "assets/images/undraw_backup.svg",
                      ),
                    ),
                  ),
                  Text(
                    AppLocalizations.of(context, 'notes_keep'),
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w600
                    ),
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      child: Text(AppLocalizations.of(context, 'notes_restore')),
                      onPressed: () async{
                        result = await FilePicker.platform.pickFiles();
                        if (result != null) {
                          PlatformFile file = result!.files.first;
                          if(file.extension!.contains("notes")){
                            final stringFile = File(file.path!).readAsStringSync();
                            final decoded = json.decode(stringFile)['notes'];
                            for(int i = 0; i < decoded.length; i++){
                              final note = Note.fromJson(decoded[i]);
                              await notesBloc.addItem(note);
                            }
                            result = null;
                          }
                        }
                        else {
                          // User canceled the picker
                        }
                      },
                      style: TextButton.styleFrom(
                        primary: HexColor.fromHex(provider.color!),
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          fontFamily: App.font
                        )
                      )
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      child: Text(AppLocalizations.of(context, 'notes_backup')),
                      onPressed: () async{
                        final notes = await notesBloc.fetchAllNotes();
                        Map<String, dynamic> notesJson = {
                          "notes": notes!.map((el) => el.toJson()).toList()
                        };
                        String dir = (await getTemporaryDirectory()).path;
                        final File file = File("$dir/all.notes");
                        file.writeAsStringSync(json.encode(notesJson));
                        Share.shareFiles(["$dir/all.notes"]).then((value){
                          file.delete();
                        });
                      },
                      style: TextButton.styleFrom(
                        primary: HexColor.fromHex(provider.color!),
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          fontFamily: App.font
                        )
                      )
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      child: Text(AppLocalizations.of(context, 'notes_open')),
                      onPressed: () async{
                        result = await FilePicker.platform.pickFiles();
                        if (result != null) {
                          PlatformFile file = result!.files.first;
                          if(file.extension! == "note"){
                            final stringFile = File(file.path!).readAsStringSync();
                            final note = Note.fromJson(json.decode(stringFile));
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
                                if(note.category! == "default"){
                                  return CreateSimpleNoteDialog(
                                    note: note,
                                    isFromImport: true
                                  );
                                }
                                else{
                                  return CreateTaskNoteDialog(
                                    note: note,
                                    isFromImport: true
                                  );
                                }
                              }
                            );
                            result = null;
                          }
                        }
                        else {
                          // User canceled the picker
                        }
                      },
                      style: TextButton.styleFrom(
                        primary: HexColor.fromHex(provider.color!),
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          fontFamily: App.font
                        )
                      )
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
