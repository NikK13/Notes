import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:notes/data/utils/extensions.dart';
import 'package:notes/data/utils/localization.dart';
import 'package:notes/ui/widgets/platform_button.dart';

class DeleteNoteDialog extends StatelessWidget {
  final Function? deleteNote;

  const DeleteNoteDialog({Key? key, this.deleteNote}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                    AppLocalizations.of(context, 'warning'),
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
                  SvgPicture.asset(
                    "assets/images/undraw_delete.svg",
                    width: 100, height: 100,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    AppLocalizations.of(context, 'delete_note_dialog'),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: PlatformButton(
                        fontSize: 18,
                        onPressed: () async{
                          await deleteNote!();
                          Navigator.pop(context);
                        },
                        text: AppLocalizations.of(context, 'delete'),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: PlatformButton(
                        fontSize: 18,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        text: AppLocalizations.of(context, 'cancel')
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
