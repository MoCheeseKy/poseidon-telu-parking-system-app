class BuildingDistance {
  final String buildingName;
  final int distanceMeters;

  final bool isStraightLineEstimate;

  const BuildingDistance({
    required this.buildingName,
    required this.distanceMeters,
    this.isStraightLineEstimate = false,
  });

  String get formattedDistance => isStraightLineEstimate
      ? '±$distanceMeters m (garis lurus)'
      : '$distanceMeters m';
}
