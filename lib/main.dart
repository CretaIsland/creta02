// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/creta_app.dart';
import 'common/util/device_info.dart';
import 'common/util/logger.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupLogger();
  DeviceInfo.init();
  // myConfig = CretaConfig(enterprise: 'skpark', serverType: ServerType.firebase);
  // HycopFactory.selectDatabase();
  // HycopFactory.selectRealTime();
  // HycopFactory.selectFunction();
  runApp(const ProviderScope(child: CretaApp()));
}
