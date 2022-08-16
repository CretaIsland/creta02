import 'package:creta02/hycop/absModel/abs_model.dart';
import '../common/util/logger.dart';
import '../hycop/absModel/abs_manager.dart';
import '../model/book_model.dart';

BookManager? bookManagerHolder;

class BookManager extends AbsManager {
  BookManager() : super('creta_book');
  @override
  AbsModel newModel() => BookModel();

  @override
  void realTimeCallback(String directive, String userId, Map<String, dynamic> dataMap) {
    logger.finest('realTimeCallback invoker($directive, $userId)');
    if (directive == 'create') {
      BookModel book = BookModel();
      book.fromMap(dataMap);
      modelList.add(book);
      logger.finest('${book.mid} realtime added');
      notifyListeners();
    } else if (directive == 'set') {
      String mid = dataMap["mid"] ?? '';
      if (mid.isEmpty) {
        return;
      }
      for (AbsModel model in modelList) {
        if (model.mid == mid) {
          model.fromMap(dataMap);
          logger.finest('${model.mid} realtime changed');
          notifyListeners();
        }
      }
    } else if (directive == 'remove') {
      String mid = dataMap["mid"] ?? '';
      logger.finest('removed mid = $mid');
      if (mid.isEmpty) {
        return;
      }
      for (AbsModel model in modelList) {
        if (model.mid == mid) {
          modelList.remove(model);
          logger.finest('${model.mid} realtime removed');
          notifyListeners();
        }
      }
    }
  }
}
