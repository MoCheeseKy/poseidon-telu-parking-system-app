import 'package:latlong2/latlong.dart';
import 'package:poseidon/data/models/building_distance.dart';
import 'package:poseidon/data/models/parking_location.dart';

class RecommendedTarget {
  final String name;
  final String slotBadgeText;
  final String distanceText;
  final String vehicleText;
  final String destinationQuery;

  const RecommendedTarget({
    required this.name,
    required this.slotBadgeText,
    required this.distanceText,
    required this.vehicleText,
    required this.destinationQuery,
  });
}

class MockParkingData {
  MockParkingData._();
  static const LatLng telkomCampusCenter = LatLng(-6.9730, 107.6303);
  static const double defaultCampusZoom = 15.55;

  static const ParkingLocation gkuMotorParking = ParkingLocation(
    id: 'gku_motor',
    name: 'Parkiran GKU (Motor)',
    mapName: 'GKU',
    subArea: 'Kawasan Gedung Kuliah Umum (Tokong Nanas)',
    gateInfo: 'Masuk Dari Gate Barat',
    vehicleType: VehicleType.motor,
    availableSlots: 46,
    occupiedSlots: 154,
    totalSlots: 200,
    status: ParkingStatus.available,
    latitude: -6.971657,
    longitude: 107.629751,
  );

  static const ParkingLocation tultMotorParking = ParkingLocation(
    id: 'tult_motor',
    name: 'Parkiran TULT (Motor)',
    mapName: 'TULT',
    subArea: 'Kawasan Fakultas Informatika (FIF) & Fakultas Kedokteran (FK)',
    gateInfo: 'Masuk Dari Gate 1',
    vehicleType: VehicleType.motor,
    availableSlots: 84,
    occupiedSlots: 166,
    totalSlots: 250,
    status: ParkingStatus.available,
    latitude: -6.969603,
    longitude: 107.629208,
  );

  static const ParkingLocation asramaPutraMotorParking = ParkingLocation(
    id: 'asrama_putra_motor',
    name: 'Parkiran Asrama Putra (Motor)',
    mapName: 'Asrama Putra',
    subArea: 'Kawasan Asrama Putra Telkom University',
    gateInfo: 'Masuk Dari Akses Asrama',
    vehicleType: VehicleType.motor,
    availableSlots: 62,
    occupiedSlots: 118,
    totalSlots: 180,
    status: ParkingStatus.available,
    latitude: -6.970072,
    longitude: 107.627462,
  );

  static const ParkingLocation tjMartMotorParking = ParkingLocation(
    id: 'tj_mart_motor',
    name: 'Parkiran TJ Mart (Motor)',
    mapName: 'TJ Mart',
    subArea: 'Area TJ Mart & Kantin Asrama',
    gateInfo: 'Masuk Dari Gate Barat',
    vehicleType: VehicleType.motor,
    availableSlots: 14,
    occupiedSlots: 86,
    totalSlots: 100,
    status: ParkingStatus.warning,
    latitude: -6.971123,
    longitude: 107.628762,
  );

  static const ParkingLocation msuMotorParking = ParkingLocation(
    id: 'msu_motor',
    name: 'Parkiran MSU (Motor)',
    mapName: 'MSU',
    subArea: 'Kawasan Masjid Syamsul Ulum & Student Center',
    gateInfo: 'Masuk Dari Gate Utama (Gate 1)',
    vehicleType: VehicleType.motor,
    availableSlots: 28,
    occupiedSlots: 112,
    totalSlots: 140,
    status: ParkingStatus.available,
    latitude: -6.976220,
    longitude: 107.632143,
  );

  static const ParkingLocation fitMotorParking = ParkingLocation(
    id: 'fit_motor',
    name: 'Parkiran FIT (Motor)',
    mapName: 'FIT',
    subArea: 'Kawasan Fakultas Ilmu Terapan (Selaru)',
    gateInfo: 'Masuk Dari Gate Utama FIT',
    vehicleType: VehicleType.motor,
    availableSlots: 52,
    occupiedSlots: 108,
    totalSlots: 160,
    status: ParkingStatus.available,
    latitude: -6.972555,
    longitude: 107.632042,
  );

  static const ParkingLocation fksMotorParking = ParkingLocation(
    id: 'fks_motor',
    name: 'Parkiran FKS (Motor)',
    mapName: 'FKS',
    subArea: 'Kawasan Fakultas Komunikasi dan Ilmu Sosial',
    gateInfo: 'Masuk Dari Gate Timur',
    vehicleType: VehicleType.motor,
    availableSlots: 0,
    occupiedSlots: 120,
    totalSlots: 120,
    status: ParkingStatus.full,
    customStatusText: 'Penuh',
    latitude: -6.972404,
    longitude: 107.633192,
  );

