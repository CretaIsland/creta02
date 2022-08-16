// ignore_for_file: depend_on_referenced_packages

import 'package:appwrite/appwrite.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../../common/util/exceptions.dart';
import '../../common/util/logger.dart';
import '../../hycop/absModel/abs_model.dart';
import '../hycop_factory.dart';

abstract class AbsDatabase {
  //connection info
  static Client? _awDBConn; //appwrite only
  static FirebaseApp? _fbDBApp; // firebase only Database connection

  static Client? get awDBConn => _awDBConn;
  static FirebaseApp? get fbDBApp => _fbDBApp;

  @protected
  static void setAppWriteApp(Client client) => _awDBConn = client;
  @protected
  static void setFirebaseApp(FirebaseApp fb) => _fbDBApp = fb;

  void initialize();

  Future<Map<String, dynamic>> getData(String collectionId, String mid);
  Future<List> getAllData(String collectionId);
  Future<List> simpleQueryData(String collectionId,
      {required String name,
      required String value,
      required String orderBy,
      bool descending = true,
      int? limit,
      int? offset});

  Future<List> queryData(String collectionId,
      {required Map<String, dynamic> where,
      required String orderBy,
      bool descending = true,
      int? limit,
      int? offset, // appwrite only
      List<Object?>? startAfter}); // firebase onlu

  Future<void> setData(String collectionId, String mid, Map<dynamic, dynamic> data);
  Future<void> createData(String collectionId, String mid, Map<dynamic, dynamic> data);
  Future<void> removeData(String collectionId, String mid);

  Future<void> setModel(String collectionId, AbsModel model) async {
    try {
      await setData(collectionId, model.mid, model.toMap());
      // Delta 를 저장한다.
      HycopFactory.myRealtime!.setDelta(directive: 'set', mid: model.mid, delta: model.toMap());
    } catch (e) {
      logger.severe("setModel(set) error", e);
      throw CretaException(message: "setModel(set) error", exception: e as Exception);
    }
  }

  Future<void> createModel(String collectionId, AbsModel model) async {
    try {
      logger.finest('createModel(${model.mid})');
      await createData(collectionId, model.mid, model.toMap());
      // Delta 를 저장한다.
      HycopFactory.myRealtime!.setDelta(directive: 'create', mid: model.mid, delta: model.toMap());
    } catch (e) {
      logger.severe("setModel(create) error", e);
      throw CretaException(message: "setModel(create) error", exception: e as Exception);
    }
  }

  Future<void> removeModel(String collectionId, String mid) async {
    try {
      await removeData(collectionId, mid);
      // Delta 를 저장한다.
      Map<String, dynamic> delta = {};
      delta['mid'] = mid;
      HycopFactory.myRealtime!.setDelta(directive: 'remove', mid: mid, delta: delta);
    } catch (e) {
      logger.severe("setModel(remove) error", e);
      throw CretaException(message: "setModel(remove) error", exception: e as Exception);
    }
  }
}
