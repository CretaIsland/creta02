// ignore_for_file: depend_on_referenced_packages, prefer_final_fields, must_be_immutable

import 'package:uuid/uuid.dart';
import 'package:equatable/equatable.dart';

//import '../common/util/logger.dart';
import '../common/undo/save_manager.dart';
import '../common/undo/undo.dart';
import '../common/util/config.dart';
import 'model_enums.dart';

String genMid(ModelType type) {
  String mid = '${type.name}=';
  mid += const Uuid().v4();
  return mid;
}

DateTime dateTimeFromDB(dynamic src) {
  if (myConfig!.serverType == ServerType.appwrite) {
    return DateTime.parse(src);
  }
  return src.toDate();
}

dynamic dateTimeToDB(DateTime src) {
  if (myConfig!.serverType == ServerType.appwrite) {
    return src.toString();
  }
  return src;
}

class AbsModel extends Equatable {
  bool autoSave = true;

  final ModelType type;
  late String _mid;
  String get mid => _mid;
  DateTime _updateTime = DateTime.now();
  DateTime get updateTime => _updateTime;

  late UndoAble<String> parentMid;
  late UndoAble<double> order;
  late UndoAble<String> hashTag;
  late UndoAble<bool> isRemoved;

  @override
  List<Object?> get props => [mid, type, parentMid, order, hashTag, isRemoved];

  AbsModel({required this.type, required String parent}) {
    _mid = genMid(type);
    parentMid = UndoAble<String>(parent, mid);
    order = UndoAble<double>(0, mid);
    hashTag = UndoAble<String>('', mid);
    isRemoved = UndoAble<bool>(false, mid);
  }

  void copyFrom(AbsModel src, {String? newMid, String? pMid}) {
    _mid = newMid ?? genMid(type);
    parentMid = UndoAble<String>(pMid ?? src.parentMid.value, mid);
    order = UndoAble<double>(src.order.value, mid);
    hashTag = UndoAble<String>(src.hashTag.value, mid);
    isRemoved = UndoAble<bool>(src.isRemoved.value, mid);
    autoSave = src.autoSave;
  }

  void copyTo(AbsModel target) {
    target.copyFrom(this, newMid: mid, pMid: parentMid.value);
  }

  void fromMap(Map<String, dynamic> map) {
    _mid = map["mid"];
    _updateTime = dateTimeFromDB(map["updateTime"]);
    parentMid.set(map["parentMid"] ?? '', save: false, noUndo: true);
    order.set(map["order"] ?? 0, save: false, noUndo: true);
    hashTag.set(map["hashTag"] ?? '', save: false, noUndo: true);
    isRemoved.set(map["isRemoved"] ?? false, save: false, noUndo: true);
  }

  Map<String, dynamic> toMap() {
    return {
      //"type": type.index,
      "mid": mid,
      "updateTime": dateTimeToDB(updateTime),
      "parentMid": parentMid.value,
      "order": order.value,
      "hashTag": hashTag.value,
      "isRemoved": isRemoved.value,
    };
  }

  bool isChanged(AbsModel other) => !(this == other);

  void save() {
    saveManagerHolder?.pushChanged(mid, 'save model');
  }

  void create() {
    saveManagerHolder!.pushCreated(this, 'create model');
  }
}
