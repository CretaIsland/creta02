// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

import '../data_io/book_manager.dart';
import '../hycop/hycop_factory.dart';
import 'navigation/routes.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
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
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('database and realTime example'),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
              onPressed: () async {
                //Navigator.of(context).pop();
                Routemaster.of(context).push(AppRoutes.login);
              },
              child: const Text('logout')),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
              onPressed: () async {
                Routemaster.of(context).push(AppRoutes.databaseExample);
              },
              child: const Text('database')),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
              onPressed: () async {
                Routemaster.of(context).push(AppRoutes.functionExample);
              },
              child: const Text('function')),
        ],
      ),
    ));
  }
}
