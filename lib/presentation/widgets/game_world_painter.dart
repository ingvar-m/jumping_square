import 'package:flutter/material.dart';

import '../../domain/model/obstacle_model.dart';
import '../../domain/model/player_model.dart';
import '../constants/game_constants.dart';

class GameWorldPainter extends CustomPainter {
  final PlayerModel player;
  final List<ObstacleModel> obstacles;

  GameWorldPainter({required this.player, required this.obstacles});

  @override
  void paint(Canvas canvas, Size size) {
    final screenHeight = size.height;

    final Paint playerPaint = Paint()..color = GameConstants.playerColor;

    final Paint obstaclePaint = Paint()
      ..color = GameConstants.obstacleColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = GameConstants.strokeGroundWidth;

    final Paint groundPaint = Paint()
      ..color = GameConstants.groundColor
      ..strokeWidth = GameConstants.strokeGroundWidth
      ..style = PaintingStyle.stroke;

    final groundY = screenHeight * (1 - GameConstants.groundHeightPercent);
    canvas.drawLine(
      Offset(0, groundY),
      Offset(size.width, groundY),
      groundPaint,
    );

    for (var obs in obstacles) {
      final double obsX = obs.x;
      final double obsWidth = GameConstants.blockSize;
      final double obsHeight = GameConstants.blockSize;

      final double obsScreenY = GameConstants.getScreenY(0, screenHeight);
      final double currentObsScreenY = obsScreenY;

      final rect = Rect.fromLTWH(obsX, currentObsScreenY, obsWidth, obsHeight);
      canvas.drawRect(rect, obstaclePaint);

      final backgroundPaint = Paint()
        ..color = GameConstants.backgroundColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = obstaclePaint.strokeWidth + 1;

      final halfStroke = obstaclePaint.strokeWidth / 2;

      canvas.drawLine(
        Offset(obsX + halfStroke, currentObsScreenY + obsHeight),
        Offset(obsX + obsWidth - halfStroke, currentObsScreenY + obsHeight),
        backgroundPaint,
      );
    }

    final double playerScreenY = GameConstants.getScreenY(
      player.y,
      screenHeight,
    );

    final double playerCenterX =
        GameConstants.blockSize +
        GameConstants.blockSize / 2;

    final double playerCenterY = playerScreenY + GameConstants.blockSize / 2;

    canvas.save();
    canvas.translate(playerCenterX, playerCenterY);
    canvas.rotate(player.rotation);

    final playerRect = Rect.fromLTWH(
      -GameConstants.blockSize / 2,
      -GameConstants.blockSize / 2,
      GameConstants.blockSize,
      GameConstants.blockSize,
    );

    canvas.drawRect(playerRect, playerPaint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant GameWorldPainter oldDelegate) {
    return oldDelegate.player.y != player.y ||
        oldDelegate.player.rotation != player.rotation ||
        oldDelegate.obstacles.length != obstacles.length ||
        oldDelegate.obstacles != obstacles;
  }
}
