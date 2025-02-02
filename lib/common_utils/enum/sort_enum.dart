// ソートのタイプ
enum WordSortType {
  allWords, // 全ての単語
  nonMemorizedWords, // MemorizedMaxがtrue以外
  memorizedWordsNot100, // memorizedAtが100でない
}

// ソートの順序
enum WordSortOrder {
  lowToHigh, // 低い順
  highToLow, // 高い順
  aToZ, // A-Z順
  zToA, // Z-A順
  random, // ランダム
}
