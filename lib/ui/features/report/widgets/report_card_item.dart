import 'package:flutter/material.dart';
import 'package:poseidon/core/constants/app_colors.dart';
import 'package:poseidon/data/models/report_item.dart';

class ReportCardItem extends StatelessWidget {
  final ReportItem report;
  final VoidCallback onTap;

  const ReportCardItem({
    super.key,
    required this.report,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    report.title,
                    style: const TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4.0),

                  // Subtitle / description
                  Text(
                    report.description,
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textSecondary,
                      height: 1.35,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 10.0),

                  // Status Badge & Date
                  Row(
                    children: [
                      // Status pill
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10.0,
                          vertical: 3.5,
                        ),
                        decoration: BoxDecoration(
                          color: report.status.backgroundColor,
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Text(
                          report.status.label,
                          style: TextStyle(
                            fontSize: 11.0,
                            fontWeight: FontWeight.w700,
                            color: report.status.textColor,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10.0),

                      // Timestamp
                      Flexible(
                        child: Text(
                          report.timestamp,
                          style: const TextStyle(
                            fontSize: 11.0,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textMuted,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8.0),
            const Icon(
              Icons.chevron_right,
              color: AppColors.textMuted,
              size: 22.0,
            ),
          ],
        ),
      ),
    );
  }
}
