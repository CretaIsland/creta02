// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'common/util/config.dart';
import 'app/creta_app.dart';
import 'common/util/logger.dart';
import 'hycop/hycop_factory.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupLogger();
  myConfig = CretaConfig(enterprise: 'skpark', serverType: ServerType.firebase);
  HycopFactory.selectDatabase();
  runApp(const ProviderScope(child: CretaApp()));
}
