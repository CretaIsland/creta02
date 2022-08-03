import 'package:flutter/material.dart';
import '../model/book_model.dart';
import '../hycop/hycop_factory.dart';

BookManager? bookManagerHolder;

class BookManager extends ChangeNotifier {
  List<BookModel> bookList = [];

  Future<int> getMyBookList(String userId) async {
    List resultList = await HycopFactory.myDataBase!
        .queryData("creta_book", name: 'userId', value: userId, orderBy: 'updateTime');
    bookList = resultList.map((ele) {
      BookModel model = BookModel();
      model.fromMap(ele);
      return model;
    }).toList();
    return bookList.length;
  }
}
