// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

import '../common/util/logger.dart';
import '../hycop/hycop_factory.dart';
import 'navigation/routes.dart';

class FunctionExamplePage extends StatefulWidget {
  const FunctionExamplePage({Key? key}) : super(key: key);

  @override
  State<FunctionExamplePage> createState() => _FunctionExamplePageState();
}

class _FunctionExamplePageState extends State<FunctionExamplePage> {
  String _test2Result = '';

  @override
  void initState() {
    super.initState();
    HycopFactory.myFunction!.initialize();
  }

  @override
  void dispose() {
    super.dispose();
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
                try {
                  _test2Result = await HycopFactory.myFunction!.execute(functionId: "test2");
                } catch (e) {
                  _test2Result = 'test2 test failed $e';
                  logger.severe(_test2Result);
                }
                setState(() {});
              },
              child: const Text('test2')),
          Text(_test2Result),
        ],
      ),
    ));
  }
}
