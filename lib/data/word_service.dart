import 'package:hive_flutter/hive_flutter.dart';
import 'package:audio2/data/word_model.dart';
import 'package:audio2/data/word_adapter.dart';
import 'package:audio2/data/json_parse.dart';
import 'package:shared_preferences/shared_preferences.dart';

// 取得系
class DatabaseService {
  bool isInitialized = false; // 初期化済みかどうかを示すフラグß

  late Box<Word> _wordsBox;
  late Box<Word> _backupBox;

  // ゲッターを追加
  Box<Word> get wordsBox => _wordsBox;

  // 現在のアプリバージョンを動的に取得
  Future<String> get currentAppVersion async {
    return '1.0.0'; // 現在のバージョンを設定
  }

  Future<void> initDatabase() async {
    print('<START> initDatabase: Hive initialized');
    // Hive使用可能状態にするだけ
    await Hive.initFlutter();
    print("[INFO] Hive - registeringAdaptor...");
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(WordAdapter());
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    isInitialized = prefs.getBool('isHiveInitialized') ?? false;

    if (!isInitialized) {
      // 必ずawaitで初期化を待つ
      _wordsBox = await Hive.openBox<Word>('words');
      _backupBox = await Hive.openBox<Word>('backupWords');

      // 初期化成功フラグONに変更
      await prefs.setBool('isHiveInitialized', true);
      print('<END> initDatabase: Hive initialized');
    } else {
      // 再起動時のケース
      await ensureWordsBoxIsOpen();
      print('<END2> Hiveは既に初期化済みです。');
    }
  }

  Future<void> ensureWordsBoxIsOpen() async {
    print('[DEBUG] ensureWordsBoxIsOpen: 開始');
    try {
      if (!Hive.isBoxOpen('words')) {
        print('[DEBUG] wordsボックスをオープンします');
        _wordsBox = await Hive.openBox<Word>('words');
        print('[INFO] wordsボックスをオープンしました。');
      } else {
        print('[DEBUG] wordsボックスは既にオープンされています');
        _wordsBox = Hive.box<Word>('words'); // オープン済みのボックスを取得
        print('[INFO] wordsボックスは既にオープンされています。');
      }
    } catch (e) {
      print('[ERROR] ensureWordsBoxIsOpenでエラー: $e');
    }
    print('[DEBUG] ensureWordsBoxIsOpen: 終了');
  }

  Future<void> ensureBackupBoxIsOpen() async {
    print('[DEBUG] ensureBackupBoxIsOpen: 開始');
    try {
      if (!Hive.isBoxOpen('backupWords')) {
        print('[DEBUG] backupWordsボックスをオープンします');
        _backupBox = await Hive.openBox<Word>('backupWords');
        print('[INFO] backupWordsボックスをオープンしました。');
      } else {
        print('[DEBUG] backupWordsボックスは既にオープンされています');
        _backupBox = Hive.box<Word>('backupWords'); // オープン済みのボックスを取得
      }
    } catch (e) {
      print('[ERROR] ensureBackupBoxIsOpenでエラー: $e');
    }
    print('[DEBUG] ensureBackupBoxIsOpen: 終了');
  }

  // migration
  Map<String, Future<void> Function()> get migrationSteps => {
        '1.0.0_to_1.1.0': _migrateFrom1_0_0To1_1_0,
        // '1.1.0_to_1.2.0': _migrateFrom1_1_0To1_2_0,

        // 他のマイグレーションステップもここに追加
      };

  Future<void> _migrateFrom1_0_0To1_1_0() async {
    await migrateData('words_1_1_0');
  }

