// ignore_for_file: depend_on_referenced_packages

import 'package:appwrite/appwrite.dart';
import '../../common/util/config.dart';
import '../../common/util/logger.dart';
import 'abs_database.dart';

class DBUtils {
  static Future<bool> login(String email, String password) async {
    if (myConfig!.serverType == ServerType.appwrite) {
      logger.finest('login($email, $password)');
      try {
        Account account = Account(AbsDatabase.awDBConn!);
        //await account.create(userId: userId, email: email, password: password);
        await account.createEmailSession(email: email, password: password);
      } catch (e) {
        logger.severe('authentication error', e);
        return false;
        //throw CretaException(message: 'authentication error', exception: e as Exception);
      }
    }
    return true;
  }

  static String midToKey(String mid) => mid.substring(mid.indexOf('=') + 1);
}
