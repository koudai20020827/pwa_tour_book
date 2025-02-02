import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:audio2/data/word_service.dart';
import 'package:audio2/data/word_model.dart';
import 'package:audio2/common_utils/enum/sort_enum.dart';
import 'dart:async';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';

class WordCardLogic extends ChangeNotifier {
  DatabaseService databaseService = DatabaseService();
  final Box<Word> wordsBox;
  late List<Word> _words;
  late Timer _timer;
  final WordSortType _currentSortType;
  final WordSortOrder _currentSortOrder;

  WordCardLogic(this.wordsBox)
      : _currentSortType = WordSortType.allWords,
        _currentSortOrder = WordSortOrder.lowToHigh {
    _words = [];
    _startTimer();
    _updateWords();
  }

  List<Word> get words => _words;

  void toggleMeaningVisibility(int subLevel, int subIndex) {
    Word? word = _words.firstWhere(
      (w) => w.subLevel == subLevel && w.subIndex == subIndex,
      orElse: () => _words[0],
    );

    word.isMeanVisible = !word.isMeanVisible;
    word.save();
    notifyListeners();
  }

  void toggleMeaningVisibilityBySubLevel(int subLevel) {
    List<Word> wordsAtSubLevel =
        _words.where((w) => w.subLevel == subLevel).toList();

    if (wordsAtSubLevel.isEmpty) return;

    bool allVisible = wordsAtSubLevel.every((w) => w.isMeanVisible);

    for (var word in wordsAtSubLevel) {
      word.isMeanVisible = allVisible ? false : true;
      word.save();
    }

    notifyListeners();
  }

  Future<void> toggleMemorized(int subLevel, int subIndex) async {
    Word? word = _words.firstWhere(
      (w) => w.subLevel == subLevel && w.subIndex == subIndex,
      orElse: () => _words[0],
    );

    if (word.isMemorizedMax) {
      word.memorizedAt = 0;
      word.memorizedCount -= 1;
      word.isMemorized = false;
      word.isMemorizedMax = false;
    } else if (word.isMemorized && word.memorizedAt < 100) {
      word.memorizedAt = 100;
      word.memorizedCount += 1;
      word.updateMemorizedAtCallCount = 0;
    } else if (word.isMemorized && word.memorizedAt == 100) {
      word.isMemorizedMax = true;
    } else {
      word.memorizedAt = 100;
      word.memorizedCount += 1;
      word.isMemorized = true;
      word.updateMemorizedAtCallCount = 0;
    }

    await word.save();
    _updateWords();
    return;
  }

  Future<void> toggleMemorizedBad(int subLevel, int subIndex) async {
    Word? word = _words.firstWhere(
      (w) => w.subLevel == subLevel && w.subIndex == subIndex,
      orElse: () => _words[0],
    );
    await word.save();
    _updateWords();
    return;
  }

  Future<void> toggleMemorizedTo100(int subLevel, int subIndex) async {
    Word? word = _words.firstWhere(
      (w) => w.subLevel == subLevel && w.subIndex == subIndex,
      orElse: () => _words[0],
    );
    if (word.isMemorized && word.memorizedAt == 100) {
      word.memorizedAt = 100;
      word.isMemorized = true;
      word.updateMemorizedAtCallCount = 0;
    } else {
      word.memorizedAt = 100;
      word.memorizedCount += 1;
      word.isMemorized = true;
      word.updateMemorizedAtCallCount = 0;
    }

    await word.save();
    _updateWords();
    return;
  }

