import 'package:flutter/material.dart';
import 'package:poseidon/core/constants/app_colors.dart';

class AppBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTabSelected;
  final VoidCallback onCenterAction;

  const AppBottomNavBar({
    super.key,
    this.currentIndex = 0,
    required this.onTabSelected,
    required this.onCenterAction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10.0,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64.0,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(
                    icon: Icons.map_outlined,
                    label: 'Peta',
                    index: 0,
                  ),
                  _buildNavItem(
                    icon: Icons.flag_outlined,
                    label: 'Laporan',
                    index: 1,
                  ),
                  const SizedBox(width: 78.0), // Space for center FAB
                  _buildNavItem(
                    icon: Icons.history,
                    label: 'Aktivitas',
                    index: 2,
                  ),
                  _buildNavItem(
                    icon: Icons.person_outline,
                    label: 'Akun',
                    index: 3,
                  ),
                ],
              ),

              // Floating Central Action Button
              Positioned(
                top: -24.0,
                child: GestureDetector(
                  key: const Key('center_action_button'),
                  onTap: onCenterAction,
                  child: Container(
                    width: 78.0,
                    height: 56.0,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE31E2D),
                      borderRadius: BorderRadius.circular(28.0),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFE31E2D).withValues(alpha: 0.42),
                          blurRadius: 18.0,
                          spreadRadius: 1.0,
                          offset: const Offset(0, 6),
                        ),
                        BoxShadow(
                          color: const Color(0xFFE31E2D).withValues(alpha: 0.20),
                          blurRadius: 6.0,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.near_me_outlined,
                        color: Colors.white,
                        size: 26.0,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final isSelected = currentIndex == index;
    final color = isSelected ? AppColors.textPrimary : const Color(0xFF686B73);

    return Expanded(
      child: InkWell(
        onTap: () => onTabSelected(index),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 23.0, color: color),
            const SizedBox(height: 4.0),
            Text(
              label,
              style: TextStyle(
                fontSize: 10.5,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
