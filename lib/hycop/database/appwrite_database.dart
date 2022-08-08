// ignore_for_file: depend_on_referenced_packages
//import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:appwrite/appwrite.dart';
import 'package:creta02/hycop/database/db_utils.dart';
import '../../common/util/logger.dart';
import 'abs_database.dart';
import '../../common/util/config.dart';

class AppwriteDatabase extends AbsDatabase {
  Databases? database;

  @override
  void initialize() {
    AbsDatabase.awDBConn = Client()
      ..setProject(myConfig!.serverConfig!.dbConnInfo.projectId)
      ..setSelfSigned(status: true)
      ..setEndpoint(myConfig!.serverConfig!.dbConnInfo.databaseURL);

    database =
        Databases(AbsDatabase.awDBConn!, databaseId: myConfig!.serverConfig!.dbConnInfo.appId);
  }

  @override
  Future<Map<String, dynamic>> getData(String collectionId, String mid) async {
    // List resultList =
    //     await simpleQueryData(collectionId, name: 'mid', value: mid, orderBy: 'updateTime');
    // return resultList.first;
    String key = DBUtils.midToKey(mid);
    final doc = await database!.getDocument(
      collectionId: collectionId,
      documentId: key,
    );
    return doc.data;
  }

  @override
  Future<List> getAllData(String collectionId) async {
    final result = await database!.listDocuments(collectionId: collectionId);
    return result.documents.map((element) {
      return element.data;
    }).toList();
  }

  @override
  Future<void> setData(String collectionId, String mid, Object data) async {
    String key = DBUtils.midToKey(mid);
    logger.finest('setData($key)');
    logger.finest('setData(${(data as Map<String, dynamic>)["name"]})');
    logger.finest('setData(${(data)["hashTag"]})');

    database!.updateDocument(
      collectionId: collectionId,
      documentId: key,
      data: data,
    );
  }

  @override
  Future<void> createData(String collectionId, String mid, Map<dynamic, dynamic> data) async {
    logger.finest('createData($mid)');
    String key = DBUtils.midToKey(mid);
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
    where.map((mid, value) {
      queryList.add(Query.equal(mid, value));
      return MapEntry(mid, value);
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
  Future<void> removeData(String collectionId, String mid) async {
    String key = DBUtils.midToKey(mid);
    database!.deleteDocument(
      collectionId: collectionId,
      documentId: key,
    );
  }
}
