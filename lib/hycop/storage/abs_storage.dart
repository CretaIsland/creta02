
// ignore: depend_on_referenced_packages
import 'dart:typed_data';

import 'package:creta02/model/file_model.dart';
// ignore: depend_on_referenced_packages
import 'package:firebase_core/firebase_core.dart';
// ignore: depend_on_referenced_packages
import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';


abstract class AbsStorage {


  static Client? _awStorageConn;
  static FirebaseApp? _fbStorageConn;

  static Client? get awStorageConn => _awStorageConn;
  static FirebaseApp? get fbStorageConn => _fbStorageConn;

  @protected
  static void setAppwriteApp(Client client) => _awStorageConn = client;
  static void setFirebaseApp(FirebaseApp firebaseApp) => _fbStorageConn = firebaseApp;



  void initialize();

  Future<void> uploadFile(String fileName, String fileType, Uint8List fileBytes);

  Future<Uint8List> downloadFile(String fileId);

  Future<void> deleteFile(String fileId);

  Future<FileModel> getFileInfo(String fileId);

  Future<List<FileModel>> getFileInfoList(
    {
      String? search,
      int? limit,
      int? offset,
      String? cursor,
      String? cursorDirection = "after",
      String? orderType = "DESC"
    }
  );

  Future<void> setBucketId(String userId);
   


}