import 'package:flutter/material.dart';
import 'package:poseidon/core/constants/app_colors.dart';
import 'package:poseidon/data/models/parking_location.dart';

class VehicleTypeSelector extends StatelessWidget {
  final VehicleType selectedType;
  final ValueChanged<VehicleType> onTypeChanged;

  const VehicleTypeSelector({
    super.key,
    required this.selectedType,
    required this.onTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44.0,
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(10.0),
      ),
      padding: const EdgeInsets.all(4.0),
      child: Row(
        children: [
          Expanded(
            child: _buildOption(
              type: VehicleType.motor,
              label: 'Motor',
              icon: Icons.two_wheeler,
              isSelected: selectedType == VehicleType.motor,
            ),
          ),
          const SizedBox(width: 4.0),
          Expanded(
            child: _buildOption(
              type: VehicleType.mobil,
              label: 'Mobil',
              icon: Icons.directions_car_outlined,
              isSelected: selectedType == VehicleType.mobil,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOption({
    required VehicleType type,
    required String label,
    required IconData icon,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () => onTypeChanged(type),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryRed : Colors.transparent,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 18.0,
                color: isSelected ? Colors.white : AppColors.textSecondary,
              ),
              const SizedBox(width: 8.0),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected ? Colors.white : AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
