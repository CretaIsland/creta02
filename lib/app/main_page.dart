// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

import 'constants.dart';
import 'drawer_widget.dart';
import 'navigation/routes.dart';
import 'realtime_example_page.dart';
import 'database_example_page.dart';
import 'function_example_page.dart';
import 'storage_example_page.dart';
import 'socketio_example_page.dart';
import 'user_example_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int counter = 0;

  late double xOffset;
  late double yOffset;
  late double zOffset;
  late double scaleFactor;
  late bool isDrawerOpen;
  bool isDragging = false;
  DrawerItem item = DrawerItems.home;

  @override
  void initState() {
    super.initState();
    // bookManagerHolder = BookManager();
    // frameManagerHolder = FrameManager();
    // HycopFactory.myRealtime!.addListener("creta_book", bookManagerHolder!.realTimeCallback);
    // HycopFactory.myRealtime!.addListener("creta_frame", frameManagerHolder!.realTimeCallback);
    // HycopFactory.myRealtime!.start();
    closeDrawer();
  }

  void openDrawer() {
    setState(() {
      xOffset = 300;
      yOffset = 150;
      zOffset = 0.75;
      scaleFactor = 0.75;
      isDrawerOpen = true;
    });
  }

  void closeDrawer() {
    setState(() {
      xOffset = 0;
      yOffset = 0;
      zOffset = 0;
      scaleFactor = 1;
      isDrawerOpen = false;
    });
  }

  @override
  void dispose() {
    super.dispose();
    //HycopFactory.myRealtime!.stop();
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor,
        body: Stack(
          children: [
            DrawerWidget(
              onSelectedItem: (item) {
                setState(() {
                  switch (item) {
                    case DrawerItems.logout:
                      Routemaster.of(context).push(AppRoutes.login);
                      return;
                    case DrawerItems.home:
                      Routemaster.of(context).push(AppRoutes.intro);
                      return;
                    default:
                      this.item = item;
                      closeDrawer();
                  }
                });
              },
            ),
            buildPage(),
          ],
        ));
  }

  Widget buildPage() {
    return
        // GestureDetector(
        //   onTap: closeDrawer,
        //   onHorizontalDragStart: (details) {
        //     isDragging = true;
        //   },
        //   onHorizontalDragUpdate: (details) {
        //     if (!isDragging) return;
        //     const delta = 1;
        //     if (details.delta.dx > delta) {
        //       openDrawer();
        //     } else if (details.delta.dx < -delta) {
        //       closeDrawer();
        //     }
        //   },
        //   child:
        AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      transform: Matrix4.translationValues(xOffset, yOffset, zOffset)..scale(scaleFactor),
      child: AbsorbPointer(
        absorbing: isDrawerOpen,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(isDrawerOpen ? 20 : 0),
          child: Container(
            color: isDrawerOpen ? Colors.white12 : backgroundColor,
            child: getDrawerPage(),
          ),
        ),
      ),
    );
    //);
  }

  Widget getDrawerPage() {
    switch (item) {
      case DrawerItems.database:
        return DatabaseExamplePage(
          key: UniqueKey(),
          openDrawer: openDrawer,
        );
      case DrawerItems.realtime:
        return RealTimeExamplePage(
          key: UniqueKey(),
          openDrawer: openDrawer,
        );
      case DrawerItems.function:
        return FunctionExamplePage(
          key: UniqueKey(),
          openDrawer: openDrawer,
        );
      case DrawerItems.storage:
        return StorageExamplePage(
          key: UniqueKey(),
          openDrawer: openDrawer,
        );
      case DrawerItems.socket:
        return SocketIOExamplePage(
          key: UniqueKey(),
          openDrawer: openDrawer,
        );
      case DrawerItems.user:
        return UserExamplePage(
          key: UniqueKey(),
          openDrawer: openDrawer,
        );

      default:
        return DatabaseExamplePage(
          key: UniqueKey(),
          openDrawer: openDrawer,
        );
    }
  }

  //
  Widget buildOrg(BuildContext context) {
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
