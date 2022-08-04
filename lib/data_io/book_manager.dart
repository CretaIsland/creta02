import 'package:flutter/material.dart';
import '../common/util/exceptions.dart';
import '../common/util/logger.dart';
import '../model/book_model.dart';
import '../hycop/hycop_factory.dart';

BookManager? bookManagerHolder;

class BookManager extends ChangeNotifier {
  List<BookModel> bookList = [];

  Future<List<BookModel>> getMyBookList(String userId) async {
    try {
      Map<String, dynamic> query = {};
      query['creator'] = userId;
      query['isRemoved'] = false;
      List resultList = await HycopFactory.myDataBase!
          .queryData("creta_book", where: query, orderBy: 'updateTime');
      return resultList.map((ele) {
        BookModel model = BookModel();
        model.fromMap(ele);
        return model;
      }).toList();
    } catch (e) {
      logger.severe('databaseError', e);
      throw CretaException(message: 'databaseError', exception: e as Exception);
    }
  }
}
