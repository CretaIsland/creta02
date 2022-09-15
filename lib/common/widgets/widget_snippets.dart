// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../hycop/database/db_utils.dart';
import '../../hycop/hycop_factory.dart';
import '../util/config.dart';
import 'resizing_icon_button.dart';

class WidgetSnippets {
  static Widget hyImageIconButton(String assetPath, double width, double height,
      {required void Function() onPressed}) {
    return ResizingIconButton(
      onPressed: onPressed,
      assetPath: assetPath,
      width: width,
      height: height,
    );
  }

  static Widget hyImageIcon(
    String asstetPath,
    double width,
    double height,
  ) {
    return Image(
        image: AssetImage(asstetPath),
        width: width,
        height: height,
        fit: BoxFit.scaleDown,
        alignment: FractionalOffset.center);
  }

  static List<Widget> hyAppBarActions(
      {required void Function() goHome, required void Function() goLogin}) {
    return [
      HycopFactory.serverType == ServerType.appwrite
          ? WidgetSnippets.appwriteLogoButton(onPressed: goHome)
          : WidgetSnippets.firebaseLogoButton(onPressed: goHome),
      Center(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Text(
          HycopFactory.enterprise,
          style: const TextStyle(fontSize: 20),
        ),
      )),
      Center(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Text(
          DBUtils.currentUserId,
          style: const TextStyle(fontSize: 24),
        ),
      )),
      Center(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: IconButton(
          icon: const Icon(Icons.logout, size: 36),
          onPressed: goLogin,
        ),
      )),
    ];
  }

  static Widget appwriteLogoButton(
      {required void Function() onPressed, double width = 120, double height = 45}) {
    return hyImageIconButton(onPressed: onPressed, 'assets/appwrite_logo.png', width, height);
  }

  static Widget firebaseLogoButton(
      {required void Function() onPressed, double width = 120, double height = 45}) {
    return hyImageIconButton(onPressed: onPressed, 'assets/firebase_logo.png', width, height);
  }

  static Widget appwriteLogo({double width = 120, double height = 45}) {
    return hyImageIcon('assets/appwrite_logo.png', width, height);
  }

  static Widget firebaseLogo({double width = 120, double height = 45}) {
    return hyImageIcon('assets/firebase_logo.png', width, height);
  }

  static Widget builtWithAppwrite({double width = 120, double height = 45}) {
    return hyImageIcon('assets/built_with_appwrite.png', width, height);
  }

  static Widget builtWithFirebase({double width = 120, double height = 45}) {
    return hyImageIcon('assets/built_with_firebase.png', width, height);
  }

  static Widget shimmerText(
      {required int duration,
      required Color fgColor,
      required Color bgColor,
      required Text child}) {
    return Shimmer.fromColors(
        //key: ValueKey(key),
        period: Duration(milliseconds: duration),
        baseColor: fgColor,
        highlightColor: bgColor,
        child: child);
  }
}
