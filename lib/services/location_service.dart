import 'dart:async';

import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:poseidon/data/models/building.dart';

enum LocationResultStatus {
  success,
  serviceDisabled,
  permissionDenied,
  permissionPermanentlyDenied,
  error,
}

class LocationServiceResult {
  final LocationResultStatus status;
  final LatLng? coordinates;
  final String message;

  const LocationServiceResult._({
    required this.status,
    required this.message,
    this.coordinates,
  });

  const LocationServiceResult.success(
    LatLng position, {
    String message = 'Lokasi saat ini berhasil ditemukan.',
  }) : this._(
         status: LocationResultStatus.success,
         coordinates: position,
         message: message,
       );

  const LocationServiceResult.failure({
    required LocationResultStatus status,
    required String message,
  }) : this._(status: status, message: message);

  bool get isSuccess =>
      status == LocationResultStatus.success && coordinates != null;
}

abstract class GeolocatorAdapter {
  Future<bool> isLocationServiceEnabled();
  Future<LocationPermission> checkPermission();
  Future<LocationPermission> requestPermission();
  Future<LatLng> getCurrentCoordinates({Duration timeLimit});
  Future<bool> openAppSettings();
  Future<bool> openLocationSettings();
}

class DefaultGeolocatorAdapter implements GeolocatorAdapter {
  const DefaultGeolocatorAdapter();

  @override
  Future<bool> isLocationServiceEnabled() {
    return Geolocator.isLocationServiceEnabled();
  }

  @override
  Future<LocationPermission> checkPermission() {
    return Geolocator.checkPermission();
  }

  @override
  Future<LocationPermission> requestPermission() {
    return Geolocator.requestPermission();
  }

  @override
  Future<LatLng> getCurrentCoordinates({
    Duration timeLimit = const Duration(seconds: 10),
  }) async {
    final position = await Geolocator.getCurrentPosition(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.high,
        timeLimit: timeLimit,
      ),
    );
    return LatLng(position.latitude, position.longitude);
  }

  @override
  Future<bool> openAppSettings() {
    return Geolocator.openAppSettings();
  }

  @override
  Future<bool> openLocationSettings() {
    return Geolocator.openLocationSettings();
  }
}

class LocationService {
  final GeolocatorAdapter adapter;
  final Duration timeout;

  const LocationService({
    this.adapter = const DefaultGeolocatorAdapter(),
    this.timeout = const Duration(seconds: 10),
  });

  Future<bool> isLocationServiceEnabled() async {
    try {
      return await adapter.isLocationServiceEnabled();
    } catch (_) {
      return false;
    }
  }

  Future<LocationPermission> checkPermission() async {
    return adapter.checkPermission();
  }

  Future<LocationPermission> requestPermission() async {
    return adapter.requestPermission();
  }

  Future<bool> openAppSettings() async {
    try {
      return await adapter.openAppSettings();
    } catch (_) {
      return false;
    }
  }

  Future<bool> openLocationSettings() async {
    try {
      return await adapter.openLocationSettings();
    } catch (_) {
      return false;
    }
  }

  Future<LocationServiceResult> getCurrentLocation() async {
    try {
      final serviceEnabled = await adapter.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return const LocationServiceResult.failure(
          status: LocationResultStatus.serviceDisabled,
          message:
              'Layanan lokasi (GPS) belum aktif. Nyalakan GPS perangkat Anda untuk melihat posisi saat ini.',
        );
      }

      var permission = await adapter.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await adapter.requestPermission();
      }

      if (permission == LocationPermission.denied) {
        return const LocationServiceResult.failure(
          status: LocationResultStatus.permissionDenied,
          message:
              'Izin lokasi ditolak. Aktifkan izin lokasi agar peta dapat menampilkan posisi Anda.',
        );
      }

      if (permission == LocationPermission.deniedForever) {
        return const LocationServiceResult.failure(
          status: LocationResultStatus.permissionPermanentlyDenied,
          message:
              'Izin lokasi ditolak permanen. Buka Pengaturan aplikasi untuk mengizinkan akses lokasi.',
        );
      }

      if (permission == LocationPermission.unableToDetermine) {
        return const LocationServiceResult.failure(
          status: LocationResultStatus.error,
          message:
              'Status izin lokasi tidak dapat ditentukan pada perangkat ini.',
        );
      }

      final coordinates = await adapter.getCurrentCoordinates(
        timeLimit: timeout,
      );

      if (!Building.isValidCoordinate(
        coordinates.latitude,
        coordinates.longitude,
      )) {
        return const LocationServiceResult.failure(
          status: LocationResultStatus.error,
          message:
              'Koordinat GPS tidak valid. Silakan coba beberapa saat lagi.',
        );
      }

      return LocationServiceResult.success(coordinates);
    } on LocationServiceDisabledException {
      return const LocationServiceResult.failure(
        status: LocationResultStatus.serviceDisabled,
        message:
            'Layanan lokasi (GPS) dinonaktifkan. Silakan aktifkan GPS perangkat Anda.',
      );
    } on PermissionDeniedException {
      return const LocationServiceResult.failure(
        status: LocationResultStatus.permissionDenied,
        message:
            'Akses lokasi tidak diizinkan. Peta tetap dapat digunakan secara manual.',
      );
    } on TimeoutException {
      return const LocationServiceResult.failure(
        status: LocationResultStatus.error,
        message:
            'Waktu pencarian sinyal GPS habis. Pastikan sinyal lokasi memadai lalu coba lagi.',
      );
    } on MissingPluginException {
      return const LocationServiceResult.failure(
        status: LocationResultStatus.error,
        message:
            'Fitur GPS belum didukung pada platform ini. Peta kampus tetap dapat digunakan.',
      );
    } on PlatformException {
      return const LocationServiceResult.failure(
        status: LocationResultStatus.error,
        message:
            'Gagal mengakses sensor lokasi perangkat. Silakan coba kembali.',
      );
    } catch (_) {
      return const LocationServiceResult.failure(
        status: LocationResultStatus.error,
        message:
            'Lokasi saat ini belum dapat dimuat. Anda tetap dapat menjelajahi peta parkir.',
      );
    }
  }
}
