// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:creta02/hycop/absModel/abs_model.dart';
import 'package:creta02/model/abs_object.dart';
// import 'package:firebase_core/firebase_core.dart';
//import 'package:creta02/common/util/exceptions.dart';
// import 'package:uuid/uuid.dart';
//import 'package:creta02/model/abs_model.dart';
import '../../common/util/logger.dart';
import 'abs_user_db.dart';
// import '../database/abs_database.dart';
import '../hycop_factory.dart';
import '../utils/hycop_exceptions.dart';
import '../utils/hycop_utils.dart';
import '../hycop_user.dart';

class FirebaseUserDb extends AbsUserDb {
  // @override
  // Future<void> initialize() async {
  //   return Future.value();
  // }
  //
  // CretaException _getCretaException(dynamic error, String defaultMessage) {
  //   String defMsg;
  //   if (error is FirebaseException) {
  //     FirebaseException ex = error;
  //     defMsg = '${ex.message} (${ex.code})';
  //   } else {
  //     defMsg = defaultMessage;
  //   }
  //   return CretaException(message: defMsg, exception: error);
  // }

  @override
  Future<void> createAccount(Map<String, dynamic> createUserData) async {
    logger.finest('createAccount($createUserData)');
    // accountSignUpType
    var accountSignUpType = AccountSignUpType.creta;
    if (createUserData['accountSignUpType'] == null) {
      createUserData['accountSignUpType'] = accountSignUpType.index; //AccountSignUpType.creta.index;
    } else {
      accountSignUpType = AccountSignUpType.fromInt(int.parse(createUserData['accountSignUpType'].toString()));
      if (accountSignUpType == AccountSignUpType.none) {
        logger.severe('invalid sign-up type !!!');
        throw HycopUtils.getHycopException(defaultMessage: 'invalid sign-up type !!!');
      }
    }
    // userId
    String userId = createUserData['userId'] ?? '';
    if (userId.isEmpty) {
      // not exist userId ==> create new one
      //userId = const Uuid().v4().replaceAll('-', '');
      userId = genMid2(ObjectType.user).replaceAll('-', '');
      createUserData['userId'] = userId;
    }
    // email
    String email = createUserData['email'] ?? '';
    if (email.isEmpty) {
      logger.severe('email is empty !!!');
      throw HycopUtils.getHycopException(defaultMessage: 'email is empty !!!');
    }
    // password
    String password = createUserData['password'] ?? '';
    if (password.isEmpty && accountSignUpType == AccountSignUpType.creta) {
      // creta need password !!!
      logger.severe('password is empty !!!');
      throw HycopUtils.getHycopException(defaultMessage: 'password is empty !!!');
    }
    String passwordSha1 = '';
    if (accountSignUpType == AccountSignUpType.creta) {
      // creta service password = sha1-hash of password
      passwordSha1 = HycopUtils.stringToSha1(password);
      logger.finest('password resetting to [$password] (creta service - [${accountSignUpType.name}]');
    } else {
      // accountSignUpType != AccountSignUpType.creta ==>
      // external service password = sha1-hash of email
      passwordSha1 = HycopUtils.stringToSha1(email); //sha1.convert(bytes).toString();
      password = passwordSha1;
      logger.finest('password resetting to [$password] (external service - [${accountSignUpType.name}]');
    }
    createUserData['password'] = passwordSha1;
    logger.finest('createAccount($createUserData)');
    HycopFactory.myDataBase!.createData('hycop_users', userId, createUserData).catchError((error, stackTrace) =>
        throw HycopUtils.getHycopException(error: error, defaultMessage: 'loginByEmail Error !!!'));
    logger.finest('createAccount($createUserData) success');
  }

  @override
  Future<bool> isExistAccount(String email) async {
    // final getUserData = 
    await HycopFactory.myDataBase!
        .simpleQueryData('hycop_users', name: 'email', value: email, orderBy: 'name')
        .catchError((error, stackTrace) =>
            throw HycopUtils.getHycopException(error: error, defaultMessage: 'not exist account(email:$email) !!!'))
        .then((value) {
      if (value.isEmpty) {
        logger.finest('not exist account(email:$email) !!!');
        //throw HycopException(message: 'not exist account(email:$email) !!!');
        return Future.value(false); //false;
      } else {
        logger.finest('exist account(email:$email)');
        return Future.value(true); //true;
      }
    });
    logger.finest('not exist account(email:$email)');
    return Future.value(false); //false;
  }

  @override
  Future<void> updateAccountInfo(Map<String, dynamic> updateUserData) async {
    logger.finest('updateAccount($updateUserData)');
    String userId = updateUserData["userId"] ?? "";
    if (userId.isEmpty) {
      throw const HycopException(message: 'no userId !!!');
    }
    await HycopFactory.myDataBase!.setData('hycop_users', userId, updateUserData).catchError(
        (error, stackTrace) => throw HycopUtils.getHycopException(error: error, defaultMessage: 'setData Error !!!'));
  }

