import 'package:flutter/material.dart';
import 'package:notes/data/utils/extensions.dart';
import 'package:notes/ui/provider/prefsprovider.dart';
import 'package:notes/ui/widgets/ripple.dart';
import 'package:provider/provider.dart';

class SelectedCheckBox extends StatelessWidget {
  final bool? isSelected;
  final Function()? onTap;
  final double size;

  const SelectedCheckBox({
    Key? key,
    this.isSelected,
    this.onTap,
    this.size = 32
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PreferenceProvider>(context);
    return Ripple(
      radius: 30,
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        child: isSelected! ? Icon(
          Icons.check,
          color: Colors.white,
          size: size / 2,
        ) : const SizedBox(),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: isSelected! ?
          HexColor.fromHex(provider.color!) :
          Colors.grey.shade300
        ),
      ),
    );
  }
}
