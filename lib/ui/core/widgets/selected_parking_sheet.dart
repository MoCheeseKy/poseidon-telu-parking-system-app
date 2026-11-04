import 'package:flutter/material.dart';
import 'package:poseidon/core/constants/app_colors.dart';
import 'package:poseidon/data/models/parking_location.dart';

/// Clean, minimal destination parking card displayed during Mode Fokus.
/// Shows parking name, location info, distance, capacity progress, and cancel action.
class SelectedParkingSheet extends StatelessWidget {
  final ParkingLocation location;
  final VoidCallback onClose;
  final VoidCallback onOpenDetail;
  final VoidCallback onCancelDestination;
  final String? distanceText;

  const SelectedParkingSheet({
    super.key,
    required this.location,
    required this.onClose,
    required this.onOpenDetail,
    required this.onCancelDestination,
    this.distanceText,
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
        return 'Data slot tidak tersedia';
      case ParkingStatus.full:
        return '0 dari ${location.totalSlots} slot tersedia';
      case ParkingStatus.available:
      case ParkingStatus.warning:
        return '${location.availableSlots} dari ${location.totalSlots} slot tersedia';
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor;

    return Center(
      heightFactor: 1.0,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560.0),
        child: Container(
          key: const Key('selected_parking_compact_sheet'),
          margin: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 20.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18.0),
            border: Border.all(
              color: AppColors.border.withValues(alpha: 0.8),
              width: 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.10),
                blurRadius: 18.0,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            bottom: true,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18.0, 16.0, 18.0, 16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Row: Status badge on left, Close button (X) on right
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10.0,
                          vertical: 4.0,
                        ),
                        decoration: BoxDecoration(
                          color: _badgeBgColor,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Text(
                          _statusBadgeLabel,
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w700,
                            color: _badgeTextColor,
                          ),
                        ),
                      ),
                      Material(
                        color: AppColors.cardSurface,
                        shape: const CircleBorder(),
                        child: InkWell(
                          key: const Key('close_selected_parking_button'),
                          customBorder: const CircleBorder(),
                          onTap: onCancelDestination,
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

                  // Detail Body (interactive for detail view if tapped)
                  InkWell(
                    key: const Key('open_parking_detail_button'),
                    onTap: onOpenDetail,
                    borderRadius: BorderRadius.circular(10.0),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Destination Title
                          Text(
                            location.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 17.5,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                            ),
                          ),

                          // Gate and Sub-area description
                          if (location.gateInfo.isNotEmpty ||
                              location.subArea.isNotEmpty) ...[
                            const SizedBox(height: 4.0),
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on_outlined,
                                  size: 14.0,
                                  color: AppColors.textSecondary,
                                ),
                                const SizedBox(width: 4.0),
                                Expanded(
                                  child: Text(
                                    location.subArea.isNotEmpty
                                        ? '${location.gateInfo}, ${location.subArea}'
                                        : location.gateInfo,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],

                          // Distance Info (Straight-line estimate)
                          if (distanceText != null &&
                              distanceText!.isNotEmpty) ...[
                            const SizedBox(height: 4.0),
                            Row(
                              children: [
                                const Icon(
                                  Icons.straighten,
                                  size: 14.0,
                                  color: AppColors.primaryRed,
                                ),
                                const SizedBox(width: 4.0),
                                Text(
                                  distanceText!,
                                  style: const TextStyle(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primaryRed,
                                  ),
                                ),
                              ],
                            ),
                          ],
                          const SizedBox(height: 12.0),

                          // Capacity Text & Occupancy
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
                              if (location.status != ParkingStatus.offline) ...[
                                const SizedBox(width: 8.0),
                                Text(
                                  '${location.occupiedSlots} terisi',
                                  style: const TextStyle(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 6.0),

                          // Availability Progress Bar
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4.0),
                            child: Container(
                              height: 5.0,
                              width: double.infinity,
                              color: AppColors.cardSurface,
                              child: FractionallySizedBox(
                                alignment: Alignment.centerLeft,
                                widthFactor: location.availabilityRatio,
                                child: Container(color: statusColor),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),

                  // Single Full-Width Action: Batalkan Tujuan
                  SizedBox(
                    width: double.infinity,
                    height: 44.0,
                    child: ElevatedButton.icon(
                      key: const Key('cancel_destination_button'),
                      onPressed: onCancelDestination,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryRed,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      icon: const Icon(
                        Icons.close,
                        size: 16.0,
                        color: Colors.white,
                      ),
                      label: const Text(
                        'Batalkan Tujuan',
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
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
