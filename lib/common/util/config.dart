// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'package:flutter/material.dart';

import 'logger.dart';

enum ServerType {
  none,
  firebase,
  appwrite;

  static ServerType fromString(String arg) {
    if (arg == 'firebase') return ServerType.firebase;
    if (arg == 'appwrite') return ServerType.appwrite;
    return ServerType.none;
  }
}

class DBConnInfo {
  String apiKey = "";
  String authDomain = "";
  String databaseURL = ''; // appwrite endpoint
  String projectId = ""; // appwrite projectId
  String storageBucket = "";
  String messagingSenderId = "";
  String appId = ""; // appwrite databaseId
}

abstract class AbsServerConfig {
  final String enterprise;

  DBConnInfo dbConnInfo = DBConnInfo();
  //DBConnInfo rtConnInfo = DBConnInfo();

  // String apiKey = "";
  // String authDomain = "";
  // String databaseURL = ''; // appwrite endpoint
  // String projectId = ""; // appwrite projectId
  // String storageBucket = "";
  // String messagingSenderId = "";
  // String appId = ""; // appwrite databaseId

  AbsServerConfig(this.enterprise);
}

class FirebaseConfig extends AbsServerConfig {
  FirebaseConfig({String enterprise = 'creta'}) : super(enterprise) {
    if (enterprise == 'creta') {
      // database info
      // dbConnInfo.apiKey = "AIzaSyBe_K6-NX9-lzYNjQCPOFWbaOUubXqWVHg";
      // dbConnInfo.authDomain = "creta01-ef955.firebaseapp.com";
      // dbConnInfo.databaseURL = ''; // 일반 Database 에는 이상하게 이 값이 없다.
      // dbConnInfo.projectId = "creta01-ef955";
      // dbConnInfo.storageBucket = "creta01-ef955.appspot.com";
      // dbConnInfo.messagingSenderId = "878607742856";
      // dbConnInfo.appId = "1:878607742856:web:87e91c3185d1a79980ec3d";

      // // realTime info
      // rtConnInfo.apiKey = "AIzaSyCq3Ap2QXjMfPptFyHLHNCyVTeQl9G2PoY";
      // rtConnInfo.authDomain = "creta02-1a520.firebaseapp.com";
      // rtConnInfo.databaseURL = "https://creta02-1a520-default-rtdb.firebaseio.com";
      // rtConnInfo.projectId = "creta02-1a520";
      // rtConnInfo.storageBucket = "creta02-1a520.appspot.com";
      // rtConnInfo.messagingSenderId = "352118964959";
      // rtConnInfo.appId = "1:352118964959:web:6b9d9378aad1b7c9261f6a";
      dbConnInfo.apiKey = "AIzaSyCq3Ap2QXjMfPptFyHLHNCyVTeQl9G2PoY";
      dbConnInfo.authDomain = "creta02-1a520.firebaseapp.com";
      dbConnInfo.databaseURL = "https://creta02-1a520-default-rtdb.firebaseio.com";
      dbConnInfo.projectId = "creta02-1a520";
      dbConnInfo.storageBucket = "creta02-1a520.appspot.com";
      dbConnInfo.messagingSenderId = "352118964959";
      dbConnInfo.appId = "1:352118964959:web:6b9d9378aad1b7c9261f6a";
    }
    if (enterprise == 'Demo') {
      // database info
      // dbConnInfo.apiKey = "AIzaSyBe_K6-NX9-lzYNjQCPOFWbaOUubXqWVHg";
      // dbConnInfo.authDomain = "creta01-ef955.firebaseapp.com";
      // dbConnInfo.databaseURL = ''; // 일반 Database 에는 이상하게 이 값이 없다.
      // dbConnInfo.projectId = "creta01-ef955";
      // dbConnInfo.storageBucket = "creta01-ef955.appspot.com";
      // dbConnInfo.messagingSenderId = "878607742856";
      // dbConnInfo.appId = "1:878607742856:web:87e91c3185d1a79980ec3d";

      // realTime info
      // rtConnInfo.apiKey = "AIzaSyCq3Ap2QXjMfPptFyHLHNCyVTeQl9G2PoY";
      // rtConnInfo.authDomain = "creta02-1a520.firebaseapp.com";
      // rtConnInfo.databaseURL = "https://creta02-1a520-default-rtdb.firebaseio.com";
      // rtConnInfo.projectId = "creta02-1a520";
      // rtConnInfo.storageBucket = "creta02-1a520.appspot.com";
      // rtConnInfo.messagingSenderId = "352118964959";
      // rtConnInfo.appId = "1:352118964959:web:6b9d9378aad1b7c9261f6a";

      dbConnInfo.apiKey = "AIzaSyCq3Ap2QXjMfPptFyHLHNCyVTeQl9G2PoY";
      dbConnInfo.authDomain = "creta02-1a520.firebaseapp.com";
      dbConnInfo.databaseURL = "https://creta02-1a520-default-rtdb.firebaseio.com";
      dbConnInfo.projectId = "creta02-1a520";
      dbConnInfo.storageBucket = "creta02-1a520.appspot.com";
      dbConnInfo.messagingSenderId = "352118964959";
      dbConnInfo.appId = "1:352118964959:web:6b9d9378aad1b7c9261f6a";
    }
  }
}

