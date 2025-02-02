import 'package:flutter/foundation.dart';

class SettingsModel with ChangeNotifier {
  bool _katakanaPronunciationFlg = false;
  bool _englishDictionaryFlg = false;
  bool _initiallyExpandedFlg = false;

  bool get katakanaPronunciationFlg => _katakanaPronunciationFlg;
  bool get englishDictionaryFlg => _englishDictionaryFlg;
  bool get initiallyExpandedFlg => _initiallyExpandedFlg;

  void toggleKatakanaPronunciationFlg(bool value) {
    _katakanaPronunciationFlg = value;
    notifyListeners();
  }

  void toggleEnglishDictionaryFlg(bool value) {
    _englishDictionaryFlg = value;
    notifyListeners();
  }

  void toggleInitiallyExpandedFlg(bool value) {
    _initiallyExpandedFlg = value;
    notifyListeners();
  }
}
