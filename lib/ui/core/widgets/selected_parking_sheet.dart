import 'package:flutter/material.dart';
import 'package:poseidon/core/constants/app_colors.dart';
import 'package:poseidon/data/models/parking_location.dart';
import 'package:poseidon/ui/core/widgets/drag_handle.dart';

/// Compact non-modal bottom sheet displayed when a parking marker is selected
/// on the map, keeping the map interactive while showing key parking details.
class SelectedParkingSheet extends StatelessWidget {
  final ParkingLocation location;
  final VoidCallback onClose;
  final VoidCallback onOpenDetail;
  final VoidCallback onFocusLocation;

  const SelectedParkingSheet({
    super.key,
    required this.location,
    required this.onClose,
    required this.onOpenDetail,
    required this.onFocusLocation,
  });

  Color get _statusColor {
    switch (location.status) {
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

  Color get _badgeBgColor {
    switch (location.status) {
      case ParkingStatus.available:
        return AppColors.statusGreenBadgeBg;
      case ParkingStatus.warning:
        return AppColors.statusOrangeBadgeBg;
      case ParkingStatus.full:
        return const Color(0xFFFEE2E2);
      case ParkingStatus.offline:
        return AppColors.cardSurface;
    }
  }

  Color get _badgeTextColor {
    switch (location.status) {
      case ParkingStatus.available:
        return AppColors.statusGreenBadgeText;
      case ParkingStatus.warning:
        return AppColors.statusOrangeBadgeText;
      case ParkingStatus.full:
        return const Color(0xFF991B1B);
      case ParkingStatus.offline:
        return AppColors.textSecondary;
    }
  }

  String get _statusBadgeLabel {
    switch (location.status) {
      case ParkingStatus.available:
        return 'Tersedia';
      case ParkingStatus.warning:
        return 'Terbatas';
      case ParkingStatus.full:
        return 'Penuh';
      case ParkingStatus.offline:
        return 'Offline';
    }
  }

  String get _capacitySummary {
    switch (location.status) {
      case ParkingStatus.offline:
        return 'Data slot sementara tidak tersedia';
      case ParkingStatus.full:
        return 'Penuh · 0 dari ${location.totalSlots} slot tersedia';
      case ParkingStatus.available:
      case ParkingStatus.warning:
        return '${location.availableSlots} dari ${location.totalSlots} slot tersedia';
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor;
    final subtitle = location.subArea.isNotEmpty
        ? '${location.gateInfo} · ${location.subArea}'
        : location.gateInfo;

    return Container(
      key: const Key('selected_parking_compact_sheet'),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(22.0)),
        border: const Border(
          top: BorderSide(color: AppColors.border, width: 1.0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12.0,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Center(
          heightFactor: 1.0,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600.0),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 8.0, 20.0, 16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const DragHandle(),

                  // Header: Parking Title + Status Pill + Close Button
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    location.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 16.5,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8.0),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0,
                                    vertical: 2.5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _badgeBgColor,
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Text(
                                    _statusBadgeLabel,
                                    style: TextStyle(
                                      fontSize: 11.0,
                                      fontWeight: FontWeight.w700,
                                      color: _badgeTextColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 3.0),
                            Text(
                              subtitle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      Material(
                        color: AppColors.cardSurface,
                        shape: const CircleBorder(),
                        child: InkWell(
                          key: const Key('close_selected_parking_button'),
                          customBorder: const CircleBorder(),
                          onTap: onClose,
                          child: const SizedBox(
                            width: 32.0,
                            height: 32.0,
                            child: Icon(
                              Icons.close,
                              size: 18.0,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12.0),

                  // Availability Bar & Slot Count
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          _capacitySummary,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w700,
                            color: statusColor,
                          ),
                        ),
                      ),
                      if (location.status != ParkingStatus.offline)
                        Text(
                          '${location.occupiedSlots} terisi',
                          style: const TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textSecondary,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 6.0),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4.0),
                    child: Container(
                      height: 6.0,
                      width: double.infinity,
                      color: AppColors.cardSurface,
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: location.availabilityRatio,
                        child: Container(color: statusColor),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14.0),

                  // Action Buttons: Focus on Map + Open Full Detail Sheet
                  Row(
                    children: [
                      OutlinedButton.icon(
                        key: const Key('sheet_focus_parking_button'),
                        onPressed: onFocusLocation,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.textPrimary,
                          side: const BorderSide(color: AppColors.border),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12.0,
                            vertical: 10.0,
                          ),
                          minimumSize: const Size(0, 42.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        icon: const Icon(
                          Icons.center_focus_strong_outlined,
                          size: 17.0,
                          color: AppColors.primaryRed,
                        ),
                        label: const Text(
                          'Fokus',
                          style: TextStyle(
                            fontSize: 13.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10.0),
                      Expanded(
                        child: SizedBox(
                          height: 42.0,
                          child: ElevatedButton.icon(
                            key: const Key('open_parking_detail_button'),
                            onPressed: onOpenDetail,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryRed,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14.0,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            icon: const Icon(
                              Icons.near_me,
                              size: 16.0,
                              color: Colors.white,
                            ),
                            label: const Text(
                              'Lihat Detail & Rute',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w700,
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
      ),
    );
  }
}

