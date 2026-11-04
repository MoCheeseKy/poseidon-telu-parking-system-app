import 'package:flutter/material.dart';

enum ReportStatus {
  selesai,
  sedangDitinjau,
  ditindaklanjuti,
}

extension ReportStatusExtension on ReportStatus {
  String get label {
    switch (this) {
      case ReportStatus.selesai:
        return 'Selesai';
      case ReportStatus.sedangDitinjau:
        return 'Sedang Ditinjau';
      case ReportStatus.ditindaklanjuti:
        return 'Ditindaklanjuti';
    }
  }

  Color get backgroundColor {
    switch (this) {
      case ReportStatus.selesai:
        return const Color(0xFFE8F5E9); // soft light green
      case ReportStatus.sedangDitinjau:
        return const Color(0xFFFEF3C7); // soft light amber
      case ReportStatus.ditindaklanjuti:
        return const Color(0xFFFEE2E2); // soft light pink/red
    }
  }

  Color get textColor {
    switch (this) {
      case ReportStatus.selesai:
        return const Color(0xFF16A34A); // green text
      case ReportStatus.sedangDitinjau:
        return const Color(0xFFD97706); // amber text
      case ReportStatus.ditindaklanjuti:
        return const Color(0xFFDC2626); // red text
    }
  }
}

class ReportItem {
  final String id;
  final String reportNumber;
  final String title;
  final String description;
  final ReportStatus status;
  final String timestamp;
  final String reportDate;
  final String reportTime;
  final String? locationName;
  final String? specificLocation;
  final String? category;
  final String? imageAttachment;
  final String attachmentBadge;
  final String? notes;

  const ReportItem({
    required this.id,
    this.reportNumber = '#R-00001-020326',
    required this.title,
    required this.description,
    required this.status,
    required this.timestamp,
    this.reportDate = '18 Agustus 1945',
    this.reportTime = '18:00 WIB',
    this.locationName,
    this.specificLocation,
    this.category,
    this.imageAttachment = 'assets/images/parking_evidence.jpg',
    this.attachmentBadge = '1 Lampiran (JPG)',
    this.notes,
  });

  ReportItem copyWith({
    String? id,
    String? reportNumber,
    String? title,
    String? description,
    ReportStatus? status,
    String? timestamp,
    String? reportDate,
    String? reportTime,
    String? locationName,
    String? specificLocation,
    String? category,
    String? imageAttachment,
    String? attachmentBadge,
    String? notes,
  }) {
    return ReportItem(
      id: id ?? this.id,
      reportNumber: reportNumber ?? this.reportNumber,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      timestamp: timestamp ?? this.timestamp,
      reportDate: reportDate ?? this.reportDate,
      reportTime: reportTime ?? this.reportTime,
      locationName: locationName ?? this.locationName,
      specificLocation: specificLocation ?? this.specificLocation,
      category: category ?? this.category,
      imageAttachment: imageAttachment ?? this.imageAttachment,
      attachmentBadge: attachmentBadge ?? this.attachmentBadge,
      notes: notes ?? this.notes,
    );
  }
}
