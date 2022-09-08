// ignore_for_file: depend_on_referenced_packages
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../common/util/logger.dart';
import '../data_io/frame_manager.dart';
import '../hycop/absModel/abs_model.dart';
import '../hycop/hycop_factory.dart';
import '../model/frame_model.dart';
import 'acc/stickerview.dart';
import 'constants.dart';
import 'drawer_menu_widget.dart';

class RealTimeExamplePage extends StatefulWidget {
  final VoidCallback openDrawer;

  const RealTimeExamplePage({Key? key, required this.openDrawer}) : super(key: key);

  @override
  State<RealTimeExamplePage> createState() => _RealTimeExamplePageState();
}

class _RealTimeExamplePageState extends State<RealTimeExamplePage> {
  final Random random = Random();

  @override
  void initState() {
    super.initState();
    frameManagerHolder = FrameManager();
    HycopFactory.myRealtime!.addListener("creta_frame", frameManagerHolder!.realTimeCallback);
    HycopFactory.myRealtime!.start();
  }

  @override
  void dispose() {
    super.dispose();
    HycopFactory.myRealtime!.stop();
  }

  @override
  Widget build(BuildContext context) {
    //Size screenSize = MediaQuery.of(context).size;
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<FrameManager>.value(
          value: frameManagerHolder!,
        ),
      ],
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: insertItem,
          child: const Icon(Icons.add),
        ),
        appBar: AppBar(
          backgroundColor: Colors.orange,
          title: const Text('RealTime Example'),
          leading: DrawerMenuWidget(
            onClicked: widget.openDrawer,
          ),
        ),
        body: FutureBuilder<List<AbsModel>>(
          future: frameManagerHolder!.getAllListFromDB(),
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
              logger.finest("frame founded ${snapshot.data!.length}");
              // if (snapshot.data!.isEmpty) {
              //   return const Center(child: Text('no frame founded'));
              // }
              return Consumer<FrameManager>(builder: (context, frameManager, child) {
                return Center(child: createView());
              });
            }
            return Container();
          },
        ),
      ),
    );
  }

  void insertItem() async {
    int randomNumber = random.nextInt(1000);
    FrameModel frame = FrameModel.withName(
        '${sampleNameList[randomNumber % sampleNameList.length]}_$randomNumber');

    frame.hashTag.set('#$randomNumber tag...');

    await frameManagerHolder!.createToDB(frame);
    frameManagerHolder!.modelList.insert(0, frame);
    frameManagerHolder!.notify();
  }

  Widget createView() {
    return StickerView(
      // List of Stickers
      stickerList: [
        Sticker(
            id: "uniqueId_000",
            // child: Image.network(
            //     "https://images.unsplash.com/photo-1640113292801-785c4c678e1e?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=736&q=80"),
            child: Container(
              color: Colors.red,
              width: 200,
              height: 200,
              child: Image.asset(
                'assets/jisoo.png',
                // frameBuilder:
                //     (BuildContext context, Widget child, int? frame, bool wasSynchronouslyLoaded) {
                //   if (wasSynchronouslyLoaded) {
                //     return child;
                //   }
                //   return AnimatedOpacity(
                //     opacity: frame == null ? 0 : 1,
                //     duration: const Duration(seconds: 10),
                //     curve: Curves.easeOut,
                //     child: child,
                //   );
                // },
              ),
            )),
        Sticker(
          id: "uniqueId_222",
          isText: true,
          child: const Text("Hello"),
        ),
      ],
    );
  }
}
