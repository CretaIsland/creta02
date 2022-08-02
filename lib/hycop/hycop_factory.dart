import 'database/firebase_database.dart';
import 'database/appwrite_database.dart';
import 'database/abs_database.dart';
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
}
