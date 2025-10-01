
import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  int score = 0;
  double x = 0.0;
  double y = 0.0;
  Random random = Random();
  Timer? timer;

  void moveSquare() {
    setState(() {
      x = random.nextDouble() * 300; // adjust based on screen width
      y = random.nextDouble() * 500; // adjust based on screen height
    });
  }

  void startGame() {
    score = 0;
    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      moveSquare();
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tap the Square'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: startGame,
          )
        ],
      ),
      body: Stack(
        children: [
          Positioned(
            top: y,
            left: x,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  score++;
                  moveSquare();
                });
              },
              child: Container(
                width: 50,
                height: 50,
                color: Colors.red,
              ),
            ),
          ),
          Positioned(
            top: 20,
            left: 20,
            child: Text(
              'Score: $score',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
