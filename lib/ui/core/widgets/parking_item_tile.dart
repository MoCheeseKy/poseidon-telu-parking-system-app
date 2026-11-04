import 'package:flutter/material.dart';
import 'package:poseidon/core/constants/app_colors.dart';
import 'package:poseidon/data/models/parking_location.dart';

class ParkingItemTile extends StatelessWidget {
  final ParkingLocation location;
  final VoidCallback? onTap;
  final bool isCardStyle;
  final String? customSubtitle;

  const ParkingItemTile({
    super.key,
    required this.location,
    this.onTap,
    this.isCardStyle = false,
    this.customSubtitle,
  });

  @override
  Widget build(BuildContext context) {
    if (isCardStyle) {
      return Container(
        margin: const EdgeInsets.only(bottom: 10.0),
        decoration: BoxDecoration(
          color: AppColors.surfaceGrey,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(color: AppColors.border, width: 1.0),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 14.0,
              vertical: 12.0,
            ),
            child: Row(
              children: [
                _buildCardIconBox(),
                const SizedBox(width: 14.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        location.name,
                        style: const TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2.0),
                      Text(
                        customSubtitle ?? _getStatusText(),
                        style: TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w600,
                          color: _getStatusColor(),
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.chevron_right,
                  size: 20.0,
                  color: AppColors.textMuted,
                ),
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

  Widget _buildCardIconBox() {
    return Container(
      width: 36.0,
      height: 36.0,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: AppColors.border, width: 1.0),
      ),
      child: const Center(
        child: Text(
          'P',
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w800,
            color: AppColors.textSecondary,
          ),
        ),
      ),
    );
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
