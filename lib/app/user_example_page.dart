import 'package:flutter/material.dart';
import 'drawer_menu_widget.dart';

class UserExamplePage extends StatefulWidget {
  final VoidCallback openDrawer;

  const UserExamplePage({Key? key, required this.openDrawer}) : super(key: key);

  @override
  State<UserExamplePage> createState() => _UserExamplePageState();
}

class _UserExamplePageState extends State<UserExamplePage> {
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
        title: const Text('User Example'),
        leading: DrawerMenuWidget(
          onClicked: widget.openDrawer,
        ),
      ),
      body: Container(),
    );
  }
}
