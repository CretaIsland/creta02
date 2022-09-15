// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';
import '../common/widgets/widget_snippets.dart';
import 'drawer_menu_widget.dart';
import 'navigation/routes.dart';

class StorageExamplePage extends StatefulWidget {
  final VoidCallback? openDrawer;

  const StorageExamplePage({Key? key, this.openDrawer}) : super(key: key);

  @override
  State<StorageExamplePage> createState() => _StorageExamplePageState();
}

class _StorageExamplePageState extends State<StorageExamplePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
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
        title: const Text('Storage Example'),
        leading: DrawerMenuWidget(onClicked: () {
          if (widget.openDrawer != null) {
            widget.openDrawer!();
          } else {
            Routemaster.of(context).push(AppRoutes.main);
          }
        }),
      ),
      body: Container(),
    );
  }
}
