class PlayerModel {
  final double y;
  final double velocity;
  final double rotation;

  PlayerModel({
    required this.y,
    required this.velocity,
    required this.rotation,
  });

  PlayerModel copyWith({double? y, double? velocity, double? rotation}) {
    return PlayerModel(
      y: y ?? this.y,
      velocity: velocity ?? this.rotation,
      rotation: rotation ?? this.velocity,
    );
  }
}
