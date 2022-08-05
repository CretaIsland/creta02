// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'package:flutter/material.dart';

import 'logger.dart';

enum ServerType {
  none,
  firebase,
  appwrite;

  static ServerType fromString(String arg) {
    if (arg == 'firebase') return ServerType.firebase;
    if (arg == 'appwrite') return ServerType.appwrite;
    return ServerType.none;
  }
}

abstract class AbsServerConfig {
  final String enterprise;

  String apiKey = "";
  String authDomain = "";
  String databaseURL = ''; // appwrite endpoint
  String projectId = ""; // appwrite projectId
  String storageBucket = "";
  String messagingSenderId = "";
  String appId = ""; // appwrite databaseId

  AbsServerConfig(this.enterprise);
}

class FirebaseConfig extends AbsServerConfig {
  FirebaseConfig({String enterprise = 'creta'}) : super(enterprise) {
    if (enterprise == 'creta') {
      apiKey = "AIzaSyBe_K6-NX9-lzYNjQCPOFWbaOUubXqWVHg";
      authDomain = "creta01-ef955.firebaseapp.com";
      databaseURL = ''; // 일반 Database 에는 이상하게 이 값이 없다.
      projectId = "creta01-ef955";
      storageBucket = "creta01-ef955.appspot.com";
      messagingSenderId = "878607742856";
      appId = "1:878607742856:web:87e91c3185d1a79980ec3d";
    }
    if (enterprise == 'skpark') {
      apiKey = "AIzaSyBe_K6-NX9-lzYNjQCPOFWbaOUubXqWVHg";
      authDomain = "creta01-ef955.firebaseapp.com";
      databaseURL = ''; // 일반 Database 에는 이상하게 이 값이 없다.
      projectId = "creta01-ef955";
      storageBucket = "creta01-ef955.appspot.com";
      messagingSenderId = "878607742856";
      appId = "1:878607742856:web:87e91c3185d1a79980ec3d";
    }
  }
}

class AppwriteConfig extends AbsServerConfig {
  AppwriteConfig({String enterprise = 'creta'}) : super(enterprise) {
    if (enterprise == 'creta') {
      databaseURL = "http://localhost/v1"; // endPoint
      projectId = "62d79f0b36f4029ce40f";
      appId = "62d79f2e5fda513f4807"; // databaseId
    }
    if (enterprise == 'skpark') {
      databaseURL = "http://localhost/v1"; // endPoint
      projectId = "62d79f0b36f4029ce40f";
      appId = "62d79f2e5fda513f4807"; // databaseId
    }
  }
}

class AssetConfig {
  final String enterprise;
  AssetConfig({this.enterprise = 'creta'});

  int savePeriod = 1000;
  Future<void> loadAsset(BuildContext context) async {
    String jsonString = '';
    try {
      jsonString =
          await DefaultAssetBundle.of(context).loadString('assets/${enterprise}_config.json');
    } catch (e) {
      logger.info('assets/${enterprise}_config.json not exist, creta_config.json will be used');
      try {
        jsonString = await DefaultAssetBundle.of(context).loadString('assets/creta_config.json');
      } catch (e) {
        logger.severe('load assets/${enterprise}_config.json failed', e);
        return;
      }
    }
    final dynamic jsonMap = jsonDecode(jsonString);
    savePeriod = jsonMap['savePeriod'] ?? 1000;
  }
}

CretaConfig? myConfig;

class CretaConfig {
  final String enterprise;
  final ServerType serverType;
  late AssetConfig config;
  AbsServerConfig? serverConfig;

  CretaConfig({required this.enterprise, required this.serverType}) {
    config = AssetConfig(enterprise: enterprise);
    if (serverType == ServerType.firebase) {
      serverConfig = FirebaseConfig(enterprise: enterprise);
    } else if (serverType == ServerType.appwrite) {
      serverConfig = AppwriteConfig(enterprise: enterprise);
    }
  }
}
