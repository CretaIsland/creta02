import 'package:flutter/material.dart';
import '../common/util/exceptions.dart';
import '../common/util/logger.dart';
import '../model/book_model.dart';
import '../hycop/hycop_factory.dart';

BookManager? bookManagerHolder;

class BookManager extends ChangeNotifier {
  void notify() => notifyListeners();

  List<BookModel> bookList = [];

  String debugText() {
    String retval = '${bookList.length} founded\n';
    for (BookModel book in bookList) {
      retval += '${book.mid},UpdateTime=${book.updateTime}\n';
    }
    return retval;
  }

  Future<List<BookModel>> getMyBookList(String userId) async {
    bookList.clear();
    try {
      Map<String, dynamic> query = {};
      query['creator'] = userId;
      query['isRemoved'] = false;
      List resultList = await HycopFactory.myDataBase!.queryData(
        "creta_book",
        where: query,
        orderBy: 'updateTime',
        //limit: 2,
        //offset: 1, // appwrite only
        //startAfter: [DateTime.parse('2022-08-04 12:00:01.000')], //firebase only
      );
      return resultList.map((ele) {
        BookModel model = BookModel();
        model.fromMap(ele);
        bookList.add(model);
        return model;
      }).toList();
    } catch (e) {
      logger.severe('databaseError', e);
      throw CretaException(message: 'databaseError', exception: e as Exception);
    }
  }

  Future<BookModel> getBook(String mid) async {
    try {
      BookModel book = BookModel();
      book.fromMap(await HycopFactory.myDataBase!.getData('creta_book', mid));
      return book;
    } catch (e) {
      logger.severe('databaseError', e);
      throw CretaException(message: 'databaseError', exception: e as Exception);
    }
  }

  Future<void> createBook(BookModel book) async {
    await HycopFactory.myDataBase!.createData('creta_book', book.mid, book.toMap());
  }
}
