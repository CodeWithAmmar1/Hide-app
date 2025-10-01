import 'dart:async';
import 'dart:math';

import 'package:app/scr/newscreen.dart';
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
        centerTitle: true,
        backgroundColor: Colors.indigoAccent,
        title: GestureDetector(
          onDoubleTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Newscreen()),
            );
          },

          child: const Text(
            'TapperizZzo',
            style: TextStyle(color: Colors.white),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: startGame,
          ),
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
              child: Image.asset("asset/TapMe-Logo.png", width: 80, height: 80),
            ),
          ),
          Positioned(
            top: 20,
            right: 20,
            child: Text(
              'Score: $score',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
