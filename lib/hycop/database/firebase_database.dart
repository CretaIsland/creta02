// ignore_for_file: depend_on_referenced_packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import '../../common/util/logger.dart';
import '../../common/util/config.dart';
import 'abs_database.dart';

class FirebaseDatabase extends AbsDatabase {
  @override
  void initialize() async {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: myConfig!.serverConfig!.apiKey,
            appId: myConfig!.serverConfig!.appId,
            storageBucket: myConfig!.serverConfig!.storageBucket,
            messagingSenderId: myConfig!.serverConfig!.messagingSenderId,
            projectId: myConfig!.serverConfig!.projectId)); // for firebase
  }

  @override
  Future<Map<String, dynamic>> getData(String collectionId, String key) async {
    CollectionReference collectionRef = FirebaseFirestore.instance.collection(collectionId);

    DocumentSnapshot<Object?> result = await collectionRef.doc(key).get();
    return result.data() as Map<String, dynamic>;
  }

  @override
  Future<List> getAllData(String collectionId) async {
    final List resultList = [];
    CollectionReference collectionRef = FirebaseFirestore.instance.collection(collectionId);
    await collectionRef.get().then((snapshot) {
      for (var result in snapshot.docs) {
        resultList.add(result);
      }
    });
    return resultList;
  }

  @override
  Future<void> setData(String collectionId, String key, Map<dynamic, dynamic> data) async {
    CollectionReference collectionRef = FirebaseFirestore.instance.collection(collectionId);
    await collectionRef.doc(key).set(data, SetOptions(merge: false));
    logger.finest('$key saved');
  }

  @override
  Future<void> createData(String collectionId, String key, Map<dynamic, dynamic> data) async {
    logger.finest('createData $key!');
    CollectionReference collectionRef = FirebaseFirestore.instance.collection(collectionId);
    await collectionRef.doc(key).set(data, SetOptions(merge: false));
    //await collectionRef.add(data);
    logger.finest('$key! created');
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
    CollectionReference collectionRef = FirebaseFirestore.instance.collection(collectionId);
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
    CollectionReference collectionRef = FirebaseFirestore.instance.collection(collectionId);
    Query<Object?> query = collectionRef.orderBy(orderBy, descending: true);
    where.map((key, value) {
      query = query.where(key, isEqualTo: value);
      return MapEntry(key, value);
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
  Future<bool> removeData(String collectionId, String key) async {
    CollectionReference collectionRef = FirebaseFirestore.instance.collection(collectionId);
    await collectionRef.doc(key).delete();
    logger.finest('$key deleted');
    return true;
  }
}
