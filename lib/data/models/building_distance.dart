class BuildingDistance {
  final String buildingName;
  final int distanceMeters;

  const BuildingDistance({
    required this.buildingName,
    required this.distanceMeters,
  });

  String get formattedDistance => '$distanceMeters m';
}
