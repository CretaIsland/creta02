// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data_io/book_manager.dart';
import '../model/book_model.dart';
import '../common/util/logger.dart';

const String userId = 'b49@sqisoft.com';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  void initState() {
    super.initState();
    bookManagerHolder = BookManager();
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
        body: FutureBuilder<List<BookModel>>(
            future: bookManagerHolder!.getMyBookList(userId),
            builder: (context, AsyncSnapshot<List<BookModel>> snapshot) {
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
                if (snapshot.data!.isEmpty) {
                  return const Center(child: Text('no book founded'));
                }
                return Center(child: Text(bookManagerHolder!.debugText()));
              }
              return Container();
            }),
      ),
    );
  }
}
