import 'package:flutter/material.dart';
import 'package:poseidon/core/constants/app_colors.dart';
import 'package:poseidon/data/mock/mock_parking_data.dart';
import 'package:poseidon/data/models/building_distance.dart';
import 'package:poseidon/data/models/parking_location.dart';
import 'package:poseidon/ui/core/widgets/drag_handle.dart';

class ParkingDetailSheet extends StatefulWidget {
  final ParkingLocation? location;
  final List<BuildingDistance>? buildingDistances;

  const ParkingDetailSheet({super.key, this.location, this.buildingDistances});

  /// Helper to display the Parking Detail as a modal bottom sheet
  static Future<void> show(
    BuildContext context, {
    ParkingLocation? location,
    List<BuildingDistance>? buildingDistances,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
      ),
      builder: (context) => ParkingDetailSheet(
        location: location,
        buildingDistances: buildingDistances,
      ),
    );
  }

  @override
  State<ParkingDetailSheet> createState() => _ParkingDetailSheetState();
}

class _ParkingDetailSheetState extends State<ParkingDetailSheet> {
  late VehicleType _selectedVehicle;
  bool _isBookmarked = false;

  @override
  void initState() {
    super.initState();
    _selectedVehicle = widget.location?.vehicleType ?? VehicleType.motor;
  }

  void _toggleVehicle() {
    setState(() {
      _selectedVehicle = _selectedVehicle == VehicleType.motor
          ? VehicleType.mobil
          : VehicleType.motor;
    });
  }

  void _toggleBookmark() {
    setState(() {
      _isBookmarked = !_isBookmarked;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Default to TULT data matching reference image
    final loc = widget.location ?? MockParkingData.tultParking;
    final distances =
        widget.buildingDistances ?? MockParkingData.tultNearestBuildings;

    return SafeArea(
      top: false,
      child: Center(
        heightFactor: 1.0,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 600.0,
            maxHeight: MediaQuery.sizeOf(context).height * 0.85,
          ),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20.0, 8.0, 20.0, 20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const DragHandle(),

                // Title & Subtitle
                Text(
                  widget.location == null ? 'Lapangan Parkir TULT' : loc.name,
                  style: const TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  loc.subArea.isNotEmpty ? loc.subArea : 'Kawasan Fakultas Informatika (FIF) & Fakultas Kedokteran (FK)',
                  style: const TextStyle(
                    fontSize: 13.0,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 16.0),

                // Vehicle Selector Pill & Entrance Gate
                Row(
                  children: [
                    GestureDetector(
                      onTap: _toggleVehicle,
                      child: Container(
                        height: 36.0,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14.0,
                          vertical: 6.0,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryRed,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _selectedVehicle == VehicleType.motor
                                  ? Icons.two_wheeler
                                  : Icons.directions_car,
                              color: Colors.white,
                              size: 16.0,
                            ),
                            const SizedBox(width: 6.0),
                            Text(
                              _selectedVehicle == VehicleType.motor
                                  ? 'Motor'
                                  : 'Mobil',
                              style: const TextStyle(
                                fontSize: 13.0,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 14.0),
                    Expanded(
                      child: Text(
                        loc.gateInfo,
                        style: const TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18.0),

                // Slot Availability Header (84 slot tersedia, 166 terisi)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Flexible(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            '${loc.availableSlots}',
                            style: const TextStyle(
                              fontSize: 28.0,
                              fontWeight: FontWeight.w800,
                              color: AppColors.statusGreen,
                            ),
                          ),
                          const SizedBox(width: 6.0),
                          const Flexible(
                            child: Text(
                              'slot tersedia',
                              style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    Text(
                      '${loc.occupiedSlots} terisi',
                      style: const TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8.0),

                // Progress Bar (84 / 250 available)
                ClipRRect(
                  borderRadius: BorderRadius.circular(4.0),
                  child: Container(
                    height: 8.0,
                    width: double.infinity,
                    color: AppColors.cardSurface,
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: loc.availabilityRatio,
                      child: Container(color: AppColors.statusGreen),
                    ),
                  ),
                ),
                const SizedBox(height: 6.0),
                Text(
                  'Kapasitas Total ${loc.totalSlots} slot',
                  style: const TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 20.0),

                // Nearest Buildings Section
                const Text(
                  'Jarak ke Gedung Terdekat',
                  style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 10.0),
                ...distances.map(
                  (d) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            d.buildingName,
                            style: const TextStyle(
                              fontSize: 13.0,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        Text(
                          d.formattedDistance,
                          style: const TextStyle(
                            fontSize: 13.0,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24.0),

                // Bottom Action Buttons (CTA + Bookmark)
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 48.0,
                        child: ElevatedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Memulai navigasi rute ke ${loc.name}...',
                                ),
                                duration: const Duration(seconds: 2),
                                backgroundColor: AppColors.textPrimary,
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryRed,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10.0,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.near_me,
                                size: 18.0,
                                color: Colors.white,
                              ),
                              SizedBox(width: 8.0),
                              Flexible(
                                child: Text(
                                  'Mulai Navigasi ke Parkir',
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12.0),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: _toggleBookmark,
                        borderRadius: BorderRadius.circular(10.0),
                        child: Container(
                          width: 48.0,
                          height: 48.0,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(
                              color: AppColors.border,
                              width: 1.0,
                            ),
                          ),
                          child: Center(
                            child: Icon(
                              _isBookmarked
                                  ? Icons.bookmark
                                  : Icons.bookmark_outline,
                              color: _isBookmarked
                                  ? AppColors.primaryRed
                                  : AppColors.textSecondary,
                              size: 22.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
