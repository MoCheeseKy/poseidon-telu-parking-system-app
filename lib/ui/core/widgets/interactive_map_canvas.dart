import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:poseidon/core/constants/app_colors.dart';
import 'package:poseidon/data/mock/mock_parking_data.dart';
import 'package:poseidon/data/models/parking_location.dart';
import 'package:poseidon/ui/core/widgets/parking_tooltip_marker.dart';

/// Controller allowing parent screens to programmatically reset the map view
/// or focus on a specific [ParkingLocation] without coupling to `flutter_map`.
class ParkingMapController {
  VoidCallback? _onResetPosition;
  ValueChanged<ParkingLocation>? _onFocusLocation;

  void _attach({
    required VoidCallback onResetPosition,
    required ValueChanged<ParkingLocation> onFocusLocation,
  }) {
    _onResetPosition = onResetPosition;
    _onFocusLocation = onFocusLocation;
  }

  void _detach() {
    _onResetPosition = null;
    _onFocusLocation = null;
  }

  /// Resets map camera to the initial Telkom University Bandung campus view.
  void resetToInitialPosition() => _onResetPosition?.call();

  /// Centers and zooms the map onto [location].
  void focusOnLocation(ParkingLocation location) =>
      _onFocusLocation?.call(location);
}

class InteractiveMapCanvas extends StatefulWidget {
  final List<ParkingLocation> locations;
  final ValueListenable<ParkingLocation?>? selectedLocationListenable;
  final ValueChanged<ParkingLocation>? onMarkerTap;
  final VoidCallback? onMapTap;
  final ParkingMapController? controller;
  final double initialBottomSheetFraction;

  const InteractiveMapCanvas({
    super.key,
    this.locations = MockParkingData.allLocations,
    this.selectedLocationListenable,
    this.onMarkerTap,
    this.onMapTap,
    this.controller,
    this.initialBottomSheetFraction = 0.50,
  });

  @override
  State<InteractiveMapCanvas> createState() => _InteractiveMapCanvasState();
}

class _InteractiveMapCanvasState extends State<InteractiveMapCanvas> {
  static const double _minZoom = 13.5;
  static const double _maxZoom = 19.0;
  static const double _focusedZoom = 17.2;

  late final MapController _mapController;
  late final NetworkTileProvider _tileProvider;
  late final ValueNotifier<ParkingLocation?> _fallbackSelectionNotifier;

  bool _isMapReady = false;
  Size _viewportSize = const Size(400.0, 730.0);

  ValueListenable<ParkingLocation?> get _selectionListenable =>
      widget.selectedLocationListenable ?? _fallbackSelectionNotifier;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _tileProvider = NetworkTileProvider(silenceExceptions: true);
    _fallbackSelectionNotifier = ValueNotifier<ParkingLocation?>(null);
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
    );
  }

  @override
  void dispose() {
    widget.controller?._detach();
    _fallbackSelectionNotifier.dispose();
    _tileProvider.dispose();
    _mapController.dispose();
    super.dispose();
  }

  /// Offsets a geographic [target] southward so it appears visually centered
  /// in the unobstructed upper portion of the map above [bottomInsetPx].
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
    if (!_isMapReady) return;
    final targetZoom = math.max(_mapController.camera.zoom, _focusedZoom);
    final adjustedCenter = _offsetForBottomInset(
      location.coordinates,
      zoom: targetZoom,
      bottomInsetPx: 185.0,
    );
    _mapController.move(adjustedCenter, targetZoom);
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
    widget.onMarkerTap?.call(location);
  }

  void _handleMapBackgroundTap() {
    if (widget.selectedLocationListenable == null) {
      _fallbackSelectionNotifier.value = null;
    }
    widget.onMapTap?.call();
  }

  @override
  Widget build(BuildContext context) {
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

                  // Custom Floating Tooltip Markers Layer (rebuilds only on selection change)
                  if (widget.locations.isNotEmpty)
                    ValueListenableBuilder<ParkingLocation?>(
                      valueListenable: _selectionListenable,
                      builder: (context, selectedLocation, _) {
                        // Render selected marker last so it stays visually on top
                        final orderedLocations = <ParkingLocation>[
                          ...widget.locations.where(
                            (loc) => loc.id != selectedLocation?.id,
                          ),
                          ...widget.locations.where(
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

            // Empty Parking Data State Pill
            if (widget.locations.isEmpty)
              Positioned(
                top: 44.0,
                left: 16.0,
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

            // Floating Map Navigation Controls (Top-Right)
            Positioned(
              right: 16.0,
              top: 16.0,
              child: Column(
                children: [
                  // Return to Initial Campus Position
                  _buildFloatingButton(
                    buttonKey: const Key('reset_map_position_button'),
                    tooltip: 'Kembali ke posisi awal kampus',
                    onPressed: _resetToInitialPosition,
                    child: const Icon(
                      Icons.my_location,
                      size: 20.0,
                      color: AppColors.primaryRed,
                    ),
                  ),
                  const SizedBox(height: 10.0),

                  // Focus on Currently Selected Parking Location
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

                  // Zoom In / Out Controls
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
