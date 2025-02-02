import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class Word extends HiveObject {
  @HiveField(0)
  final int id; // 単語の一意のID。

  @HiveField(1)
  final String secondId; // サブIDなどの補助的なID。

  @HiveField(2)
  final int level; // 単語のレベル。

  @HiveField(3)
  final int subLevel; // サブレベル。

  @HiveField(4)
  final int subIndex; // サブインデックス。

  @HiveField(5)
  String word; // 単語自体。

  @HiveField(6)
  String meaningSimple; // 簡単な意味。

  @HiveField(7)
  String meaningDetail; // 単語の詳細な意味。

  @HiveField(8)
  String meaningEnglish; // 単語の英語での意味。

  @HiveField(9)
  String part; // 品詞（名詞、動詞など）。

  @HiveField(10)
  String pronunciation; // 発音。

  @HiveField(11)
  String pronunciationKatakana; // 発音のカタカナ表記。

  @HiveField(12)
  String sentenceEng; // 単語を使った例文。

  @HiveField(13)
  String sentenceJpn; // 例文の日本語訳。

  @HiveField(14)
  int frequency; // 単語の使用頻度。

  @HiveField(15)
  String tpo; // 使用場面（Time, Place, Occasion）。

  @HiveField(16)
  String usageGuide; // 使用ガイド。

  @HiveField(17)
  String etymology; // 語源。

  @HiveField(18)
  String idiomSimple; // 慣用句。

  @HiveField(19)
  String collocationSimple; // コロケーション（よく一緒に使われる単語の組み合わせ）。

  @HiveField(20)
  String synonymsSimple; // 同義語。

  @HiveField(21)
  String idiomDetail; // 慣用句の詳細。

  @HiveField(22)
  String collocationDetail; // コロケーションの詳細。

  @HiveField(23)
  String synonymsDetail; // 同義語の詳細。

  @HiveField(24)
  String shortStoryEng; // 短いストーリー（英語）。

  @HiveField(25)
  String shortStoryJpn; // 短いストーリー（日本語）。

  @HiveField(26)
  final String pronunciationMp3; // 発音の音声ファイルのURL。

  @HiveField(27)
  final String sentenceMp3; // 例文の音声ファイルのURL。

  @HiveField(28)
  final String shortStoryMp3; // 例文の音声ファイルのURL。

  @HiveField(29)
  final String imgUrl; // 単語に関連する画像のURL。

  @HiveField(30)
  bool isMemorized; // 単語が暗記済みかどうか。

  @HiveField(31)
  bool isMemorizedMax; // 最大暗記数に達しているかどうか。

  @HiveField(32)
  int memorizedAt; // 暗記した日時。

  @HiveField(33)
  int memorizedCount; // 暗記した回数。

  @HiveField(34)
  int updateMemorizedAtCallCount; // 暗記情報の更新回数。

  @HiveField(35)
  bool isFavorite; // お気に入りかどうか。

  @HiveField(36)
  bool isMeanVisible; // 意味が表示されるかどうか。

  Word({
    required this.id,
    required this.secondId,
    required this.level,
    required this.subLevel,
    required this.subIndex,
    required this.word,
    required this.meaningSimple,
    required this.meaningDetail,
    required this.meaningEnglish,
    required this.part,
    required this.pronunciation,
    required this.pronunciationKatakana,
    required this.sentenceEng,
    required this.sentenceJpn,
    required this.frequency,
    required this.tpo,
    required this.usageGuide,
    required this.etymology,
    required this.idiomSimple,
    required this.collocationSimple,
    required this.synonymsSimple,
    required this.idiomDetail,
    required this.collocationDetail,
    required this.synonymsDetail,
    required this.shortStoryEng,
    required this.shortStoryJpn,
    required this.pronunciationMp3,
    required this.sentenceMp3,
    required this.shortStoryMp3,
    required this.imgUrl,
    required this.isMemorized,
    required this.isMemorizedMax,
    required this.memorizedAt,
    required this.memorizedCount,
    required this.updateMemorizedAtCallCount,
    required this.isFavorite,
    required this.isMeanVisible,
  });

  // v2.0.0で追加
  // fromJsonファクトリコンストラクタの追加
  factory Word.fromJson(Map<String, dynamic> json) {
    return Word(
      id: json['id'] ?? 0,
      secondId: json['secondId'] ?? 0,
      level: json['level'] ?? 0,
      subLevel: json['subLevel'] ?? 0,
      subIndex: json['subIndex'] ?? 0,
      word: json['word'] ?? '',
      meaningSimple: json['meaningSimple'] ?? '',
      meaningDetail: json['meaningDetail'] ?? '',
      meaningEnglish: json['meaningEnglish'] ?? '',
      part: json['part'] ?? '',
      pronunciation: json['pronunciation'] ?? '',
      pronunciationKatakana: json['pronunciationKatakana'] ?? '',
      sentenceEng: json['sentenceEng'] ?? '',
      sentenceJpn: json['sentenceJpn'] ?? '',
      frequency: json['frequency'] ?? 0,
      tpo: json['tpo'] ?? 0,
      usageGuide: json['usageGuide'] ?? '',
      etymology: json['etymology'] ?? '',
      idiomSimple: json['idiomSimple'] ?? '',
      collocationSimple: json['collocationSimple'] ?? '',
      synonymsSimple: json['synonymsSimple'] ?? '',
      idiomDetail: json['idiomDetail'] ?? '',
      collocationDetail: json['collocationDetail'] ?? '',
      synonymsDetail: json['synonymsDetail'] ?? '',
      shortStoryEng: json['shortStoryEng'] ?? '',
      shortStoryJpn: json['shortStoryJpn'] ?? '',
      pronunciationMp3: json['pronunciationMp3'] ?? '',
      sentenceMp3: json['sentenceMp3'] ?? '',
      shortStoryMp3: json['shortStoryMp3'] ?? '',
      imgUrl: json['imgUrl'] ?? '',
      isMemorized: json['isMemorized'] ?? false,
      isMemorizedMax: json['isMemorizedMax'] ?? false,
      memorizedAt: json['memorizedAt'] ?? 0,
      memorizedCount: json['memorizedCount'] ?? 0,
      updateMemorizedAtCallCount: json['updateMemorizedAtCallCount'] ?? 0,
      isFavorite: json['isFavorite'] ?? false,
      isMeanVisible: json['isMeanVisible'] ?? false,
    );
  }

  // toMapメソッドの追加（必要に応じて）
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'secondId': secondId,
      'level': level,
      'subLevel': subLevel,
      'subIndex': subIndex,
      'word': word,
      'meaningSimple': meaningSimple,
      'meaningDetail': meaningDetail,
      'meaningEnglish': meaningEnglish,
      'part': part,
      'pronunciation': pronunciation,
      'pronunciationKatakana': pronunciationKatakana,
      'sentenceEng': sentenceEng,
      'sentenceJpn': sentenceJpn,
      'frequency': frequency,
      'tpo': tpo,
      'usageGuide': usageGuide,
      'etymology': etymology,
      'idiomSimple': idiomSimple,
      'collocationSimple': collocationSimple,
      'synonymsSimple': synonymsSimple,
      'idiomDetail': idiomDetail,
      'collocationDetail': collocationDetail,
      'synonymsDetail': synonymsDetail,
      'shortStoryEng': shortStoryEng,
      'shortStoryJpn': shortStoryJpn,
      'pronunciationMp3': pronunciationMp3,
      'sentenceMp3': sentenceMp3,
      'shortStoryMp3': shortStoryMp3,
      'imgUrl': imgUrl,
      'isMemorized': isMemorized,
      'isMemorizedMax': isMemorizedMax,
      'memorizedAt': memorizedAt,
      'memorizedCount': memorizedCount,
      'updateMemorizedAtCallCount': updateMemorizedAtCallCount,
      'isFavorite': isFavorite,
      'isMeanVisible': isMeanVisible,
    };
  }
}
