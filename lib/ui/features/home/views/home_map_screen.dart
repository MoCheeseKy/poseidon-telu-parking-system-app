import 'package:flutter/material.dart';
import 'package:poseidon/core/constants/app_colors.dart';
import 'package:poseidon/data/mock/mock_parking_data.dart';
import 'package:poseidon/data/models/parking_location.dart';
import 'package:poseidon/ui/core/widgets/app_bottom_nav_bar.dart';
import 'package:poseidon/ui/core/widgets/drag_handle.dart';
import 'package:poseidon/ui/core/widgets/interactive_map_canvas.dart';
import 'package:poseidon/ui/core/widgets/parking_item_tile.dart';
import 'package:poseidon/ui/core/widgets/poseidon_app_bar.dart';
import 'package:poseidon/ui/core/widgets/selected_parking_sheet.dart';
import 'package:poseidon/ui/core/widgets/vehicle_type_selector.dart';
import 'package:poseidon/ui/features/activity/views/activity_screen.dart';
import 'package:poseidon/ui/features/detail/views/parking_detail_sheet.dart';
import 'package:poseidon/ui/features/report/views/report_screen.dart';
import 'package:poseidon/ui/features/search/views/search_destination_sheet.dart';

class HomeMapScreen extends StatefulWidget {
  const HomeMapScreen({super.key});

  @override
  State<HomeMapScreen> createState() => _HomeMapScreenState();
}

class _HomeMapScreenState extends State<HomeMapScreen> {
  int _currentNavIndex = 0;
  VehicleType _selectedVehicle = VehicleType.motor;

  late final ValueNotifier<ParkingLocation?> _selectedLocationNotifier;
  late final ParkingMapController _parkingMapController;

  @override
  void initState() {
    super.initState();
    _selectedLocationNotifier = ValueNotifier<ParkingLocation?>(null);
    _parkingMapController = ParkingMapController();
  }

  @override
  void dispose() {
    _selectedLocationNotifier.dispose();
    super.dispose();
  }

  void _openSearchSheet() {
    SearchDestinationSheet.show(context);
  }

  void _openParkingDetail(ParkingLocation location) {
    ParkingDetailSheet.show(context, location: location);
  }

  void _handleMarkerSelected(ParkingLocation location) {
    _selectedLocationNotifier.value = location;
  }

  void _clearSelectedLocation() {
    if (_selectedLocationNotifier.value != null) {
      _selectedLocationNotifier.value = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _currentNavIndex == 0
          ? Colors.white
          : AppColors.pageBackground,
      appBar: const PoseidonAppBar(),
      body: _buildBody(),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: _currentNavIndex,
        onTabSelected: (index) {
          setState(() {
            _currentNavIndex = index;
          });
        },
        onCenterAction: _openSearchSheet,
      ),
    );
  }

  Widget _buildBody() {
    switch (_currentNavIndex) {
      case 1:
        return const ReportScreen(showScaffold: false);
      case 2:
        return const ActivityScreen(showScaffold: false);
      case 3:
        return _buildAccountPlaceholder();
      case 0:
      default:
        return _buildMapBody();
    }
  }

  Widget _buildMapBody() {
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
            controller: _parkingMapController,
            onMarkerTap: _handleMarkerSelected,
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
                      onClose: _clearSelectedLocation,
                      onFocusLocation: () =>
                          _parkingMapController.focusOnLocation(
                            selectedLocation,
                          ),
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
                        const Text(
                          'Halo! Rifky',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                          ),
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

  Widget _buildAccountPlaceholder() {
    return SafeArea(
      top: false,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600.0),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 32.0),
            children: [
              // Profile Card
              Container(
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.0),
                  border: Border.all(color: const Color(0xFFF1F1F1)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.025),
                      blurRadius: 8.0,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 56.0,
                      height: 56.0,
                      decoration: const BoxDecoration(
                        color: AppColors.primaryRed,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 32.0,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Rifky',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          SizedBox(height: 4.0),
                          Text(
                            'Mahasiswa Telkom University',
                            style: TextStyle(
                              fontSize: 13.0,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          SizedBox(height: 2.0),
                          Text(
                            'rifky@student.telkomuniversity.ac.id',
                            style: TextStyle(
                              fontSize: 12.0,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20.0),

              // Menu Items
              _buildAccountMenuItem(
                icon: Icons.directions_bike,
                title: 'Kendaraan Terdaftar',
                subtitle: 'Honda Vario 160 (D 1945 TEL)',
              ),
              _buildAccountMenuItem(
                icon: Icons.notifications_outlined,
                title: 'Pengaturan Notifikasi',
                subtitle: 'Push notifikasi & peringatan parkir penuh',
              ),
              _buildAccountMenuItem(
                icon: Icons.help_outline,
                title: 'Pusat Bantuan & Syarat Ketentuan',
                subtitle: 'Panduan penggunaan sistem parkir Poseidon',
              ),
              _buildAccountMenuItem(
                icon: Icons.info_outline,
                title: 'Tentang Aplikasi',
                subtitle: 'Poseidon Smart Parking v1.0.0',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAccountMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.0),
        border: Border.all(color: const Color(0xFFF1F1F1)),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: AppColors.chipBackground,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Icon(icon, color: AppColors.textPrimary, size: 20.0),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            fontSize: 12.0,
            color: AppColors.textSecondary,
          ),
        ),
        trailing: const Icon(
          Icons.chevron_right,
          color: AppColors.textMuted,
          size: 20.0,
        ),
        onTap: () {},
      ),
    );
  }
}
