import 'package:flutter/material.dart';
import 'dart:async';

class LoadingStartUpScreen extends StatefulWidget {
  final ValueNotifier<int> progressNotifier;
  final int totalWords;

  const LoadingStartUpScreen(
      {super.key, required this.progressNotifier, required this.totalWords});

  @override
  _LoadingStartUpState createState() => _LoadingStartUpState();
}

class _LoadingStartUpState extends State<LoadingStartUpScreen> {
  Timer? _timer;
  int _currentProgress = 0;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _startProgress();
  }

  void _startProgress() {
    const int totalTime = 15; // 15 seconds
    const int interval = 1; // Update every second
    int ticks = 0;

    _timer = Timer.periodic(const Duration(seconds: interval), (timer) {
      ticks++;
      _currentProgress = ticks * widget.totalWords ~/ totalTime;
      if (_currentProgress > widget.totalWords) {
        _currentProgress = widget.totalWords;
      }
      widget.progressNotifier.value = _currentProgress;

      if (ticks >= totalTime) {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 24, 23, 23),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 40.0, left: 20.0, right: 20.0),
            child: Column(
              children: [
                const SizedBox(height: 70),
                const Text(
                  'AI英単語をインストール中',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                ValueListenableBuilder<int>(
                  valueListenable: widget.progressNotifier,
                  builder: (context, progress, child) {
                    double progressValue = widget.totalWords > 0
                        ? progress / widget.totalWords
                        : 0;
                    return Column(
                      children: [
                        SizedBox(
                          width: 240,
                          height: 10,
                          child: ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20)),
                            child: LinearProgressIndicator(
                              value: progressValue,
                              backgroundColor:
                                  const Color.fromARGB(255, 66, 68, 75),
                              color: const Color.fromARGB(255, 86, 179, 255),
                              minHeight: 10,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '$progress / ${widget.totalWords} words loaded',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: 10,
              itemBuilder: (context, index) {
                return Center(
                  child: Text(
                    'Slide ${index + 1}',
                    style: const TextStyle(color: Colors.white, fontSize: 24),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