  // checkAndMigrateメソッド
  Future<void> checkAndMigrate() async {
    print('<START> checkAndMigrate');
    try {
      // バージョン情報用ボックスを開く
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String savedAppVersion = prefs.getString('savedAppVersion') ?? '1.0.0';
      String appVersion = await currentAppVersion;

      // バージョンが同じ場合、何もしない
      if (savedAppVersion == appVersion) {
        print('[INFO] アプリのバージョンは変更されていません。スキップします。');
        print('<END> checkAndMigrate');
        return;
      }

      // ダウングレードになっていないかチェック
      if (compareVersions(savedAppVersion, appVersion) > 0) {
        print(
            '[WARN] ダウングレードはサポートされていません。from: $savedAppVersion, to: $appVersion');
        print('<END> checkAndMigrate');
        return;
      }

      await _migrate(savedAppVersion, appVersion);
      await prefs.setString('savedAppVersion', appVersion);
      print('[INFO] バージョンを $savedAppVersion から $appVersion に更新しました。');
      print('<END2> checkAndMigrate');
    } catch (e, stackTrace) {
      // エラーが発生してもアプリを継続可能にする
      print('[WARN] マイグレーション中にエラーが発生しました: $e');
      print('[WARN] スタックトレース: $stackTrace');
    }
  }

  /// マイグレーション処理を行うメソッド
  Future<void> _migrate(String from, String to) async {
    List<String> versionOrder = ['1.0.0', '1.1.0']; // 必要に応じて追加

    int fromIndex = versionOrder.indexOf(from);
    int toIndex = versionOrder.indexOf(to);

    if (fromIndex == -1 || toIndex == -1) {
      print('[ERROR] 未対応のバージョンが検出されました: from=$from, to=$to');
      return; // 未対応バージョンの場合、エラーをスローせずスキップ
    }

    print('[INFO] マイグレーション処理を開始します。from: $from, to: $to');
    for (int i = fromIndex; i < toIndex; i++) {
      String migrationKey = '${versionOrder[i]}_to_${versionOrder[i + 1]}';
      if (migrationSteps.containsKey(migrationKey)) {
        try {
          print('[INFO] マイグレーション $migrationKey を実行します。');
          await migrationSteps[migrationKey]!();
        } catch (e, stackTrace) {
          // マイグレーションステップのエラーをキャッチし、ログに記録
          print('[ERROR] マイグレーションエラー: $migrationKey: $e');
          print('[ERROR] スタックトレース: $stackTrace');
          break; // エラー発生時は以降のマイグレーションを中断
        }
      } else {
        print('[SKIPPED] 未対応のマイグレーションステップ: $migrationKey');
        break; // 未定義のマイグレーションがある場合も中断
      }
    }
  }

  /// バージョン間のマイグレーション処理を共通化
  Future<void> migrateData(String jsonFileName) async {
    try {
      ensureBackupBoxIsOpen();
      await _backupData(); // マイグレーション前にバックアップ

      // JSONからデータをロード
      List<Word> jsonWords = await loadWordsFromJsonMigrate(jsonFileName);
      if (jsonWords.isEmpty) {
        print('[WARN] JSONファイルにデータがありません: $jsonFileName');
        return;
      }

      print('[INFO] 差分更新を開始します。既存データを保持しつつ新データを反映します。');

      for (var jsonWord in jsonWords) {
        // 既存のWordをIDで検索
        int? key = _wordsBox.keys.firstWhere(
          (k) => _wordsBox.get(k)!.id == jsonWord.id,
          orElse: () => null,
        );

        if (key != null) {
          // 既存のデータが見つかった場合は特定のフィールドのみ更新
          Word existingWord = _wordsBox.get(key)!;

          // 更新するフィールドのみを上書き
          existingWord.word = jsonWord.word;
          existingWord.meaningSimple = jsonWord.meaningSimple;
          existingWord.meaningDetail = jsonWord.meaningDetail;
          existingWord.meaningEnglish = jsonWord.meaningEnglish;
          existingWord.part = jsonWord.part;
          existingWord.pronunciation = jsonWord.pronunciation;
          existingWord.pronunciationKatakana = jsonWord.pronunciationKatakana;
          existingWord.sentenceEng = jsonWord.sentenceEng;
          existingWord.sentenceJpn = jsonWord.sentenceJpn;
          existingWord.frequency = jsonWord.frequency;
          existingWord.tpo = jsonWord.tpo;
          existingWord.usageGuide = jsonWord.usageGuide;
          existingWord.etymology = jsonWord.etymology;
          existingWord.idiomSimple = jsonWord.idiomSimple;
          existingWord.collocationSimple = jsonWord.collocationSimple;
          existingWord.synonymsSimple = jsonWord.synonymsSimple;
          existingWord.idiomDetail = jsonWord.idiomDetail;
          existingWord.collocationDetail = jsonWord.collocationDetail;
          existingWord.synonymsDetail = jsonWord.synonymsDetail;
          existingWord.shortStoryEng = jsonWord.shortStoryEng;
          existingWord.shortStoryJpn = jsonWord.shortStoryJpn;

          // `isFavorite` やその他の保持したいフィールドは触らない
          print('[DEBUG] 更新: ID=${jsonWord.id}');
          await _wordsBox.put(key, existingWord);
        } else {
          // 新しいデータを追加
          print('[DEBUG] 新規追加: ID=${jsonWord.id}');
          await _wordsBox.add(jsonWord);
        }
      }

      print('[INFO] マイグレーションが完了しました: $jsonFileName');
    } catch (e) {
      print('[ERROR] マイグレーションエラー: $e');
      await _restoreBackup(); // エラー発生時にバックアップから復元
    }
  }

