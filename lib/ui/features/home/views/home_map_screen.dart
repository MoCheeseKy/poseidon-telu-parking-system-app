import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:poseidon/core/constants/app_colors.dart';
import 'package:poseidon/data/mock/mock_parking_data.dart';
import 'package:poseidon/data/mock/mock_user_profile_data.dart';
import 'package:poseidon/data/models/building.dart';
import 'package:poseidon/data/models/parking_location.dart';
import 'package:poseidon/services/location_service.dart';
import 'package:poseidon/services/recommendation_service.dart';
import 'package:poseidon/ui/core/widgets/app_bottom_nav_bar.dart';
import 'package:poseidon/ui/core/widgets/drag_handle.dart';
import 'package:poseidon/ui/core/widgets/interactive_map_canvas.dart';
import 'package:poseidon/ui/core/widgets/parking_item_tile.dart';
import 'package:poseidon/ui/core/widgets/poseidon_app_bar.dart';
import 'package:poseidon/ui/core/widgets/selected_parking_sheet.dart';
import 'package:poseidon/ui/core/widgets/vehicle_type_selector.dart';
import 'package:poseidon/ui/features/activity/views/activity_screen.dart';
import 'package:poseidon/ui/features/detail/views/parking_detail_sheet.dart';
import 'package:poseidon/ui/features/profile/views/profile_screen.dart';
import 'package:poseidon/ui/features/report/views/report_screen.dart';
import 'package:poseidon/ui/features/search/views/search_destination_sheet.dart';

class HomeMapScreen extends StatefulWidget {
  final LocationService locationService;

  const HomeMapScreen({
    super.key,
    this.locationService = const LocationService(),
  });

  @override
  State<HomeMapScreen> createState() => _HomeMapScreenState();
}

class _HomeMapScreenState extends State<HomeMapScreen> {
  int _currentNavIndex = 0;
  VehicleType _selectedVehicle = VehicleType.motor;

  late final ValueNotifier<ParkingLocation?> _selectedLocationNotifier;
  late final ValueNotifier<LatLng?> _userLocationNotifier;
  late final ValueNotifier<bool> _isRouteVisibleNotifier;
  late final ParkingMapController _parkingMapController;

  @override
  void initState() {
    super.initState();
    _selectedLocationNotifier = ValueNotifier<ParkingLocation?>(null);
    _userLocationNotifier = ValueNotifier<LatLng?>(null);
    _isRouteVisibleNotifier = ValueNotifier<bool>(true);
    _parkingMapController = ParkingMapController();
  }

  @override
  void dispose() {
    _selectedLocationNotifier.dispose();
    _userLocationNotifier.dispose();
    _isRouteVisibleNotifier.dispose();
    super.dispose();
  }

  bool get _isFocusModeActive {
    final hasSelection = _selectedLocationNotifier.value != null;
    final userPos = _userLocationNotifier.value;
    final hasUserPos = userPos != null &&
        Building.isValidCoordinate(userPos.latitude, userPos.longitude);
    final isRouteVisible = _isRouteVisibleNotifier.value;
    return isRouteVisible && hasSelection && hasUserPos;
  }

  void _openSearchSheet() {
    SearchDestinationSheet.show(
      context,
      initialVehicleType: _selectedVehicle,
      parkingLocations: MockParkingData.allLocations,
      onParkingSelected: (loc) =>
          _handleParkingSelected(loc, focusCamera: true),
    );
  }

