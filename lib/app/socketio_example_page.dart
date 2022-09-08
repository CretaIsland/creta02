import 'package:flutter/material.dart';
import 'drawer_menu_widget.dart';

class SocketIOExamplePage extends StatefulWidget {
  final VoidCallback openDrawer;

  const SocketIOExamplePage({Key? key, required this.openDrawer}) : super(key: key);

  @override
  State<SocketIOExamplePage> createState() => _SocketIOExamplePageState();
}

class _SocketIOExamplePageState extends State<SocketIOExamplePage> {
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
        title: const Text('SocketIO Example'),
        leading: DrawerMenuWidget(
          onClicked: widget.openDrawer,
        ),
      ),
      body: Container(),
    );
  }
}
