import 'package:flutter/material.dart';
import 'package:notes/data/model/note.dart';
import 'package:notes/data/utils/extensions.dart';
import 'package:notes/ui/widgets/selected_checkbox.dart';

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