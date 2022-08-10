// ignore_for_file: depend_on_referenced_packages

import 'package:appwrite/appwrite.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

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
}
