// ignore_for_file: depend_on_referenced_packages

import 'package:appwrite/appwrite.dart';

abstract class AbsDatabase {
  Client? dbConn; //appwrite only

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
