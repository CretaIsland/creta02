// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'navigation/routes.dart';
import 'package:routemaster/routemaster.dart';
import '../common/util/config.dart';

class CretaApp extends ConsumerStatefulWidget {
  const CretaApp({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CretaAppState();
}

class _CretaAppState extends ConsumerState<CretaApp> {
  @override
  Widget build(BuildContext context) {
    myConfig?.config.loadAsset(context);
    return MaterialApp.router(
      routerDelegate: RoutemasterDelegate(routesBuilder: (context) {
        return routesLoggedOut;
      }),
      routeInformationParser: const RoutemasterParser(),
    );
  }
}
