// ignore_for_file: depend_on_referenced_packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import '../../common/util/logger.dart';
import '../../common/util/config.dart';
import 'abs_database.dart';

class FirebaseDatabase extends AbsDatabase {
  @override
  void initialize() async {
    AbsDatabase.fbDBApp = await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: myConfig!.serverConfig!.dbConnInfo.apiKey,
            appId: myConfig!.serverConfig!.dbConnInfo.appId,
            storageBucket: myConfig!.serverConfig!.dbConnInfo.storageBucket,
            messagingSenderId: myConfig!.serverConfig!.dbConnInfo.messagingSenderId,
            projectId: myConfig!.serverConfig!.dbConnInfo.projectId)); // for database
  }

  @override
  Future<Map<String, dynamic>> getData(String collectionId, String mid) async {
    CollectionReference collectionRef =
        FirebaseFirestore.instanceFor(app: AbsDatabase.fbDBApp!).collection(collectionId);

    DocumentSnapshot<Object?> result = await collectionRef.doc(mid).get();
    return result.data() as Map<String, dynamic>;
  }

  @override
  Future<List> getAllData(String collectionId) async {
    final List resultList = [];
    CollectionReference collectionRef =
        FirebaseFirestore.instanceFor(app: AbsDatabase.fbDBApp!).collection(collectionId);
    await collectionRef.get().then((snapshot) {
      for (var result in snapshot.docs) {
        resultList.add(result);
      }
    });
    return resultList;
  }

  @override
  Future<void> setData(String collectionId, String mid, Map<dynamic, dynamic> data) async {
    CollectionReference collectionRef =
        FirebaseFirestore.instanceFor(app: AbsDatabase.fbDBApp!).collection(collectionId);
    await collectionRef.doc(mid).set(data, SetOptions(merge: false));
    logger.finest('$mid saved');
  }

  @override
  Future<void> createData(String collectionId, String mid, Map<dynamic, dynamic> data) async {
    logger.finest('createData $mid!');
    CollectionReference collectionRef =
        FirebaseFirestore.instanceFor(app: AbsDatabase.fbDBApp!).collection(collectionId);
    await collectionRef.doc(mid).set(data, SetOptions(merge: false));
    //await collectionRef.add(data);
    logger.finest('$mid! created');
  }

  @override
  Future<List> simpleQueryData(String collectionId,
      {required String name,
      required String value,
      required String orderBy,
      bool descending = true,
      int? limit,
      int? offset}) async {
    final List resultList = [];
    CollectionReference collectionRef =
        FirebaseFirestore.instanceFor(app: AbsDatabase.fbDBApp!).collection(collectionId);
    await collectionRef
        .orderBy(orderBy, descending: true)
        .where(name, isEqualTo: value)
        .get()
        .then((snapshot) {
      for (var result in snapshot.docs) {
        resultList.add(result);
      }
    });
    return resultList;
  }

  @override
  Future<List> queryData(String collectionId,
      {required Map<String, dynamic> where,
      required String orderBy,
      bool descending = true,
      int? limit,
      int? offset,
      List<Object?>? startAfter}) async {
    CollectionReference collectionRef =
        FirebaseFirestore.instanceFor(app: AbsDatabase.fbDBApp!).collection(collectionId);
    Query<Object?> query = collectionRef.orderBy(orderBy, descending: true);
    where.map((mid, value) {
      query = query.where(mid, isEqualTo: value);
      return MapEntry(mid, value);
    });

    if (limit != null) query = query.limit(limit);
    if (startAfter != null && startAfter.isNotEmpty) query = query.startAfter(startAfter);

    return await query.get().then((snapshot) {
      return snapshot.docs.map((doc) {
        //logger.finest(doc.data()!.toString());
        return doc.data()! as Map<String, dynamic>;
      }).toList();
    });
  }

  @override
  Future<void> removeData(String collectionId, String mid) async {
    CollectionReference collectionRef =
        FirebaseFirestore.instanceFor(app: AbsDatabase.fbDBApp!).collection(collectionId);
    await collectionRef.doc(mid).delete();
    logger.finest('$mid deleted');

    //FirebaseFirestore.instanceFor(app: app)
  }
}
