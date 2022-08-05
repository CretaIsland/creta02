// ignore_for_file: depend_on_referenced_packages
//import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:appwrite/appwrite.dart';
import '../../common/util/logger.dart';
import 'abs_database.dart';
import '../../common/util/config.dart';

class AppwriteDatabase extends AbsDatabase {
  Client? dbConn;
  Databases? database;

  @override
  void initialize() {
    dbConn = Client()
      ..setProject(myConfig!.serverConfig!.projectId)
      ..setSelfSigned(status: true)
      ..setEndpoint(myConfig!.serverConfig!.databaseURL);

    database = Databases(dbConn!, databaseId: myConfig!.serverConfig!.appId);
  }

  @override
  Future<Map<String, dynamic>> getData(String collectionId, String key) async {
    List resultList =
        await simpleQueryData(collectionId, name: 'mid', value: key, orderBy: 'updateTime');
    return resultList.first;
    // final doc = await database!.getDocument(
    //   collectionId: collectionId,
    //   documentId: key,
    // );
    // return doc.data;
  }

  @override
  Future<List> getAllData(String collectionId) async {
    final result = await database!.listDocuments(collectionId: collectionId);
    return result.documents.map((element) {
      return element.data;
    }).toList();
  }

  @override
  Future<void> setData(String collectionId, String key, Object data) async {
    database!.updateDocument(
      collectionId: collectionId,
      documentId: key,
      data: data as Map<String, dynamic>,
    );
  }

  @override
  Future<void> createData(String collectionId, String key, Map<dynamic, dynamic> data) async {
    logger.finest('createData($key)');
    database!.createDocument(
      collectionId: collectionId,
      documentId: key,
      data: data,
    );
  }

  @override
  Future<List> simpleQueryData(String collectionId,
      {required String name,
      required String value,
      required String orderBy,
      bool descending = true,
      int? limit,
      int? offset}) async {
    String orderType = descending ? 'DESC' : 'ASC';
    final result = await database!.listDocuments(
      collectionId: collectionId,
      queries: [Query.equal(name, value)], // index 를 만들어줘야 함.
      orderAttributes: [orderBy],
      orderTypes: [orderType],
    );
    return result.documents.map((element) {
      return element.data;
    }).toList();
  }

  @override
  Future<List> queryData(
    String collectionId, {
    required Map<String, dynamic> where,
    required String orderBy,
    bool descending = true,
    int? limit,
    int? offset, // appwrite only
    List<Object?>? startAfter, // firebase only
  }) async {
    String orderType = descending ? 'DESC' : 'ASC';

    List<dynamic> queryList = [];
    where.map((key, value) {
      queryList.add(Query.equal(key, value));
      return MapEntry(key, value);
    });

    final result = await database!.listDocuments(
      collectionId: collectionId,
      queries: queryList, // index 를 만들어줘야 함.
      orderAttributes: [orderBy],
      orderTypes: [orderType],
      limit: limit,
      offset: offset,
    );
    return result.documents.map((doc) {
      //logger.finest(doc.data.toString());
      return doc.data;
    }).toList();
  }

  @override
  Future<bool> removeData(String collectionId, String key) async {
    return true;
  }
}
