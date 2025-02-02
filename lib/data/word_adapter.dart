import 'package:hive/hive.dart';

import 'word_model.dart';

class WordAdapter extends TypeAdapter<Word> {
  @override
  final int typeId = 0;

  @override
  Word read(BinaryReader reader) {
    return Word(
      id: reader.readInt(),
      secondId: reader.readString(),
      level: reader.readInt(),
      subLevel: reader.readInt(),
      subIndex: reader.readInt(),
      word: reader.readString(),
      meaningSimple: reader.readString(),
      meaningDetail: reader.readString(),
      meaningEnglish: reader.readString(),
      part: reader.readString(),
      pronunciation: reader.readString(),
      pronunciationKatakana: reader.readString(),
      sentenceEng: reader.readString(),
      sentenceJpn: reader.readString(),
      frequency: reader.readInt(),
      tpo: reader.readString(),
      usageGuide: reader.readString(),
      etymology: reader.readString(),
      idiomSimple: reader.readString(),
      collocationSimple: reader.readString(),
      synonymsSimple: reader.readString(),
      idiomDetail: reader.readString(),
      collocationDetail: reader.readString(),
      synonymsDetail: reader.readString(),
      shortStoryEng: reader.readString(),
      shortStoryJpn: reader.readString(),
      pronunciationMp3: reader.readString(),
      sentenceMp3: reader.readString(),
      shortStoryMp3: reader.readString(),
      imgUrl: reader.readString(),
      isMemorized: reader.readBool(),
      isMemorizedMax: reader.readBool(),
      memorizedAt: reader.readInt(),
      memorizedCount: reader.readInt(),
      updateMemorizedAtCallCount: reader.readInt(),
      isFavorite: reader.readBool(),
      isMeanVisible: reader.readBool(),
    );
  }

  @override
  void write(BinaryWriter writer, Word obj) {
    writer
      ..writeInt(obj.id)
      ..writeString(obj.secondId)
      ..writeInt(obj.level)
      ..writeInt(obj.subLevel)
      ..writeInt(obj.subIndex)
      ..writeString(obj.word)
      ..writeString(obj.meaningSimple)
      ..writeString(obj.meaningDetail)
      ..writeString(obj.meaningEnglish)
      ..writeString(obj.part)
      ..writeString(obj.pronunciation)
      ..writeString(obj.pronunciationKatakana)
      ..writeString(obj.sentenceEng)
      ..writeString(obj.sentenceJpn)
      ..writeInt(obj.frequency)
      ..writeString(obj.tpo)
      ..writeString(obj.usageGuide)
      ..writeString(obj.etymology)
      ..writeString(obj.idiomSimple)
      ..writeString(obj.collocationSimple)
      ..writeString(obj.synonymsSimple)
      ..writeString(obj.idiomDetail)
      ..writeString(obj.collocationDetail)
      ..writeString(obj.synonymsDetail)
      ..writeString(obj.shortStoryEng)
      ..writeString(obj.shortStoryJpn)
      ..writeString(obj.pronunciationMp3)
      ..writeString(obj.sentenceMp3)
      ..writeString(obj.shortStoryMp3)
      ..writeString(obj.imgUrl)
      ..writeBool(obj.isMemorized)
      ..writeBool(obj.isMemorizedMax)
      ..writeInt(obj.memorizedAt)
      ..writeInt(obj.memorizedCount)
      ..writeInt(obj.updateMemorizedAtCallCount)
      ..writeBool(obj.isFavorite)
      ..writeBool(obj.isMeanVisible);
  }
}
