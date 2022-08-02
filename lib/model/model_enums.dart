//import 'dart:ui';

enum ModelType {
  none,
  book,
  page,
  acc,
  contents;
  //int typeToInt(ModelType type) => type.index; // if page, it return 2
  //ModelType intToType(int t) => ModelType.values[t]; // if 2,  it returns ModelType.page
  // String typeToString(ModelType type) => type.name; // if page, it returns 'page';
}

enum BookType {
  none,
  signage,
  presentaion,
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
}
