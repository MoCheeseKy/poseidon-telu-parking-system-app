import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:poseidon/ui/features/report/views/camera_capture_screen.dart';

enum ReportPhotoSource {
  camera,
  systemGallery,
}

class CapturedReportPhoto {
  final Uint8List bytes;
  final String fileName;
  final ReportPhotoSource source;

  const CapturedReportPhoto({
    required this.bytes,
    required this.fileName,
    required this.source,
  });

  String get badgeLabel {
    final ext = fileName.contains('.')
        ? fileName.split('.').last.toUpperCase()
        : 'JPG';
    final normalizedExt = (ext == 'JPEG' || ext.isEmpty) ? 'JPG' : ext;
    return '1 Lampiran ($normalizedExt)';
  }
}

class ReportMediaService {
  final ImagePicker? imagePicker;

  const ReportMediaService({this.imagePicker});

  ImagePicker get _picker => imagePicker ?? ImagePicker();

  Future<CapturedReportPhoto?> captureFromCamera(BuildContext context) async {
    if (!context.mounted) return null;

    final result = await Navigator.push<CameraCaptureResult>(
      context,
      MaterialPageRoute<CameraCaptureResult>(
        builder: (_) => const CameraCaptureScreen(),
      ),
    );

    if (result == null) return null;

    return CapturedReportPhoto(
      bytes: result.bytes,
      fileName: result.fileName,
      source: ReportPhotoSource.camera,
    );
  }

  Future<CapturedReportPhoto?> pickFromSystem() async {
    final XFile? file = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
      maxWidth: 1600,
    );
    if (file == null) return null;

    final bytes = await file.readAsBytes();
    return CapturedReportPhoto(
      bytes: bytes,
      fileName: file.name.isNotEmpty
          ? file.name
          : 'lampiran_${DateTime.now().millisecondsSinceEpoch}.jpg',
      source: ReportPhotoSource.systemGallery,
    );
  }
}
