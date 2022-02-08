import 'package:flutter/material.dart';
import 'package:notes/data/utils/app.dart';
import 'package:notes/data/utils/extensions.dart';
import 'package:notes/ui/provider/prefsprovider.dart';
import 'package:notes/ui/widgets/ripple.dart';
import 'package:provider/provider.dart';

class SettingsRow extends StatelessWidget {

  final String? title;
  final String? trailing;
  final Function? onTap;
  final IconData? icon;
  final Widget? switchData;

  const SettingsRow({
    Key? key,
    this.title,
    this.onTap,
    this.trailing,
    this.icon,
    this.switchData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PreferenceProvider>(context);
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 5,
      child: Ripple(
        radius: 16,
        rippleColor: Theme.of(context).brightness == Brightness.dark ?
        Colors.black26 : Colors.white,
        onTap: () => onTap!(),
        child: SizedBox(
          width: double.infinity,
          child: InkWell(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 8,
                vertical: trailing != null ? 12 : 15,
              ),
              child:Row(
                children: [
                  Icon(
                    icon!,
                    size: 36,
                    color: HexColor.fromHex(provider.color!),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          title!,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600
                          ),
                          maxLines: 1,
                        ),
                        if(trailing != null)
                        Text(
                          trailing!,
                          style: TextStyle(
                            fontSize: 14,
                            color: HexColor.fromHex(provider.color!),
                            fontWeight: FontWeight.w600
                          ),
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ),
                  if(switchData != null)
                  switchData!
                ],
              ),
            ),
          ),
        ),
      ),
    );
    /*return ListTile(
      title: Text(
        title!,
        style: const TextStyle(
          fontWeight: FontWeight.w700,
          fontFamily: App.font,
        ),
      ),
      onTap: () => onTap!(),
      subtitle: Text(
        trailing!,
        style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: App.appColor,
            fontFamily: App.font
        ),
      ),
      leading: Icon(
        icon!,
        size: 36,
        color: Theme.of(context).textTheme.bodyText1!.color,
      ),
    );*/
  }
}

class SettingsTitle extends StatelessWidget {

  final String? title;

  const SettingsTitle({Key? key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical:2),
      child: Text(
        title!,
        style: TextStyle(
          fontFamily: App.font,
          fontWeight: FontWeight.w700,
          color: Theme.of(context).textTheme.bodyText1!.color,
          fontSize: 16,
        ),
      ),
    );
  }
}

