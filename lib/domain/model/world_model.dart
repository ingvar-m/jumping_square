import 'package:jumping_square/domain/model/obstacle_model.dart';

class WorldModel {

  final List<ObstacleModel> obstacles;
  final int score;

  WorldModel(this.obstacles, this.score);
}