import 'package:flutter/material.dart';
import 'package:poseidon/core/constants/app_colors.dart';
import 'package:poseidon/data/models/parking_location.dart';

class ParkingItemTile extends StatelessWidget {
  final ParkingLocation location;
  final VoidCallback? onTap;
  final bool isCardStyle;
  final String? customSubtitle;
  final String? distanceText;

  const ParkingItemTile({
    super.key,
    required this.location,
    this.onTap,
    this.isCardStyle = false,
    this.customSubtitle,
    this.distanceText,
  });

  @override
  Widget build(BuildContext context) {
    if (isCardStyle) {
      final isWarning = location.status == ParkingStatus.warning;
      final isFull = location.status == ParkingStatus.full;
      final badgeBg = isFull
          ? const Color(0xFFFEE2E2)
          : isWarning
              ? AppColors.statusOrangeBadgeBg
              : AppColors.statusGreenBadgeBg;
      final badgeText = isFull
          ? AppColors.statusRed
          : isWarning
              ? AppColors.statusOrangeBadgeText
              : AppColors.statusGreenBadgeText;

      final iconBg = isFull
          ? const Color(0xFFFEE2E2)
          : isWarning
              ? const Color(0xFFFEF3C7)
              : const Color(0xFFDCFCE7);
      final iconColor = isFull
          ? AppColors.statusRed
          : isWarning
              ? AppColors.statusOrange
              : AppColors.statusGreen;

      final slotCount = '${location.availableSlots} slot';

      return Container(
        margin: const EdgeInsets.only(bottom: 12.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(color: AppColors.subtleCardBorder),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.025),
              blurRadius: 8.0,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16.0),
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Squircle tinted leading 'P' badge
                    Container(
                      width: 42.0,
                      height: 42.0,
                      decoration: BoxDecoration(
                        color: iconBg,
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'P',
                        style: TextStyle(
                          fontSize: 16.5,
                          fontWeight: FontWeight.w800,
                          color: iconColor,
                        ),
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
                              fontSize: 14.5,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.2,
                              color: AppColors.textPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (location.subArea.isNotEmpty) ...[
                            const SizedBox(height: 2.5),
                            Text(
                              location.subArea,
                              style: const TextStyle(
                                fontSize: 11.5,
                                color: AppColors.textSecondary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    // Availability slot badge pill
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                        vertical: 4.5,
                      ),
                      decoration: BoxDecoration(
                        color: badgeBg,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Text(
                        slotCount,
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                          color: badgeText,
                        ),
                      ),
                    ),
                  ],
                ),
                if (distanceText != null || customSubtitle != null) ...[
                  const SizedBox(height: 12.0),
                  const Divider(height: 1.0, color: Color(0xFFF3F4F6)),
                  const SizedBox(height: 10.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.straighten,
                            size: 14.0,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 4.0),
                          Text(
                            distanceText ?? customSubtitle!,
                            style: const TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Pilih',
                            style: TextStyle(
                              fontSize: 12.0,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primaryRed,
                            ),
                          ),
                          SizedBox(width: 2.0),
                          Icon(
                            Icons.chevron_right_rounded,
                            size: 16.0,
                            color: AppColors.primaryRed,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      );
    }

    // Default clean row format (Screen A)
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 9.0, horizontal: 2.0),
        child: Row(
          children: [
            _buildLeadingIcon(),
            const SizedBox(width: 12.0),
            Expanded(
              child: Text(
                location.name,
                style: const TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8.0),
            Text(
              _getStatusText(),
              style: TextStyle(
                fontSize: 13.0,
                fontWeight: FontWeight.w700,
                color: _getStatusColor(),
              ),
            ),
            const SizedBox(width: 4.0),
            const Icon(
              Icons.chevron_right,
              size: 18.0,
              color: AppColors.textMuted,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeadingIcon() {
    if (location.isFavorite) {
      return const Icon(
        Icons.star_rounded,
        size: 20.0,
        color: AppColors.primaryRed,
      );
    }

    switch (location.status) {
      case ParkingStatus.offline:
        return const Icon(
          Icons.portable_wifi_off_outlined,
          size: 18.0,
          color: AppColors.statusGrey,
        );
      case ParkingStatus.full:
        return const Icon(
          Icons.do_not_disturb_alt_outlined,
          size: 18.0,
          color: AppColors.statusRed,
        );
      case ParkingStatus.available:
      case ParkingStatus.warning:
        return const Text(
          'P',
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w800,
            color: AppColors.textSecondary,
          ),
        );
    }
  }



  String _getStatusText() {
    if (location.customStatusText != null) {
      return location.customStatusText!;
    }
    return '${location.availableSlots} slot';
  }

  Color _getStatusColor() {
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
}
