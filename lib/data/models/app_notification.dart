import 'package:flutter/material.dart';

enum NotificationSection {
  today,
  yesterday,
}

enum NotificationCategoryType {
  parkingReportPending,
  sensorStatus,
  campusInfo,
  parkingReportResolved,
}

class AppNotification {
  final String id;
  final String title;
  final String message;
  final String fullDetail;
  final String timeLabel;
  final String categoryLabel;
  final NotificationSection section;
  final NotificationCategoryType categoryType;
  final bool isUnread;

  const AppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.fullDetail,
    required this.timeLabel,
    required this.categoryLabel,
    required this.section,
    required this.categoryType,
    this.isUnread = false,
  });

  AppNotification copyWith({
    String? id,
    String? title,
    String? message,
    String? fullDetail,
    String? timeLabel,
    String? categoryLabel,
    NotificationSection? section,
    NotificationCategoryType? categoryType,
    bool? isUnread,
  }) {
    return AppNotification(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      fullDetail: fullDetail ?? this.fullDetail,
      timeLabel: timeLabel ?? this.timeLabel,
      categoryLabel: categoryLabel ?? this.categoryLabel,
      section: section ?? this.section,
      categoryType: categoryType ?? this.categoryType,
      isUnread: isUnread ?? this.isUnread,
    );
  }

  IconData get leadingIcon {
    switch (categoryType) {
      case NotificationCategoryType.parkingReportPending:
        return Icons.assignment_turned_in_outlined;
      case NotificationCategoryType.sensorStatus:
        return Icons.sensors_off;
      case NotificationCategoryType.campusInfo:
        return Icons.campaign_outlined;
      case NotificationCategoryType.parkingReportResolved:
        return Icons.check_circle_outline;
    }
  }

  IconData get badgeIcon {
    switch (categoryType) {
      case NotificationCategoryType.parkingReportPending:
        return Icons.directions_car_outlined;
      case NotificationCategoryType.sensorStatus:
        return Icons.router_outlined;
      case NotificationCategoryType.campusInfo:
        return Icons.school_outlined;
      case NotificationCategoryType.parkingReportResolved:
        return Icons.check;
    }
  }

  Color get accentColor {
    switch (categoryType) {
      case NotificationCategoryType.parkingReportPending:
        return const Color(0xFFC8102E);
      case NotificationCategoryType.sensorStatus:
        return const Color(0xFFB45309);
      case NotificationCategoryType.campusInfo:
        return const Color(0xFF4B5563);
      case NotificationCategoryType.parkingReportResolved:
        return const Color(0xFF15803D);
    }
  }

  Color get softBackgroundColor {
    switch (categoryType) {
      case NotificationCategoryType.parkingReportPending:
        return const Color(0xFFFDECEC);
      case NotificationCategoryType.sensorStatus:
        return const Color(0xFFF6EFE2);
      case NotificationCategoryType.campusInfo:
        return const Color(0xFFEEF0F3);
      case NotificationCategoryType.parkingReportResolved:
        return const Color(0xFFE6F4EA);
    }
  }
}