  static const ParkingLocation febMotorParking = ParkingLocation(
    id: 'feb_motor',
    name: 'Parkiran FEB (Motor)',
    mapName: 'FEB',
    subArea: 'Kawasan Fakultas Ekonomi dan Bisnis (FEB)',
    gateInfo: 'Masuk Dari Gate Utara',
    vehicleType: VehicleType.motor,
    availableSlots: 18,
    occupiedSlots: 132,
    totalSlots: 150,
    status: ParkingStatus.warning,
    latitude: -6.971208,
    longitude: 107.631700,
  );

  static const ParkingLocation btpMotorParking = ParkingLocation(
    id: 'btp_motor',
    name: 'Parkiran BTP (Motor)',
    mapName: 'BTP',
    subArea: 'Kawasan Bandung Techno Park (BTP)',
    gateInfo: 'Masuk Dari Gate BTP',
    vehicleType: VehicleType.motor,
    availableSlots: 55,
    occupiedSlots: 95,
    totalSlots: 150,
    status: ParkingStatus.available,
    latitude: -6.970146,
    longitude: 107.630744,
  );

  static const ParkingLocation gkuMobilParking = ParkingLocation(
    id: 'gku_mobil',
    name: 'Parkiran GKU (Mobil)',
    mapName: 'GKU',
    subArea: 'Kawasan Gedung Kuliah Umum (Tokong Nanas)',
    gateInfo: 'Masuk Dari Gate Barat',
    vehicleType: VehicleType.mobil,
    availableSlots: 12,
    occupiedSlots: 78,
    totalSlots: 90,
    status: ParkingStatus.warning,
    latitude: -6.972302,
    longitude: 107.629696,
  );

  static const ParkingLocation tultMobilParking = ParkingLocation(
    id: 'tult_mobil',
    name: 'Parkiran TULT (Mobil)',
    mapName: 'TULT',
    subArea: 'Kawasan Telkom University Landmark Tower',
    gateInfo: 'Masuk Dari Gate 1',
    vehicleType: VehicleType.mobil,
    availableSlots: 34,
    occupiedSlots: 86,
    totalSlots: 120,
    status: ParkingStatus.available,
    latitude: -6.969427,
    longitude: 107.628468,
  );

  static const ParkingLocation tuchMobilParking = ParkingLocation(
    id: 'tuch_mobil',
    name: 'Parkiran TUCH (Mobil)',
    mapName: 'TUCH',
    subArea: 'Kawasan Telkom University Convention Hall',
    gateInfo: 'Masuk Dari Gate Utara',
    vehicleType: VehicleType.mobil,
    availableSlots: 45,
    occupiedSlots: 65,
    totalSlots: 110,
    status: ParkingStatus.available,
    latitude: -6.971005,
    longitude: 107.631325,
  );

  static const ParkingLocation cacukMobilParking = ParkingLocation(
    id: 'cacuk_mobil',
    name: 'Parkiran Cacuk (Mobil)',
    mapName: 'Cacuk',
    subArea: 'Kawasan Fakultas Rekayasa Industri (FRI)',
    gateInfo: 'Masuk Dari Gate Utama (Gate 1)',
    vehicleType: VehicleType.mobil,
    availableSlots: 42,
    occupiedSlots: 58,
    totalSlots: 100,
    status: ParkingStatus.available,
    latitude: -6.974600,
    longitude: 107.631629,
  );

  static const ParkingLocation fitMobilParking = ParkingLocation(
    id: 'fit_mobil',
    name: 'Parkiran FIT (Mobil)',
    mapName: 'FIT',
    subArea: 'Kawasan Fakultas Ilmu Terapan (FIT)',
    gateInfo: 'Masuk Dari Gate Utama FIT',
    vehicleType: VehicleType.mobil,
    availableSlots: 8,
    occupiedSlots: 52,
    totalSlots: 60,
    status: ParkingStatus.warning,
    latitude: -6.972073,
    longitude: 107.631579,
  );

  static const ParkingLocation btpMobilParking = ParkingLocation(
    id: 'btp_mobil',
    name: 'Parkiran BTP (Mobil)',
    mapName: 'BTP',
    subArea: 'Kawasan Bandung Techno Park (BTP)',
    gateInfo: 'Masuk Dari Gate BTP',
    vehicleType: VehicleType.mobil,
    availableSlots: 29,
    occupiedSlots: 51,
    totalSlots: 80,
    status: ParkingStatus.available,
    latitude: -6.970586,
    longitude: 107.630887,
  );

  static const ParkingLocation penambulaiMobilParking = ParkingLocation(
    id: 'penambulai_mobil',
    name: 'Parkiran Penambulai (Mobil)',
    mapName: 'Penambulai',
    subArea: 'Kawasan Gedung Penambulai & Rektorat',
    gateInfo: 'Masuk Dari Gate Selatan',
    vehicleType: VehicleType.mobil,
    availableSlots: 16,
    occupiedSlots: 44,
    totalSlots: 60,
    status: ParkingStatus.available,
    latitude: -6.975767,
    longitude: 107.630290,
  );

