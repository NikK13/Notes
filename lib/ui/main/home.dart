import 'package:flutter/rendering.dart';
import 'package:notes/ui/main/backup.dart';
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

  void Function(void Function())? _setSearchState, _setListState, _setFabState;

  String _filter = '';
  bool _isFabExpanded = true;

  List<Note>? notes;

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
        floatingActionButtonLocation: App.platform == "ios" ?
        FloatingActionButtonLocation.centerFloat :
        FloatingActionButtonLocation.endFloat,
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(
            bottom: 12
          ),
          child: App.platform == "ios" ? FloatingActionButton(
            onPressed: () => _openNewNoteDialog(context),
            backgroundColor: HexColor.fromHex(provider.color!),
            child: const Icon(
              Icons.add,
              color: Colors.white,
              size: 28,
            ),
          ) : StatefulBuilder(
            builder: (_, setItem){
              _setFabState = setItem;
              return FloatingActionButton.extended(
                onPressed: () => _openNewNoteDialog(context),
                isExtended: _isFabExpanded,
                backgroundColor: HexColor.fromHex(provider.color!),
                label: _isFabExpanded ? Row(
                  children: [
                    const Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                    Row(
                      children: [
                        const SizedBox(width: 6),
                        Text(
                          AppLocalizations.of(context, 'create'),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600
                          ),
                        ),
                      ],
                    )
                  ],
                ) : const SizedBox(),
                icon: !_isFabExpanded ? const Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 28,
                ) : null,
              );
            },
          )
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(
              left: 20, right: 20,
              top: 28, bottom: 16
            ),
            child: StreamBuilder(
              stream: notesBloc.listStream,
              builder: (context, AsyncSnapshot<List<Note>?> snapshot) {
                //debugPrint("_____NOTES STREAM BUILD_____");
                if(snapshot.hasData){
                  snapshot.data!.sort((a,b){
                    return b.date!.compareTo(a.date!);
                  });
                }
                return NotificationListener<UserScrollNotification>(
                  onNotification: (notification){
                    if(App.platform == "android"){
                      if(notification.direction == ScrollDirection.forward){
                        _setFabState!(() => _isFabExpanded = true);
                      }
                      else if(notification.direction == ScrollDirection.reverse){
                        _setFabState!(() => _isFabExpanded = false);
                      }
                    }
                    return true;
                  },
                  child: SingleChildScrollView(
                    physics: App.platform == "ios" ?
                    const BouncingScrollPhysics() :
                    const AlwaysScrollableScrollPhysics(),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: (snapshot.hasData) ?
                        (snapshot.data!.isNotEmpty) ?
                        double.infinity : MediaQuery.of(context).size.height - 100 :
                        MediaQuery.of(context).size.height - 100
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
                                    onTap: () async{
                                      AppNavigator.of(context).push(const BackUpNotes());
                                    },
                                    child: Icon(
                                      CupertinoIcons.cloud_download,
                                      size: 31,
                                      color: HexColor.fromHex(provider.color!),
                                    ),
                                  ),
                                  const SizedBox(width: 18),
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
                                enabled: (snapshot.hasData && snapshot.data!.isNotEmpty),
                                hintText: AppLocalizations.of(context, 'typehint'),
                              );
                            },
                          ),
                          (snapshot.hasData) ? (snapshot.data!.isNotEmpty) ? Column(
                            children: [
                              const SizedBox(height: 24),
                              StatefulBuilder(
                                builder: (_, setItem){
                                  _setListState = setItem;
                                  return StaggeredGridView.countBuilder(
                                    physics: const NeverScrollableScrollPhysics(),
                                    crossAxisCount: 2,
                                    itemCount: _getSearchList(snapshot.data!).length,
                                    shrinkWrap: true,
                                    itemBuilder: (BuildContext context, int index) {
                                      final item = _getSearchList(snapshot.data!)[index];
                                      return NoteItem(note: item);
                                    },
                                    staggeredTileBuilder: (int index) => StaggeredTile.count(
                                        1, (index) % 2 == 0 ? 1.3 : 1
                                    ),
                                    crossAxisSpacing: 12.0, mainAxisSpacing: 12.0,
                                  );
                                },
                              ),
                            ],
                          ) : const Expanded(
                            child: NoDataPage()
                          ) :
                          Expanded(
                            child: Center(
                              child: LoadingView(color: HexColor.fromHex(provider.color!))
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              }
            ),
          ),
        )
      ),
    );
  }

  void _openNewNoteDialog(BuildContext context){
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
  }

  List<Note> _getSearchList(List<Note> currentList){
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