  /// バックアップ用データボックスをクリアしてデータをバックアップ
  // Future<void> _backupData() async {
  //   //TODO ここでエラーが発生している
  //   print('[INFO] データのバックアップを開始します');
  //   await _backupBox.clear(); // 既存のバックアップをクリア
  //   for (var key in _wordsBox.keys) {
  //     Word? word = _wordsBox.get(key);
  //     if (word != null) {
  //       await _backupBox.put(key, word);
  //     }
  //   }
  //   print('[INFO] データのバックアップが完了しました。');
  // }
  Future<void> _backupData() async {
    print('[INFO] データのバックアップを開始します');
    await _backupBox.clear(); // 既存のバックアップをクリア
    for (var key in _wordsBox.keys) {
      Word? word = _wordsBox.get(key);
      if (word != null) {
        // 新しいインスタンスを作成して保存
        final backupWord = Word(
          id: word.id,
          secondId: word.secondId,
          level: word.level,
          subLevel: word.subLevel,
          subIndex: word.subIndex,
          word: word.word,
          meaningSimple: word.meaningSimple,
          meaningDetail: word.meaningDetail,
          meaningEnglish: word.meaningEnglish,
          part: word.part,
          pronunciation: word.pronunciation,
          pronunciationKatakana: word.pronunciationKatakana,
          sentenceEng: word.sentenceEng,
          sentenceJpn: word.sentenceJpn,
          frequency: word.frequency,
          tpo: word.tpo,
          usageGuide: word.usageGuide,
          etymology: word.etymology,
          idiomSimple: word.idiomSimple,
          collocationSimple: word.collocationSimple,
          synonymsSimple: word.synonymsSimple,
          idiomDetail: word.idiomDetail,
          collocationDetail: word.collocationDetail,
          synonymsDetail: word.synonymsDetail,
          shortStoryEng: word.shortStoryEng,
          shortStoryJpn: word.shortStoryJpn,
          pronunciationMp3: word.pronunciationMp3,
          sentenceMp3: word.sentenceMp3,
          shortStoryMp3: word.shortStoryMp3,
          imgUrl: word.imgUrl,
          isMemorized: word.isMemorized,
          isMemorizedMax: word.isMemorizedMax,
          memorizedAt: word.memorizedAt,
          memorizedCount: word.memorizedCount,
          updateMemorizedAtCallCount: word.updateMemorizedAtCallCount,
          isFavorite: word.isFavorite,
          isMeanVisible: word.isMeanVisible,
        );

        await _backupBox.put(key, backupWord);
      }
    }
    print('[INFO] データのバックアップが完了しました。');
  }

  /// バックアップからデータを復元
  Future<void> _restoreBackup() async {
    print('[INFO] _wordsBoxがクリアされます');
    await _wordsBox.clear(); // 現在のデータをクリア

    int restoredCount = 0; // 復元された件数をカウント

    for (var key in _backupBox.keys) {
      try {
        Word? word = _backupBox.get(key);
        if (word != null) {
          await _wordsBox.put(key, word);
          restoredCount++; // 復元成功時にカウントを増やす
        }
      } catch (e) {
        print('[ERROR] データのリストア中にエラーが発生しました: key=$key, error=$e');
      }
    }
    print('[INFO] バックアップからデータを復元しました。復元件数: $restoredCount');
    print('[INFO] 復元後のデータ件数: ${_wordsBox.length}');
  }

