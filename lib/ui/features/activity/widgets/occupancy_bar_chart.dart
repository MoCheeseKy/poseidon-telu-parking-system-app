import 'package:flutter/material.dart';
import 'package:poseidon/core/constants/app_colors.dart';
import 'package:poseidon/data/models/activity_analytics.dart';

class OccupancyBarChart extends StatefulWidget {
  final String title;
  final String subtitle;
  final List<OccupancyBarData> bars;

  const OccupancyBarChart({
    super.key,
    required this.title,
    required this.subtitle,
    required this.bars,
  });

  @override
  State<OccupancyBarChart> createState() => _OccupancyBarChartState();
}

class _OccupancyBarChartState extends State<OccupancyBarChart> {
  int? _hoveredIndex;

  @override
  Widget build(BuildContext context) {
    // Determine which bar is the peak
    final peakIndex = widget.bars.indexWhere((b) => b.isPeak);
    final activeTooltipIndex = _hoveredIndex ?? (peakIndex != -1 ? peakIndex : 2);
    final activeBar = widget.bars.isNotEmpty && activeTooltipIndex < widget.bars.length
        ? widget.bars[activeTooltipIndex]
        : null;

    final tooltipText = activeBar?.peakBadgeText ??
        '${activeBar?.time ?? ""}, ${((activeBar?.percentage ?? 0) * 100).toInt()}% Keterisian';

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
          // Title
          Text(
            widget.title,
            style: const TextStyle(
              fontSize: 16.5,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.3,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 3.0),

          // Subtitle
          Text(
            widget.subtitle,
            style: const TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w400,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 16.0),

          // Peak Badge Tooltip (positioned above peak bar)
          Center(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14.0,
                    vertical: 5.5,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryRed,
                    borderRadius: BorderRadius.circular(16.0),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryRed.withValues(alpha: 0.3),
                        blurRadius: 6.0,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    tooltipText,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                // Tiny downward triangle pointing down
                CustomPaint(
                  size: const Size(12, 6),
                  painter: _TrianglePainter(color: AppColors.primaryRed),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8.0),

          // Chart Graphic Area: Left Y-Axis Labels + Dashed Grid + Bars
          SizedBox(
            height: 175.0,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Y-Axis Labels
                SizedBox(
                  width: 36.0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildYLabel('100%'),
                      _buildYLabel('80%', isRed: true),
                      _buildYLabel('60%'),
                      _buildYLabel('40%'),
                      _buildYLabel('20%'),
                      _buildYLabel('0%'),
                    ],
                  ),
                ),

                // Grid Lines & Bars Area
                Expanded(
                  child: Stack(
                    children: [
                      // Background Dashed Grid
                      const Positioned.fill(
                        child: CustomPaint(
                          painter: _DashedGridPainter(),
                        ),
                      ),

                      // Bars
                      Positioned.fill(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              for (int i = 0; i < widget.bars.length; i++)
                                _buildBarItem(
                                  index: i,
                                  data: widget.bars[i],
                                  isSelected: i == activeTooltipIndex,
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8.0),

          // Bottom X-Axis Time Labels
          Padding(
            padding: const EdgeInsets.only(left: 36.0),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  for (int i = 0; i < widget.bars.length; i++)
                    SizedBox(
                      width: 36.0,
                      child: Text(
                        widget.bars[i].time,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 10.5,
                          fontWeight: widget.bars[i].isPeak
                              ? FontWeight.w800
                              : FontWeight.w500,
                          color: widget.bars[i].isPeak
                              ? AppColors.textPrimary
                              : AppColors.textSecondary,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 18.0),

          // Legend at bottom
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildLegendItem(
                color: const Color(0xFF48A868),
                title: 'Rendah',
                subtitle: '(<60%)',
              ),
              _buildLegendItem(
                color: const Color(0xFFC07D2B),
                title: 'Menengah',
                subtitle: '(60–80%)',
              ),
              _buildLegendItem(
                color: AppColors.primaryRed,
                title: 'Puncak',
                subtitle: '(>80%)',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildYLabel(String text, {bool isRed = false}) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 9.5,
        fontWeight: isRed ? FontWeight.w800 : FontWeight.w500,
        color: isRed ? AppColors.primaryRed : AppColors.textMuted,
      ),
    );
  }

  Widget _buildBarItem({
    required int index,
    required OccupancyBarData data,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _hoveredIndex = index;
        });
      },
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            width: 20.0,
            height: 175.0 * data.percentage.clamp(0.05, 1.0),
            decoration: BoxDecoration(
              color: data.barColor,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(4.0),
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: data.barColor.withValues(alpha: 0.35),
                        blurRadius: 6.0,
                        offset: const Offset(0, -1),
                      ),
                    ]
                  : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem({
    required Color color,
    required String title,
    required String subtitle,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 2.0),
          width: 10.0,
          height: 10.0,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2.0),
          ),
        ),
        const SizedBox(width: 6.0),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 11.0,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 10.0,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _TrianglePainter extends CustomPainter {
  final Color color;

  const _TrianglePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width / 2, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _DashedGridPainter extends CustomPainter {
  const _DashedGridPainter();

  @override
  void paint(Canvas canvas, Size size) {
    const levels = [1.0, 0.8, 0.6, 0.4, 0.2, 0.0];

    for (final level in levels) {
      final y = size.height * (1.0 - level);
      final isRedThreshold = (level - 0.8).abs() < 0.01;

      final paint = Paint()
        ..color = isRedThreshold
            ? const Color(0xFFE53935).withValues(alpha: 0.5)
            : const Color(0xFFE5E7EB)
        ..strokeWidth = isRedThreshold ? 1.2 : 0.8
        ..style = PaintingStyle.stroke;

      _drawDashedLine(canvas, Offset(0, y), Offset(size.width, y), paint);
    }
  }

  void _drawDashedLine(Canvas canvas, Offset start, Offset end, Paint paint) {
    const dashWidth = 3.5;
    const dashSpace = 3.0;
    double currentX = start.dx;

    while (currentX < end.dx) {
      final nextX = (currentX + dashWidth).clamp(start.dx, end.dx);
      canvas.drawLine(
        Offset(currentX, start.dy),
        Offset(nextX, start.dy),
        paint,
      );
      currentX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
