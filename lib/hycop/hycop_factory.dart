import 'package:creta02/hycop/storage/abs_storage.dart';
import 'package:creta02/hycop/storage/appwrite_storage.dart';
import 'package:creta02/hycop/storage/firebase_storage.dart';

import '../common/util/logger.dart';
import 'database/firebase_database.dart';
import 'database/appwrite_database.dart';
import 'database/abs_database.dart';
import 'realtime/abs_realtime.dart';
import 'realtime/firebase_realtime.dart';
import 'realtime/appwrite_realtime.dart';
import 'function/abs_function.dart';
import 'function/appwrite_function.dart';
import 'function/firebase_function.dart';
import '../common/util/config.dart';

class HycopFactory {
  static String enterprise = 'Demo';
  static ServerType serverType = ServerType.firebase;
  static AbsDatabase? myDataBase;
  static void selectDatabase() {
    if (HycopFactory.serverType == ServerType.appwrite) {
      myDataBase = AppwriteDatabase();
    } else {
      myDataBase = FirebaseDatabase();
    }
    myDataBase!.initialize();
    return;
  }

  static AbsRealtime? myRealtime;
  static void selectRealTime() {
    if (HycopFactory.serverType == ServerType.appwrite) {
      myRealtime = AppwriteRealtime();
    } else {
      myRealtime = FirebaseRealtime();
    }
    myRealtime!.initialize();
    return;
  }

  static AbsFunction? myFunction;
  static void selectFunction() {
    if (HycopFactory.serverType == ServerType.appwrite) {
      myFunction = AppwriteFunction();
    } else {
      myFunction = FirebaseFunction();
    }
    myFunction!.initialize();
    return;
  }

  static AbsStorage? myStorage;
  static void selectStorage() {
    if (HycopFactory.serverType == ServerType.appwrite) {
      myStorage = AppwriteStorage();
    } else {
      myStorage = FirebaseAppStorage();
    }
    myStorage!.initialize();
    return;
  }

  static void initAll() {
    if (myConfig != null) return;
    logger.info('initAll()');
    myConfig = HycopConfig();
    HycopFactory.selectDatabase();
    HycopFactory.selectRealTime();
    HycopFactory.selectFunction();
    HycopFactory.selectStorage();
  }
}
