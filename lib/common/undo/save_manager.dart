// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
import 'dart:collection';
import 'package:flutter/foundation.dart';
import 'package:synchronized/synchronized.dart';

import '../../hycop/absModel/abs_model.dart';
import '../util/config.dart';
import '../util/logger.dart';

SaveManager? saveManagerHolder;

//자동 저장 , 변경이 있을 때 마다 저장되게 된다.
class SaveManager extends ChangeNotifier {
  final Lock _datalock = Lock();
  final Lock _dataCreatedlock = Lock();

  final Queue<String> _dataChangedQue = Queue<String>();
  final Queue<AbsModel> _dataCreatedQue = Queue<AbsModel>();

  Timer? _saveTimer;

  void stopTimer() {
    _saveTimer?.cancel();
    _saveTimer = null;
  }

  // void shouldBookSave(String mid) {
  //   if (mid.substring(0, 5) != 'Book=') {
  //     // book 이 아닌 다른 Row 가 save 된 것인데, 마지막에 Book 의 updateTime 을 한번 바뀌어 줘야 한다.
  //     if (bookManagerHolder!.defaultBook != null) {
  //       bookManagerHolder!.defaultBook!.updateTime = DateTime.now();
  //       _dataChangedQue.add(bookManagerHolder!.defaultBook!.mid);
  //     }
  //   }
  // }

  Future<void> pushChanged(String mid, String hint, {bool dontChangeBookTime = false}) async {
    await _datalock.synchronized(() async {
      if (!_dataChangedQue.contains(mid)) {
        logger.finest('changed:$mid, via $hint');
        _dataChangedQue.add(mid);
        notifyListeners();
        if (dontChangeBookTime == false) {
          //shouldBookSave(mid);
        }
      }
    });
  }

  Future<void> pushCreated(AbsModel model, String hint) async {
    await _dataCreatedlock.synchronized(() async {
      logger.finest('created:${model.mid}, via $hint');
      _dataCreatedQue.add(model);
      notifyListeners();
      //shouldBookSave(model.mid);
    });
  }

  Future<void> runSaveTimer() async {
    _saveTimer = Timer.periodic(Duration(seconds: myConfig!.config.savePeriod), (timer) async {
      await _datalock.synchronized(() async {
        if (_dataChangedQue.isNotEmpty) {
          while (_dataChangedQue.isNotEmpty) {
            final mid = _dataChangedQue.first;
            // Save here !!!!
            logger.finest('$mid saved');
            _dataChangedQue.removeFirst();
          }
          notifyListeners();
          //logHolder.log('autoSave------------end', level: 5);
        }
      });
      await _dataCreatedlock.synchronized(() async {
        if (_dataCreatedQue.isNotEmpty) {
          logger.finest('autoSaveCreated------------start(${_dataCreatedQue.length})');
          while (_dataCreatedQue.isNotEmpty) {
            final model = _dataCreatedQue.first;
            // Save here !!!!
            logger.finest('${model.mid} saved');
            _dataCreatedQue.removeFirst();
          }
          notifyListeners();
          logger.finest('autoSaveCreated------------end');
        }
      });
    });
  }
}
