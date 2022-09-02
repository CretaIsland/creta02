import 'package:flutter/material.dart';

class WidgetSnippets {
  static Widget hyImageIcon(String asstetPath, double width, double height) {
    return Image(
        image: AssetImage(asstetPath),
        width: width,
        height: height,
        fit: BoxFit.scaleDown,
        alignment: FractionalOffset.center);

    // return ImageIcon(
    //   AssetImage(
    //     asstetPath,
    //   ),
    //   //color: bgColor,
    //   size: size,
    // );
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
}
