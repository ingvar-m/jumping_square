import 'package:flutter/material.dart';

class GameConstants {
  static const double blockSize = 50.0;
  static const Color playerColor = Color(0xFFE3BA02);
  static const Color obstacleColor = Color(0xFF66D3FE);
  static const Color groundColor = Color(0xFF66D3FE);
  static const Color backgroundColor = Color(0xFF093DE2);
  static const Color gameStartColor = Color(0xFF40E000);
  static const Color gameOverColor = Color(0xFFD30000);
  static const double groundHeightPercent = 0.4;
  static const double strokeGroundWidth = 4;

  static double getScreenY(double logicalY, double screenHeight) {
    final groundY = screenHeight * (1 - groundHeightPercent);
    return groundY - logicalY - blockSize;
  }
}