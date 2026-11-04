import 'package:flutter/material.dart';
import 'package:poseidon/core/constants/app_colors.dart';
import 'package:poseidon/data/mock/mock_building_data.dart';
import 'package:poseidon/data/mock/mock_parking_data.dart';
import 'package:poseidon/data/models/building.dart';
import 'package:poseidon/data/models/parking_location.dart';
import 'package:poseidon/services/recommendation_service.dart';
import 'package:poseidon/ui/core/widgets/drag_handle.dart';
import 'package:poseidon/ui/core/widgets/parking_item_tile.dart';
import 'package:poseidon/ui/core/widgets/vehicle_type_selector.dart';
import 'package:poseidon/ui/features/detail/views/parking_detail_sheet.dart';

class SearchDestinationSheet extends StatefulWidget {
  final VehicleType initialVehicleType;
  final Building? initialBuilding;
  final List<Building>? buildings;
  final List<ParkingLocation> parkingLocations;
  final RecommendationService recommendationService;
  final ValueChanged<ParkingLocation>? onParkingSelected;

  const SearchDestinationSheet({
    super.key,
    this.initialVehicleType = VehicleType.motor,
    this.initialBuilding,
    this.buildings,
    this.parkingLocations = MockParkingData.allLocations,
    this.recommendationService = const RecommendationService(),
    this.onParkingSelected,
  });

  /// Helper to display the Search sheet as a modal bottom sheet.
  static Future<void> show(
    BuildContext context, {
    VehicleType initialVehicleType = VehicleType.motor,
    Building? initialBuilding,
    List<Building>? buildings,
    List<ParkingLocation> parkingLocations = MockParkingData.allLocations,
    ValueChanged<ParkingLocation>? onParkingSelected,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
      ),
      builder: (context) => SearchDestinationSheet(
        initialVehicleType: initialVehicleType,
        initialBuilding: initialBuilding,
        buildings: buildings,
        parkingLocations: parkingLocations,
        onParkingSelected: onParkingSelected,
      ),
    );
  }

  @override
  State<SearchDestinationSheet> createState() => _SearchDestinationSheetState();
}

class _SearchDestinationSheetState extends State<SearchDestinationSheet> {
  late final TextEditingController _searchController;
  late VehicleType _selectedVehicle;
  Building? _selectedBuilding;
  String _searchQuery = '';

  List<Building> get _allBuildings =>
      widget.buildings ?? MockBuildingData.getAllBuildings();

