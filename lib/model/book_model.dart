// ignore_for_file: must_be_immutable

import '../common/util/logger.dart';
import '../common/undo/undo.dart';
import 'abs_model.dart';
import 'model_enums.dart';

// ignore: camel_case_types
class BookModel extends AbsModel {
  String creator = '';
  late UndoAble<String> name;
  late UndoAble<int> width;
  late UndoAble<int> height;
  late UndoAble<bool> isSilent;
  late UndoAble<bool> isAutoPlay;
  late UndoAble<BookType> bookType;
  late UndoAble<String> description;
  late UndoAble<bool> readOnly;
  late UndoAble<String> thumbnailUrl;
  late UndoAble<ContentsType> thumbnailType;
  late UndoAble<double> thumbnailAspectRatio;
  late UndoAble<int> viewCount;

  @override
  List<Object?> get props => [
        ...super.props,
        creator,
        name,
        width,
        height,
        isSilent,
        isAutoPlay,
        bookType,
        description,
        readOnly,
        thumbnailUrl,
        thumbnailType,
        thumbnailAspectRatio,
        viewCount
      ];
  BookModel() : super(type: ModelType.book, parent: '') {
    name = UndoAble<String>('', mid);
    thumbnailUrl = UndoAble<String>('', mid);
    thumbnailType = UndoAble<ContentsType>(ContentsType.none, mid);
    thumbnailAspectRatio = UndoAble<double>(1, mid);
    isSilent = UndoAble<bool>(false, mid);
    isAutoPlay = UndoAble<bool>(false, mid);
    bookType = UndoAble<BookType>(BookType.presentaion, mid);
    readOnly = UndoAble<bool>(false, mid);
    viewCount = UndoAble<int>(0, mid);
    description = UndoAble<String>("You could do it simple and plain", mid);
  }

  BookModel.withName(String nameStr, this.creator) : super(type: ModelType.book, parent: '') {
    name = UndoAble<String>(nameStr, mid);
    thumbnailUrl = UndoAble<String>('', mid);
    thumbnailType = UndoAble<ContentsType>(ContentsType.none, mid);
    thumbnailAspectRatio = UndoAble<double>(1, mid);
    isSilent = UndoAble<bool>(false, mid);
    isAutoPlay = UndoAble<bool>(false, mid);
    bookType = UndoAble<BookType>(BookType.presentaion, mid);
    readOnly = UndoAble<bool>(false, mid);
    viewCount = UndoAble<int>(0, mid);
    description = UndoAble<String>("You could do it simple and plain", mid);
  }
  @override
  void copyFrom(AbsModel src, {String? newMid, String? pMid}) {
    super.copyFrom(src, newMid: newMid, pMid: pMid);
    BookModel srcBook = src as BookModel;
    bookType.set(srcBook.bookType.value, save: false);
    isSilent.set(srcBook.isSilent.value, save: false);
    isAutoPlay.set(srcBook.isAutoPlay.value, save: false);
    readOnly.set(srcBook.readOnly.value, save: false);
    thumbnailUrl.set(srcBook.thumbnailUrl.value, save: false);
    thumbnailType.set(srcBook.thumbnailType.value, save: false);
    thumbnailAspectRatio.set(srcBook.thumbnailAspectRatio.value, save: false);
    viewCount.set(srcBook.viewCount.value, save: false);
    description.set(srcBook.description.value, save: false);
    logger.finest('BookCopied($mid)');
  }

  @override
  void fromMap(Map<String, dynamic> map) {
    super.fromMap(map);
    name.set(map["name"], save: false);
    creator = map["creator"];
    isSilent.set(map["isSilent"] ?? false, save: false);
    isAutoPlay.set(map["isAutoPlay"] ?? false, save: false);
    readOnly.set(map["readOnly"] ?? false, save: false);
    bookType.set(BookType.values[map["bookType"] ?? 0], save: false);
    description.set(map["description"], save: false);
    thumbnailUrl.set(map["thumbnailUrl"], save: false);
    thumbnailType.set(ContentsType.values[map["thumbnailType"] ?? 0], save: false);
    thumbnailAspectRatio.set((map["thumbnailAspectRatio"] ?? 1), save: false);
    viewCount.set((map["viewCount"] ?? 0), save: false, noUndo: true);
  }

  @override
  Map<String, dynamic> toMap() {
    return super.toMap()
      ..addEntries({
        "name": name.value,
        "creator": creator,
        "isSilent": isSilent.value,
        "isAutoPlay": isAutoPlay.value,
        "readOnly": readOnly.value,
        "bookType": bookType.value.index,
        "description": description.value,
        "thumbnailUrl": thumbnailUrl.value,
        "thumbnailType": thumbnailType.value.index,
        "thumbnailAspectRatio": thumbnailAspectRatio.value,
        "viewCount": viewCount.value,
      }.entries);
  }
}
