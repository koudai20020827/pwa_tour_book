import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:pwa_tour_book/data/word_model.dart';

Future<List<Word>> loadWordsFromJson() async {
  try {
    // JSONファイルの読み込み
    String data = await rootBundle.loadString('assets/json/words.json');

    // JSONデータのパース
    Map<String, dynamic> jsonMap = jsonDecode(data);
    if (jsonMap.containsKey('words') && jsonMap['words'] is List) {
      List<dynamic> jsonList = jsonMap['words'];

      // Wordオブジェクトに変換
      List<Word> words = jsonList.map((json) {
        if (json is Map<String, dynamic>) {
          return Word.fromJson(json);
        } else {
          throw const FormatException('Invalid JSON format for word entry.');
        }
      }).toList();

      return words;
    } else {
      throw const FormatException(
          'Invalid JSON structure. "words" key not found or is not a list.');
    }
  } catch (e) {
    print('Error loading words from JSON: $e');
    return [];
  }
}

Future<List<Word>> loadWordsFromJsonMigrate(String path) async {
  try {
    // JSONファイルの読み込み
    String data = await rootBundle.loadString('assets/json/' + path + '.json');

    // JSONデータのパース
    Map<String, dynamic> jsonMap = jsonDecode(data);
    if (jsonMap.containsKey('words') && jsonMap['words'] is List) {
      List<dynamic> jsonList = jsonMap['words'];

      // Wordオブジェクトに変換
      List<Word> words = jsonList.map((json) {
        if (json is Map<String, dynamic>) {
          return Word.fromJson(json);
        } else {
          throw const FormatException('Invalid JSON format for word entry.');
        }
      }).toList();

      return words;
    } else {
      throw const FormatException(
          'Invalid JSON structure. "words" key not found or is not a list.');
    }
  } catch (e) {
    print('[ERROR] Error loading words from JSON: $e');
    return [];
  }
}
