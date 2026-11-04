import 'package:latlong2/latlong.dart';

enum ParkingStatus { available, warning, full, offline }

enum VehicleType { motor, mobil }

class ParkingLocation {
  final String id;
  final String name;
  final String? mapName;
  final String subArea;
  final String gateInfo;
  final VehicleType vehicleType;
  final int availableSlots;
  final int occupiedSlots;
  final int totalSlots;
  final ParkingStatus status;
  final bool isFavorite;
  final String? customStatusText;
  final double latitude;
  final double longitude;
  final double relativeMapX;
  final double relativeMapY;
  final String mapLabel;

  const ParkingLocation({
    required this.id,
    required this.name,
    this.mapName,
    this.subArea = '',
    this.gateInfo = 'Masuk Dari Gate 1',
    this.vehicleType = VehicleType.motor,
    required this.availableSlots,
    required this.occupiedSlots,
    required this.totalSlots,
    required this.status,
    this.isFavorite = false,
    this.customStatusText,
    required this.latitude,
    required this.longitude,
    this.relativeMapX = 0.0,
    this.relativeMapY = 0.0,
    this.mapLabel = '',
  });

  LatLng get coordinates => LatLng(latitude, longitude);

  bool get hasValidCoordinates =>
      latitude.isFinite &&
      longitude.isFinite &&
      latitude >= -90.0 &&
      latitude <= 90.0 &&
      longitude >= -180.0 &&
      longitude <= 180.0 &&
      !(latitude == 0.0 && longitude == 0.0);

  String get displayMapName => mapName ?? name;

  double get availabilityRatio =>
      totalSlots > 0 ? (availableSlots / totalSlots).clamp(0.0, 1.0) : 0.0;
}
