import 'package:flutter/material.dart';
import 'package:notes/data/utils/extensions.dart';
import 'package:notes/data/utils/localization.dart';
import 'package:notes/ui/provider/prefsprovider.dart';
import 'package:notes/ui/widgets/platform_button.dart';
import 'package:notes/ui/widgets/platform_textfield.dart';
import 'package:provider/provider.dart';

class NewItemDialog extends StatefulWidget {
  final Function? addNewItem;

  const NewItemDialog({
    Key? key,
    this.addNewItem
  }) : super(key: key);

  @override
  _NewItemDialogState createState() => _NewItemDialogState();
}

class _NewItemDialogState extends State<NewItemDialog> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PreferenceProvider>(context);
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
                            const SizedBox(width: 40),
                            Text(
                              AppLocalizations.of(context, 'new_item'),
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
                            PlatformTextField(
                              controller: _descController,
                              isForNotes: true,
                              showClear: false,
                              minLines: 1,
                              maxLines: 1,
                              hintText: AppLocalizations.of(context, 'typehint'),
                              isExpanded: false,
                              inputAction: TextInputAction.done,
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: PlatformButton(
                                fontSize: 20,
                                onPressed: () async {
                                  final title = _titleController.text.trim();
                                  final desc = _descController.text.trim();
                                  if(title.isNotEmpty){
                                    await widget.addNewItem!(
                                      title, desc.isNotEmpty ? desc : null
                                    );
                                    Navigator.pop(context);
                                  }
                                  else{
                                    debugPrint("Empty field now");
                                  }
                                },
                                text: AppLocalizations.of(context, 'create'),
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

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }
}
