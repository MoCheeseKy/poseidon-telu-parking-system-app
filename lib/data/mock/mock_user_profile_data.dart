import 'package:flutter/foundation.dart';
import 'package:poseidon/data/mock/mock_parking_data.dart';
import 'package:poseidon/data/models/parking_location.dart';

class UserProfileData {
  final String fullName;
  final String nim;
  final String faculty;
  final String studyProgram;
  final String email;
  final String phoneNumber;
  final bool isSsoVerified;

  const UserProfileData({
    required this.fullName,
    required this.nim,
    required this.faculty,
    required this.studyProgram,
    required this.email,
    required this.phoneNumber,
    this.isSsoVerified = true,
  });

  String get firstName {
    final trimmed = fullName.trim();
    if (trimmed.isEmpty) return 'Mahasiswa';
    return trimmed.split(RegExp(r'\s+')).first;
  }

  UserProfileData copyWith({
    String? fullName,
    String? nim,
    String? faculty,
    String? studyProgram,
    String? email,
    String? phoneNumber,
    bool? isSsoVerified,
  }) {
    return UserProfileData(
      fullName: fullName ?? this.fullName,
      nim: nim ?? this.nim,
      faculty: faculty ?? this.faculty,
      studyProgram: studyProgram ?? this.studyProgram,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      isSsoVerified: isSsoVerified ?? this.isSsoVerified,
    );
  }
}

class RegisteredVehicle {
  final String id;
  final String name;
  final String plateNumber;
  final VehicleType vehicleType;
  final String colorLabel;
  final bool isPrimary;

  const RegisteredVehicle({
    required this.id,
    required this.name,
    required this.plateNumber,
    required this.vehicleType,
    required this.colorLabel,
    this.isPrimary = false,
  });

  RegisteredVehicle copyWith({
    String? id,
    String? name,
    String? plateNumber,
    VehicleType? vehicleType,
    String? colorLabel,
    bool? isPrimary,
  }) {
    return RegisteredVehicle(
      id: id ?? this.id,
      name: name ?? this.name,
      plateNumber: plateNumber ?? this.plateNumber,
      vehicleType: vehicleType ?? this.vehicleType,
      colorLabel: colorLabel ?? this.colorLabel,
      isPrimary: isPrimary ?? this.isPrimary,
    );
  }
}

class NotificationPreferences {
  final bool reportStatusUpdates;
  final bool parkingFullAlerts;
  final bool sensorOfflineAlerts;
  final bool campusTrafficInfo;
  final bool quietHoursEnabled;

  const NotificationPreferences({
    this.reportStatusUpdates = true,
    this.parkingFullAlerts = true,
    this.sensorOfflineAlerts = true,
    this.campusTrafficInfo = true,
    this.quietHoursEnabled = false,
  });

  NotificationPreferences copyWith({
    bool? reportStatusUpdates,
    bool? parkingFullAlerts,
    bool? sensorOfflineAlerts,
    bool? campusTrafficInfo,
    bool? quietHoursEnabled,
  }) {
    return NotificationPreferences(
      reportStatusUpdates: reportStatusUpdates ?? this.reportStatusUpdates,
      parkingFullAlerts: parkingFullAlerts ?? this.parkingFullAlerts,
      sensorOfflineAlerts: sensorOfflineAlerts ?? this.sensorOfflineAlerts,
      campusTrafficInfo: campusTrafficInfo ?? this.campusTrafficInfo,
      quietHoursEnabled: quietHoursEnabled ?? this.quietHoursEnabled,
    );
  }
}

class UserProfileStore extends ChangeNotifier {
  UserProfileStore()
    : _isLoggedIn = true,
      _profile = MockUserProfileData.defaultProfile,
      _vehicles = List<RegisteredVehicle>.from(
        MockUserProfileData.defaultVehicles,
      ),
      _favoriteParkingIds = List<String>.from(
        MockUserProfileData.defaultFavoriteIds,
      ),
      _notificationPreferences = const NotificationPreferences();

  bool _isLoggedIn;
  UserProfileData _profile;
  List<RegisteredVehicle> _vehicles;
  List<String> _favoriteParkingIds;
  NotificationPreferences _notificationPreferences;

  bool get isLoggedIn => _isLoggedIn;
  UserProfileData get profile => _profile;
  List<RegisteredVehicle> get vehicles => List.unmodifiable(_vehicles);
  List<String> get favoriteParkingIds => List.unmodifiable(_favoriteParkingIds);
  NotificationPreferences get notificationPreferences =>
      _notificationPreferences;

