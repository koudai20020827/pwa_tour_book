import 'package:flutter/material.dart';

class MyPageRule extends StatelessWidget {
  final VoidCallback onReturn;

  const MyPageRule({super.key, required this.onReturn});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('設定'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            onReturn();
            Navigator.of(context).pop();
          },
        ),
      ),
      body: const Center(
        child: Text('ここに設定画面の内容を追加します'),
      ),
    );
  }
}
