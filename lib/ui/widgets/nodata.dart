import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:notes/data/utils/extensions.dart';
import 'package:notes/data/utils/localization.dart';
import 'package:notes/ui/provider/prefsprovider.dart';
import 'package:provider/provider.dart';

class NoDataPage extends StatelessWidget {
  const NoDataPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PreferenceProvider>(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 55),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            CupertinoIcons.square_list,
            size: 70,
            color: HexColor.fromHex(provider.color!),
          ),
          Text(
            AppLocalizations.of(context, "nodata"),
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
