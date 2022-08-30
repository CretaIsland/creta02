// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';

import '../../common/util/device_info.dart';
import '../../common/util/logger.dart';
import '../database/db_utils.dart';

abstract class AbsRealtime {
  //connection info
  static FirebaseApp? _fbRTApp; // firebase only RealTime connetion
  static FirebaseApp? get fbRTApp => _fbRTApp;
  @protected
  static void setFirebaseApp(FirebaseApp fb) => _fbRTApp = fb;

  String lastUpdateTime = DateTime.now().toString(); // used only firebase

  void initialize();
  void start();
  void stop();
  void clearListener();

  Future<bool> setDelta({
    required String directive,
    required String mid,
    required Map<String, dynamic>? delta,
  });

  @protected
  Map<String, void Function(String directive, String userId, Map<String, dynamic> dataModel)>
      listenerMap = {};
  void addListener(String collectionId,
      void Function(String directive, String userId, Map<String, dynamic> dataModel) listener) {
    listenerMap[collectionId] = listener;
  }

  @protected
  Map<String, dynamic> makeData({
    required String directive,
    required String mid,
    required Map<String, dynamic>? delta,
  }) {
    Map<String, dynamic> input = {};
    input['directive'] = directive;
    input['collectionId'] = DBUtils.collectionFromMid(mid);
    input['mid'] = mid; //'book=3ecb527f-4f5e-4350-8705-d5742781451b';
    input['userId'] = DBUtils.currentUserId;
    input['deviceId'] = DeviceInfo.deviceId;
    input['updateTime'] = DBUtils.dateTimeToDB(DateTime.now());
    input['delta'] = delta != null ? json.encode(delta) : '';

    return input;
  }

  @protected
  void processEvent(Map<String, dynamic> mapValue) {
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
  }
}
