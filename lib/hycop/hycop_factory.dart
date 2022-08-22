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
  static AbsDatabase? myDataBase;
  static void selectDatabase() {
    if (myConfig!.serverType == ServerType.appwrite) {
      myDataBase = AppwriteDatabase();
    } else {
      myDataBase = FirebaseDatabase();
    }
    myDataBase!.initialize();
    return;
  }

  static AbsRealtime? myRealtime;
  static void selectRealTime() {
    if (myConfig!.serverType == ServerType.appwrite) {
      myRealtime = AppwriteRealtime();
    } else {
      myRealtime = FirebaseRealtime();
    }
    myRealtime!.initialize();
    return;
  }

  static AbsFunction? myFunction;
  static void selectFunction() {
    if (myConfig!.serverType == ServerType.appwrite) {
      myFunction = AppwriteFunction();
    } else {
      myFunction = FirebaseFunction();
    }
    myFunction!.initialize();
    return;
  }
}
