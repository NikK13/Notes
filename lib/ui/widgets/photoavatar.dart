import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notes/data/utils/appnavigator.dart';
import 'package:notes/data/utils/extensions.dart';
import 'package:notes/ui/provider/prefsprovider.dart';

class PhotoCircle extends StatelessWidget {
  final String? photo;
  final String? userName;
  final PreferenceProvider? provider;

  const PhotoCircle({Key? key, this.photo, this.provider, this.userName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        //AppNavigator.of(context).push(LoginPage());
      },
      child: photo != null ? photo != "default" ?
      SizedBox(
        height: 30, width: 30,
        child: CircleAvatar(
          foregroundImage: NetworkImage(
            photo!
          ),
          child: Text(
            (userName != null) ?
            userName![0] : "U",
            style: const TextStyle(
                color: Colors.white
            ),
          ),
        ),
      ) : SizedBox(
        height: 32, width: 32,
        child: CircleAvatar(
          child: Text(
            userName != null ?
            userName![0] : "U",
            style: const TextStyle(
                color: Colors.white
            ),
          ),
        ),
      ) : Center(
        child: Icon(
          CupertinoIcons.person_crop_circle,
          size: 34,
          color: HexColor.fromHex(provider!.color!),
        ),
      ),
    );
  }
}