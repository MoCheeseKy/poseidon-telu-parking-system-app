import 'dart:typed_data';

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
        return const Color(0xFFE8F5E9); 
      case ReportStatus.sedangDitinjau:
        return const Color(0xFFFEF3C7); 
      case ReportStatus.ditindaklanjuti:
        return const Color(0xFFFEE2E2); 
    }
  }

  Color get textColor {
    switch (this) {
      case ReportStatus.selesai:
        return const Color(0xFF16A34A); 
      case ReportStatus.sedangDitinjau:
        return const Color(0xFFD97706); 
      case ReportStatus.ditindaklanjuti:
        return const Color(0xFFDC2626); 
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
  final Uint8List? attachmentBytes;
  final String? attachmentFileName;
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
    this.attachmentBytes,
    this.attachmentFileName,
    this.attachmentBadge = '1 Lampiran (JPG)',
    this.notes,
  });

  bool get hasPhotoEvidence =>
      attachmentBytes != null ||
      (imageAttachment != null && imageAttachment!.isNotEmpty);

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
    Uint8List? attachmentBytes,
    String? attachmentFileName,
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
      attachmentBytes: attachmentBytes ?? this.attachmentBytes,
      attachmentFileName: attachmentFileName ?? this.attachmentFileName,
      attachmentBadge: attachmentBadge ?? this.attachmentBadge,
      notes: notes ?? this.notes,
    );
  }
}
