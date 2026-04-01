import 'dart:math';

import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jumping_square/domain/enums/game_status.dart';
import 'package:jumping_square/domain/enums/obstacle_type.dart';
import 'package:jumping_square/domain/model/player_model.dart';
import 'package:jumping_square/domain/model/world_model.dart';

import '../../data/repositories/score_repository.dart';
import '../../domain/model/game_state.dart';
import '../../domain/model/obstacle_model.dart';

class GameController extends Notifier<GameState> {
  Ticker? _ticker;
  Duration _lastTime = Duration.zero;

  final _scoreRepo = ScoreRepository();

  static const double gravity = 1500.0;
  static const double jumpVelocity = 600.0;
  static const double worldSpeed = 500.0;
  static const double blockSize = 50.0;
  double _distanceSinceLastSpawn = 0;

  @override
  GameState build() {
    _loadHighScore();
    return GameState.initial(0);
  }

  void startGame() {
    state = state.copyWith(status: GameStatus.playing);
    _lastTime = Duration.zero;
    _ticker ??= Ticker(_onTick);
    _ticker!.start();
  }

  void gameOver() async {
    _ticker?.stop();

    bool isNew = false;
    int currentHigh = state.highScore;

    if (state.score > state.highScore && state.score > 0) {
      isNew = true;
      currentHigh = state.score;
      await _scoreRepo.saveHighScore(currentHigh);
    }
    state = state.copyWith(
      status: GameStatus.gameOver,
      highScore: currentHigh,
      isNewRecord: isNew,
    );
  }

  void reset() {
    state = GameState.initial(state.highScore);
    _distanceSinceLastSpawn = 0;
    state = state.copyWith(status: GameStatus.playing);
    _lastTime = Duration.zero;
    _ticker?.start();
  }

  Future<void> _loadHighScore() async {
    final hs = await _scoreRepo.getHighScore();
    state = state.copyWith(highScore: hs);
  }

  void _onTick(Duration elapsed) {
    final dt = (elapsed.inMicroseconds - _lastTime.inMicroseconds) / 1000000.0;
    _lastTime = elapsed;

    var currentPlayer = state.player;
    var currentObstacles = List<ObstacleModel>.from(state.obstacles);
    var currentScore = state.score;

    double groundLevel = 0;
    for (var obs in currentObstacles) {
      if (blockSize + blockSize > obs.x && blockSize < obs.x + blockSize) {
        double obsTop = blockSize;
        if (currentPlayer.y >= obsTop - 5) {
          groundLevel = max(groundLevel, obsTop);
        }
      }
    }

    currentPlayer = _updatePhysics(currentPlayer, dt, groundLevel);

    final worldUpdate = _moveWorld(currentObstacles, currentScore, dt);
    currentObstacles = worldUpdate.obstacles;
    currentScore = worldUpdate.score;

    if (_checkCollisions(currentPlayer, currentObstacles)) {
      gameOver();
      return;
    }

    state = state.copyWith(
      player: currentPlayer,
      obstacles: currentObstacles,
      score: currentScore,
    );
  }

  PlayerModel _updatePhysics(
    PlayerModel player,
    double dt,
    double groundLevel,
  ) {
    const double gravityForce = -2500.0;
    const double speedRotation = pi * 2.1;

    double newVelocity = player.velocity + (gravityForce * dt);
    double newY = player.y + (newVelocity * dt);
    double newRotation = player.rotation;

    if (newY <= groundLevel) {
      newY = groundLevel;
      newVelocity = 0;

      newRotation = (newRotation / (pi / 2)).round() * (pi / 2);
    } else {
      newRotation += speedRotation * dt;
    }

    return player.copyWith(
      y: newY,
      velocity: newVelocity,
      rotation: newRotation,
    );
  }

  bool _checkCollisions(PlayerModel player, List<ObstacleModel> obstacles) {
    const double pLeft = blockSize;
    final double pRight = pLeft + blockSize;
    final double pBottom = player.y;
    const double pSteps = 2;

    for (var obs in obstacles) {
      final double oLeft = obs.x;
      final double oRight = obs.x + blockSize;
      final double oTop = blockSize;

      bool isIntersecting =
          (pLeft + pSteps < oRight) &&
          (pRight - pSteps > oLeft) &&
          (pBottom + pSteps < oTop);

      if (isIntersecting && pBottom > oTop - 15) {
        isIntersecting = false;
      }

      if (isIntersecting) return true;
    }
    return false;
  }

  WorldModel _moveWorld(
    List<ObstacleModel> currentObstacles,
    int currentScore,
    double dt,
  ) {
    int newScore = currentScore + (100 * dt).toInt();
    List<ObstacleModel> newObstacles = [];
    for (var obs in currentObstacles) {
      final newX = obs.x - (worldSpeed * dt);
      if (newX > -blockSize * 2) {
        newObstacles.add(obs.copyWith(x: newX));
      }
    }
    _distanceSinceLastSpawn += worldSpeed * dt;
    if (_distanceSinceLastSpawn >= blockSize * 6) {
      _distanceSinceLastSpawn = 0;
      if (Random().nextDouble() > 0.4) {
        ObstacleType type = ObstacleType.single;
        newObstacles.add(ObstacleModel(x: 500, type: type));
      }
    }
    return WorldModel(newObstacles, newScore);
  }

  void jump() {
    if (state.player.velocity == 0) {
      final updatedPlayer = state.player.copyWith(velocity: jumpVelocity);
      state = state.copyWith(player: updatedPlayer);
    }
  }
}

final gameControllerProvider = NotifierProvider<GameController, GameState>(() {
  return GameController();
});
