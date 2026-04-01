import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jumping_square/presentation/constants/game_constants.dart';

import '../../domain/enums/game_status.dart';
import '../providers/game_controller.dart';
import '../widgets/game_world_painter.dart';

class GameScreen extends ConsumerWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameControllerProvider);
    final controller = ref.watch(gameControllerProvider.notifier);
    return Scaffold(
      backgroundColor: GameConstants.backgroundColor,
      body: GestureDetector(
        onTap: () {
          if (gameState.status == GameStatus.initial) {
            controller.startGame();
          } else if (gameState.status == GameStatus.playing) {
            controller.jump();
          } else if (gameState.status == GameStatus.gameOver) {
            controller.reset();
          }
        },
        child: Stack(
          children: [
            Positioned.fill(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return CustomPaint(
                    painter: GameWorldPainter(
                      player: gameState.player,
                      obstacles: gameState.obstacles,
                    ),
                    size: Size(constraints.maxWidth, constraints.maxHeight),
                  );
                },
              ),
            ),
            if (gameState.status == GameStatus.initial)
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Record: ${_formatTime(gameState.highScore)}",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      'START',
                      style: TextStyle(
                        fontSize: 60,
                        color: GameConstants.gameStartColor,
                      ),
                    ),
                  ],
                ),
              ),
            if (gameState.status == GameStatus.gameOver)
              Container(
                color: Colors.black54,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (gameState.isNewRecord)
                        const Text(
                          "NEW RECORD",
                          style: TextStyle(
                            fontSize: 22,
                            color: Colors.amber,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      Text(
                        "BEST: ${_formatTime(gameState.highScore)}",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      const SizedBox(height: 30),
                      const Text(
                        "GAME OVER",
                        style: TextStyle(
                          color: GameConstants.gameOverColor,
                          fontSize: 48,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Tap to retry",
                        style: TextStyle(
                            color: Colors.white70,
                            fontSize: 20
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            if (gameState.status == GameStatus.playing)
              Positioned(
                top: 50,
                left: 0,
                right: 0,
                child: Center(
                  child: Column(
                    children: [
                      Text(
                        _formatTime(gameState.score),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "RECORD: ${_formatTime(gameState.highScore)}",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _formatTime(int score) {
    final totalSeconds = (score / 100).floor();
    final minutes = (totalSeconds / 60).floor().toString().padLeft(2, '0');
    final seconds = (totalSeconds % 60).floor().toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}
