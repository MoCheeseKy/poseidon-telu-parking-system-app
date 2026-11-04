import 'package:flutter/material.dart';

enum TimeRangeFilter {
  days7,
  days30,
}

extension TimeRangeFilterExtension on TimeRangeFilter {
  String get label {
    switch (this) {
      case TimeRangeFilter.days7:
        return '7 Hari Terakhir';
      case TimeRangeFilter.days30:
        return '30 Hari Terakhir';
    }
  }
}

enum BusyLevel {
  padat,
  menengah,
  rendah,
}

extension BusyLevelExtension on BusyLevel {
  String get label {
    switch (this) {
      case BusyLevel.padat:
        return 'Padat';
      case BusyLevel.menengah:
        return 'Menengah';
      case BusyLevel.rendah:
        return 'Rendah';
    }
  }

  Color get badgeBg {
    switch (this) {
      case BusyLevel.padat:
        return const Color(0xFFFEE2E2);
      case BusyLevel.menengah:
        return const Color(0xFFFEF3C7);
      case BusyLevel.rendah:
        return const Color(0xFFD1FAE5);
    }
  }

  Color get badgeText {
    switch (this) {
      case BusyLevel.padat:
        return const Color(0xFFDC2626);
      case BusyLevel.menengah:
        return const Color(0xFFB45309);
      case BusyLevel.rendah:
        return const Color(0xFF059669);
    }
  }

  Color get barColor {
    switch (this) {
      case BusyLevel.padat:
        return const Color(0xFFE53935);
      case BusyLevel.menengah:
        return const Color(0xFFD97706);
      case BusyLevel.rendah:
        return const Color(0xFF10B981);
    }
  }
}

class OccupancyBarData {
  final String time;
  final double percentage; // 0.0 to 1.0 (e.g. 0.86)
  final bool isPeak;
  final String? peakBadgeText;
  final Color barColor;

  const OccupancyBarData({
    required this.time,
    required this.percentage,
    this.isPeak = false,
    this.peakBadgeText,
    required this.barColor,
  });
}

class BusyTimeSlot {
  final String number;
  final String title;
  final String subtitle;
  final BusyLevel level;
  final double progress; // 0.0 to 1.0

  const BusyTimeSlot({
    required this.number,
    required this.title,
    required this.subtitle,
    required this.level,
    required this.progress,
  });
}

class ActivityAnalytics {
  final int avgOccupancy;
  final String avgOccupancyUnit;
  final String avgOccupancySub;
  final int monitoredAreas;
  final String monitoredAreasUnit;
  final String monitoredAreasSub;
  final String peakTime;
  final String peakTimeSub;
  final String chartTitle;
  final String chartSubtitle;
  final List<OccupancyBarData> bars;
  final List<BusyTimeSlot> busySlots;

  const ActivityAnalytics({
    required this.avgOccupancy,
    this.avgOccupancyUnit = '%',
    required this.avgOccupancySub,
    required this.monitoredAreas,
    this.monitoredAreasUnit = 'Lokasi',
    required this.monitoredAreasSub,
    required this.peakTime,
    required this.peakTimeSub,
    required this.chartTitle,
    required this.chartSubtitle,
    required this.bars,
    required this.busySlots,
  });
}