class AppwriteConfig extends AbsServerConfig {
  AppwriteConfig({String enterprise = 'creta'}) : super(enterprise) {
    if (enterprise == 'creta') {
      dbConnInfo.apiKey =
          "163c3964999075adc6b7317f211855832ebb6d464520446280af0f8bbb9e642ffdcd2588a5141ce3ea0011c5780ce10986ed57b742fdb6a641e2ecf7310512cd5349e61385f856eb4789e718d750e2451c1b1519dd20cdf557b5edc1ae066e28430f5cc3e157abc4a13ad6aa112a48b07ce707341edfdc41d2572e95b4728905"; // apiKet
      dbConnInfo.databaseURL = "http://192.168.10.3/v1"; // endPoint
      dbConnInfo.projectId = "62d79f0b36f4029ce40f";
      dbConnInfo.appId = "62d79f2e5fda513f4807"; // databaseId
    }
    if (enterprise == 'Demo') {
      dbConnInfo.apiKey =
          "163c3964999075adc6b7317f211855832ebb6d464520446280af0f8bbb9e642ffdcd2588a5141ce3ea0011c5780ce10986ed57b742fdb6a641e2ecf7310512cd5349e61385f856eb4789e718d750e2451c1b1519dd20cdf557b5edc1ae066e28430f5cc3e157abc4a13ad6aa112a48b07ce707341edfdc41d2572e95b4728905"; // apiKet
      dbConnInfo.databaseURL = "http://192.168.10.3/v1"; // endPoint
      dbConnInfo.projectId = "62d79f0b36f4029ce40f";
      dbConnInfo.appId = "62d79f2e5fda513f4807"; // databaseId
    }
  }
}

class AssetConfig {
  final String enterprise;
  AssetConfig({this.enterprise = 'creta'});

  int savePeriod = 1000;
  Future<void> loadAsset(BuildContext context) async {
    String jsonString = '';
    try {
      jsonString =
          await DefaultAssetBundle.of(context).loadString('assets/${enterprise}_config.json');
    } catch (e) {
      logger.info('assets/${enterprise}_config.json not exist, creta_config.json will be used');
      try {
        jsonString = await DefaultAssetBundle.of(context).loadString('assets/creta_config.json');
      } catch (e) {
        logger.severe('load assets/${enterprise}_config.json failed', e);
        return;
      }
    }
    final dynamic jsonMap = jsonDecode(jsonString);
    savePeriod = jsonMap['savePeriod'] ?? 1000;
  }
}

HycopConfig? myConfig;

class HycopConfig {
  final String enterprise;
  final ServerType serverType;
  late AssetConfig config;
  AbsServerConfig? serverConfig;

  HycopConfig({required this.enterprise, required this.serverType}) {
    config = AssetConfig(enterprise: enterprise);
    if (serverType == ServerType.firebase) {
      serverConfig = FirebaseConfig(enterprise: enterprise);
    } else if (serverType == ServerType.appwrite) {
      serverConfig = AppwriteConfig(enterprise: enterprise);
    }
  }
}
