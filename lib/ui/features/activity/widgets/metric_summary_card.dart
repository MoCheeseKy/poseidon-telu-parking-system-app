import 'package:flutter/material.dart';
import 'package:poseidon/core/constants/app_colors.dart';

class MetricSummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final String? unit;
  final String subtitle;
  final IconData icon;
  final Color? iconColor;
  final Color? valueColor;

  const MetricSummaryCard({
    super.key,
    required this.title,
    required this.value,
    this.unit,
    required this.subtitle,
    required this.icon,
    this.iconColor,
    this.valueColor,
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
          // Top Row: Title + Icon
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13.0,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
              ),
              Icon(
                icon,
                size: 20.0,
                color: iconColor ?? AppColors.textSecondary,
              ),
            ],
          ),
          const SizedBox(height: 8.0),

          // Middle: Big Value + Unit
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: value.length > 5 ? 21.0 : 28.0,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                    color: valueColor ?? AppColors.textPrimary,
                  ),
                ),
                if (unit != null) ...[
                  const SizedBox(width: 4.0),
                  Text(
                    unit!,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w700,
                      color: valueColor ?? AppColors.textPrimary,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 4.0),

          // Footnote / Subtitle
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w400,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
