import 'package:flutter/material.dart';
import 'package:notes/data/utils/localization.dart';

class ChipsList extends StatelessWidget {
  final int? index;
  final Color? color;
  final Function? func;

  const ChipsList({
    Key? key,
    this.index, this.color, this.func
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> chips = [];
    List _options = [
      AppLocalizations.of(context, 'low'),
      AppLocalizations.of(context, 'medium'),
      AppLocalizations.of(context, 'high')
    ];
    for (int i = 0; i < _options.length; i++) {
      ChoiceChip choiceChip = ChoiceChip(
        selected: index == i,
        label: Text(
          _options[i],
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16
          ),
        ),
        elevation: 1,
        pressElevation: 5,
        backgroundColor: Colors.grey.withOpacity(0.35),
        selectedColor: color,
        onSelected: (bool selected) {
          func!(selected, i);
        },
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12)
        ),
      );
      chips.add(
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: choiceChip,
        ),
      );
    }
    return SizedBox(
      height: 50,
      child: ListView(
        // This next line does the trick.
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        children: chips,
      ),
    );
  }
}