  @override
  Future<void> updateAccountPassword(String newPassword, String oldPassword) async {
    logger.finest('updateAccountPassword($newPassword)');
    //
    if (newPassword.isEmpty || newPassword.isEmpty || newPassword == oldPassword) {
      // invalid password !!!
      logger.severe('invalid password !!!');
      throw HycopUtils.getHycopException(defaultMessage: 'invalid password !!!');
    }
    //
    String email = HycopUser.currentLoginUser.email;
    final getUserData = await HycopFactory.myDataBase!
        .simpleQueryData('hycop_users', name: 'email', value: email, orderBy: 'name')
        .catchError((error, stackTrace) =>
            throw HycopUtils.getHycopException(error: error, defaultMessage: 'not exist account(email:$email) !!!'));
    if (getUserData.isEmpty) {
      logger.finest('not exist account(email:$email) !!!');
      throw HycopException(message: 'not exist account(email:$email) !!!');
    }
    String oldPasswordSha1 = HycopUtils.stringToSha1(oldPassword);
    String newPasswordSha1 = HycopUtils.stringToSha1(newPassword);
    for (var result in getUserData) {
      String pwd = result['password'] ?? '';
      if (pwd != oldPasswordSha1) {
        logger.finest('different oldpassword (email:$oldPassword) !!!');
        throw HycopException(message: 'not exist account(email:$email) !!!');
      }
      break;
    }
    //
    Map<String, dynamic> newUserData = {};
    newUserData.addAll(HycopUser.currentLoginUser.getValueMap);
    newUserData['password'] = newPasswordSha1;
    String userId = HycopUser.currentLoginUser.userId;
    await HycopFactory.myDataBase!.setData('hycop_users', userId, newUserData).catchError(
        (error, stackTrace) => throw HycopUtils.getHycopException(error: error, defaultMessage: 'setData Error !!!'));
  }

  @override
  Future<void> deleteAccount() async {
    logger.finest('deleteAccount(${HycopUser.currentLoginUser.email})');
    //
    Map<String, dynamic> newUserData = {};
    newUserData.addAll(HycopUser.currentLoginUser.getValueMap);
    newUserData['isRemoved'] = true;
    String userId = HycopUser.currentLoginUser.userId;
    await HycopFactory.myDataBase!.setData('hycop_users', userId, newUserData).catchError(
        (error, stackTrace) => throw HycopUtils.getHycopException(error: error, defaultMessage: 'setData Error !!!'));
  }

  @override
  Future<void> login(String email, String password,
      {Map<String, dynamic>? returnUserData, AccountSignUpType accountSignUpType = AccountSignUpType.creta}) async {
    logger.finest('loginByEmail($email, $password)');
    String passwordSha1 = HycopUtils.stringToSha1(password);
    var getUserData = await HycopFactory.myDataBase!
        .queryData('hycop_users', where: {'email': email, 'password': passwordSha1}, orderBy: 'name')
        .catchError((error, stackTrace) =>
            throw HycopUtils.getHycopException(error: error, defaultMessage: 'not exist account(email:$email) !!!'));
    if (getUserData.isEmpty) {
      logger.severe('getData error !!!');
      throw const HycopException(message: 'getData failed !!!');
    }
    for (var result in getUserData) {
      final type = AccountSignUpType.fromInt(
          int.parse(result['accountSignUpType'].toString()));
      if (type != accountSignUpType) {
        logger.severe('not [${accountSignUpType.name}] sign-up user !!!');
        throw HycopUtils.getHycopException(defaultMessage: 'not [${accountSignUpType.name}] sign-up user !!!');
      }
      if (result['isRemoved'] == true) {
        logger.severe('removed user !!!');
        throw HycopUtils.getHycopException(defaultMessage: 'removed user !!!');
      }
      returnUserData?.addAll(result);
      break;
    }
    logger.finest('loginByEmail success ($returnUserData)');
  }

  @override
  Future<void> logout() async {
    logger.finest('logout');
    // do nothing
  }

  @override
  Future<void> resetPassword(String email) async {
    logger.finest('resetPassword');
    //
    // ????????? api-url??? email?????? ??????
    // => users ??????????????? email ????????? ????????? (?????????)secret??? set, userId??? get
    // => smtp??? email ???????????? secret??? ??? userId??? ?????? (ex: https://www.examples.com/resetPasswordConfirm?userId=xxx&secret=yyy )
    //
  }

  @override
  Future<void> resetPasswordConfirm(String userId, String secret, String newPassword) async {
    logger.finest('resetPassword(userId:$userId, secret:$secret, newPassword:$newPassword)');
    var getUserData = await HycopFactory.myDataBase!.getData('hycop_users', userId).catchError(
        (error, stackTrace) =>
            throw HycopUtils.getHycopException(error: error, defaultMessage: 'not exist account(userId:$userId) !!!'));
    if (getUserData.isEmpty) {
      logger.severe('getData error !!!');
      throw const HycopException(message: 'getData failed !!!');
    }
    String dbSecret = getUserData['secret'] ?? "";
    if (dbSecret != secret) {
      logger.severe('not match secret-key !!!');
      throw const HycopException(message: 'not match secret-key !!!');
    }
    getUserData['password'] = HycopUtils.stringToSha1(newPassword);
    await HycopFactory.myDataBase!.setData('hycop_users', userId, getUserData).catchError(
        (error, stackTrace) => throw HycopUtils.getHycopException(error: error, defaultMessage: 'setData Error !!!'));
  }
}
