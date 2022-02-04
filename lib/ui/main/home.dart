import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notes/data/utils/app.dart';
import 'package:notes/data/utils/appnavigator.dart';
import 'package:notes/data/utils/extensions.dart';
import 'package:notes/data/utils/localization.dart';
import 'package:notes/ui/main/settings.dart';
import 'package:notes/ui/provider/prefsprovider.dart';
import 'package:notes/ui/widgets/platform_textfield.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _searchController = TextEditingController();

  void Function(void Function())? _setSearchState;

  String _filter = '';

  @override
  void initState() {
    _searchController.addListener(() {
      _setSearchState!(() {
        _filter = _searchController.text;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PreferenceProvider>(context);
    App.setupBar(Theme.of(context).brightness == Brightness.light);
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        floatingActionButtonLocation: App.platform == "ios" ?
        FloatingActionButtonLocation.centerFloat :
        FloatingActionButtonLocation.endFloat,
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(
            bottom: 12
          ),
          child: App.platform == "ios" ? FloatingActionButton(
            onPressed: (){},
            backgroundColor: HexColor.fromHex(provider.color!),
            child: const Icon(
              Icons.add,
              color: Colors.white,
              size: 28,
            ),
          ) : FloatingActionButton.extended(
            onPressed: (){},
            backgroundColor: HexColor.fromHex(provider.color!),
            label: Row(
              children: [
                const Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                const SizedBox(width: 6),
                Text(
                  AppLocalizations.of(context, 'create'),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600
                  ),
                )
              ],
            ),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(
              left: 20, right: 20,
              top: 28, bottom: 16
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context, 'explore'),
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w700
                      ),
                    ),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: (){

                          },
                          child: Icon(
                            CupertinoIcons.arrow_down_doc,
                            size: 30,
                            color: HexColor.fromHex(provider.color!),
                          ),
                        ),
                        const SizedBox(width: 16),
                        GestureDetector(
                          onTap: (){
                            AppNavigator.of(context).push(SettingsPage(
                              reloadDesign: _reloadDesign,
                            ));
                          },
                          child: Icon(
                            CupertinoIcons.settings,
                            size: 30,
                            color: HexColor.fromHex(provider.color!),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                StatefulBuilder(
                  builder: (_, setItem){
                    _setSearchState = setItem;
                    return PlatformTextField(
                      controller: _searchController,
                      showClear: _filter.isNotEmpty,
                      hintText: AppLocalizations.of(context, 'typehint'),
                    );
                  },
                ),
              ],
            ),
          ),
        )
      ),
    );
  }

  void _reloadDesign(){
    setState(() {
      if(App.platform == "android"){
        App.platform = "ios";
      }
      else{
        App.platform = "android";
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

