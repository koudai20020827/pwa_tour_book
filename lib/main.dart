import 'package:audio2/screens/home/home.dart';
import 'package:flutter/material.dart';
import 'package:audio2/data/word_service.dart';
import 'package:audio2/data/word_model.dart';
import 'package:audio2/data/json_parse.dart';
import 'package:audio2/data/setting_model.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'package:audio2/data/word_logic_service.dart';
import 'package:audio2/screens/loading/loading_startup.dart';

// メイン関数の最初にスプラッシュ画面を表示するように変更
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const SplashScreen());
}

// スプラッシュ画面
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // スプラッシュ画面を0.4秒間表示して次の画面に遷移
    Future.delayed(const Duration(milliseconds: 2000), () {
      _initializeApp(context);
    });

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Image.asset(
            'assets/icons/audioLogoWhite.png',
            width: 150,
            height: 150,
          ),
        ),
      ),
    );
  }

  void _initializeApp(BuildContext context) async {
    DatabaseService databaseService = DatabaseService();
    // DBの初期化（初期化済みであればスキップされます）
    await databaseService.initDatabase();

    ValueNotifier<int> progressNotifier = ValueNotifier<int>(0);

    // log
    print('DatabaseService: ${databaseService.wordsBox.isOpen}'); // デバッグ用

    List<Word> words = databaseService.getWords();
    print('words: $words'); // デバッグ用

    // UTF-8にしておく必要あり
    if (words.isEmpty) {
      print("Loading words from JSON...");
      runApp(LoadingApp(
          progressNotifier: progressNotifier,
          totalWords: 10000)); // 仮のtotalWords値

      words = await loadWordsFromJsonWithProgress(progressNotifier);
      await databaseService.addWords(words);
    }

    // DBのバージョンチェックとマイグレーション
    await databaseService.checkAndMigrate();

    WordCardLogic wordCardLogic = WordCardLogic(databaseService.wordsBox);
    await wordCardLogic.scheduleAdvanceDate();

    runApp(
      MultiProvider(
        providers: [
          Provider<DatabaseService>.value(value: databaseService),
          ChangeNotifierProvider<WordCardLogic>.value(value: wordCardLogic),
          ChangeNotifierProvider<SettingsModel>(
            create: (context) => SettingsModel(),
          ),
        ],
        child: MyApp(
            databaseService: databaseService, wordCardLogic: wordCardLogic),
      ),
    );
  }
}

class LoadingApp extends StatelessWidget {
  final ValueNotifier<int> progressNotifier;
  final int totalWords;

  const LoadingApp(
      {super.key, required this.progressNotifier, required this.totalWords});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Loading...',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color.fromARGB(255, 24, 23, 23),
      ),
      home: LoadingStartUpScreen(
          progressNotifier: progressNotifier, totalWords: totalWords),
    );
  }
}

Future<List<Word>> loadWordsFromJsonWithProgress(
    ValueNotifier<int> progressNotifier) async {
  List<Word> words = await loadWordsFromJson();
  for (int i = 0; i < words.length; i++) {
    // Simulate some delay for loading
    await Future.delayed(const Duration(milliseconds: 10));
    progressNotifier.value = i + 1;
  }
  return words;
}

class MyApp extends StatelessWidget {
  final DatabaseService databaseService;
  final WordCardLogic wordCardLogic;

  const MyApp(
      {super.key, required this.databaseService, required this.wordCardLogic});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'The Flutter Way - Template',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color.fromARGB(255, 24, 23, 23),
      ),
      home: HomeScreen(onReturn: _reloadData),
      // routes: routes,
    );
  }

  void _reloadData() async {
    await databaseService.initDatabase();
    await databaseService.checkAndMigrate();
    await wordCardLogic.scheduleAdvanceDate();
  }
}
