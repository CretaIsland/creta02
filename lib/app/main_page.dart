// ignore_for_file: depend_on_referenced_packages

import 'package:creta02/hycop/database/db_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:routemaster/routemaster.dart';

import '../data_io/book_manager.dart';
import '../hycop/absModel/abs_model.dart';
import '../hycop/hycop_factory.dart';
import '../model/book_model.dart';
import '../common/util/logger.dart';
import 'navigation/routes.dart';

const String userId = 'b49@sqisoft.com';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String _bookModelStr = '';
  int counter = 0;
  @override
  void initState() {
    super.initState();
    bookManagerHolder = BookManager();
    HycopFactory.myRealtime!.addListener("creta_book", bookManagerHolder!.realTimeCallback);
    HycopFactory.myRealtime!.start();
  }

  @override
  void dispose() {
    super.dispose();
    HycopFactory.myRealtime!.stop();
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<BookManager>.value(
          value: bookManagerHolder!,
        ),
      ],
      child: Scaffold(
        body: FutureBuilder<List<AbsModel>>(
            future: bookManagerHolder!.getListFromDB(userId),
            builder: (context, AsyncSnapshot<List<AbsModel>> snapshot) {
              if (snapshot.hasError) {
                //error가 발생하게 될 경우 반환하게 되는 부분
                logger.severe("data fetch error");
                return const Center(child: Text('data fetch error'));
              }
              if (snapshot.hasData == false) {
                logger.severe("No data founded");
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.connectionState == ConnectionState.done) {
                logger.finest("book founded ${snapshot.data!.length}");
                // if (snapshot.data!.isEmpty) {
                //   return const Center(child: Text('no book founded'));
                // }
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        onPressed: () async {
                          //Navigator.of(context).pop();
                          Routemaster.of(context).push(AppRoutes.login);
                        },
                        child: const Text('logout')),
                    Center(child: Text(bookManagerHolder!.debugText())),
                    ElevatedButton(
                        onPressed: () async {
                          BookModel book = await bookManagerHolder!
                              .getFromDB(bookManagerHolder!.modelList.first.mid) as BookModel;
                          setState(() {
                            _bookModelStr = book.debugText();
                          });
                        },
                        child: const Text('get first data')),
                    Text(_bookModelStr),
                    ElevatedButton(
                        onPressed: () async {
                          if (bookManagerHolder!.modelList.isEmpty) {
                            BookModel book =
                                BookModel.withName('sample($counter)', DBUtils.currentUserId);
                            await bookManagerHolder!.createToDB(book);
                          } else {
                            BookModel book = BookModel();
                            book.copyFrom(bookManagerHolder!.modelList.first, newMid: book.mid);
                            book.name.set('(${counter++}) new created book', save: false);
                            await bookManagerHolder!.createToDB(book);
                          }
                          setState(() {});
                        },
                        child: const Text('create data')),
                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          BookModel book = bookManagerHolder!.modelList.first as BookModel;
                          book.name.set('change #${++counter}th book', save: false);
                          book.hashTag.set("#${counter}th Tag", save: false);
                          await bookManagerHolder!.setToDB(book);
                          setState(() {
                            _bookModelStr = '';
                          });
                        },
                        child: const Text('set data')),
                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          await bookManagerHolder!
                              .removeToDB(bookManagerHolder!.modelList.first.mid);
                          setState(() {});
                        },
                        child: const Text('remove data')),
                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          BookModel book = bookManagerHolder!.modelList.first as BookModel;
                          HycopFactory.myRealtime!.createExample(book.mid);
                        },
                        child: const Text('create delta sample')),
                  ],
                );
              }
              return Container();
            }),
      ),
    );
  }
}