  Future<void> toggleMemorizedMax(int subLevel, int subIndex) async {
    Word? word = _words.firstWhere(
      (w) => w.subLevel == subLevel && w.subIndex == subIndex,
      orElse: () => _words[0],
    );
    if (word.isMemorizedMax) {
      word.isMemorizedMax = true;
      word.memorizedAt = 100;
      word.isMemorized = true;
      word.updateMemorizedAtCallCount = 0;
    }
    if (word.isMemorized) {
      word.isMemorizedMax = true;
      word.memorizedAt = 100;
      word.isMemorized = true;
      word.updateMemorizedAtCallCount = 0;
    } else {
      word.isMemorizedMax = true;
      word.memorizedAt = 100;
      word.isMemorized = true;
      word.memorizedCount += 1;
      word.updateMemorizedAtCallCount = 0;
    }

    await word.save();
    _updateWords();
    return;
  }

  void updateMemorizedAt() {
    for (int i = 0; i < _words.length; i++) {
      Word word = _words[i];
      if (!word.isMemorizedMax && word.isMemorized) {
        word.updateMemorizedAtCallCount++;
        double T = 3;
        double elapsedDays = word.updateMemorizedAtCallCount.toDouble();
        double memorizedCountFactor = 1 + (word.memorizedCount.toDouble() / 10);
        double R = exp(-0.693 * elapsedDays / (T * memorizedCountFactor));
        double decreased = (1 - R) * word.memorizedAt.toDouble();
        word.memorizedAt = max((word.memorizedAt - decreased).toInt(), 1);
        _words[i] = word;
      }
    }
    _sortWords();
    notifyListeners();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(days: 1), (timer) {
      updateMemorizedAt();
    });
  }

  Future<void> _advanceDate() async {
    updateMemorizedAt();
    return;
  }

  Future<void> scheduleAdvanceDate() async {
    final prefs = await SharedPreferences.getInstance();
    final lastRun = prefs.getInt('lastRun') ?? 0;
    final now = DateTime.now();
    DateTime lastRunDate = DateTime.fromMillisecondsSinceEpoch(lastRun);
    final todayMidnight = DateTime(now.year, now.month, now.day);

    while (lastRunDate.isBefore(todayMidnight)) {
      await _advanceDate();
      lastRunDate = lastRunDate.add(const Duration(days: 1));
      await prefs.setInt('lastRun', lastRunDate.millisecondsSinceEpoch);
    }

    Future.delayed(const Duration(hours: 24), scheduleAdvanceDate);
    return;
  }

  Future<void> updateFavorite(int id) async {
    Word? word = _words.firstWhere(
      (w) => w.id == id,
      orElse: () => _words[0],
    );
    word.isFavorite = !word.isFavorite;
    await word.save();
    notifyListeners();
    return;
  }

  List<Word> _filterWords(List<Word> words) {
    switch (_currentSortType) {
      case WordSortType.allWords:
        return words;
      case WordSortType.nonMemorizedWords:
        return words.where((word) => !word.isMemorizedMax).toList();
      case WordSortType.memorizedWordsNot100:
        return words.where((word) => word.memorizedAt != 100).toList();
    }
  }

  void _sortWords() {
    List<Word> sortedWords = List.from(_words);

    switch (_currentSortOrder) {
      case WordSortOrder.lowToHigh:
        sortedWords.sort((a, b) => a.memorizedAt.compareTo(b.memorizedAt));
        break;
      case WordSortOrder.highToLow:
        sortedWords.sort((a, b) {
          if (a.isMemorizedMax && !b.isMemorizedMax) {
            return -1;
          } else if (!a.isMemorizedMax && b.isMemorizedMax) {
            return 1;
          } else {
            return b.memorizedAt.compareTo(a.memorizedAt);
          }
        });
        break;
      case WordSortOrder.aToZ:
        sortedWords.sort((a, b) => a.word.compareTo(b.word));
        break;
      case WordSortOrder.zToA:
        sortedWords.sort((a, b) => b.word.compareTo(a.word));
        break;
      case WordSortOrder.random:
        sortedWords.shuffle();
        break;
    }

    _words = sortedWords;
    notifyListeners();
  }

  void _updateWords() {
    _words = _filterWords(wordsBox.values.toList());
    _sortWords();
    notifyListeners();
  }
}
