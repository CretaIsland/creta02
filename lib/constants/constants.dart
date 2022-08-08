const String nonePrefix = 'none=';
const String pagePrefix = 'page=';
const String accPrefix = 'acc=';
const String contentsPrefix = 'contents=';
const String bookPrefix = 'book=';

List<String> languages = [
  '한국어',
  'Deutsch (Deutschland)',
  'English (US)',
  'Español (España)',
  'Français (France)',
  'हिंदी',
  'Bahasa Indonesia',
  'Italiano',
  '日本語',
  'Nederlands',
  'Polski',
  'Português (Brasil)',
  'Русский',
  '中文 (中国大陆)',
  '中文 (台灣)',
];
List<String> langCodes = [
  'ko',
  'de',
  'en',
  'es',
  'fr',
  'hi',
  'id',
  'it',
  'ja',
  'nl',
  'pl',
  'pt',
  'ru',
  'zh-cn',
  'zh-tw',
];
List<String> ttsCodes = [
  'ko-KR',
  'de-DE',
  'en-US',
  'es-ES',
  'fr-FR',
  'hi-IN',
  'id-ID',
  'it-IT',
  'ja-JP',
  'nl-NL',
  'pl-PL',
  'pt-BR',
  'ru-RU',
  'zh-CN',
  'zh-TW',
];

Map<String, String> lang2CodeMap = {};
Map<String, String> code2LangMap = {};
Map<String, String> code2TTSMap = {};
void initLangMap() {
  lang2CodeMap.clear();
  code2LangMap.clear();
  code2TTSMap.clear();
  int len = languages.length;
  for (int i = 0; i < len; i++) {
    lang2CodeMap[languages[i]] = langCodes[i];
    code2LangMap[langCodes[i]] = languages[i];
    code2TTSMap[langCodes[i]] = ttsCodes[i];
  }
}
