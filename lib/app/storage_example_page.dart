import 'package:flutter/material.dart';
import 'drawer_menu_widget.dart';

class StorageExamplePage extends StatefulWidget {
  final VoidCallback openDrawer;

  const StorageExamplePage({Key? key, required this.openDrawer}) : super(key: key);

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
        backgroundColor: Colors.orange,
        title: const Text('Storage Example'),
        leading: DrawerMenuWidget(
          onClicked: widget.openDrawer,
        ),
      ),
      body: Container(),
    );
  }
}
