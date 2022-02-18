import 'package:flutter/material.dart';
import 'package:notes/data/model/preferences.dart';
import 'package:notes/data/utils/app.dart';
import 'package:notes/data/utils/extensions.dart';
import 'package:notes/data/utils/localization.dart';
import 'package:notes/ui/provider/prefsprovider.dart';
import 'package:notes/ui/widgets/platform_button.dart';
import 'package:provider/provider.dart';

class OnBoard extends StatelessWidget {
  final Preferences? preferences;

  const OnBoard({Key? key, this.preferences}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    App.setupBar(Theme.of(context).brightness == Brightness.light);
    return OnBoardScreen(prefs: preferences);
  }
}

class OnBoardScreen extends StatelessWidget {
  final Preferences? prefs;

  const OnBoardScreen({Key? key, this.prefs}) : super(key: key);

  proceedToApp(context, provider) async {
    await provider
      ..savePreference('language', prefs!.locale!.languageCode)
      ..savePreference('first', false);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PreferenceProvider>(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 24,
                ),
                child: Center(
                  child: Icon(
                    Icons.note_alt_outlined,
                    size: 200,
                    color: HexColor.fromHex(provider.color!),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 16,
                horizontal: 32
              ),
              child: Column(
                children: [
                  const FittedBox(
                    fit: BoxFit.cover,
                    child: Text(
                      App.appName,
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w800
                      ),
                    ),
                  ),
                  FittedBox(
                    fit: BoxFit.cover,
                    child: Text(
                      AppLocalizations.of(context, 'description'),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600
                      ),
                    ),
                  )
                ],
              )
            ),
            Padding(
              padding: const EdgeInsets.only(
                bottom: 48,
                top: 8,
              ),
              child: PlatformButton(
                text: AppLocalizations.of(context, 'start'),
                onPressed: () async {
                  await proceedToApp(context, provider);
                },
              )
            )
          ],
        ),
      ),
    );
  }
}


