import 'dart:math' as math;

import 'package:poseidon/data/models/building.dart';
import 'package:poseidon/data/models/building_distance.dart';
import 'package:poseidon/data/models/parking_location.dart';

class ParkingRecommendation {
  final ParkingLocation parkingLocation;
  final double straightLineDistanceMeters;

  const ParkingRecommendation({
    required this.parkingLocation,
    required this.straightLineDistanceMeters,
  });

  int get roundedStraightLineMeters => straightLineDistanceMeters.round();
  String get formattedStraightLineDistance {
    return RecommendationService.formatStraightLineDistance(
      straightLineDistanceMeters,
    );
  }
}

enum RecommendationEmptyReason {
  none,
  noDestinationSelected,
  invalidDestinationCoordinates,
  emptyParkingList,
  noCompatibleVehicleParking,
  allCompatibleParkingUnavailable,
}

class RecommendationResult {
  final Building? destination;
  final VehicleType vehicleType;
  final ParkingRecommendation? bestRecommendation;
  final List<ParkingRecommendation> alternatives;
  final RecommendationEmptyReason emptyReason;

  const RecommendationResult({
    required this.destination,
    required this.vehicleType,
    this.bestRecommendation,
    this.alternatives = const [],
    this.emptyReason = RecommendationEmptyReason.none,
  });

  bool get hasRecommendation => bestRecommendation != null;

  String get vehicleLabel =>
      vehicleType == VehicleType.motor ? 'Motor' : 'Mobil';

  String get emptyStateTitle {
    switch (emptyReason) {
      case RecommendationEmptyReason.none:
        return '';
      case RecommendationEmptyReason.noDestinationSelected:
        return 'Pilih Gedung Tujuan';
      case RecommendationEmptyReason.invalidDestinationCoordinates:
        return 'Koordinat Gedung Tidak Valid';
      case RecommendationEmptyReason.emptyParkingList:
        return 'Data Parkir Kosong';
      case RecommendationEmptyReason.noCompatibleVehicleParking:
        return 'Tidak Ada Parkiran $vehicleLabel';
      case RecommendationEmptyReason.allCompatibleParkingUnavailable:
        return 'Parkiran $vehicleLabel Sedang Penuh';
    }
  }

  String get emptyStateMessage {
    switch (emptyReason) {
      case RecommendationEmptyReason.none:
        return '';
      case RecommendationEmptyReason.noDestinationSelected:
        return 'Silakan cari dan pilih gedung tujuan terlebih dahulu.';
      case RecommendationEmptyReason.invalidDestinationCoordinates:
        return 'Data koordinat pintu gedung belum tersedia untuk menghitung estimasi jarak.';
      case RecommendationEmptyReason.emptyParkingList:
        return 'Belum ada data lokasi parkir yang terdaftar saat ini.';
      case RecommendationEmptyReason.noCompatibleVehicleParking:
        return 'Belum tersedia area parkir khusus $vehicleLabel pada daftar lokasi.';
      case RecommendationEmptyReason.allCompatibleParkingUnavailable:
        return 'Seluruh kantong parkir $vehicleLabel yang tersedia saat ini sedang penuh atau offline.';
    }
  }
}

class RecommendationService {
  static const double _earthRadiusMeters = 6371000.0;
  const RecommendationService();