  List<Building> get _filteredBuildings {
    final normalized = _searchQuery.trim().toLowerCase();
    if (normalized.isEmpty) {
      return _allBuildings;
    }

    // Reuse MockBuildingData search ordering when using default building list.
    if (widget.buildings == null) {
      return MockBuildingData.searchBuildings(_searchQuery);
    }

    return _allBuildings
        .where((building) {
          return building.name.toLowerCase().contains(normalized) ||
              building.code.toLowerCase().contains(normalized) ||
              building.area.toLowerCase().contains(normalized);
        })
        .toList(growable: false);
  }

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _selectedVehicle = widget.initialVehicleType;
    final availableBuildings = _allBuildings;
    _selectedBuilding =
        widget.initialBuilding ??
        (availableBuildings.isNotEmpty ? availableBuildings.first : null);
  }

  @override
  void didUpdateWidget(covariant SearchDestinationSheet oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.buildings != widget.buildings) {
      final available = _allBuildings;
      if (available.isEmpty) {
        _selectedBuilding = null;
      } else if (_selectedBuilding == null ||
          !available.any((b) => b.id == _selectedBuilding!.id)) {
        _selectedBuilding = available.first;
      }
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _selectBuilding(Building building, {bool clearQuery = false}) {
    FocusScope.of(context).unfocus();
    setState(() {
      _selectedBuilding = building;
      if (clearQuery) {
        _searchController.clear();
        _searchQuery = '';
      }
    });
  }

  void _handleParkingSelection(ParkingLocation location) {
    if (widget.onParkingSelected != null) {
      widget.onParkingSelected!(location);
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
      return;
    }

    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
    ParkingDetailSheet.show(context, location: location);
  }

  @override
  Widget build(BuildContext context) {
    final result = widget.recommendationService.recommend(
      destination: _selectedBuilding,
      vehicleType: _selectedVehicle,
      parkingLocations: widget.parkingLocations,
    );
    final isSearching = _searchQuery.trim().isNotEmpty;
    final matchingBuildings = _filteredBuildings;
    final bottomKeyboardInset = MediaQuery.viewInsetsOf(context).bottom;

    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.only(bottom: bottomKeyboardInset),
        child: Center(
          heightFactor: 1.0,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 600.0,
              maxHeight: MediaQuery.sizeOf(context).height * 0.88,
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

                  // Single Search Field with Red Search Icon & Clear Button
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
                            key: const Key('destination_search_text_field'),
                            controller: _searchController,
                            onChanged: (value) {
                              setState(() {
                                _searchQuery = value;
                              });
                            },
                            style: const TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                            decoration: const InputDecoration(
                              hintText:
                                  'Cari nama atau kode gedung (TULT, GKU, FIT...)',
                              hintStyle: TextStyle(
                                color: AppColors.textMuted,
                                fontSize: 13.5,
                              ),
                              border: InputBorder.none,
                              isDense: true,
                            ),
                          ),
                        ),
                        GestureDetector(
                          key: const Key('clear_destination_search_button'),
                          onTap: () {
                            if (_searchController.text.isEmpty &&
                                _searchQuery.isEmpty) {
                              return;
                            }
                            setState(() {
                              _searchController.clear();
                              _searchQuery = '';
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
                  const SizedBox(height: 12.0),

                  // Dynamic Building Selector / Search Filter Results
                  if (_allBuildings.isEmpty)
                    _buildNoBuildingsBanner(
                      title: 'Daftar gedung belum tersedia',
                      subtitle:
                          'Data master gedung tujuan belum dapat dimuat.',
                    )
                  else if (isSearching)
                    _buildFilteredBuildingResults(matchingBuildings)
                  else
                    _buildQuickBuildingSelector(_allBuildings),

                  const SizedBox(height: 14.0),

                  // Vehicle Type Selector (recalculates recommendations dynamically)
                  VehicleTypeSelector(
                    selectedType: _selectedVehicle,
                    onTypeChanged: (type) {
                      if (_selectedVehicle == type) return;
                      setState(() {
                        _selectedVehicle = type;
                      });
                    },
                  ),
                  const SizedBox(height: 16.0),

                  // Dynamic Recommendation Card or Clean Empty State
                  if (result.hasRecommendation)
                    _buildRecommendationCard(result)
                  else
                    _buildEmptyRecommendationState(result),

                  if (result.alternatives.isNotEmpty) ...[
                    const SizedBox(height: 20.0),
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
                    ...result.alternatives.map(
                      (alt) => ParkingItemTile(
                        key: ValueKey(
                          'search_alternative_${alt.parkingLocation.id}',
                        ),
                        location: alt.parkingLocation,
                        isCardStyle: true,
                        distanceText: alt.formattedStraightLineDistance,
                        onTap: () =>
                            _handleParkingSelection(alt.parkingLocation),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickBuildingSelector(List<Building> buildings) {
    return SizedBox(
      height: 36.0,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: buildings.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8.0),
        itemBuilder: (context, index) {
          final building = buildings[index];
          final isSelected = _selectedBuilding?.id == building.id;
          return Material(
            color: isSelected
                ? AppColors.primaryRed.withValues(alpha: 0.08)
                : AppColors.surfaceGrey,
            borderRadius: BorderRadius.circular(18.0),
            child: InkWell(
              key: ValueKey('building_chip_${building.id}'),
              borderRadius: BorderRadius.circular(18.0),
              onTap: () => _selectBuilding(building),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18.0),
                  border: Border.all(
                    color: isSelected ? AppColors.primaryRed : AppColors.border,
                    width: isSelected ? 1.3 : 1.0,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  building.name,
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected
                        ? AppColors.primaryRed
                        : AppColors.textPrimary,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFilteredBuildingResults(List<Building> matches) {
    if (matches.isEmpty) {
      return _buildNoBuildingsBanner(
        key: const Key('no_matching_building_state'),
        title: 'Gedung tidak ditemukan',
        subtitle:
            'Tidak ada gedung yang cocok dengan "${_searchQuery.trim()}". Coba kata kunci seperti TULT, GKU, FIT, FEB, atau Rektorat.',
      );
    }

    return Container(
      key: const Key('filtered_building_results_list'),
      constraints: const BoxConstraints(maxHeight: 184.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: AppColors.border, width: 1.0),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        itemCount: matches.length,
        separatorBuilder: (_, _) => const Divider(
          height: 1.0,
          thickness: 1.0,
          color: AppColors.border,
          indent: 14.0,
          endIndent: 14.0,
        ),
        itemBuilder: (context, index) {
          final building = matches[index];
          final isSelected = _selectedBuilding?.id == building.id;
          return InkWell(
            key: ValueKey('building_result_${building.id}'),
            onTap: () => _selectBuilding(building, clearQuery: true),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 14.0,
                vertical: 10.0,
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.apartment_outlined,
                    size: 18.0,
                    color: isSelected
                        ? AppColors.primaryRed
                        : AppColors.textSecondary,
                  ),
                  const SizedBox(width: 10.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          building.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13.5,
                            fontWeight: isSelected
                                ? FontWeight.w700
                                : FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        if (building.area.isNotEmpty)
                          Text(
                            building.area,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 11.5,
                              color: AppColors.textSecondary,
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 3.0,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.chipBackground,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      building.code,
                      style: const TextStyle(
                        fontSize: 11.0,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildNoBuildingsBanner({
    Key? key,
    required String title,
    required String subtitle,
  }) {
    return Container(
      key: key,
      width: double.infinity,
      padding: const EdgeInsets.all(14.0),
      decoration: BoxDecoration(
        color: AppColors.surfaceGrey,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: AppColors.border, width: 1.0),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.search_off_outlined,
            size: 20.0,
            color: AppColors.textSecondary,
          ),
          const SizedBox(width: 10.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2.0),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12.0,
                    height: 1.35,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationCard(RecommendationResult result) {
    final best = result.bestRecommendation!;
    final loc = best.parkingLocation;
    final isWarning = loc.status == ParkingStatus.warning;
    final badgeBg = isWarning
        ? AppColors.statusOrangeBadgeBg
        : AppColors.statusGreenBadgeBg;
    final badgeText = isWarning
        ? AppColors.statusOrangeBadgeText
        : AppColors.statusGreenBadgeText;

    return Material(
      color: AppColors.surfaceGrey,
      borderRadius: BorderRadius.circular(14.0),
      child: InkWell(
        key: const Key('primary_recommendation_card'),
        borderRadius: BorderRadius.circular(14.0),
        onTap: () => _handleParkingSelection(loc),
        child: Container(
          padding: const EdgeInsets.all(14.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14.0),
            border: Border.all(color: AppColors.border, width: 1.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Row: Destination + Recommended Parking Title + Available Slot Badge
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Rekomendasi',
                          key: Key('selected_destination_label'),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 3.0),
                        Text(
                          loc.name,
                          style: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10.0,
                      vertical: 4.0,
                    ),
                    decoration: BoxDecoration(
                      color: badgeBg,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Text(
                      '${loc.availableSlots} slot',
                      style: TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w700,
                        color: badgeText,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10.0),

              // Sub info: Straight-Line Approximate Distance
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.straighten,
                    size: 15.0,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 4.0),
                  Text(
                    best.formattedStraightLineDistance,
                    style: const TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14.0),

              // Full-width red action button
              SizedBox(
                width: double.infinity,
                height: 44.0,
                child: ElevatedButton(
                  key: const Key('select_recommended_parking_button'),
                  onPressed: () => _handleParkingSelection(loc),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryRed,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.near_me, size: 16.0, color: Colors.white),
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
      ),
    );
  }

  Widget _buildEmptyRecommendationState(RecommendationResult result) {
    return Container(
      key: const Key('empty_recommendation_state'),
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.surfaceGrey,
        borderRadius: BorderRadius.circular(14.0),
        border: Border.all(color: AppColors.border, width: 1.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.local_parking_outlined,
                size: 20.0,
                color: AppColors.statusRed,
              ),
              const SizedBox(width: 8.0),
              Expanded(
                child: Text(
                  result.emptyStateTitle,
                  style: const TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6.0),
          Text(
            result.emptyStateMessage,
            style: const TextStyle(
              fontSize: 12.5,
              height: 1.4,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
