import 'package:flutter/material.dart';
import 'package:poseidon/core/constants/app_colors.dart';
import 'package:poseidon/data/mock/mock_activity_data.dart';
import 'package:poseidon/data/models/activity_analytics.dart';
import 'package:poseidon/data/models/parking_location.dart';
import 'package:poseidon/ui/core/widgets/app_bottom_nav_bar.dart';
import 'package:poseidon/ui/core/widgets/poseidon_app_bar.dart';
import 'package:poseidon/ui/features/activity/widgets/activity_filter_pills.dart';
import 'package:poseidon/ui/features/activity/widgets/busy_time_pattern_card.dart';
import 'package:poseidon/ui/features/activity/widgets/metric_summary_card.dart';
import 'package:poseidon/ui/features/activity/widgets/occupancy_bar_chart.dart';

class ActivityScreen extends StatefulWidget {
  final bool showScaffold;
  final ValueChanged<int>? onTabSelected;
  final VoidCallback? onCenterAction;

  const ActivityScreen({
    super.key,
    this.showScaffold = true,
    this.onTabSelected,
    this.onCenterAction,
  });

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  TimeRangeFilter _timeRange = TimeRangeFilter.days7;
  VehicleType _vehicle = VehicleType.motor;

  @override
  Widget build(BuildContext context) {
    final analytics = MockActivityData.getAnalytics(
      vehicleType: _vehicle,
      timeRange: _timeRange,
    );

    final content = _buildContent(analytics);

    if (!widget.showScaffold) {
      return content;
    }

    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      appBar: const PoseidonAppBar(),
      body: content,
      bottomNavigationBar: widget.onTabSelected != null
          ? AppBottomNavBar(
              currentIndex: 2,
              onTabSelected: widget.onTabSelected!,
              onCenterAction: widget.onCenterAction ?? () {},
            )
          : null,
    );
  }

  Widget _buildContent(ActivityAnalytics analytics) {
    return SafeArea(
      top: false,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600.0),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 32.0),
            physics: const BouncingScrollPhysics(),
            children: [
              // Page Title
              const Text(
                'Aktivitas',
                style: TextStyle(
                  fontSize: 26.0,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 6.0),

              // Subtitle
              const Text(
                'Analitik penggunaan parkir kampus',
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 16.0),

              // Filter Controls (Time Range & Vehicle)
              ActivityFilterPills(
                selectedTimeRange: _timeRange,
                onTimeRangeChanged: (val) {
                  setState(() => _timeRange = val);
                },
                selectedVehicle: _vehicle,
                onVehicleChanged: (val) {
                  setState(() => _vehicle = val);
                },
              ),
              const SizedBox(height: 16.0),

              // Metric 1: Rata-rata Keterisian
              MetricSummaryCard(
                title: 'Rata-rata Keterisian',
                value: '${analytics.avgOccupancy}',
                unit: analytics.avgOccupancyUnit,
                subtitle: analytics.avgOccupancySub,
                icon: Icons.show_chart,
              ),
              const SizedBox(height: 12.0),

              // Metric 2: Area Terpantau
              MetricSummaryCard(
                title: 'Area Terpantau',
                value: '${analytics.monitoredAreas}',
                unit: analytics.monitoredAreasUnit,
                subtitle: analytics.monitoredAreasSub,
                icon: Icons.sensors,
              ),
              const SizedBox(height: 12.0),

              // Metric 3: Puncak Kepadatan
              MetricSummaryCard(
                title: 'Puncak Kepadatan',
                value: analytics.peakTime,
                subtitle: analytics.peakTimeSub,
                icon: Icons.access_time,
                iconColor: AppColors.primaryRed,
                valueColor: AppColors.primaryRed,
              ),
              const SizedBox(height: 16.0),

              // Chart: Tren Okupansi Harian
              OccupancyBarChart(
                title: analytics.chartTitle,
                subtitle: analytics.chartSubtitle,
                bars: analytics.bars,
              ),
              const SizedBox(height: 16.0),

              // List: Pola Waktu Tersibuk
              BusyTimePatternCard(
                title: 'Pola Waktu Tersibuk',
                subtitle: 'Berdasarkan rekap sensor harian',
                slots: analytics.busySlots,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