  RecommendationResult recommend({
    required Building? destination,
    required VehicleType vehicleType,
    required List<ParkingLocation> parkingLocations,
    int maxAlternatives = 3,
  }) {
    if (destination == null) {
      return RecommendationResult(
        destination: null,
        vehicleType: vehicleType,
        emptyReason: RecommendationEmptyReason.noDestinationSelected,
      );
    }

    if (!destination.hasValidEntranceCoordinates) {
      return RecommendationResult(
        destination: destination,
        vehicleType: vehicleType,
        emptyReason: RecommendationEmptyReason.invalidDestinationCoordinates,
      );
    }

    if (parkingLocations.isEmpty) {
      return RecommendationResult(
        destination: destination,
        vehicleType: vehicleType,
        emptyReason: RecommendationEmptyReason.emptyParkingList,
      );
    }

    final vehicleCompatible = parkingLocations
        .where((loc) => loc.vehicleType == vehicleType)
        .toList();

    if (vehicleCompatible.isEmpty) {
      return RecommendationResult(
        destination: destination,
        vehicleType: vehicleType,
        emptyReason: RecommendationEmptyReason.noCompatibleVehicleParking,
      );
    }

    final eligibleRecommendations = <ParkingRecommendation>[];

    for (final loc in vehicleCompatible) {
      if (loc.availableSlots <= 0) continue;
      if (loc.status == ParkingStatus.full ||
          loc.status == ParkingStatus.offline) {
        continue;
      }
      if (!loc.hasValidCoordinates) continue;

      final distanceMeters = calculateStraightLineDistanceMeters(
        startLatitude: loc.latitude,
        startLongitude: loc.longitude,
        endLatitude: destination.entranceLatitude,
        endLongitude: destination.entranceLongitude,
      );
      if (!distanceMeters.isFinite) continue;

      eligibleRecommendations.add(
        ParkingRecommendation(
          parkingLocation: loc,
          straightLineDistanceMeters: distanceMeters,
        ),
      );
    }

    if (eligibleRecommendations.isEmpty) {
      return RecommendationResult(
        destination: destination,
        vehicleType: vehicleType,
        emptyReason: RecommendationEmptyReason.allCompatibleParkingUnavailable,
      );
    }

    eligibleRecommendations.sort((a, b) {
      final distanceComparison = a.straightLineDistanceMeters.compareTo(
        b.straightLineDistanceMeters,
      );
      if (distanceComparison != 0) return distanceComparison;

      final slotComparison = b.parkingLocation.availableSlots.compareTo(
        a.parkingLocation.availableSlots,
      );
      if (slotComparison != 0) return slotComparison;

      return a.parkingLocation.id.compareTo(b.parkingLocation.id);
    });

    final best = eligibleRecommendations.first;
    final alternatives = maxAlternatives <= 0
        ? const <ParkingRecommendation>[]
        : eligibleRecommendations.skip(1).take(maxAlternatives).toList();

    return RecommendationResult(
      destination: destination,
      vehicleType: vehicleType,
      bestRecommendation: best,
      alternatives: List.unmodifiable(alternatives),
      emptyReason: RecommendationEmptyReason.none,
    );
  }

  List<BuildingDistance> calculateNearestBuildings({
    required ParkingLocation location,
    required List<Building> buildings,
    int limit = 3,
  }) {
    if (!location.hasValidCoordinates || buildings.isEmpty || limit <= 0) {
      return const [];
    }

    final pairs = <({Building building, double distance})>[];
    for (final building in buildings) {
      if (!building.hasValidEntranceCoordinates) continue;
      final distance = calculateStraightLineDistanceMeters(
        startLatitude: location.latitude,
        startLongitude: location.longitude,
        endLatitude: building.entranceLatitude,
        endLongitude: building.entranceLongitude,
      );
      if (distance.isFinite) {
        pairs.add((building: building, distance: distance));
      }
    }

    pairs.sort((a, b) => a.distance.compareTo(b.distance));

    return pairs
        .take(limit)
        .map(
          (entry) => BuildingDistance(
            buildingName: entry.building.name,
            distanceMeters: entry.distance.round(),
            isStraightLineEstimate: true,
          ),
        )
        .toList(growable: false);
  }

  static double calculateStraightLineDistanceMeters({
    required double startLatitude,
    required double startLongitude,
    required double endLatitude,
    required double endLongitude,
  }) {
    if (!Building.isValidCoordinate(startLatitude, startLongitude) ||
        !Building.isValidCoordinate(endLatitude, endLongitude)) {
      return double.nan;
    }

    final dLat = _degreesToRadians(endLatitude - startLatitude);
    final dLon = _degreesToRadians(endLongitude - startLongitude);

    final lat1Rad = _degreesToRadians(startLatitude);
    final lat2Rad = _degreesToRadians(endLatitude);

    final sinHalfLat = math.sin(dLat / 2.0);
    final sinHalfLon = math.sin(dLon / 2.0);

    final a =
        (sinHalfLat * sinHalfLat) +
        math.cos(lat1Rad) * math.cos(lat2Rad) * (sinHalfLon * sinHalfLon);
    final clampedA = a.clamp(0.0, 1.0);
    final c = 2.0 * math.atan2(math.sqrt(clampedA), math.sqrt(1.0 - clampedA));

    return _earthRadiusMeters * c;
  }

  static String formatStraightLineDistance(double meters) {
    if (!meters.isFinite || meters < 0) {
      return 'Jarak belum tersedia';
    }
    final rounded = meters.round();
    if (rounded < 1000) {
      return '±$rounded m garis lurus';
    }
    final km = (meters / 1000.0).toStringAsFixed(1).replaceAll('.', ',');
    return '±$km km garis lurus';
  }

  static double _degreesToRadians(double degrees) =>
      degrees * (math.pi / 180.0);
}

