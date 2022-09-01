// ignore_for_file: depend_on_referenced_packages

import 'package:creta02/common/widgets/glass_box.dart';
import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

import '../common/util/config.dart';
import '../common/util/logger.dart';
import '../common/widgets/card_flip.dart';
import '../common/widgets/glowing_button.dart';
import '../common/widgets/text_field.dart';
import '../hycop/hycop_factory.dart';
import 'navigation/routes.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({Key? key}) : super(key: key);

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  ServerType _serverType = ServerType.firebase;
  final TextEditingController _enterpriseTextEditingController = TextEditingController();
  bool _isFlip = false;

  @override
  void dispose() {
    _enterpriseTextEditingController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (myConfig != null) {
      _serverType = myConfig!.serverType;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
          image: AssetImage('hycop_intro.jpg'),
          fit: BoxFit.cover,
        )),
        child: Center(
          child: TwinCardFlip(
            firstPage: firstPage(),
            secondPage: secondPage(),
            flip: _isFlip,
          ),
        ),
      ),
    );
  }

  Widget firstPage() {
    return GlassBox(
      width: 600,
      height: 600,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Choose your PAS Server',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 30,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            color: Colors.white.withOpacity(0.5),
            width: 480,
            child: Column(
              children: [
                RadioListTile(
                    title: Text(
                      "On Cloud Server(Firebase)",
                      style: TextStyle(
                        fontWeight:
                            _serverType == ServerType.firebase ? FontWeight.bold : FontWeight.w600,
                        fontSize: _serverType == ServerType.firebase ? 28 : 20,
                      ),
                    ),
                    value: ServerType.firebase,
                    groupValue: _serverType,
                    onChanged: (value) {
                      setState(() {
                        _serverType = value as ServerType;
                      });
                    }),
                RadioListTile(
                    title: Text(
                      "On Premiss Server(Appwrite)",
                      style: TextStyle(
                        fontWeight:
                            _serverType == ServerType.appwrite ? FontWeight.bold : FontWeight.w600,
                        fontSize: _serverType == ServerType.appwrite ? 28 : 20,
                      ),
                    ),
                    value: ServerType.appwrite,
                    groupValue: _serverType,
                    onChanged: (value) {
                      setState(() {
                        _serverType = value as ServerType;
                      });
                    }),
              ],
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          const Text(
            'Input your Enterprise ID',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 30,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            width: 400,
            child: NameTextField(
              controller: _enterpriseTextEditingController,
              hintText: "Demo",
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          GlowingButton(
            onPressed: () {
              setState(() {
                _isFlip = !_isFlip;
              });
            },
            text: 'Next',
          ),
        ],
      ),
    );
  }

  Widget secondPage() {
    return GlassBox(
      width: 600,
      height: 600,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Second Page',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 30,
            ),
          ),
          const SizedBox(
            height: 200,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GlowingButton(
                icon1: Icons.back_hand,
                icon2: Icons.back_hand_outlined,
                color1: Colors.amberAccent,
                color2: Colors.orangeAccent,
                onPressed: () {
                  setState(() {
                    _isFlip = !_isFlip;
                  });
                },
                text: 'Prev',
              ),
              const SizedBox(width: 20),
              GlowingButton(
                onPressed: () {
                  _gettingStarted();
                },
                text: 'Next',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _gettingStarted() async {
    logger.finest('_gettingStarted');

    String enterprise = _enterpriseTextEditingController.text;
    if (enterprise.isEmpty) {
      enterprise = 'Demo';
    }
    myConfig = CretaConfig(enterprise: enterprise, serverType: _serverType);
    HycopFactory.selectDatabase();
    HycopFactory.selectRealTime();
    HycopFactory.selectFunction();

    Routemaster.of(context).push(AppRoutes.login);
  }
}
