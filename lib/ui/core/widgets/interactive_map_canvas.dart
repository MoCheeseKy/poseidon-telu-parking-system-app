import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:poseidon/core/constants/app_colors.dart';
import 'package:poseidon/data/mock/mock_parking_data.dart';
import 'package:poseidon/data/models/building.dart';
import 'package:poseidon/data/models/parking_location.dart';
import 'package:poseidon/services/location_service.dart';
import 'package:poseidon/services/recommendation_service.dart';
import 'package:poseidon/ui/core/widgets/parking_tooltip_marker.dart';

class ParkingMapController {
  VoidCallback? _onResetPosition;
  ValueChanged<ParkingLocation>? _onFocusLocation;
  Future<void> Function()? _onLocateCurrentUser;

  void _attach({
    required VoidCallback onResetPosition,
    required ValueChanged<ParkingLocation> onFocusLocation,
    required Future<void> Function() onLocateCurrentUser,
  }) {
    _onResetPosition = onResetPosition;
    _onFocusLocation = onFocusLocation;
    _onLocateCurrentUser = onLocateCurrentUser;
  }

  void _detach() {
    _onResetPosition = null;
    _onFocusLocation = null;
    _onLocateCurrentUser = null;
  }

  /// Resets map camera to the initial Telkom University Bandung campus view.
  void resetToInitialPosition() => _onResetPosition?.call();

  /// Centers and zooms the map onto [location].
  void focusOnLocation(ParkingLocation location) =>
      _onFocusLocation?.call(location);

  /// Explicitly requests current GPS position and centers the map on the user.
  Future<void> locateCurrentUser() =>
      _onLocateCurrentUser?.call() ?? Future<void>.value();
}

class InteractiveMapCanvas extends StatefulWidget {
  final List<ParkingLocation> locations;
  final ValueListenable<ParkingLocation?>? selectedLocationListenable;
  final ValueListenable<LatLng?>? userLocationListenable;
  final ValueListenable<bool>? routeVisibleListenable;
  final ValueChanged<ParkingLocation>? onMarkerTap;
  final ValueChanged<LatLng>? onUserLocationUpdated;
  final VoidCallback? onClearRoute;
  final VoidCallback? onMapTap;
  final ParkingMapController? controller;
  final LocationService locationService;
  final double initialBottomSheetFraction;

  const InteractiveMapCanvas({
    super.key,
    this.locations = MockParkingData.allLocations,
    this.selectedLocationListenable,
    this.userLocationListenable,
    this.routeVisibleListenable,
    this.onMarkerTap,
    this.onUserLocationUpdated,
    this.onClearRoute,
    this.onMapTap,
    this.controller,
    this.locationService = const LocationService(),
    this.initialBottomSheetFraction = 0.50,
  });

  @override
  State<InteractiveMapCanvas> createState() => _InteractiveMapCanvasState();
}

class _InteractiveMapCanvasState extends State<InteractiveMapCanvas> {
  static const double _minZoom = 13.5;
  static const double _maxZoom = 19.0;
  static const double _focusedZoom = 17.2;
  static const double _userLocationZoom = 16.6;

  late final MapController _mapController;
  late final NetworkTileProvider _tileProvider;
  late final ValueNotifier<ParkingLocation?> _fallbackSelectionNotifier;
  late final ValueNotifier<LatLng?> _fallbackUserLocationNotifier;
  late final ValueNotifier<bool> _fallbackRouteVisibleNotifier;

  bool _isMapReady = false;
  bool _isLocatingUser = false;
  Size _viewportSize = const Size(400.0, 730.0);

  ValueListenable<ParkingLocation?> get _selectionListenable =>
      widget.selectedLocationListenable ?? _fallbackSelectionNotifier;

  ValueListenable<LatLng?> get _userLocationListenable =>
      widget.userLocationListenable ?? _fallbackUserLocationNotifier;

