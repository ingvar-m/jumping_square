import 'package:jumping_square/domain/enums/game_status.dart';
import 'package:jumping_square/domain/model/obstacle_model.dart';
import 'package:jumping_square/domain/model/player_model.dart';

class GameState {
  final GameStatus status;
  final int score;
  final int highScore;
  final PlayerModel player;
  final List<ObstacleModel> obstacles;
  final bool isNewRecord;

  GameState({
    required this.status,
    required this.score,
    required this.highScore,
    required this.player,
    required this.obstacles,
    required this.isNewRecord,
  });

  factory GameState.initial(int currentHighScore) {
    return GameState(
        status: GameStatus.initial,
        score: 0,
        highScore: currentHighScore,
        player: PlayerModel(y: 0, velocity: 0, rotation: 0),
        obstacles: [],
        isNewRecord: false,
    );
  }

  GameState copyWith({GameStatus? status,
    int? score,
    int? highScore,
    PlayerModel? player,
    List<ObstacleModel>? obstacles,
    bool? isNewRecord
  }) {
    return GameState(
        status: status ?? this.status,
        score: score ?? this.score,
        highScore: highScore ?? this.highScore,
        player: player ?? this.player,
        obstacles: obstacles ?? this.obstacles,
        isNewRecord: isNewRecord ?? this.isNewRecord
    );
  }

}
