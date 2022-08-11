// ignore_for_file: depend_on_referenced_packages

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';

abstract class AbsRealtime {
  //connection info
  static FirebaseApp? _fbRTApp; // firebase only RealTime connetion
  static FirebaseApp? get fbRTApp => _fbRTApp;
  @protected
  static void setFirebaseApp(FirebaseApp fb) => _fbRTApp = fb;

  void initialize();
  void start();
  void stop();

  Future<bool> createExample(String mid);
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
}
