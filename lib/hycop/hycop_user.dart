import 'package:creta02/hycop/hycop_factory.dart';

import '../../common/util/config.dart';
// import 'absModel/abs_model.dart';
import 'user/abs_user_db.dart';
import 'user/appwrite_user_db.dart';
import 'user/firebase_user_db.dart';
// import 'package:creta02/common/util/exceptions.dart';
import '../common/util/logger.dart';
import 'database/db_utils.dart';
import '../model/abs_object.dart';
import 'utils/hycop_utils.dart';

enum AccountSignUpType {
  none,
  creta,
  google,
  //facebook,
  //instagram,
  //twitter,
  end;

  static int validCheck(int val) => (val > end.index || val < none.index) ? none.index : val;
  static AccountSignUpType fromInt(int? val) => AccountSignUpType.values[validCheck(val ?? none.index)];
}

class HycopUser extends AbsObject {
  // static
  static AbsUserDb? _userDb; // = null;

  static void initialize() {
    if (_userDb != null) return;
    if (HycopFactory.serverType == ServerType.appwrite) {
      _userDb = AppwriteUserDb();
    } else {
      _userDb = FirebaseUserDb();
    }
    //_userDb!.initialize();
  }

  static Future<void> createAccount(Map<String, dynamic> userData) async {
    initialize();
    logger.finest('createAccount start');
    await _userDb!.createAccount(userData).onError((error, stackTrace) =>
        throw HycopUtils.getHycopException(error: error, defaultMessage: 'HycopUser.createAccount Failed !!!'));
    logger.finest('createAccount end');
    _currentLoginUser = HycopUser(userData: userData);
    logger.finest('createAccount set');
  }

  static Future<bool> isExistAccount(String email) {
    initialize();
    return _userDb!.isExistAccount(email).catchError((error, stackTrace) =>
        throw HycopUtils.getHycopException(error: error, defaultMessage: 'HycopUser.isExistAccount Failed !!!'));
  }

  static Future<void> updateAccountInfo(Map<String, dynamic> updateUserData) async {
    if (_currentLoginUser._isLoginedUser == false) {
      // not login !!!
      throw HycopUtils.getHycopException(defaultMessage: 'not login !!!');
    }
    initialize();
    Map<String, dynamic> newUserData = {};
    newUserData.addAll(_currentLoginUser.getValueMap);
    newUserData.addAll(updateUserData);
    await _userDb!.updateAccountInfo(newUserData).onError((error, stackTrace) =>
        throw HycopUtils.getHycopException(error: error, defaultMessage: 'HycopUser.updateAccount Failed !!!'));
    _currentLoginUser = HycopUser(userData: newUserData);
  }

  static Future<void> updateAccountPassword(String newPassword, String oldPassword) async {
    if (_currentLoginUser._isLoginedUser == false) {
      // not login !!!
      throw HycopUtils.getHycopException(defaultMessage: 'not login !!!');
    }
    initialize();
    Map<String, dynamic> newUserData = {};
    newUserData.addAll(_currentLoginUser.getValueMap);
    newUserData['password'] = HycopUtils.stringToSha1(newPassword);
    await _userDb!.updateAccountPassword(newPassword, oldPassword).onError((error, stackTrace) =>
        throw HycopUtils.getHycopException(error: error, defaultMessage: 'HycopUser.updateAccount Failed !!!'));
    _currentLoginUser = HycopUser(userData: newUserData);
  }

  static Future<void> login(String email, String password) async {
    if (_currentLoginUser._isLoginedUser) {
      // already login !!!
      throw HycopUtils.getHycopException(defaultMessage: 'already logined !!!');
    }
    initialize();
    Map<String, dynamic> userData = {};
    await _userDb!.login(email, password, returnUserData: userData).onError((error, stackTrace) =>
        throw HycopUtils.getHycopException(error: error, defaultMessage: 'HycopUser.loginByEmail Failed !!!'));
    _currentLoginUser = HycopUser(userData: userData);
  }

  static Future<void> loginByService(String email, AccountSignUpType accountSignUpType) async {
    if (_currentLoginUser._isLoginedUser) {
      // already login !!!
      throw HycopUtils.getHycopException(defaultMessage: 'already logined !!!');
    }
    initialize();
    Map<String, dynamic> userData = {};
    await _userDb!.login(email, email, returnUserData: userData, accountSignUpType: accountSignUpType).onError(
        (error, stackTrace) =>
            throw HycopUtils.getHycopException(error: error, defaultMessage: 'HycopUser.loginByEmail Failed !!!'));
    _currentLoginUser = HycopUser(userData: userData);
  }

  static Future<void> deleteAccount() async {
    if (_currentLoginUser._isLoginedUser == false) {
      // already logout !!!
      throw HycopUtils.getHycopException(defaultMessage: 'not login !!!');
    }
    initialize();
    await _userDb!.deleteAccount().onError((error, stackTrace) =>
        throw HycopUtils.getHycopException(error: error, defaultMessage: 'HycopUser.deleteAccount Failed !!!'));
    _currentLoginUser = HycopUser(logout: true);
  }

  static Future<void> logout() async {
    if (_currentLoginUser._isLoginedUser == false) {
      // already logout !!!
      return;
    }
    initialize();
    logger.finest('logout start');
    await _userDb!.logout().onError((error, stackTrace) =>
        throw HycopUtils.getHycopException(error: error, defaultMessage: 'HycopUser.logout Failed !!!'));
    logger.finest('logout end');
    _currentLoginUser = HycopUser(logout: true);
    logger.finest('logout set');
  }

  static Future<void> resetPassword(String email) async {
    initialize();
    await _userDb!.resetPassword(email).onError((error, stackTrace) =>
        throw HycopUtils.getHycopException(error: error, defaultMessage: 'HycopUser.resetPassword Failed !!!'));
  }

  static Future<void> resetPasswordConfirm(String userId, String secret, String newPassword) async {
    initialize();
    await _userDb!.resetPasswordConfirm(DBUtils.midToKey(userId), secret, newPassword).onError((error, stackTrace) =>
        throw HycopUtils.getHycopException(error: error, defaultMessage: 'HycopUser.resetPassword Failed !!!'));
  }

  static HycopUser _currentLoginUser = HycopUser(logout: true);
  static HycopUser get currentLoginUser => _currentLoginUser;

  // member
  bool _isLoginedUser = false;
  //AccountSignUpType _accountSignUpType = AccountSignInType.none;
  //bool _isGoogleAccount = false;
  //Map<String, dynamic> _userData = {};
  //Map<String, dynamic> get allUserData => _userData;

  bool get isLoginedUser => _isLoginedUser;
  AccountSignUpType get accountSignUpType =>
      AccountSignUpType.fromInt(int.parse(getValue('accountSignUpType')?.toString() ?? AccountSignUpType.none.index.toString()));
  String get userId => getValue('userId') ?? '';
  String get email => getValue('email') ?? '';
  String get password => getValue('password') ?? '';
  String get name => getValue('name') ?? '';
  String get phone => getValue('phone') ?? '';
  String get imagefile => getValue('imagefile') ?? '';
  String get userType => getValue('userType') ?? '';

  HycopUser({ObjectType type = ObjectType.user, Map<String, dynamic>? userData, bool logout = false})
      : super(type: type) {
    if (logout || userData == null) {
      return;
    }
    if (userData.isEmpty) {
      return;
    }
    String userId = userData['userId'] ?? '';
    if (userId.isEmpty) {
      return;
    }
    _isLoginedUser = true;
    fromMap(userData);
  }
}

//
// setValue 예제 필요
//
