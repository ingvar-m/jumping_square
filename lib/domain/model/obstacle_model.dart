import 'package:jumping_square/domain/enums/obstacle_type.dart';

class ObstacleModel {

  final double x;
  final ObstacleType type;

  ObstacleModel({required this.x, required this.type});

  ObstacleModel copyWith({double? x, ObstacleType? type}) {
    return ObstacleModel(
      x: x ?? this.x,
      type: type ?? this.type,
    );
  }

}