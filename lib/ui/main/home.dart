import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:notes/data/model/note.dart';
import 'package:notes/data/utils/app.dart';
import 'package:notes/data/utils/appnavigator.dart';
import 'package:notes/data/utils/extensions.dart';
import 'package:notes/data/utils/localization.dart';
import 'package:notes/ui/bloc/notes_bloc.dart';
import 'package:notes/ui/dialogs/note_type_dialog.dart';
import 'package:notes/ui/main/settings.dart';
import 'package:notes/ui/provider/prefsprovider.dart';
import 'package:notes/ui/widgets/loading.dart';
import 'package:notes/ui/widgets/nodata.dart';
import 'package:notes/ui/widgets/platform_textfield.dart';
import 'package:provider/provider.dart';

late NotesBloc notesBloc;
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _searchController = TextEditingController();

  void Function(void Function())? _setSearchState, _setListState;

  String _filter = '';

  @override
  void initState() {
    _searchController.addListener(() {
      _setSearchState!(() {
        _filter = _searchController.text;
        _setListState!((){});
      });
    });
    notesBloc = NotesBloc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PreferenceProvider>(context);
    App.setupBar(Theme.of(context).brightness == Brightness.light);
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
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
                      AppLocalizations.of(context, 'notes'),
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w700
                      ),
                    ),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: (){
                            /*AppNavigator.of(context).push(
                              SimpleNotePage(notesBloc: _notesBloc)
                            );*/
                            showModalBottomSheet(
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(16),
                                  topRight: Radius.circular(16)
                                )
                              ),
                              context: context,
                              isScrollControlled: true,
                              builder: (context) => const NoteTypeDialog()
                            );
                          },
                          child: Icon(
                            CupertinoIcons.add_circled,
                            size: 32,
                            color: HexColor.fromHex(provider.color!),
                          ),
                        ),
                        const SizedBox(width: 16),
                        GestureDetector(
                          onTap: (){
                            AppNavigator.of(context).push(SettingsPage(
                              reloadDesign: _reloadDesign,
                              notesBloc: notesBloc,
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
                Expanded(
                  child: StreamBuilder(
                    stream: notesBloc.listStream,
                    builder: (context, AsyncSnapshot<List<Note>?> snapshot) {
                      //debugPrint("${snapshot.data}");
                      if(snapshot.connectionState == ConnectionState.active){
                        if(snapshot.hasData){
                          if(snapshot.data!.isNotEmpty){
                            final list = snapshot.data;
                            list!.sort((a,b){
                              return b.date!.compareTo(a.date!);
                            });
                            return Column(
                              children: [
                                const SizedBox(height: 24),
                                Expanded(
                                  child: StatefulBuilder(
                                    builder: (_, setItem){
                                      _setListState = setItem;
                                      return StaggeredGridView.countBuilder(
                                        physics: const BouncingScrollPhysics(),
                                        crossAxisCount: 2,
                                        itemCount: getSearchList(list).length,
                                        shrinkWrap: true,
                                        itemBuilder: (BuildContext context, int index) {
                                          final item = getSearchList(list)[index];
                                          return NoteItem(note: item);
                                        },
                                        staggeredTileBuilder: (int index) => StaggeredTile.count(
                                          (index + 1) % 3 == 0 ? 2 : 1, 1
                                        ),
                                        crossAxisSpacing: 12.0, mainAxisSpacing: 12.0,
                                      );
                                    },
                                  ),
                                ),
                              ],
                            );
                          }
                          return const NoDataPage();
                        }
                        return const NoDataPage();
                      }
                      return Center(child: LoadingView(color: HexColor.fromHex(provider.color!)));
                    }
                  ),
                )
              ],
            ),
          ),
        )
      ),
    );
  }

  List<Note> getSearchList(List<Note> currentList){
    return _filter.isEmpty ? currentList :
      currentList.where((element) => element.title!.contains(_filter)).toList();
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