  /// Triggers GPS request before entering mode fokus if GPS is not yet active.
  /// If permission is denied or GPS is disabled, prevents entering mode fokus.
  Future<void> _handleParkingSelected(
    ParkingLocation location, {
    bool focusCamera = false,
  }) async {
    // Check if valid GPS coordinates are already available
    final currentUserPos = _userLocationNotifier.value;
    if (currentUserPos != null &&
        Building.isValidCoordinate(
          currentUserPos.latitude,
          currentUserPos.longitude,
        )) {
      _enterFocusMode(location, focusCamera: focusCamera);
      return;
    }

    // GPS is not ready yet -> trigger GPS prompt first!
    final result = await widget.locationService.getCurrentLocation();
    if (!mounted) return;

    if (result.isSuccess && result.coordinates != null) {
      _userLocationNotifier.value = result.coordinates;
      _enterFocusMode(location, focusCamera: focusCamera);
      return;
    }

    // Permission denied or GPS disabled -> CANNOT enter mode fokus!
    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger != null) {
      messenger.hideCurrentSnackBar();
      SnackBarAction? action;
      if (result.status == LocationResultStatus.permissionPermanentlyDenied) {
        action = SnackBarAction(
          label: 'Pengaturan',
          textColor: Colors.white,
          onPressed: () => widget.locationService.openAppSettings(),
        );
      } else if (result.status == LocationResultStatus.serviceDisabled) {
        action = SnackBarAction(
          label: 'Aktifkan',
          textColor: Colors.white,
          onPressed: () => widget.locationService.openLocationSettings(),
        );
      }
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            result.status == LocationResultStatus.permissionDenied ||
                    result.status ==
                        LocationResultStatus.permissionPermanentlyDenied
                ? 'Izin GPS diperlukan untuk masuk ke mode fokus tujuan parkir.'
                : result.message,
          ),
          duration: const Duration(seconds: 3),
          backgroundColor: AppColors.textPrimary,
          action: action,
        ),
      );
    }
  }

  void _enterFocusMode(ParkingLocation location, {bool focusCamera = false}) {
    ScaffoldMessenger.maybeOf(context)?.hideCurrentSnackBar();
    final needsStateSync =
        _currentNavIndex != 0 || _selectedVehicle != location.vehicleType;
    if (needsStateSync) {
      setState(() {
        _currentNavIndex = 0;
        _selectedVehicle = location.vehicleType;
      });
    }

    _selectedLocationNotifier.value = location;
    _isRouteVisibleNotifier.value = true;

    if (focusCamera) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _parkingMapController.focusOnLocation(location);
      });
    }
  }

  void _openParkingDetail(ParkingLocation location) {
    ParkingDetailSheet.show(
      context,
      location: location,
      onStartNavigation: () => _handleParkingSelected(location, focusCamera: true),
    );
  }

  void _handleMarkerSelected(ParkingLocation location) {
    _handleParkingSelected(location, focusCamera: false);
  }

  void _clearSelectedLocation() {
    // If mode fokus is active, keep the user locked in map focus
    if (_isFocusModeActive) {
      return;
    }
    if (_selectedLocationNotifier.value != null) {
      _selectedLocationNotifier.value = null;
    }
  }

  void _cancelFocusMode() {
    _isRouteVisibleNotifier.value = false;
    _selectedLocationNotifier.value = null;
  }

  void _handleUserLocationUpdated(LatLng position) {
    _userLocationNotifier.value = position;
    _isRouteVisibleNotifier.value = true;
  }

  void _clearDemoRoute() {
    if (_isRouteVisibleNotifier.value) {
      _isRouteVisibleNotifier.value = false;
    }
  }

  String? _calculateCurrentDistanceText(ParkingLocation location) {
    final userPos = _userLocationNotifier.value;
    if (userPos == null ||
        !Building.isValidCoordinate(userPos.latitude, userPos.longitude) ||
        !location.hasValidCoordinates) {
      return null;
    }
    final meters = RecommendationService.calculateStraightLineDistanceMeters(
      startLatitude: userPos.latitude,
      startLongitude: userPos.longitude,
      endLatitude: location.latitude,
      endLongitude: location.longitude,
    );
    return RecommendationService.formatStraightLineDistance(meters);
  }

  @override
  Widget build(BuildContext context) {
    final mergedRouteListenables = Listenable.merge([
      _isRouteVisibleNotifier,
      _selectedLocationNotifier,
      _userLocationNotifier,
    ]);

    return AnimatedBuilder(
      animation: mergedRouteListenables,
      builder: (context, _) {
        final isFocusMode = _isFocusModeActive;

        return Scaffold(
          backgroundColor: _currentNavIndex == 0
              ? Colors.white
              : AppColors.pageBackground,
          appBar: isFocusMode
              ? null
              : PoseidonAppBar(
                  onProfileTap: () {
                    if (_currentNavIndex != 3) {
                      setState(() => _currentNavIndex = 3);
                    }
                  },
                ),
          body: _buildBody(isFocusMode),
          bottomNavigationBar: isFocusMode
              ? null
              : AppBottomNavBar(
                  currentIndex: _currentNavIndex,
                  onTabSelected: (index) {
                    setState(() {
                      _currentNavIndex = index;
                    });
                  },
                  onCenterAction: _openSearchSheet,
                ),
        );
      },
    );
  }

  Widget _buildBody(bool isFocusMode) {
    switch (_currentNavIndex) {
      case 1:
        return const ReportScreen(showScaffold: false);
      case 2:
        return const ActivityScreen(showScaffold: false);
      case 3:
        return ProfileScreen(
          showScaffold: false,
          onNavigateToParking: (loc) =>
              _handleParkingSelected(loc, focusCamera: true),
        );
      case 0:
      default:
        return _buildMapBody(isFocusMode);
    }
  }

  Widget _buildMapBody(bool isFocusMode) {
    final visibleLocations = MockParkingData.locationsByVehicle(
      _selectedVehicle,
    );
    final favoriteLocation = MockParkingData.favoriteByVehicle(
      _selectedVehicle,
    );
    final favoriteTarget = MockParkingData.primaryTultByVehicle(
      _selectedVehicle,
    );

    return Stack(
      children: [
        // Geographic Interactive Parking Map
        Positioned.fill(
          child: InteractiveMapCanvas(
            locations: visibleLocations,
            selectedLocationListenable: _selectedLocationNotifier,
            userLocationListenable: _userLocationNotifier,
            routeVisibleListenable: _isRouteVisibleNotifier,
            controller: _parkingMapController,
            locationService: widget.locationService,
            onMarkerTap: _handleMarkerSelected,
            onUserLocationUpdated: _handleUserLocationUpdated,
            onClearRoute: _clearDemoRoute,
            onMapTap: _clearSelectedLocation,
          ),
        ),

        // Bottom Sheet Switcher: Default Parking List vs Compact Selected Marker Info
        ValueListenableBuilder<ParkingLocation?>(
          valueListenable: _selectedLocationNotifier,
          builder: (context, selectedLocation, listSheet) {
            return Stack(
              children: [
                Visibility(
                  visible: selectedLocation == null,
                  maintainState: true,
                  child: listSheet!,
                ),
                if (selectedLocation != null)
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: SelectedParkingSheet(
                      location: selectedLocation,
                      distanceText: _calculateCurrentDistanceText(
                        selectedLocation,
                      ),
                      onClose: _cancelFocusMode,
                      onCancelDestination: _cancelFocusMode,
                      onOpenDetail: () => _openParkingDetail(selectedLocation),
                    ),
                  ),
              ],
            );
          },
          child: DraggableScrollableSheet(
            initialChildSize: 0.50,
            minChildSize: 0.40,
            maxChildSize: 0.88,
            snap: true,
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(24.0),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10.0,
                      offset: Offset(0, -2),
                    ),
                  ],
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 600.0),
                    child: ListView(
                      controller: scrollController,
                      padding: const EdgeInsets.fromLTRB(20.0, 8.0, 20.0, 20.0),
                      physics: const BouncingScrollPhysics(),
                      children: [
                        const DragHandle(),

                        // Greeting
                        ListenableBuilder(
                          listenable: MockUserProfileData.sharedStore,
                          builder: (context, _) {
                            final firstName = MockUserProfileData
                                .sharedStore
                                .profile
                                .firstName;
                            return Text(
                              'Halo! $firstName',
                              style: const TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textPrimary,
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 4.0),
                        const Text(
                          'Pastikan parkir ditempat terbaik sebelum menuju gedung tujuan ya!',
                          style: TextStyle(
                            fontSize: 13.0,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textSecondary,
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: 16.0),

                        // Segmented Vehicle Selector
                        VehicleTypeSelector(
                          selectedType: _selectedVehicle,
                          onTypeChanged: (type) {
                            if (_selectedVehicle == type) return;
                            if (_selectedLocationNotifier.value?.vehicleType !=
                                type) {
                              _selectedLocationNotifier.value = null;
                            }
                            setState(() {
                              _selectedVehicle = type;
                            });
                          },
                        ),
                        const SizedBox(height: 20.0),

                        // Section: FAVORIT TERSIMPAN
                        const Text(
                          'FAVORIT TERSIMPAN',
                          style: TextStyle(
                            fontSize: 11.0,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.8,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 8.0),

                        // Favorite Item Tile (TULT Motor / Mobil)
                        ParkingItemTile(
                          location: favoriteLocation,
                          onTap: () => _openParkingDetail(favoriteTarget),
                        ),
                        const SizedBox(height: 16.0),

                        // Section: SEMUA LOKASI PARKIR
                        const Text(
                          'SEMUA LOKASI PARKIR',
                          style: TextStyle(
                            fontSize: 11.0,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.8,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 6.0),

                        // Filtered parking items by selected vehicle type
                        ...visibleLocations.map(
                          (loc) => ParkingItemTile(
                            location: loc,
                            onTap: () => _openParkingDetail(loc),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