  static const ParkingLocation gedungDamarMobilParking = ParkingLocation(
    id: 'damar_mobil',
    name: 'Parkiran Gedung Damar (Mobil)',
    mapName: 'Damar',
    subArea: 'Kawasan Gedung Damar & Open Library',
    gateInfo: 'Masuk Dari Gate Selatan',
    vehicleType: VehicleType.mobil,
    availableSlots: 0,
    occupiedSlots: 65,
    totalSlots: 65,
    status: ParkingStatus.full,
    customStatusText: 'Penuh',
    latitude: -6.975159,
    longitude: 107.629929,
  );

  static const ParkingLocation gedungEfMobilParking = ParkingLocation(
    id: 'gedung_ef_mobil',
    name: 'Parkiran Gedung E & F (Mobil)',
    mapName: 'Gedung E & F',
    subArea: 'Kawasan Gedung Kuliah E & F',
    gateInfo: 'Masuk Dari Gate Selatan (Gate 3)',
    vehicleType: VehicleType.mobil,
    availableSlots: 19,
    occupiedSlots: 51,
    totalSlots: 70,
    status: ParkingStatus.available,
    latitude: -6.976591,
    longitude: 107.630792,
  );

  static const ParkingLocation favoriteTultMotorParking = ParkingLocation(
    id: 'favorite_tult_motor',
    name: 'Parkiran TULT (Motor)',
    mapName: 'Parkiran TULT',
    subArea: 'Kawasan Fakultas Informatika (FIF) & Fakultas Kedokteran (FK)',
    gateInfo: 'Masuk Dari Gate 1',
    vehicleType: VehicleType.motor,
    availableSlots: 84,
    occupiedSlots: 166,
    totalSlots: 250,
    status: ParkingStatus.available,
    isFavorite: true,
    latitude: -6.969603,
    longitude: 107.629208,
  );

  static const ParkingLocation favoriteTultMobilParking = ParkingLocation(
    id: 'favorite_tult_mobil',
    name: 'Parkiran TULT (Mobil)',
    mapName: 'Parkiran TULT',
    subArea: 'Kawasan Telkom University Landmark Tower',
    gateInfo: 'Masuk Dari Gate 1',
    vehicleType: VehicleType.mobil,
    availableSlots: 34,
    occupiedSlots: 86,
    totalSlots: 120,
    status: ParkingStatus.available,
    isFavorite: true,
    latitude: -6.969427,
    longitude: 107.628468,
  );

  static const ParkingLocation favoriteTultParking = favoriteTultMotorParking;
  static const ParkingLocation tultParking = tultMotorParking;

  static const List<ParkingLocation> motorLocations = [
    gkuMotorParking,
    tultMotorParking,
    asramaPutraMotorParking,
    tjMartMotorParking,
    msuMotorParking,
    fitMotorParking,
    fksMotorParking,
    febMotorParking,
    btpMotorParking,
  ];

  static const List<ParkingLocation> mobilLocations = [
    gkuMobilParking,
    tultMobilParking,
    tuchMobilParking,
    cacukMobilParking,
    fitMobilParking,
    btpMobilParking,
    penambulaiMobilParking,
    gedungDamarMobilParking,
    gedungEfMobilParking,
  ];

  static const List<ParkingLocation> allLocations = [
    gkuMotorParking,
    gkuMobilParking,
    tultMotorParking,
    tultMobilParking,
    asramaPutraMotorParking,
    tuchMobilParking,
    tjMartMotorParking,
    msuMotorParking,
    cacukMobilParking,
    fitMotorParking,
    fitMobilParking,
    fksMotorParking,
    febMotorParking,
    btpMobilParking,
    btpMotorParking,
    penambulaiMobilParking,
    gedungDamarMobilParking,
    gedungEfMobilParking,
  ];

  static List<ParkingLocation> locationsByVehicle(VehicleType type) {
    return type == VehicleType.motor ? motorLocations : mobilLocations;
  }

  static ParkingLocation favoriteByVehicle(VehicleType type) {
    return type == VehicleType.motor
        ? favoriteTultMotorParking
        : favoriteTultMobilParking;
  }

  static ParkingLocation primaryTultByVehicle(VehicleType type) {
    return type == VehicleType.motor ? tultMotorParking : tultMobilParking;
  }

  static const RecommendedTarget recommendation = RecommendedTarget(
    name: 'Parkiran TULT',
    slotBadgeText: 'Slot 12',
    distanceText: '160 m dari tujuan',
    vehicleText: 'Motor & Mobil',
    destinationQuery: 'Gedung TULT',
  );

  static const List<ParkingLocation> searchAlternatives = [
    gkuMotorParking,
    fitMotorParking,
  ];

  static const List<BuildingDistance> tultNearestBuildings = [
    BuildingDistance(buildingName: 'Gedung TULT', distanceMeters: 160),
    BuildingDistance(
      buildingName: 'Gedung Fakultas Kedokteran',
      distanceMeters: 280,
    ),
    BuildingDistance(buildingName: 'Asrama Pria', distanceMeters: 350),
  ];
}
