import 'package:flutter/material.dart';
import 'package:poseidon/core/constants/app_colors.dart';
import 'package:poseidon/data/models/activity_analytics.dart';

class BusyTimePatternCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<BusyTimeSlot> slots;

  const BusyTimePatternCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.slots,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text(
            title,
            style: const TextStyle(
              fontSize: 16.5,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.3,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 3.0),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w400,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 16.0),

          // Items
          for (int i = 0; i < slots.length; i++) ...[
            if (i > 0) const SizedBox(height: 18.0),
            _buildSlotItem(slots[i]),
          ],
        ],
      ),
    );
  }

  Widget _buildSlotItem(BusyTimeSlot slot) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Number box (01, 02, etc.)
            Container(
              width: 28.0,
              height: 28.0,
              decoration: BoxDecoration(
                color: AppColors.chipBackground,
                borderRadius: BorderRadius.circular(6.0),
              ),
              child: Center(
                child: Text(
                  slot.number,
                  style: const TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10.0),

            // Title & Subtitle & Badge
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          slot.title,
                          style: const TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8.0,
                          vertical: 2.5,
                        ),
                        decoration: BoxDecoration(
                          color: slot.level.badgeBg,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Text(
                          slot.level.label,
                          style: TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w700,
                            color: slot.level.badgeText,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2.0),
                  Text(
                    slot.subtitle,
                    style: const TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8.0),

        // Progress bar
        ClipRRect(
          borderRadius: BorderRadius.circular(3.0),
          child: Container(
            height: 6.0,
            width: double.infinity,
            color: AppColors.chipBackground,
            child: Align(
              alignment: Alignment.centerLeft,
              child: FractionallySizedBox(
                widthFactor: slot.progress.clamp(0.0, 1.0),
                child: Container(
                  color: slot.level.barColor,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