  void login({String? email, String? password}) {
    _isLoggedIn = true;
    if (email != null && email.trim().isNotEmpty) {
      _profile = _profile.copyWith(email: email.trim());
    }
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    notifyListeners();
  }

  RegisteredVehicle? get primaryVehicle {
    if (_vehicles.isEmpty) return null;
    return _vehicles.firstWhere(
      (v) => v.isPrimary,
      orElse: () => _vehicles.first,
    );
  }

  List<ParkingLocation> get favoriteLocations {
    final all = MockParkingData.allLocations;
    return _favoriteParkingIds
        .map((id) => all.where((loc) => loc.id == id).firstOrNull)
        .whereType<ParkingLocation>()
        .toList();
  }

  void updateProfile(UserProfileData updated) {
    _profile = updated;
    notifyListeners();
  }

  void addVehicle({
    required String name,
    required String plateNumber,
    required VehicleType vehicleType,
    required String colorLabel,
    bool setAsPrimary = false,
  }) {
    final shouldBePrimary = setAsPrimary || _vehicles.isEmpty;
    if (shouldBePrimary) {
      _vehicles = _vehicles.map((v) => v.copyWith(isPrimary: false)).toList();
    }
    _vehicles = [
      ..._vehicles,
      RegisteredVehicle(
        id: 'veh_${DateTime.now().microsecondsSinceEpoch}',
        name: name.trim(),
        plateNumber: plateNumber.trim().toUpperCase(),
        vehicleType: vehicleType,
        colorLabel: colorLabel.trim().isEmpty ? 'Hitam' : colorLabel.trim(),
        isPrimary: shouldBePrimary,
      ),
    ];
    notifyListeners();
  }

  void setPrimaryVehicle(String id) {
    _vehicles = _vehicles
        .map((v) => v.copyWith(isPrimary: v.id == id))
        .toList();
    notifyListeners();
  }

  void removeVehicle(String id) {
    _vehicles = _vehicles.where((v) => v.id != id).toList();
    if (_vehicles.isNotEmpty && !_vehicles.any((v) => v.isPrimary)) {
      _vehicles[0] = _vehicles[0].copyWith(isPrimary: true);
    }
    notifyListeners();
  }

  bool isFavoriteParking(String locationId) {
    return _favoriteParkingIds.contains(locationId);
  }

  void toggleFavoriteParking(String locationId) {
    if (_favoriteParkingIds.contains(locationId)) {
      _favoriteParkingIds = _favoriteParkingIds
          .where((id) => id != locationId)
          .toList();
    } else {
      _favoriteParkingIds = [..._favoriteParkingIds, locationId];
    }
    notifyListeners();
  }

  void updateNotificationPreferences(NotificationPreferences updated) {
    _notificationPreferences = updated;
    notifyListeners();
  }

  void resetToDefault() {
    _isLoggedIn = true;
    _profile = MockUserProfileData.defaultProfile;
    _vehicles = List<RegisteredVehicle>.from(
      MockUserProfileData.defaultVehicles,
    );
    _favoriteParkingIds = List<String>.from(
      MockUserProfileData.defaultFavoriteIds,
    );
    _notificationPreferences = const NotificationPreferences();
    notifyListeners();
  }
}

class MockUserProfileData {
  MockUserProfileData._();

  static final UserProfileStore sharedStore = UserProfileStore();

  static const UserProfileData defaultProfile = UserProfileData(
    fullName: 'Rifky Muhammad Prayudhi',
    nim: '103022400003',
    faculty: 'Fakultas Informatika (FIF)',
    studyProgram: 'S1 Rekayasa Perangkat Lunak',
    email: 'rifkymuhammad@student.telkomuniversity.ac.id',
    phoneNumber: '+6281210714320',
    isSsoVerified: true,
  );

  static const List<RegisteredVehicle> defaultVehicles = [
    RegisteredVehicle(
      id: 'veh_1',
      name: 'Honda Vario 160',
      plateNumber: 'D 1945 TEL',
      vehicleType: VehicleType.motor,
      colorLabel: 'Hitam Matte',
      isPrimary: true,
    ),
    RegisteredVehicle(
      id: 'veh_2',
      name: 'Toyota Raize GR',
      plateNumber: 'D 1024 TLU',
      vehicleType: VehicleType.mobil,
      colorLabel: 'Putih',
      isPrimary: false,
    ),
  ];

  static const List<String> defaultFavoriteIds = [
    'tult_motor',
    'gku_motor',
    'tult_mobil',
  ];
}

