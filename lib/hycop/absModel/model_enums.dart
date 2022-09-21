//import 'dart:ui';

enum ModelType {
  none,
  book,
  page,
  frame,
  contents,
  end;

  static int validCheck(int val) => (val > end.index || val < none.index) ? none.index : val;
  static ModelType fromInt(int? val) => ModelType.values[validCheck(val ?? none.index)];
}

enum BookType {
  none,
  signage,
  presentaion,
  end;

  static int validCheck(int val) => (val > end.index || val < none.index) ? none.index : val;
  static BookType fromInt(int? val) => BookType.values[validCheck(val ?? none.index)];
}

enum ContentsType {
  none,
  video,
  image,
  text,
  youtube,
  effect,
  sticker,
  music,
  wheather,
  news,
  document,
  datasheet,
  pdf,
  threeD,
  web,
  octetstream,
  end;

  static int validCheck(int val) => (val > end.index || val < none.index) ? none.index : val;
  static ContentsType fromInt(int? val) => ContentsType.values[validCheck(val ?? none.index)];
  static getContentTypes(String contentType) {
    if(contentType.contains("image")) {
      return ContentsType.image;
    } else if (contentType.contains("video")) {
      return ContentsType.video;
    } else if (contentType.contains("audio")) {
      return ContentsType.music;
    } else if (contentType.contains("text")) {
      return ContentsType.text;
    } else if (contentType.contains("pdf")) {
      return ContentsType.pdf;
    } else {
      return ContentsType.octetstream;
    }
  }
}
