// ignore_for_file: depend_on_referenced_packages

import 'package:firebase_core/firebase_core.dart';

abstract class AbsRealtime {
  //connection info
  static FirebaseApp? fbRTConn; // firebase only RealTime connetion

  void initialize();
  void listen();
}
