import 'package:flutter/material.dart';
import '../../common/util/exceptions.dart';
import '../../common/util/logger.dart';
import '../absModel/abs_model.dart';
import '../hycop_factory.dart';

abstract class AbsManager extends ChangeNotifier {
  @protected
  final String collectionId;
  AbsManager(this.collectionId);

  AbsModel newModel();
  void realTimeCallback(String directive, String userId, Map<String, dynamic> dataMap);

  void notify() => notifyListeners();

  List<AbsModel> modelList = [];

  String debugText() {
    String retval = '${modelList.length} $collectionId founded\n';
    for (AbsModel model in modelList) {
      if (model.isRemoved.value == false) {
        retval +=
            '${model.mid.substring(0, 15)}...,time=${model.updateTime},tag=${model.hashTag.value}\n';
      }
    }
    return retval;
  }

  Future<List<AbsModel>> getListFromDB(String userId) async {
    modelList.clear();
    try {
      Map<String, dynamic> query = {};
      query['creator'] = userId;
      query['isRemoved'] = false;
      List resultList = await HycopFactory.myDataBase!.queryData(
        collectionId,
        where: query,
        orderBy: 'updateTime',
        //limit: 2,
        //offset: 1, // appwrite only
        //startAfter: [DateTime.parse('2022-08-04 12:00:01.000')], //firebase only
      );
      return resultList.map((ele) {
        AbsModel model = newModel();
        model.fromMap(ele);
        modelList.add(model);
        return model;
      }).toList();
    } catch (e) {
      logger.severe('databaseError', e);
      throw CretaException(message: 'databaseError', exception: e as Exception);
    }
  }

  Future<AbsModel> getFromDB(String mid) async {
    try {
      AbsModel model = newModel();
      model.fromMap(await HycopFactory.myDataBase!.getData(collectionId, mid));
      return model;
    } catch (e) {
      logger.severe('databaseError', e);
      throw CretaException(message: 'databaseError', exception: e as Exception);
    }
  }

  Future<List<AbsModel>> getAllListFromDB() async {
    modelList.clear();
    try {
      Map<String, dynamic> query = {};
      query['isRemoved'] = false;
      List resultList = await HycopFactory.myDataBase!.queryData(
        collectionId,
        where: query,
        orderBy: 'updateTime',
        //limit: 2,
        //offset: 1, // appwrite only
        //startAfter: [DateTime.parse('2022-08-04 12:00:01.000')], //firebase only
      );
      return resultList.map((ele) {
        AbsModel model = newModel();
        model.fromMap(ele);
        modelList.add(model);
        return model;
      }).toList();
    } catch (e) {
      logger.severe('databaseError', e);
      throw CretaException(message: 'databaseError', exception: e as Exception);
    }
  }

  Future<void> createToDB(AbsModel model) async {
    try {
      //await HycopFactory.myDataBase!.createData(collectionId, model.mid, model.toMap());
      await HycopFactory.myDataBase!.createModel(collectionId, model);
    } catch (e) {
      logger.severe('databaseError', e);
      throw CretaException(message: 'databaseError', exception: e as Exception);
    }
  }

  Future<void> setToDB(AbsModel model) async {
    try {
      //await HycopFactory.myDataBase!.setData(collectionId, model.mid, model.toMap());
      await HycopFactory.myDataBase!.setModel(collectionId, model);
    } catch (e) {
      logger.severe('databaseError', e);
      throw CretaException(message: 'databaseError', exception: e as Exception);
    }
  }

  Future<void> removeToDB(String mid) async {
    try {
      //await HycopFactory.myDataBase!.removeData(collectionId, mid);
      await HycopFactory.myDataBase!.removeModel(collectionId, mid);
    } catch (e) {
      logger.severe('databaseError', e);
      throw CretaException(message: 'databaseError', exception: e as Exception);
    }
  }
}
