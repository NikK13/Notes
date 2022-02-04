import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notes/data/utils/app.dart';

class LoadingView extends StatelessWidget {
  final Color? color;

  const LoadingView({Key? key, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return App.platform == "ios"
    ?
    const CupertinoActivityIndicator()
    :
    CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation(color!),
    );
  }
}
