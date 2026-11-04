import 'package:latlong2/latlong.dart';

class Building {
  final String id;
  final String name;
  final String code;
  final String area;
  final double latitude;
  final double longitude;
  final double entranceLatitude;
  final double entranceLongitude;

  const Building({
    required this.id,
    required this.name,
    required this.code,
    this.area = '',
    required this.latitude,
    required this.longitude,
    required this.entranceLatitude,
    required this.entranceLongitude,
  });

  LatLng get centerCoordinates => LatLng(latitude, longitude);

  LatLng get entranceCoordinates => LatLng(entranceLatitude, entranceLongitude);

  bool get hasValidCenterCoordinates =>
      isValidCoordinate(latitude, longitude);

  bool get hasValidEntranceCoordinates =>
      isValidCoordinate(entranceLatitude, entranceLongitude);

  bool get hasValidCoordinates =>
      hasValidCenterCoordinates && hasValidEntranceCoordinates;

  static bool isValidCoordinate(double lat, double lng) {
    if (!lat.isFinite || !lng.isFinite) return false;
    if (lat < -90.0 || lat > 90.0) return false;
    if (lng < -180.0 || lng > 180.0) return false;
    if (lat == 0.0 && lng == 0.0) return false;
    return true;
  }
}

