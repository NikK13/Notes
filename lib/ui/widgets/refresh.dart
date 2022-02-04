import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notes/data/utils/app.dart';
import 'package:notes/data/utils/extensions.dart';
import 'package:notes/ui/provider/prefsprovider.dart';
import 'package:provider/provider.dart';

class RefreshView extends StatelessWidget {
  final Widget? child;
  final Function? updateCurrentDate;

  const RefreshView({
    Key? key,
    this.child,
    this.updateCurrentDate
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PreferenceProvider>(context);
    return App.platform != "ios"
      ? RefreshIndicator(
        color: HexColor.fromHex(provider.color!),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: child,
        ),
        onRefresh: updateCurrentDate as Future<void> Function(),
      )
      : CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          CupertinoSliverRefreshControl(
            onRefresh: updateCurrentDate as Future<void> Function(),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, _) => child,
              childCount: 1,
            ),
          )
        ],
      );
  }
}
