import 'package:flutter/material.dart';
import 'package:poseidon/core/constants/app_colors.dart';
import 'package:poseidon/data/mock/mock_parking_data.dart';
import 'package:poseidon/data/models/parking_location.dart';
import 'package:poseidon/ui/core/widgets/drag_handle.dart';
import 'package:poseidon/ui/core/widgets/parking_item_tile.dart';
import 'package:poseidon/ui/features/detail/views/parking_detail_sheet.dart';

class SearchDestinationSheet extends StatefulWidget {
  const SearchDestinationSheet({super.key});

  /// Helper to display the Search sheet as a modal bottom sheet
  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
      ),
      builder: (context) => const SearchDestinationSheet(),
    );
  }

  @override
  State<SearchDestinationSheet> createState() => _SearchDestinationSheetState();
}

class _SearchDestinationSheetState extends State<SearchDestinationSheet> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(
      text: MockParkingData.recommendation.destinationQuery,
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onOpenParkingDetail(ParkingLocation location) {
    Navigator.of(context).pop(); // Dismiss search sheet
    ParkingDetailSheet.show(context, location: location);
  }

  @override
  Widget build(BuildContext context) {
    final rec = MockParkingData.recommendation;

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
                const Text(
                  'Cari Gedung Tujuan',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4.0),
                const Text(
                  'Cari gedung tujuan kamu, untuk kami bantu cari parkiran terbaik untukmu!',
                  style: TextStyle(
                    fontSize: 13.0,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 16.0),

                // Search Field with Red Search Icon & Clear Button
                Container(
                  height: 48.0,
                  decoration: BoxDecoration(
                    color: AppColors.cardSurface,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 14.0),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.search,
                        color: AppColors.primaryRed,
                        size: 22.0,
                      ),
                      const SizedBox(width: 10.0),
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          style: const TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                          decoration: const InputDecoration(
                            hintText: 'Cari gedung...',
                            hintStyle: TextStyle(
                              color: AppColors.textMuted,
                              fontSize: 14.0,
                            ),
                            border: InputBorder.none,
                            isDense: true,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _searchController.clear();
                          });
                        },
                        child: const Icon(
                          Icons.cancel,
                          size: 18.0,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18.0),

                // Recommended Parking Card
                Container(
                  padding: const EdgeInsets.all(14.0),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceGrey,
                    borderRadius: BorderRadius.circular(14.0),
                    border: Border.all(color: AppColors.border, width: 1.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Row: Title + Green Slot Badge (Separate Slot 12 mock)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Rekomendasi',
                                style: TextStyle(
                                  fontSize: 11.0,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 2.0),
                              Text(
                                rec.name,
                                style: const TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10.0,
                              vertical: 4.0,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.statusGreenBadgeBg,
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Text(
                              rec.slotBadgeText,
                              style: const TextStyle(
                                fontSize: 12.0,
                                fontWeight: FontWeight.w700,
                                color: AppColors.statusGreenBadgeText,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10.0),

                      // Sub info: Distance & Supported Vehicles
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 6.0,
                        runSpacing: 4.0,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.directions_walk,
                                size: 15.0,
                                color: AppColors.textSecondary,
                              ),
                              const SizedBox(width: 4.0),
                              Text(
                                rec.distanceText,
                                style: const TextStyle(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                          const Text(
                            '•',
                            style: TextStyle(
                              fontSize: 12.0,
                              color: AppColors.textMuted,
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.two_wheeler,
                                size: 15.0,
                                color: AppColors.textSecondary,
                              ),
                              const SizedBox(width: 4.0),
                              Text(
                                rec.vehicleText,
                                style: const TextStyle(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 14.0),

                      // Full-width red button
                      SizedBox(
                        width: double.infinity,
                        height: 44.0,
                        child: ElevatedButton(
                          onPressed: () {
                            _onOpenParkingDetail(MockParkingData.tultParking);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryRed,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12.0,
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
                                size: 16.0,
                                color: Colors.white,
                              ),
                              SizedBox(width: 8.0),
                              Flexible(
                                child: Text(
                                  'Pilih & Mulai Rute ke Parkir',
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
                    ],
                  ),
                ),
                const SizedBox(height: 20.0),

                // Section: ALTERNATIF TERDEKAT LAINNYA
                const Text(
                  'ALTERNATIF TERDEKAT LAINNYA',
                  style: TextStyle(
                    fontSize: 11.0,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 12.0),

                // Alternative list items (Card style)
                ...MockParkingData.searchAlternatives.map(
                  (alt) => ParkingItemTile(
                    location: alt,
                    isCardStyle: true,
                    customSubtitle: '${alt.availableSlots} slot tersedia',
                    onTap: () => _onOpenParkingDetail(alt),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
