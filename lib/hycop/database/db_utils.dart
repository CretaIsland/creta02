// ignore_for_file: depend_on_referenced_packages

import 'package:uuid/uuid.dart';
import '../absModel/model_enums.dart';

class DBUtils {
  //static String HycopUser.currentLoginUser = 'b49@sqisoft.com'; // 임시로 사용

  // static Future<bool> login(String email, String password) async {
  //   if (HycopFactory.serverType == ServerType.appwrite) {
  //     try {
  //       Account account = Account(AbsDatabase.awDBConn!);
  //       //await account.create(userId: userId, email: email, password: password);
  //       await account.createEmailSession(email: email, password: password);
  //       //HycopUser.currentLoginUser = email;
  //       logger.info('login($email, $password)');
  //     } catch (e) {
  //       logger.severe('authentication error', e);
  //       return false;
  //       //throw CretaException(message: 'authentication error', exception: e as Exception);
  //     }
  //   } else {
  //     //if (email.isNotEmpty) HycopUser.currentLoginUser = email;
  //   }
  //   return true;
  // }

  static String midToKey(String mid) {
    int pos = mid.indexOf('=');
    if (pos >= 0 && pos < mid.length - 1) return mid.substring(pos + 1);
    return mid;
  }

  static String collectionFromMid(String mid) {
    int pos = mid.indexOf('=');
    if (pos >= 0 && pos < mid.length - 1) return 'creta_${mid.substring(0, pos)}';
    return 'creta_unknown';
  }

  static String genMid(ModelType type) {
    String mid = '${type.name}=';
    mid += const Uuid().v4();
    return mid;
  }

  static DateTime dateTimeFromDB(String src) {
    //if (myConfig!.serverType == ServerType.appwrite) {
    return DateTime.parse(src).toLocal(); // yyyy-mm-dd hh:mm:ss.sss
    //}
    //return src.toDate();
  }

  static String dateTimeToDB(DateTime src) {
    //if (myConfig!.serverType == ServerType.appwrite) {
    return src.toUtc().toString(); // yyyy-mm-dd hh:mm:ss.sssZ
    //}
    //return src;
  }
}
