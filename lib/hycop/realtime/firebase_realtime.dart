// ignore_for_file: depend_on_referenced_packages
import 'package:firebase_core/firebase_core.dart';
import '../../common/util/config.dart';
import 'abs_realtime.dart';

class FirebaseRealtime extends AbsRealtime {
  @override
  void initialize() async {
    // 일반 reealTime DB 사용의 경우.
    AbsRealtime.fbRTConn = await Firebase.initializeApp(
        options: FirebaseOptions(
            databaseURL: myConfig!.serverConfig!.rtConnInfo.databaseURL,
            apiKey: myConfig!.serverConfig!.rtConnInfo.apiKey,
            appId: myConfig!.serverConfig!.rtConnInfo.appId,
            storageBucket: myConfig!.serverConfig!.rtConnInfo.storageBucket,
            messagingSenderId: myConfig!.serverConfig!.rtConnInfo.messagingSenderId,
            projectId: myConfig!.serverConfig!.rtConnInfo.projectId)); // for realtime
  }

  @override
  void listen() {}
}
