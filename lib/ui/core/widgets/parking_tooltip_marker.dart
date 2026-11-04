import 'package:flutter/material.dart';
import 'package:poseidon/core/constants/app_colors.dart';
import 'package:poseidon/data/models/parking_location.dart';

/// Compact, geographic-anchored floating tooltip marker for a [ParkingLocation].
///
/// Designed to be used inside `flutter_map`'s `Marker` with
/// `alignment: Alignment.topCenter` so the bottom anchor point aligns
/// accurately with the location's geographic coordinates across pan and zoom.
class ParkingTooltipMarker extends StatelessWidget {
  static const double markerWidth = 132.0;
  static const double markerHeight = 38.0;

  final ParkingLocation location;
  final bool isSelected;
  final VoidCallback? onTap;

  const ParkingTooltipMarker({
    super.key,
    required this.location,
    this.isSelected = false,
    this.onTap,
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

  String get _capacityLabel {
    switch (location.status) {
      case ParkingStatus.available:
      case ParkingStatus.warning:
        return '${location.availableSlots}';
      case ParkingStatus.full:
        return location.customStatusText ?? 'Penuh';
      case ParkingStatus.offline:
        return location.customStatusText ?? 'Offline';
    }
  }

  @override
  Widget build(BuildContext context) {
    final borderColor = isSelected ? AppColors.primaryRed : AppColors.border;
    final statusColor = _statusColor;

    return Align(
      alignment: Alignment.bottomCenter,
      child: GestureDetector(
        key: ValueKey('parking_marker_${location.id}'),
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Compact Single-Line Floating Pill Tooltip
            Container(
              constraints: const BoxConstraints(maxWidth: markerWidth),
              padding: const EdgeInsets.symmetric(
                horizontal: 7.5,
                vertical: 3.5,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14.0),
                border: Border.all(
                  color: borderColor,
                  width: isSelected ? 1.6 : 1.0,
                ),
                boxShadow: [
                  BoxShadow(
                    color: isSelected
                        ? AppColors.primaryRed.withValues(alpha: 0.22)
                        : Colors.black.withValues(alpha: 0.10),
                    blurRadius: isSelected ? 7.0 : 4.0,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 6.0,
                    height: 6.0,
                    decoration: BoxDecoration(
                      color: statusColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 4.5),
                  Flexible(
                    child: Text(
                      location.displayMapName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 10.5,
                        height: 1.15,
                        fontWeight: FontWeight.w700,
                        color: isSelected
                            ? AppColors.primaryRed
                            : AppColors.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 4.5),
                  Text(
                    _capacityLabel,
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 10.5,
                      height: 1.15,
                      fontWeight: FontWeight.w700,
                      color: statusColor,
                    ),
                  ),
                ],
              ),
            ),

            // Small Pointer Triangle Connecting Bubble to Coordinate Anchor
            Transform.translate(
              offset: const Offset(0, -1.0),
              child: CustomPaint(
                size: const Size(8.0, 4.0),
                painter: _TooltipPointerPainter(
                  fillColor: Colors.white,
                  borderColor: borderColor,
                  borderWidth: isSelected ? 1.6 : 1.0,
                ),
              ),
            ),

            // Geographic Coordinate Anchor Dot
            Container(
              width: isSelected ? 7.5 : 6.0,
              height: isSelected ? 7.5 : 6.0,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primaryRed : statusColor,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 1.4),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.16),
                    blurRadius: 2.0,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TooltipPointerPainter extends CustomPainter {
  final Color fillColor;
  final Color borderColor;
  final double borderWidth;

  const _TooltipPointerPainter({
    required this.fillColor,
    required this.borderColor,
    required this.borderWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final fillPath = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width / 2, size.height)
      ..lineTo(size.width, 0)
      ..close();

    final fillPaint = Paint()
      ..color = fillColor
      ..style = PaintingStyle.fill;
    canvas.drawPath(fillPath, fillPaint);

    final borderPath = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width / 2, size.height)
      ..lineTo(size.width, 0);

    final borderPaint = Paint()
      ..color = borderColor
      ..strokeWidth = borderWidth
      ..style = PaintingStyle.stroke
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(borderPath, borderPaint);
  }

  @override
  bool shouldRepaint(covariant _TooltipPointerPainter oldDelegate) {
    return oldDelegate.fillColor != fillColor ||
        oldDelegate.borderColor != borderColor ||
        oldDelegate.borderWidth != borderWidth;
  }
}