  Future<void> addWords(List<Word> words) async {
    for (var word in words) {
      _wordsBox.add(word);
    }
  }

  List<Word> getWords() {
    return _wordsBox.values.toList();
  }

  Word? getWordById(int id) {
    final word = _wordsBox.values.firstWhere((word) => word.id == id);
    return word;
  }

  List<Word> getWordsBySubLevel(int subLevel) {
    return _wordsBox.values.where((word) => word.subLevel == subLevel).toList();
  }

  // List<Word> getWordsByLevelAndSubLevel(int level, int subLevel) {
  //   return _wordsBox.values
  //       .where((word) => word.level == level && word.subLevel == subLevel)
  //       .toList();
  // }

  double countAllWords() {
    return _wordsBox.values.toList().length.toDouble();
  }

  double countMemorizedAllWords() {
    return _wordsBox.values
        .where((word) => word.isMemorized || word.isMemorizedMax)
        .length
        .toDouble();
  }

  double countWordsBySubLevel(int subLevel) {
    return _wordsBox.values
        .where((word) => word.subLevel == subLevel)
        .length
        .toDouble();
  }

  double countMemorizedWordsBySubLevel(int subLevel) {
    return _wordsBox.values
        .where((word) =>
            word.subLevel == subLevel &&
            (word.isMemorized || word.isMemorizedMax))
        .length
        .toDouble();
  }

  double countMemorizedMaxWordsBySubLevel(int subLevel) {
    return _wordsBox.values
        .where((word) => word.subLevel == subLevel && word.isMemorizedMax)
        .length
        .toDouble();
  }

  double countBelow50MemorizedAtWordsBySubLevel(int subLevel) {
    return _wordsBox.values
        .where((word) => word.subLevel == subLevel && (word.memorizedAt <= 50))
        .length
        .toDouble();
  }

  double countNonMemorizedWordsBySubLevel(int subLevel) {
    return _wordsBox.values
        .where((word) => word.subLevel == subLevel && !word.isMemorizedMax)
        .length
        .toDouble();
  }

  double countFavoriteWordsBySubLevel(int subLevel) {
    return _wordsBox.values
        .where((word) => word.subLevel == subLevel && word.isFavorite)
        .length
        .toDouble();
  }

  // 単語検索機能を追加
  List<Word> searchWords(String query) {
    return _wordsBox.values.where((word) {
      final wordMatch = word.word.toLowerCase().contains(query.toLowerCase());
      final meaningMatch = word.meaningSimple.contains(query);
      return wordMatch || meaningMatch;
    }).toList();
  }

  // バックアップ用isMemorizedを取得
  bool? getIsMemorizedById(int id) {
    final word = _wordsBox.values.firstWhere((word) => word.id == id);
    return word.isMemorized;
  }

  // バックアップ用isMemorizedMaxを取得
  bool? getIsMemorizedMaxById(int id) {
    final word = _wordsBox.values.firstWhere((word) => word.id == id);
    return word.isMemorizedMax;
  }
}

/// バージョン文字列を比較する関数
/// 戻り値:
/// - 正の値: v1 > v2
/// - 負の値: v1 < v2
/// - 0: v1 == v2
int compareVersions(String v1, String v2) {
  final parts1 = v1.split('.').map(int.parse).toList();
  final parts2 = v2.split('.').map(int.parse).toList();

  // 長さを揃える（短い方を0で埋める）
  final maxLength =
      parts1.length > parts2.length ? parts1.length : parts2.length;
  while (parts1.length < maxLength) parts1.add(0);
  while (parts2.length < maxLength) parts2.add(0);

  // 部分ごとに比較
  for (int i = 0; i < maxLength; i++) {
    if (parts1[i] != parts2[i]) {
      return parts1[i].compareTo(parts2[i]);
    }
  }

  // 全て同じなら等しい
  return 0;
}