  ValueListenable<bool> get _routeVisibleListenable =>
      widget.routeVisibleListenable ?? _fallbackRouteVisibleNotifier;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _tileProvider = NetworkTileProvider(silenceExceptions: true);
    _fallbackSelectionNotifier = ValueNotifier<ParkingLocation?>(null);
    _fallbackUserLocationNotifier = ValueNotifier<LatLng?>(null);
    _fallbackRouteVisibleNotifier = ValueNotifier<bool>(true);
    _attachController(widget.controller);
  }

  @override
  void didUpdateWidget(covariant InteractiveMapCanvas oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?._detach();
      _attachController(widget.controller);
    }
  }

  void _attachController(ParkingMapController? controller) {
    controller?._attach(
      onResetPosition: _resetToInitialPosition,
      onFocusLocation: _focusOnLocation,
      onLocateCurrentUser: _locateCurrentUser,
    );
  }

  @override
  void dispose() {
    widget.controller?._detach();
    _fallbackSelectionNotifier.dispose();
    _fallbackUserLocationNotifier.dispose();
    _fallbackRouteVisibleNotifier.dispose();
    _tileProvider.dispose();
    _mapController.dispose();
    super.dispose();
  }

  LatLng _offsetForBottomInset(
    LatLng target, {
    required double zoom,
    required double bottomInsetPx,
  }) {
    if (bottomInsetPx <= 0) return target;
    final degreesPerPixel = 360.0 / (256.0 * math.pow(2.0, zoom));
    final latitudeOffset = (bottomInsetPx * 0.5) * degreesPerPixel;
    return LatLng(target.latitude - latitudeOffset, target.longitude);
  }

  double get _currentBottomInsetPx {
    final hasSelection = _selectionListenable.value != null;
    return hasSelection
        ? 185.0
        : _viewportSize.height * widget.initialBottomSheetFraction;
  }

  LatLng _visibleFocusFromCamera(LatLng cameraCenter, double zoom) {
    final bottomInsetPx = _currentBottomInsetPx;
    if (bottomInsetPx <= 0) return cameraCenter;
    final degreesPerPixel = 360.0 / (256.0 * math.pow(2.0, zoom));
    final latitudeOffset = (bottomInsetPx * 0.5) * degreesPerPixel;
    return LatLng(
      cameraCenter.latitude + latitudeOffset,
      cameraCenter.longitude,
    );
  }

  LatLng _computeInitialCenter(Size size) {
    final hasSelection = _selectionListenable.value != null;
    final bottomInset = hasSelection
        ? 185.0
        : size.height * widget.initialBottomSheetFraction;
    return _offsetForBottomInset(
      MockParkingData.telkomCampusCenter,
      zoom: MockParkingData.defaultCampusZoom,
      bottomInsetPx: bottomInset,
    );
  }

  void _resetToInitialPosition() {
    if (!_isMapReady) return;
    final center = _computeInitialCenter(_viewportSize);
    _mapController.move(center, MockParkingData.defaultCampusZoom);
  }

  void _focusOnLocation(ParkingLocation location) {
    if (!_isMapReady || !location.hasValidCoordinates) return;
    final targetZoom = math.max(_mapController.camera.zoom, _focusedZoom);
    final adjustedCenter = _offsetForBottomInset(
      location.coordinates,
      zoom: targetZoom,
      bottomInsetPx: 185.0,
    );
    _mapController.move(adjustedCenter, targetZoom);
  }

  void _moveCameraToUserPosition(LatLng coordinates) {
    if (!_isMapReady) return;
    final targetZoom = math.max(_mapController.camera.zoom, _userLocationZoom);
    final adjustedCenter = _offsetForBottomInset(
      coordinates,
      zoom: targetZoom,
      bottomInsetPx: _currentBottomInsetPx,
    );
    _mapController.move(adjustedCenter, targetZoom);
  }

  Future<void> _locateCurrentUser() async {
    if (_isLocatingUser) return;
    setState(() {
      _isLocatingUser = true;
    });

    final result = await widget.locationService.getCurrentLocation();
    if (!mounted) return;

    setState(() {
      _isLocatingUser = false;
    });

    if (result.isSuccess && result.coordinates != null) {
      final position = result.coordinates!;
      if (widget.userLocationListenable == null) {
        _fallbackUserLocationNotifier.value = position;
      }
      if (widget.routeVisibleListenable == null) {
        _fallbackRouteVisibleNotifier.value = true;
      }
      widget.onUserLocationUpdated?.call(position);
      _moveCameraToUserPosition(position);
      return;
    }

    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger == null) return;

    messenger.hideCurrentSnackBar();
    SnackBarAction? action;
    if (result.status == LocationResultStatus.permissionPermanentlyDenied) {
      action = SnackBarAction(
        label: 'Pengaturan',
        textColor: Colors.white,
        onPressed: () {
          widget.locationService.openAppSettings();
        },
      );
    } else if (result.status == LocationResultStatus.serviceDisabled) {
      action = SnackBarAction(
        label: 'Aktifkan',
        textColor: Colors.white,
        onPressed: () {
          widget.locationService.openLocationSettings();
        },
      );
    }

    messenger.showSnackBar(
      SnackBar(
        content: Text(result.message),
        duration: const Duration(seconds: 3),
        backgroundColor: AppColors.textPrimary,
        action: action,
      ),
    );
  }

  void _zoomBy(double delta) {
    if (!_isMapReady) return;
    final camera = _mapController.camera;
    final nextZoom = (camera.zoom + delta).clamp(_minZoom, _maxZoom);
    if (nextZoom == camera.zoom) return;
    final visibleTarget = _visibleFocusFromCamera(camera.center, camera.zoom);
    final nextCenter = _offsetForBottomInset(
      visibleTarget,
      zoom: nextZoom,
      bottomInsetPx: _currentBottomInsetPx,
    );
    _mapController.move(nextCenter, nextZoom);
  }

  void _zoomIn() => _zoomBy(0.75);

  void _zoomOut() => _zoomBy(-0.75);

  void _handleMarkerTap(ParkingLocation location) {
    if (widget.selectedLocationListenable == null) {
      _fallbackSelectionNotifier.value = location;
    }
    if (widget.routeVisibleListenable == null) {
      _fallbackRouteVisibleNotifier.value = true;
    }
    widget.onMarkerTap?.call(location);
  }

  void _handleMapBackgroundTap() {
    if (widget.selectedLocationListenable == null) {
      _fallbackSelectionNotifier.value = null;
    }
    widget.onMapTap?.call();
  }

  void _handleClearDemoRoute() {
    if (widget.routeVisibleListenable == null) {
      _fallbackRouteVisibleNotifier.value = false;
    }
    widget.onClearRoute?.call();
  }

  @override
  Widget build(BuildContext context) {
    final validLocations = widget.locations
        .where((loc) => loc.hasValidCoordinates)
        .toList(growable: false);

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : MediaQuery.sizeOf(context).width;
        final height = constraints.maxHeight.isFinite
            ? constraints.maxHeight
            : MediaQuery.sizeOf(context).height;
        _viewportSize = Size(width, height);

        final initialCenter = _offsetForBottomInset(
          MockParkingData.telkomCampusCenter,
          zoom: MockParkingData.defaultCampusZoom,
          bottomInsetPx: height * widget.initialBottomSheetFraction,
        );

        final mergedRouteListenables = Listenable.merge([
          _selectionListenable,
          _userLocationListenable,
          _routeVisibleListenable,
        ]);

        return Stack(
          children: [
            // Geographic Interactive Map Layer (OpenStreetMap)
            Positioned.fill(
              child: FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter: initialCenter,
                  initialZoom: MockParkingData.defaultCampusZoom,
                  minZoom: _minZoom,
                  maxZoom: _maxZoom,
                  backgroundColor: AppColors.mapBg,
                  interactionOptions: const InteractionOptions(
                    flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
                  ),
                  onMapReady: () {
                    _isMapReady = true;
                  },
                  onTap: (_, _) => _handleMapBackgroundTap(),
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'id.ac.telkomuniversity.poseidon',
                    maxNativeZoom: 19,
                    tileDisplay: const TileDisplay.instantaneous(),
                    tileProvider: _tileProvider,
                  ),

                  // Demo-Only Straight-Line Visual Route Layer
                  // Shown only when user GPS location and a selected parking
                  // destination are both active and route display is enabled.
                  AnimatedBuilder(
                    animation: mergedRouteListenables,
                    builder: (context, _) {
                      final selected = _selectionListenable.value;
                      final userPos = _userLocationListenable.value;
                      final isRouteVisible = _routeVisibleListenable.value;

                      final canDrawDemoRoute =
                          isRouteVisible &&
                          selected != null &&
                          selected.hasValidCoordinates &&
                          userPos != null &&
                          Building.isValidCoordinate(
                            userPos.latitude,
                            userPos.longitude,
                          );

                      if (!canDrawDemoRoute) {
                        return const SizedBox.shrink();
                      }

                      return PolylineLayer(
                        key: const Key('demo_route_polyline_layer'),
                        polylines: [
                          Polyline(
                            points: [userPos, selected.coordinates],
                            color: AppColors.primaryRed.withValues(alpha: 0.85),
                            strokeWidth: 3.5,
                            pattern: StrokePattern.dashed(
                              segments: const [10.0, 6.0],
                            ),
                          ),
                        ],
                      );
                    },
                  ),

                  // Current User GPS Marker Layer
                  ValueListenableBuilder<LatLng?>(
                    valueListenable: _userLocationListenable,
                    builder: (context, userPos, _) {
                      if (userPos == null ||
                          !Building.isValidCoordinate(
                            userPos.latitude,
                            userPos.longitude,
                          )) {
                        return const SizedBox.shrink();
                      }
                      return MarkerLayer(
                        markers: [
                          Marker(
                            key: const Key('user_current_location_marker'),
                            point: userPos,
                            width: 30.0,
                            height: 30.0,
                            alignment: Alignment.center,
                            child: IgnorePointer(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: const Color(
                                    0xFF2563EB,
                                  ).withValues(alpha: 0.20),
                                  shape: BoxShape.circle,
                                ),
                                alignment: Alignment.center,
                                child: Container(
                                  width: 14.0,
                                  height: 14.0,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF2563EB),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 2.5,
                                    ),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 4.0,
                                        offset: Offset(0, 1),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),

                  // Custom Floating Tooltip Markers Layer (rebuilds only on selection change)
                  if (validLocations.isNotEmpty)
                    ValueListenableBuilder<ParkingLocation?>(
                      valueListenable: _selectionListenable,
                      builder: (context, selectedLocation, _) {
                        // Render selected marker last so it stays visually on top
                        final orderedLocations = <ParkingLocation>[
                          ...validLocations.where(
                            (loc) => loc.id != selectedLocation?.id,
                          ),
                          ...validLocations.where(
                            (loc) => loc.id == selectedLocation?.id,
                          ),
                        ];

                        return MarkerLayer(
                          markers: orderedLocations.map((location) {
                            final isSelected =
                                selectedLocation?.id == location.id;
                            return Marker(
                              key: ValueKey('map_marker_${location.id}'),
                              point: location.coordinates,
                              width: ParkingTooltipMarker.markerWidth,
                              height: ParkingTooltipMarker.markerHeight,
                              alignment: Alignment.topCenter,
                              child: ParkingTooltipMarker(
                                location: location,
                                isSelected: isSelected,
                                onTap: () => _handleMarkerTap(location),
                              ),
                            );
                          }).toList(),
                        );
                      },
                    ),

                  // Proper OpenStreetMap Attribution (placed top-left above bottom sheets)
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 12.0,
                      top: 12.0,
                      right: 68.0,
                    ),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6.0),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: DefaultTextStyle(
                            style: const TextStyle(
                              fontSize: 9.5,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textSecondary,
                            ),
                            child: SimpleAttributionWidget(
                              alignment: Alignment.topLeft,
                              backgroundColor: Colors.white.withValues(
                                alpha: 0.88,
                              ),
                              source: const Text('OpenStreetMap contributors'),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Demo Route Disclaimer & Clear Pill (shown only when demo route is drawn)
            AnimatedBuilder(
              animation: mergedRouteListenables,
              builder: (context, _) {
                final selected = _selectionListenable.value;
                final userPos = _userLocationListenable.value;
                final isRouteVisible = _routeVisibleListenable.value;

                final showBanner =
                    isRouteVisible &&
                    selected != null &&
                    selected.hasValidCoordinates &&
                    userPos != null &&
                    Building.isValidCoordinate(
                      userPos.latitude,
                      userPos.longitude,
                    );

                if (!showBanner) {
                  return const SizedBox.shrink();
                }

                final approxMeters =
                    RecommendationService.calculateStraightLineDistanceMeters(
                      startLatitude: userPos.latitude,
                      startLongitude: userPos.longitude,
                      endLatitude: selected.latitude,
                      endLongitude: selected.longitude,
                    );
                final distanceText =
                    RecommendationService.formatStraightLineDistance(
                      approxMeters,
                    );

                return Positioned(
                  top: 12.0,
                  left: 12.0,
                  right: 68.0,
                  child: SafeArea(
                    top: true,
                    bottom: false,
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        key: const Key('demo_route_info_pill'),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                        vertical: 5.5,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.95),
                        borderRadius: BorderRadius.circular(18.0),
                        border: Border.all(color: AppColors.border),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4.0,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.straighten,
                            size: 14.0,
                            color: AppColors.primaryRed,
                          ),
                          const SizedBox(width: 6.0),
                          Flexible(
                            child: Text(
                              '$distanceText (estimasi, bukan rute jalan)',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 11.0,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6.0),
                          GestureDetector(
                            key: const Key('clear_demo_route_button'),
                            onTap: _handleClearDemoRoute,
                            child: const Icon(
                              Icons.close,
                              size: 15.0,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),

          // Empty Parking Data State Pill
          if (validLocations.isEmpty)
            Positioned(
              top: 44.0,
              left: 16.0,
              child: SafeArea(
                top: true,
                bottom: false,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 6.0,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: const Text(
                    'Belum ada lokasi parkir tersedia',
                    style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
            ),

          // Floating Map Navigation Controls (Top-Right)
          Positioned(
            right: 16.0,
            top: 12.0,
            child: SafeArea(
              top: true,
              bottom: false,
              child: Column(
                children: [
                  // 1. Current GPS Location Button (explicit user-triggered GPS)
                  _buildFloatingButton(
                    buttonKey: const Key('gps_current_location_button'),
                    tooltip: 'Lokasi saya saat ini (GPS)',
                    onPressed: _locateCurrentUser,
                    child: _isLocatingUser
                        ? const SizedBox(
                            width: 16.0,
                            height: 16.0,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.0,
                              color: AppColors.primaryRed,
                            ),
                          )
                        : const Icon(
                            Icons.my_location,
                            size: 20.0,
                            color: AppColors.primaryRed,
                          ),
                  ),
                  const SizedBox(height: 10.0),

                  // 2. Return to Initial Campus Position (distinct from GPS button)
                  _buildFloatingButton(
                    buttonKey: const Key('reset_map_position_button'),
                    tooltip: 'Kembali ke posisi awal kampus',
                    onPressed: _resetToInitialPosition,
                    child: const Icon(
                      Icons.explore_outlined,
                      size: 20.0,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 10.0),

                  // 3. Focus on Currently Selected Parking Location
                  ValueListenableBuilder<ParkingLocation?>(
                    valueListenable: _selectionListenable,
                    builder: (context, selectedLocation, _) {
                      final hasSelection = selectedLocation != null;
                      return _buildFloatingButton(
                        buttonKey: const Key('focus_selected_parking_button'),
                        tooltip: 'Fokus ke parkiran terpilih',
                        onPressed: hasSelection
                            ? () => _focusOnLocation(selectedLocation)
                            : null,
                        child: Icon(
                          Icons.center_focus_strong_outlined,
                          size: 20.0,
                          color: hasSelection
                              ? AppColors.primaryRed
                              : AppColors.textMuted,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 10.0),

                  // 4. Zoom In / Out Controls
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(color: AppColors.border, width: 0.8),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6.0,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _buildSmallIconButton(
                          buttonKey: const Key('zoom_in_map_button'),
                          icon: Icons.add,
                          tooltip: 'Perbesar peta',
                          onPressed: _zoomIn,
                        ),
                        Container(
                          width: 28.0,
                          height: 1.0,
                          color: AppColors.border,
                        ),
                        _buildSmallIconButton(
                          buttonKey: const Key('zoom_out_map_button'),
                          icon: Icons.remove,
                          tooltip: 'Perkecil peta',
                          onPressed: _zoomOut,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          ],
        );
      },
    );
  }

  Widget _buildFloatingButton({
    Key? buttonKey,
    required String tooltip,
    required Widget child,
    required VoidCallback? onPressed,
  }) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.white,
        shape: const CircleBorder(
          side: BorderSide(color: AppColors.border, width: 0.8),
        ),
        elevation: 2.0,
        shadowColor: Colors.black26,
        child: InkWell(
          key: buttonKey,
          customBorder: const CircleBorder(),
          onTap: onPressed,
          child: SizedBox(
            width: 38.0,
            height: 38.0,
            child: Center(child: child),
          ),
        ),
      ),
    );
  }

  Widget _buildSmallIconButton({
    Key? buttonKey,
    required IconData icon,
    required String tooltip,
    required VoidCallback onPressed,
  }) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          key: buttonKey,
          onTap: onPressed,
          child: SizedBox(
            width: 36.0,
            height: 36.0,
            child: Icon(icon, size: 18.0, color: AppColors.textPrimary),
          ),
        ),
      ),
    );
  }
}
