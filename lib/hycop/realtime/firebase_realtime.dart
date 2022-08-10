// ignore_for_file: depend_on_referenced_packages
import 'package:creta02/common/util/device_info.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:uuid/uuid.dart';

import '../../common/util/config.dart';
import '../../common/util/logger.dart';
import 'abs_realtime.dart';

class FirebaseRealtime extends AbsRealtime {
  late DatabaseReference _db;

  @override
  void initialize() async {
    // 일반 reealTime DB 사용의 경우.
    AbsRealtime.setFirebaseApp(await Firebase.initializeApp(
        name: "realTime",
        options: FirebaseOptions(
            databaseURL: myConfig!.serverConfig!.rtConnInfo.databaseURL,
            apiKey: myConfig!.serverConfig!.rtConnInfo.apiKey,
            appId: myConfig!.serverConfig!.rtConnInfo.appId,
            storageBucket: myConfig!.serverConfig!.rtConnInfo.storageBucket,
            messagingSenderId: myConfig!.serverConfig!.rtConnInfo.messagingSenderId,
            projectId: myConfig!.serverConfig!.rtConnInfo.projectId)));
    _db = FirebaseDatabase.instanceFor(app: AbsRealtime.fbRTApp!).ref(); // for realtime
  }

  @override
  void listen() {}

  @override
  Future<bool> createExample(String mid) async {
    String key = const Uuid().v4();
    Map<String, dynamic> sampleData = {};
    sampleData['mid'] = mid; //'book=3ecb527f-4f5e-4350-8705-d5742781451b';
    sampleData['userId'] = 'b49@sqisoft.com';
    sampleData['deviceId'] = DeviceInfo.deviceId;
    sampleData['updateTime'] = DateTime.now().toString();
    sampleData['delta'] = '';

    try {
      await _db.child('creta_delta').child(key).set(sampleData);
      logger.finest("CRETA_DELTA sample data created");
      return true;
    } catch (e) {
      logger.severe("CRETA_DELTA SET DB ERROR : $e");
      return false;
    }
  }
}
