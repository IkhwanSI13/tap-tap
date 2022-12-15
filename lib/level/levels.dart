final gameLevels = [
  const GameLevel(number: 1, speed: 1),
  const GameLevel(number: 2, speed: 2),
  const GameLevel(number: 3, speed: 3),
];

class GameLevel {
  final int number;
  final double speed;

  /// The achievement to unlock when the level is finished, if any.
  // final String? achievementIdIOS;
  // final String? achievementIdAndroid;
  // bool get awardsAchievement => achievementIdAndroid != null;

  const GameLevel({
    required this.number,
    required this.speed,
    // this.achievementIdIOS,
    // this.achievementIdAndroid,
  });
}
