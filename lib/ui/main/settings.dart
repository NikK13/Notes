import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:notes/data/utils/app.dart';
import 'package:notes/data/utils/appnavigator.dart';
import 'package:notes/data/utils/extensions.dart';
import 'package:notes/data/utils/localization.dart';
import 'package:notes/ui/bloc/notes_bloc.dart';
import 'package:notes/ui/provider/prefsprovider.dart';
import 'package:notes/ui/widgets/appbar.dart';
import 'package:notes/ui/widgets/settings_ui.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  final Function? reloadDesign;
  final NotesBloc? notesBloc;

  const SettingsPage({
    Key? key,
    this.reloadDesign,
    this.notesBloc,
  }) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Color? currentColor;

  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<PreferenceProvider>(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            right: 16, left: 16, top: 24
          ),
          child: SingleChildScrollView(
            physics: App.platform == "ios" ? const BouncingScrollPhysics() :
              const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PlatformAppBar(
                  title: AppLocalizations.of(context, 'settings'),
                  titleFontSize: 30,
                ),
                const SizedBox(height: 32),
                SettingsSection(
                  title: AppLocalizations.of(context, 'common'),
                  settingsItems: [
                    SettingsRow(
                      title: AppLocalizations.of(context, 'changelang'),
                      onTap: () => App.platform == "ios" ?
                      showIosLangDialog(context, _provider) :
                      showLangDialog(context, _provider),
                      trailing: getTitle(context),
                      icon: Icons.language_rounded,
                      isFirst: true,
                      isLast: false,
                    ),
                    SettingsRow(
                      title: AppLocalizations.of(context, 'currenttheme'),
                      onTap: () => App.platform == "ios" ?
                      showIosThemesDialog(context, _provider) :
                      showThemesDialog(context, _provider),
                      trailing: _provider.getThemeTitle(context),
                      icon: Icons.brightness_auto,
                      isFirst: false,
                      isLast: true,
                    ),
                  ]
                ),
                SettingsSection(
                  title: AppLocalizations.of(context, 'appearance'),
                  settingsItems: [
                    SettingsRow(
                      title: AppLocalizations.of(context, 'appcolor'),
                      onTap: () => showColorDialog(context, _provider),
                      icon: Icons.color_lens,
                      switchData: Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ClipOval(
                          child: Material(
                            color: HexColor.fromHex(_provider.color!),
                            child: const SizedBox(
                              height: 30,
                              width: 30,
                            ),
                          ),
                        ),
                      ),
                      isFirst: true,
                      isLast: true,
                    ),
                  ]
                ),
                SettingsSection(
                  title: AppLocalizations.of(context, 'app'),
                  settingsItems: [
                    SettingsRow(
                      title: AppLocalizations.of(context, 'delete_all'),
                      onTap: () async{
                        await widget.notesBloc!.deleteAllItems();
                        AppNavigator.of(context).pop();
                      },
                      icon: Icons.delete_outline,
                      isFirst: true,
                      isLast: false,
                    ),
                    SettingsRow(
                      title: "${App.appName}, v 0.1.0",
                      onTap: () {
                        widget.reloadDesign!();
                        AppNavigator.of(context).pop();
                      },
                      trailing: App.platform.capitalize(),
                      icon: Icons.help_outline,
                      isFirst: false,
                      isLast: true,
                    ),
                  ]
                ),
                //const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  changeLabelsValue(provider, value) => provider.savePreference('isLabels', value);

  String getTitle(BuildContext context) {
    var lang = Localizations.localeOf(context).languageCode;
    switch (lang) {
      case 'ru':
        return 'Русский';
      case 'en':
        return 'English';
      default:
        return '';
    }
  }

  showLangDialog(BuildContext context, provider) {
    showModalBottomSheet(
      context: context,
      backgroundColor: getThemedBackgroundColor(context),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16)
        )
      ),
      builder: (context){
        return buildLangWidget(context, provider);
      }
    );
  }

  showIosLangDialog(BuildContext context, provider){
    showCupertinoModalPopup(
      context: context,
      builder: (_) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.of(context).pop();
              provider.savePreference('language', 'en');
            },
            child: Text(
              'English',
              style: TextStyle(
                fontFamily: App.font,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).textTheme.headline1!.color
              ),
            )
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.of(context).pop();
              provider.savePreference('language', 'ru');
            },
            child: Text(
              'Русский',
              style: TextStyle(
                fontFamily: App.font,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).textTheme.headline1!.color
              ),
            )
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            AppLocalizations.of(context, 'cancel'),
            style: const TextStyle(
              fontFamily: App.font,
              color: Colors.red,
              fontWeight: FontWeight.w600
            ),
          )
        ),
      )
    );
  }

  showColorDialog(context, PreferenceProvider provider){
    showDialog(
      context: context,
      builder: (ctx){
        currentColor = HexColor.fromHex(provider.color!);
        return AlertDialog(
          title: const Text('Pick a color!'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: HexColor.fromHex(provider.color!),
              onColorChanged: (Color color){
                currentColor = color;
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: (){
                Navigator.pop(ctx);
                provider.savePreference("color", App.defColor);
              },
              child: const Text("Reset to default")
            ),
            TextButton(
              onPressed: (){
                Navigator.pop(ctx);
                provider.savePreference("color", currentColor!.toHex());
              },
              child: const Text("OK")
            )
          ],
        );
      }
    );
  }

  showThemesDialog(BuildContext context, provider) {
    // show the dialog
    showModalBottomSheet(
      context: context,
      backgroundColor: getThemedBackgroundColor(context),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16)
        )
      ),
      builder: (context){
        return buildWidget(context, provider);
      }
    );
  }

  showIosThemesDialog(BuildContext context, provider){
    showCupertinoModalPopup(
      context: context,
      builder: (_) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.of(context).pop();
              provider.savePreference('mode', 'light');
            },
            child: Text(
              AppLocalizations.of(context, 'lighttheme'),
              style: TextStyle(
                fontFamily: App.font,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).textTheme.headline1!.color
              ),
            )
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.of(context).pop();
              provider.savePreference('mode', 'dark');
            },
            child: Text(
              AppLocalizations.of(context, 'darktheme'),
              style: TextStyle(
                fontFamily: App.font,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).textTheme.headline1!.color
              ),
            )
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.of(context).pop();
              provider.savePreference('mode', 'system');
            },
            child: Text(
              AppLocalizations.of(context, 'systemtheme'),
              style: TextStyle(
                fontFamily: App.font,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).textTheme.headline1!.color
              ),
            )
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            AppLocalizations.of(context, 'cancel'),
            style: const TextStyle(
              fontFamily: App.font,
              fontWeight: FontWeight.w600,
              color: Colors.red
            ),
          )
        ),
      )
    );
  }

  buildWidget(BuildContext context, provider) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 12, vertical: 8
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          dialogLine,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(width: 40),
              Text(
                AppLocalizations.of(context, 'currenttheme'),
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
          const SizedBox(height: 12),
          ListTile(
            leading: Icon(
              Icons.brightness_high,
              color: Theme.of(context).textTheme.bodyText1!.color,
            ),
            title: Text(
              AppLocalizations.of(context, 'lighttheme'),
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18
              ),
            ),
            onTap: () async {
              Navigator.pop(context);
              provider.savePreference('mode', 'light');
            },
          ),
          ListTile(
            leading: Icon(
              Icons.brightness_4,
              color: Theme.of(context).textTheme.bodyText1!.color,
            ),
            title: Text(
              AppLocalizations.of(context, 'darktheme'),
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18
              ),
            ),
            onTap: () async {
              Navigator.pop(context);
              provider.savePreference('mode', 'dark');
            },
          ),
          ListTile(
            leading: Icon(
              Icons.phone_iphone,
              color: Theme.of(context).textTheme.bodyText1!.color,
            ),
            title: Text(
              AppLocalizations.of(context, 'systemtheme'),
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18
              ),
            ),
            onTap: () async {
              Navigator.pop(context);
              provider.savePreference('mode', 'system');
            },
          )
        ],
      ),
    );
  }

  buildLangWidget(BuildContext context, provider) =>
      Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 12, vertical: 8
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            dialogLine,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 40),
                Text(
                  AppLocalizations.of(context, 'changelang'),
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
            const SizedBox(height: 12),
            ListTile(
              leading: const Text(
                'EN',
                style: TextStyle(fontSize: 18),
              ),
              title: const Text(
                'English',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18
                ),
              ),
              onTap: () async {
                Navigator.pop(context);
                provider.savePreference('language', 'en');
              },
            ),
            ListTile(
              leading: const Text('RU', style: TextStyle(fontSize: 18)),
              title: const Text(
                'Русский',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18
                ),
              ),
              onTap: () async {
                Navigator.pop(context);
                provider.savePreference('language', 'ru');
              },
            ),
          ],
        ),
      );
}

