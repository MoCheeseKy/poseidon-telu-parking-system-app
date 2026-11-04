import 'package:flutter/material.dart';
import 'package:poseidon/core/constants/app_colors.dart';
import 'package:poseidon/data/mock/mock_parking_data.dart';
import 'package:poseidon/data/mock/mock_user_profile_data.dart';
import 'package:poseidon/data/models/parking_location.dart';
import 'package:poseidon/ui/core/widgets/poseidon_sub_app_bar.dart';
import 'package:poseidon/ui/features/detail/views/parking_detail_sheet.dart';

class FavoriteParkingScreen extends StatelessWidget {
  final UserProfileStore? store;
  final ValueChanged<ParkingLocation>? onNavigateToMap;

  const FavoriteParkingScreen({
    super.key,
    this.store,
    this.onNavigateToMap,
  });

  static MaterialPageRoute<void> route({
    UserProfileStore? store,
    ValueChanged<ParkingLocation>? onNavigateToMap,
  }) {
    return MaterialPageRoute<void>(
      builder: (_) => FavoriteParkingScreen(
        store: store,
        onNavigateToMap: onNavigateToMap,
      ),
    );
  }

  UserProfileStore get _store => store ?? MockUserProfileData.sharedStore;

  Color _dotColorFor(ParkingStatus status) {
    switch (status) {
      case ParkingStatus.available:
        return AppColors.statusGreen;
      case ParkingStatus.warning:
        return AppColors.statusOrange;
      case ParkingStatus.full:
        return AppColors.statusRed;
      case ParkingStatus.offline:
        return AppColors.statusGrey;
    }
  }

  String _formatLocationSubtitle(ParkingLocation location) {
    if (location.status == ParkingStatus.offline || location.totalSlots == 0) {
      return location.customStatusText ?? 'Kapasitas belum diketahui';
    }
    return '${location.availableSlots}/${location.totalSlots} slot tersedia';
  }

  @override
  Widget build(BuildContext context) {
    final allLocations = MockParkingData.allLocations;

    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      appBar: const PoseidonSubAppBar(title: 'Lokasi Parkir Favorit'),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600.0),
            child: ListenableBuilder(
              listenable: _store,
              builder: (context, _) {
                final favorites = _store.favoriteLocations;
                final otherLocations = allLocations
                    .where((loc) => !_store.isFavoriteParking(loc.id))
                    .toList();

                return ListView(
                  padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 32.0),
                  physics: const BouncingScrollPhysics(),
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'FAVORIT TERSIMPAN',
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10.0,
                            vertical: 4.0,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12.0),
                            border: Border.all(
                              color: AppColors.subtleCardBorder,
                            ),
                          ),
                          child: Text(
                            '${favorites.length} Lokasi',
                            style: const TextStyle(
                              fontSize: 11.0,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10.0),

                    if (favorites.isEmpty)
                      Container(
                        padding: const EdgeInsets.all(22.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18.0),
                          border: Border.all(color: AppColors.subtleCardBorder),
                        ),
                        child: const Text(
                          'Belum ada lokasi parkir favorit yang disimpan.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13.0,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      )
                    else
                      _buildGroupedLocations(
                        context,
                        locations: favorites,
                        isFavorite: true,
                      ),

                    const SizedBox(height: 24.0),
                    const Text(
                      'AREA PARKIR LAINNYA',
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 10.0),

                    _buildGroupedLocations(
                      context,
                      locations: otherLocations,
                      isFavorite: false,
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGroupedLocations(
    BuildContext context, {
    required List<ParkingLocation> locations,
    required bool isFavorite,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.0),
        border: Border.all(color: AppColors.subtleCardBorder),
      ),
      child: Column(
        children: [
          for (int i = 0; i < locations.length; i++) ...[
            if (i > 0)
              const Divider(
                height: 1.0,
                color: Color(0xFFF3F4F6),
                indent: 18.0,
                endIndent: 18.0,
              ),
            _buildLocationRow(
              context,
              location: locations[i],
              isFavorite: isFavorite,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLocationRow(
    BuildContext context, {
    required ParkingLocation location,
    required bool isFavorite,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(18.0),
      onTap: () {
        ParkingDetailSheet.show(
          context,
          location: location,
          onStartNavigation: onNavigateToMap != null
              ? () {
                  Navigator.pop(context);
                  onNavigateToMap!(location);
                }
              : null,
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 14.0),
        child: Row(
          children: [
            Container(
              width: 8.5,
              height: 8.5,
              decoration: BoxDecoration(
                color: _dotColorFor(location.status),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 12.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    location.name,
                    style: const TextStyle(
                      fontSize: 13.8,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2.5),
                  Text(
                    _formatLocationSubtitle(location),
                    style: const TextStyle(
                      fontSize: 12.0,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              tooltip: isFavorite ? 'Hapus dari Favorit' : 'Simpan ke Favorit',
              visualDensity: VisualDensity.compact,
              onPressed: () => _store.toggleFavoriteParking(location.id),
              icon: Icon(
                isFavorite ? Icons.bookmark_rounded : Icons.bookmark_border,
                color: isFavorite
                    ? AppColors.avatarDeepRed
                    : AppColors.textMuted,
                size: 21.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
