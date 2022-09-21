

import 'dart:typed_data';

import 'package:creta02/common/util/config.dart';
import 'package:creta02/common/util/exceptions.dart';
import 'package:creta02/hycop/absModel/model_enums.dart';
import 'package:creta02/hycop/storage/abs_storage.dart';
import 'package:creta02/hycop/storage/storage_utils.dart';
import 'package:creta02/model/file_model.dart';

// ignore: depend_on_referenced_packages
import 'package:appwrite/appwrite.dart';
// ignore: depend_on_referenced_packages
import 'package:dart_appwrite/dart_appwrite.dart' as aw_server;

class AppwriteStorage extends AbsStorage {

  late Storage _storage;
  late aw_server.Storage _serverStorage;



  @override
  void initialize() {
    AbsStorage.setAppwriteApp(Client()
      ..setEndpoint(myConfig!.serverConfig!.storageConnInfo.storageURL)
      ..setProject(myConfig!.serverConfig!.storageConnInfo.projectId)
      ..setSelfSigned(status: true)
    );
    _storage = Storage(AbsStorage.awStorageConn!);

    _serverStorage = aw_server.Storage(aw_server.Client()
      ..setEndpoint(myConfig!.serverConfig!.storageConnInfo.storageURL)
      ..setProject(myConfig!.serverConfig!.storageConnInfo.projectId)
      ..setKey(myConfig!.serverConfig!.storageConnInfo.apiKey)
    );

    setBucketId("userId");
  }

  @override
  Future<void> uploadFile(String fileName, String fileType, Uint8List fileBytes) async {
    await _storage.createFile(
      bucketId: myConfig!.serverConfig!.storageConnInfo.bucketId,
      fileId: StorageUtils.cidToKey(StorageUtils.genCid(ContentsType.getContentTypes(fileType))), 
      file: InputFile(filename: fileName, contentType: fileType, bytes: fileBytes)
    ).onError((error, stackTrace) => throw CretaException(message: stackTrace.toString()));
  }

  @override
  Future<Uint8List> downloadFile(String fileId) async {
    return await _storage.getFileDownload(
      bucketId: myConfig!.serverConfig!.storageConnInfo.bucketId, 
      fileId: fileId
    ).onError((error, stackTrace) => throw CretaException(message: stackTrace.toString()));
  }

  @override
  Future<void> deleteFile(String fileId) async {
    await _storage.deleteFile(
      bucketId: myConfig!.serverConfig!.storageConnInfo.bucketId, 
      fileId: fileId
    ).onError((error, stackTrace) => throw CretaException(message: stackTrace.toString()));
  }

  @override
  Future<FileModel> getFileInfo(String fileId) async {
    final res = await _storage.getFile(
      bucketId: myConfig!.serverConfig!.storageConnInfo.bucketId, 
      fileId: fileId
    ).onError((error, stackTrace) => throw CretaException(message: stackTrace.toString()));

    return FileModel(
      fileId: res.$id,//res["\$id"],
      fileName: res.name,//res["name"],
      fileView:  await _storage.getFileView(bucketId: myConfig!.serverConfig!.storageConnInfo.bucketId, fileId: res.$id/*res["\$id"]*/),
      fileMd5: res.signature,//res["signature"],
      fileSize: res.sizeOriginal,//res["sizeOriginal"],
      fileType: ContentsType.getContentTypes(res.mimeType/*res["mimeType"]*/)
    );
  }

  @override
  Future<List<FileModel>> getFileInfoList({String? search, int? limit, int? offset, String? cursor, String? cursorDirection = "after", String? orderType = "DESC"}) async {
    List<FileModel> fileInfoList = [];

    final res = await _storage.listFiles(
      bucketId: myConfig!.serverConfig!.storageConnInfo.bucketId,
      search: search,
      limit: limit,
      offset: offset,
      cursor: cursor,
      cursorDirection: cursorDirection,
      orderType: orderType
    );

    for(var element in res.files/*res['files']*/) {

      Uint8List fileData = await _storage.getFileView(bucketId: myConfig!.serverConfig!.storageConnInfo.bucketId, fileId: element.$id/*element["\$id"]*/);

      fileInfoList.add(FileModel(
        fileId: element.$id,//element['\$id'],
        fileName: element.name,//element['name'],
        fileView: fileData, 
        fileMd5: element.signature,//element['signature'],
        fileSize: element.sizeOriginal,//element['sizeOriginal'],
        fileType: ContentsType.getContentTypes(element.mimeType/*element['mimeType']*/))
      );
    }
    return fileInfoList;
  }

  @override
  Future<void> setBucketId(String userId) async {
    final res = await _serverStorage.listBuckets();

    for(var element in res.buckets) {
      if(element.name == userId) {
        myConfig!.serverConfig!.storageConnInfo.bucketId = element.$id;
        return ;
      }
    }

     _serverStorage.createBucket(
      bucketId: userId,
      name: userId,
      permission: 'bucket',
      read: ['role:member'],
      write: ['role:member']
    );

    myConfig!.serverConfig!.storageConnInfo.bucketId = userId;
    
  }










}