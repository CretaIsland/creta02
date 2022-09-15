// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';
import 'package:uuid/uuid.dart';

import '../common/util/logger.dart';
import '../common/widgets/widget_snippets.dart';
import '../hycop/hycop_factory.dart';
import 'drawer_menu_widget.dart';
import 'navigation/routes.dart';

class FunctionExamplePage extends StatefulWidget {
  final VoidCallback? openDrawer;

  const FunctionExamplePage({Key? key, this.openDrawer}) : super(key: key);

  @override
  State<FunctionExamplePage> createState() => _FunctionExamplePageState();
}

class _FunctionExamplePageState extends State<FunctionExamplePage> {
  String _setDBTestResult = '';
  String _getDBTestResult = '';
  String _removeDeltaResult = '';

  @override
  void initState() {
    super.initState();
    //HycopFactory.myFunction!.initialize();
    logger.finest('_FunctionExamplePageState initState()');
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String id = const Uuid().v4();

    return Scaffold(
        appBar: AppBar(
          actions: WidgetSnippets.hyAppBarActions(
            goHome: () {
              Routemaster.of(context).push(AppRoutes.intro);
            },
            goLogin: () {
              Routemaster.of(context).push(AppRoutes.login);
            },
          ),
          backgroundColor: Colors.orange,
          title: const Text('Function Example'),
          leading: DrawerMenuWidget(onClicked: () {
            if (widget.openDrawer != null) {
              widget.openDrawer!();
            } else {
              Routemaster.of(context).push(AppRoutes.main);
            }
          }),
        ),
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
                    _setDBTestResult = '';
                    try {
                      _setDBTestResult = await HycopFactory.myFunction!.execute(
                          functionId: "setDBTest", params: '{"text":"helloworld","id":"$id"}');
                    } catch (e) {
                      _setDBTestResult = 'setDBTest test failed $e';
                      logger.severe(_setDBTestResult);
                    }
                    setState(() {});
                  },
                  child: const Text('setDBTest')),
              Text(_setDBTestResult),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () async {
                    _getDBTestResult = '';
                    try {
                      _getDBTestResult = await HycopFactory.myFunction!
                          .execute(functionId: "getDBTest", params: '{"text":"helloworld"}');
                    } catch (e) {
                      _getDBTestResult = 'getDBTest test failed $e';
                      logger.severe(_getDBTestResult);
                    }
                    setState(() {});
                  },
                  child: const Text('getDBTest')),
              Text(_getDBTestResult),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () async {
                    _removeDeltaResult = '';
                    try {
                      _removeDeltaResult =
                          await HycopFactory.myFunction!.execute(functionId: "removeDelta");
                    } catch (e) {
                      _removeDeltaResult = 'removeDelta test failed $e';
                      logger.severe(_removeDeltaResult);
                    }
                    setState(() {});
                  },
                  child: const Text('removeDelta Test')),
              Text(_removeDeltaResult),
            ],
          ),
        ));
  }
}
