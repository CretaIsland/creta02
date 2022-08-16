// ignore_for_file: depend_on_referenced_packages
import 'dart:async';
import 'dart:convert';
import 'package:creta02/common/util/device_info.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:uuid/uuid.dart';

import '../../common/util/config.dart';
import '../../common/util/logger.dart';
import '../database/db_utils.dart';
import 'abs_realtime.dart';

class FirebaseRealtime extends AbsRealtime {
  late DatabaseReference _db;
  StreamSubscription<DatabaseEvent>? _deltaStream;
  String lastUpdateTime = DateTime.now().toString();
  bool isListenComplete = true;
  Timer? _listenTimer;

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
    logger.finest('realTime initialized');
    _db = FirebaseDatabase.instanceFor(app: AbsRealtime.fbRTApp!).ref();

    // for realtime
  }

  @override
  void start() {
    _listenTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (isListenComplete) {
        isListenComplete = false;
        logger.finest('listener restart');
        _deltaStream?.cancel();
        _deltaStream = _db
            .child('creta_delta')
            .orderByChild('updateTime')
            .startAfter(lastUpdateTime)
            .onValue
            .listen((event) => _listenCallback(event, ''));
      }
    });
  }

  void _listenCallback(DatabaseEvent event, String hint) {
    if (event.snapshot.value == null) {
      return;
    }
    DateTime now = DateTime.now();
    final rows = event.snapshot.value as Map<String, dynamic>;

    logger.finest('[$hint Listen]------------------------------');
    rows.forEach((mapKey, mapValue) {
      lastUpdateTime = mapValue["updateTime"] ?? '';

      String deviceId = mapValue["deviceId"] ?? '';
      if (deviceId == DeviceInfo.deviceId) {
        return;
      }
      String directive = mapValue["directive"] ?? '';
      // = mapValue["mid"] ?? '';
      String collectionId = mapValue["collectionId"] ?? '';
      String userId = mapValue["userId"] ?? '';
      String delta = mapValue["delta"] ?? '';
      logger.finest('$lastUpdateTime,$directive,$collectionId,$userId');

      Map<String, dynamic> dataMap = json.decode(delta) as Map<String, dynamic>;
      listenerMap[collectionId]?.call(directive, userId, dataMap);
    });
    logger.finest('[$hint end ${now.toString()}]-------------------------------------');
    isListenComplete = true;
  }

  @override
  void stop() {
    _deltaStream?.cancel();
    _listenTimer?.cancel();
  }

  @override
  Future<bool> createExample(String mid) async {
    String key = const Uuid().v4();
    Map<String, dynamic> sampleData = {};
    sampleData['directive'] = 'set';
    sampleData['mid'] = mid; //'book=3ecb527f-4f5e-4350-8705-d5742781451b';
    sampleData['userId'] = 'b49@sqisoft.com';
    sampleData['deviceId'] = DeviceInfo.deviceId;
    sampleData['updateTime'] = DateTime.now().toString();
    sampleData['delta'] = '';

    try {
      await _db.child('creta_delta').child(key).set(sampleData);
      logger.finest("CRETA_DELTA data created");
      return true;
    } catch (e) {
      logger.severe("CRETA_DELTA SET DB ERROR : $e");
      return false;
    }
  }

  @override
  Future<bool> setDelta({
    required String directive,
    required String mid,
    required Map<String, dynamic>? delta,
  }) async {
    Map<String, dynamic> input = {};
    input['directive'] = directive;
    input['collectionId'] = DBUtils.collectionFromMid(mid);
    input['mid'] = mid; //'book=3ecb527f-4f5e-4350-8705-d5742781451b';
    input['userId'] = DBUtils.currentUserId;
    input['deviceId'] = DeviceInfo.deviceId;
    input['updateTime'] = DateTime.now().toString();
    input['delta'] = delta != null ? json.encode(delta) : '';

    logger.finest('setDelta = ${input.toString()}');

    try {
      await _db.child('creta_delta').child(mid).set(input);
      logger.finest("CRETA_DELTA sample data created");
      return true;
    } catch (e) {
      logger.severe("CRETA_DELTA SET DB ERROR : $e");
      return false;
    }
  }
}
