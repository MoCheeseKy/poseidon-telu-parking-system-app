import 'package:flutter/material.dart';
import 'package:poseidon/core/constants/app_colors.dart';
import 'package:poseidon/data/models/activity_analytics.dart';
import 'package:poseidon/data/models/parking_location.dart';

class ActivityFilterPills extends StatelessWidget {
  final TimeRangeFilter selectedTimeRange;
  final ValueChanged<TimeRangeFilter> onTimeRangeChanged;
  final VehicleType selectedVehicle;
  final ValueChanged<VehicleType> onVehicleChanged;

  const ActivityFilterPills({
    super.key,
    required this.selectedTimeRange,
    required this.onTimeRangeChanged,
    required this.selectedVehicle,
    required this.onVehicleChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Time Range Filter Row
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.chipBackground,
              borderRadius: BorderRadius.circular(20.0),
            ),
            padding: const EdgeInsets.all(3.5),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTimeChip(
                  label: '7 Hari Terakhir',
                  isSelected: selectedTimeRange == TimeRangeFilter.days7,
                  onTap: () => onTimeRangeChanged(TimeRangeFilter.days7),
                ),
                _buildTimeChip(
                  label: '30 Hari Terakhir',
                  isSelected: selectedTimeRange == TimeRangeFilter.days30,
                  onTap: () => onTimeRangeChanged(TimeRangeFilter.days30),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10.0),

        // Vehicle Filter Row
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.chipBackground,
              borderRadius: BorderRadius.circular(20.0),
            ),
            padding: const EdgeInsets.all(3.5),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildVehicleChip(
                  label: 'Motor',
                  icon: Icons.two_wheeler,
                  isSelected: selectedVehicle == VehicleType.motor,
                  onTap: () => onVehicleChanged(VehicleType.motor),
                ),
                _buildVehicleChip(
                  label: 'Mobil',
                  icon: Icons.directions_car_outlined,
                  isSelected: selectedVehicle == VehicleType.mobil,
                  onTap: () => onVehicleChanged(VehicleType.mobil),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 6.0),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(18.0),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 4.0,
                    offset: const Offset(0, 1),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12.5,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildVehicleChip({
    required String label,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 5.0),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(18.0),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 4.0,
                    offset: const Offset(0, 1),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16.0,
              color: isSelected ? AppColors.primaryRed : AppColors.textMuted,
            ),
            const SizedBox(width: 6.0),
            Text(
              label,
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color:
                    isSelected ? AppColors.textPrimary : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
