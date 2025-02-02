import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:archive/archive.dart';
import 'package:hive/hive.dart';
import 'package:audio2/data/word_model.dart';
// import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:audio2/common_utils/colors.dart';

class QRCodeUpdateScreen extends StatefulWidget {
  final VoidCallback onReturn;
  final Color modalBackgroundColor; // モーダルの背景色を指定できるように追加

  const QRCodeUpdateScreen({
    super.key,
    required this.onReturn,
    this.modalBackgroundColor =
        const Color.fromARGB(255, 34, 38, 44), // デフォルトの色を設定
  });

  @override
  _QRCodeUpdateScreenState createState() => _QRCodeUpdateScreenState();
}

class _QRCodeUpdateScreenState extends State<QRCodeUpdateScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  final bool _loading = false;
  final bool _updated = false;
  String _qrData = '';
  bool _isInitialized = false;
  bool _qrCodeGenerated = false;
  late Box<Word> _wordsBox;
  double _progress = 0.0;
  String _compressedString = '';
  bool _showBackupFields = false;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _initializeWords();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _initializeWords() async {
    try {
      _wordsBox = await Hive.openBox<Word>('words');

      List<int> wordIds = [];

      for (int i = 1; i <= 4; i++) {
        wordIds.add(i - 1);
      }
      await _generateQrImageData(wordIds);

      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    } catch (e) {
      print("Error initializing words: $e");
      // 必要に応じてエラーダイアログを表示
    }
  }

  String _generateBackupData(List<int> ids) {
    List<Map<String, dynamic>> backupData = [];

    for (var id in ids) {
      final word = _wordsBox.get(id);
      final Map<String, dynamic> data = {
        'id': id,
        'isMemorized': word?.isMemorized ?? false ? 1 : 0,
        'isMemorizedMax': word?.isMemorizedMax ?? false ? 1 : 0,
        'memorizedCount': word?.memorizedCount ?? 0,
      };
      backupData.add(data);
    }
    print('BackUpData: $backupData');

    return jsonEncode(backupData);
  }

  Future<void> _generateQrImageData(List<int> ids) async {
    String jsonData = _generateBackupData(ids);
    String compressedString = _compressQrDataToString(jsonData);

    setState(() {
      _qrData = jsonData;
      _qrCodeGenerated = true;
      _progress = 0.0;
      _compressedString = compressedString;
    });
  }

  String _compressQrDataToString(String jsonData) {
    List<int> input = utf8.encode(jsonData);
    List<int>? compressed = GZipEncoder().encode(input);
    if (compressed != null) {
      return base64Encode(compressed).toString();
    } else {
      print("データの圧縮に失敗しました");
      return "xxxxxxxxxxxxxxxx";
    }
  }

  Future<void> _compressedStringCopyToClipboard() async {
    await Clipboard.setData(ClipboardData(text: _compressedString));
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('データをコピーしました')));
  }

  Future<void> updateMemorizationStatusFromCompressed(
      String compressedData) async {
    // モーダルを表示
    showDialog(
      context: context,
      barrierDismissible: false, // ユーザーがタップして閉じられないようにする
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('データ更新中', style: TextStyle(color: Colors.white)),
          backgroundColor: widget.modalBackgroundColor,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              LinearProgressIndicator(
                value: _progress,
                color: Colors.white,
                backgroundColor: Colors.grey,
              ),
              const SizedBox(height: 20),
              Text('${(_progress * 100).toStringAsFixed(0)}% 完了',
                  style: const TextStyle(color: Colors.white)),
            ],
          ),
        );
      },
    );

    try {
      print('JSONデータのデコードと解凍<START>');
      List<int> compressedBytes = base64Decode(compressedData);
      List<int> decompressedBytes = GZipDecoder().decodeBytes(compressedBytes);
      String jsonString = utf8.decode(decompressedBytes);

      print('jsonString: $jsonString');

      List<dynamic> jsonList = jsonDecode(jsonString);
      print('JsonStringAfterParse: $jsonList');

      Map<int, Map<String, dynamic>> updateMap = {};
      for (var json in jsonList) {
        print('json: $json');
        int id = json['id'];
        bool isMemorized = json['isMemorized'] == 1;
        bool isMemorizedMax = json['isMemorizedMax'] == 1;
        int memorizedCount = json['memorizedCount'];

        updateMap[id + 1] = {
          'isMemorized': isMemorized,
          'isMemorizedMax': isMemorizedMax,
          'memorizedCount': memorizedCount,
        };
      }
      print('JsonUpdateMap: $updateMap');

      for (var i = 0; i < _wordsBox.length; i++) {
        var word = _wordsBox.getAt(i);
        if (word != null && updateMap.containsKey(word.id)) {
          var updateData = updateMap[word.id];
          if (updateData != null) {
            word.isMemorized = updateData['isMemorized'] ?? false;
            word.isMemorizedMax = updateData['isMemorizedMax'] ?? false;
            word.memorizedAt = updateData['isMemorized'] ?? false ? 100 : 0;
            word.memorizedCount = updateData['memorizedCount'] ?? 0;
            await word.save();
          }
        }
        // 進捗を更新
        setState(() {
          _progress = (i + 1) / _wordsBox.length;
        });
      }
      print('データベースの更新が完了しました');

      // モーダルを閉じて完了メッセージを表示
      Navigator.of(context).pop(); // モーダルを閉じる
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('完了', style: TextStyle(color: Colors.white)),
            backgroundColor: widget.modalBackgroundColor,
            content: const Text(
              '引き継ぎ完了しました',
              style: TextStyle(color: Colors.white),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  widget.onReturn(); // 必要に応じてコールバックを実行
                },
                child: const Text(
                  'OK',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          );
        },
      );
    } catch (e) {
      print('データの更新に失敗しました: $e');
      // モーダルを閉じてエラーメッセージを表示
      Navigator.of(context).pop(); // モーダルを閉じる
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('エラー', style: TextStyle(color: Colors.white)),
            backgroundColor: widget.modalBackgroundColor,
            content: Text(
              'データの更新に失敗しました。\nエラー: $e',
              style: const TextStyle(color: Colors.white),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'OK',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          );
        },
      );
    }
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          backgroundColor: widget.modalBackgroundColor, // モーダルの背景色を設定
          title: const Text(
            '確認',
            style: TextStyle(fontSize: 40, color: Colors.white),
          ),
          content: const Text(
            '元の状態に戻せないですが、本当に引き継ぎしてよろしいですか？',
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
          actions: [
            TextButton(
              child: const Text(
                '戻る',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                '更新する',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              onPressed: () async {
                Navigator.of(context).pop();
                String compressedData = _controller.text;
                if (compressedData.isEmpty) {
                  _showErrorDialog();
                } else {
                  await updateMemorizationStatusFromCompressed(compressedData);
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          backgroundColor: widget.modalBackgroundColor, // モーダルの背景色を設定
          title: const Text(
            'エラー',
            style: TextStyle(fontSize: 40, color: Colors.white),
          ),
          content: const Text(
            '未入力のため引き継ぎできません。',
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            TextButton(
              child: const Text(
                '戻る',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.modalBackgroundColor, // 全体の背景色を設定
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: widget.modalBackgroundColor,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            icon: const Icon(Icons.close, color: Colors.white),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        GestureDetector(
                          onTap: () async {
                            await _compressedStringCopyToClipboard();
                          },
                          child: _qrCodeGenerated
                              ? Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white, // 背景色を白に設定
                                    borderRadius:
                                        BorderRadius.circular(12.0), // 角丸を設定
                                  ),
                                  padding:
                                      const EdgeInsets.all(16.0), // QRコード周りの余白
                                  child: PrettyQr(
                                    data: _qrData,
                                    size: 200,
                                    roundEdges: true,
                                    errorCorrectLevel: QrErrorCorrectLevel.H,
                                    image: const AssetImage(
                                        'assets/icons/audioLogoWhite.png'),
                                  ),
                                )
                              : const Center(
                                  child: Text(
                                    'バックアップデータの生成',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                        ),
                        const SizedBox(height: 50.0),
                        OutlinedButton.icon(
                          onPressed: () {
                            // Navigator.of(context).push(
                            //   MaterialPageRoute(
                            //     builder: (context) => QRScanScreen(
                            //       onScanComplete: (String scannedData) async {
                            //         await updateMemorizationStatusFromCompressed(
                            //             scannedData);
                            //       },
                            //     ),
                            //   ),
                            // );
                          },
                          icon: const Icon(Icons.qr_code_scanner,
                              color: Colors.white),
                          label: const Text('QRスキャンして引き継ぎする',
                              style: TextStyle(color: Colors.white)),
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            side: const BorderSide(color: Colors.grey),
                            minimumSize: const Size(double.infinity, 48),
                          ),
                        ),
                        const SizedBox(height: 25.0),
                        AnimatedSize(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          child: Column(
                            children: [
                              if (!_showBackupFields) ...[
                                OutlinedButton.icon(
                                  onPressed: () {
                                    setState(() {
                                      _showBackupFields = !_showBackupFields;
                                      if (_showBackupFields) {
                                        _animationController.forward();
                                      } else {
                                        _animationController.reverse();
                                      }
                                    });
                                  },
                                  label: const Text('バックアップコードで引き継ぎする',
                                      style: TextStyle(color: Colors.white)),
                                  style: OutlinedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    side: const BorderSide(color: Colors.grey),
                                    minimumSize:
                                        const Size(double.infinity, 48),
                                  ),
                                ),
                                const SizedBox(height: 25.0),
                              ],
                              if (_showBackupFields) ...[
                                FadeTransition(
                                  opacity: _fadeAnimation,
                                  child: Column(
                                    children: [
                                      LinearProgressIndicator(
                                        value: _progress,
                                        color: Colors.grey[500],
                                        minHeight: 1.8,
                                      ),
                                      const SizedBox(height: 25.0),
                                      GestureDetector(
                                        onTap: () async {
                                          await _compressedStringCopyToClipboard();
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12.0, vertical: 16.0),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.grey,
                                              width: 1.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(4.0),
                                          ),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  _compressedString,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                      fontSize: 16.0,
                                                      color: Colors.grey),
                                                ),
                                              ),
                                              const Icon(Icons.copy,
                                                  color: Colors.grey),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 20.0),
                                      TextField(
                                        controller: _controller,
                                        decoration: const InputDecoration(
                                            border: OutlineInputBorder(),
                                            labelText: 'バックアップコードを入力',
                                            labelStyle:
                                                TextStyle(color: Colors.white)),
                                        maxLines: null,
                                        style: const TextStyle(
                                            color: Colors.white),
                                        cursorColor: Colors.white,
                                        inputFormatters: [NoInputFormatter()],
                                        readOnly: true,
                                      ),
                                      const SizedBox(height: 30.0),
                                      ElevatedButton.icon(
                                        onPressed: () {
                                          if (_controller.text.isEmpty) {
                                            _showErrorDialog();
                                          } else {
                                            _showConfirmationDialog();
                                          }
                                        },
                                        label: const Text('引き継ぎを始める',
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.white)),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color.fromARGB(
                                              255, 50, 50, 70),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                          ),
                                          minimumSize:
                                              const Size(double.infinity, 60),
                                        ),
                                      ),
                                      const SizedBox(height: 16.0),
                                    ],
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// カスタムのTextInputFormatter
class NoInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // 入力を許可しない（ただしペーストは許可される）
    return oldValue;
  }
}

// QRコードスキャン画面
// class QRScanScreen extends StatefulWidget {
//   final Function(String) onScanComplete;

//   const QRScanScreen({super.key, required this.onScanComplete});

//   @override
//   _QRScanScreenState createState() => _QRScanScreenState();
// }

// class _QRScanScreenState extends State<QRScanScreen> {
//   final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
//   QRViewController? controller;

//   @override
//   void dispose() {
//     controller?.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
//           onPressed: () {
//             Navigator.pop(context); // 押されたときに前の画面に戻る
//           },
//         ),
//         title: const Text('QRコードをスキャン', style: TextStyle(color: Colors.white)),
//         backgroundColor: primaryGray,
//         centerTitle: true,
//       ),
//       body: QRView(
//         key: qrKey,
//         onQRViewCreated: _onQRViewCreated,
//         overlay: QrScannerOverlayShape(
//           borderColor: Colors.white,
//           borderRadius: 10,
//           borderLength: 30,
//           borderWidth: 10,
//           cutOutSize: MediaQuery.of(context).size.width * 0.8,
//         ),
//       ),
//     );
//   }

//   void _onQRViewCreated(QRViewController controller) {
//     this.controller = controller;
//     controller.scannedDataStream.listen((scanData) {
//       controller.pauseCamera();
//       widget.onScanComplete(scanData.code ?? '');
//       Navigator.of(context).pop(); // スキャン完了後、元の画面に戻る
//     });
//   }
// }
