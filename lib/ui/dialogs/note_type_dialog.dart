import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:notes/data/utils/extensions.dart';
import 'package:notes/data/utils/localization.dart';
import 'package:notes/ui/dialogs/create_simple_note.dart';
import 'package:notes/ui/dialogs/create_task_note.dart';
import 'package:notes/ui/widgets/ripple.dart';

class NoteTypeDialog extends StatelessWidget {

  const NoteTypeDialog({Key? key}) : super(key: key);

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
                    AppLocalizations.of(context, 'createnote'),
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
                  NewNoteItem(
                    image: "assets/images/undraw_note.svg",
                    title: " ${AppLocalizations.of(context, 'simple_note')}",
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
                        builder: (context) => const CreateSimpleNoteDialog()
                      );
                    },
                  ),
                  NewNoteItem(
                    image: "assets/images/undraw_task.svg",
                    title: " ${AppLocalizations.of(context, 'task_note')}",
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
                        builder: (context) => const CreateTaskNoteDialog()
                      );
                      /*showModalBottomSheet(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        isScrollControlled: true,
                        isDismissible: true,
                        context: context,
                        builder: (context) => DraggableScrollableSheet(
                          initialChildSize: 0.75,
                          minChildSize: 0.5,
                          maxChildSize: 0.95,
                          expand: false,
                          snap: true,
                          builder: (context, scrollController) {
                            return CreateTaskNoteDialog(
                              controller: scrollController,
                            );
                          },
                        ),
                      );*/
                    },
                  ),
                  NewNoteItem(
                    image: "assets/images/undraw_cart.svg",
                    title: AppLocalizations.of(context, 'shop_note'),
                    onTap: (){

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

class NewNoteItem extends StatelessWidget {
  final String? image;
  final String? title;
  final String? desc;
  final Function? onTap;

  const NewNoteItem({
    Key? key,
    this.title,
    this.desc,
    this.image,
    this.onTap
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
                SvgPicture.asset(
                  image!,
                  width: 50,
                  height: 50,
                  fit: BoxFit.fill,
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title!,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if(desc != null)
                      Text(
                        desc!,
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ],
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

