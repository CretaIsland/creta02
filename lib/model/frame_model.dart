// ignore_for_file: must_be_immutable

import '../common/util/logger.dart';
import '../common/undo/undo.dart';
import '../hycop/absModel/abs_model.dart';
import '../hycop/absModel/model_enums.dart';

// ignore: camel_case_types
class FrameModel extends AbsModel {
  late UndoAble<String> name;
  late UndoAble<double> width;
  late UndoAble<double> height;
  late UndoAble<double> posX;
  late UndoAble<double> posY;
  late UndoAble<double> angle;

  @override
  List<Object?> get props => [...super.props, name, width, height, posX, posY, angle];
  FrameModel() : super(type: ModelType.frame, parent: '') {
    name = UndoAble<String>('', mid);
    width = UndoAble<double>(0, mid);
    height = UndoAble<double>(0, mid);
    posX = UndoAble<double>(0, mid);
    posY = UndoAble<double>(0, mid);
    angle = UndoAble<double>(0, mid);
  }

  FrameModel.withName(String nameStr) : super(type: ModelType.frame, parent: '') {
    name = UndoAble<String>(nameStr, mid);
    width = UndoAble<double>(200, mid);
    height = UndoAble<double>(200, mid);
    posX = UndoAble<double>(100, mid);
    posY = UndoAble<double>(100, mid);
    angle = UndoAble<double>(0, mid);
  }
  @override
  void copyFrom(AbsModel src, {String? newMid, String? pMid}) {
    super.copyFrom(src, newMid: newMid, pMid: pMid);
    FrameModel srcFrame = src as FrameModel;
    name = UndoAble<String>(srcFrame.name.value, mid);
    width = UndoAble<double>(srcFrame.width.value, mid);
    height = UndoAble<double>(srcFrame.height.value, mid);
    posX = UndoAble<double>(srcFrame.posX.value, mid);
    posY = UndoAble<double>(srcFrame.posY.value, mid);
    angle = UndoAble<double>(srcFrame.angle.value, mid);
    logger.finest('FrameCopied($mid)');
  }

  @override
  void fromMap(Map<String, dynamic> map) {
    super.fromMap(map);
    name.set(map["name"] ?? '', save: false, noUndo: true);
    width.set(map["width"] ?? 0, save: false, noUndo: true);
    height.set(map["height"] ?? 0, save: false, noUndo: true);
    posX.set(map["posX"] ?? false, save: false, noUndo: true);
    posY.set(map["posY"] ?? false, save: false, noUndo: true);
    angle.set((map["angle"] ?? 0), save: false, noUndo: true);
  }

  @override
  Map<String, dynamic> toMap() {
    return super.toMap()
      ..addEntries({
        "name": name.value,
        "width": width.value,
        "height": height.value,
        "posX": posX.value,
        "posY": posY.value,
        "angle": angle.value,
      }.entries);
  }
}
