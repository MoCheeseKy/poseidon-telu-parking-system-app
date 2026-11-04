import 'package:flutter/material.dart';
import 'package:poseidon/core/constants/app_colors.dart';
import 'package:poseidon/data/models/report_item.dart';
import 'package:poseidon/ui/core/widgets/drag_handle.dart';

class ReportDetailSheet extends StatelessWidget {
  final ReportItem report;
  final VoidCallback? onCancelReport;

  const ReportDetailSheet({
    super.key,
    required this.report,
    this.onCancelReport,
  });

  static void show(
    BuildContext context, {
    required ReportItem report,
    VoidCallback? onCancelReport,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ReportDetailSheet(
        report: report,
        onCancelReport: onCancelReport,
      ),
    );
  }

  void _confirmCancel(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        title: const Text(
          'Batalkan Laporan?',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18.0),
        ),
        content: const Text(
          'Apakah Anda yakin ingin membatalkan laporan kendala ini?',
          style: TextStyle(fontSize: 13.5, color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text(
              'Kembali',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext); // close dialog
              Navigator.pop(context); // close sheet
              onCancelReport?.call();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: AppColors.textPrimary,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  content: const Text(
                    'Laporan telah berhasil dibatalkan.',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryRed,
              foregroundColor: Colors.white,
              elevation: 0,
            ),
            child: const Text('Ya, Batalkan'),
          ),
        ],
      ),
    );
  }

  Widget _buildEvidencePreview() {
    if (report.attachmentBytes != null) {
      return Image.memory(
        report.attachmentBytes!,
        height: 190.0,
        width: double.infinity,
        fit: BoxFit.cover,
      );
    }

    if (report.imageAttachment != null && report.imageAttachment!.isNotEmpty) {
      return Image.asset(
        report.imageAttachment!,
        height: 190.0,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            height: 190.0,
            width: double.infinity,
            color: const Color(0xFFE2E8F0),
            child: const Center(
              child: Icon(
                Icons.image_outlined,
                size: 40.0,
                color: AppColors.textMuted,
              ),
            ),
          );
        },
      );
    }

    return Container(
      height: 100.0,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: const Center(
        child: Text(
          'Tidak ada lampiran foto bukti',
          style: TextStyle(
            fontSize: 12.5,
            color: AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasPhoto = report.hasPhotoEvidence;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 20.0,
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const DragHandle(),

              // Title & Reference Subtitle
              Text(
                report.title,
                style: const TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.4,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4.0),
              Text(
                'Laporan ${report.reportNumber}',
                style: const TextStyle(
                  fontSize: 13.0,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12.0),

              // Status Badge
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 4.0,
                  ),
                  decoration: BoxDecoration(
                    color: report.status.backgroundColor,
                    borderRadius: BorderRadius.circular(14.0),
                  ),
                  child: Text(
                    report.status.label,
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                      color: report.status.textColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),

              // Details White Card
              Container(
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
                    // Section 1: TANGGAL LAPORAN
                    const Text(
                      'TANGGAL LAPORAN',
                      style: TextStyle(
                        fontSize: 11.0,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      report.reportDate,
                      style: const TextStyle(
                        fontSize: 15.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2.0),
                    Text(
                      report.reportTime,
                      style: const TextStyle(
                        fontSize: 13.0,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 14.0),
                    const Divider(height: 1.0, color: Color(0xFFF1F3F5)),
                    const SizedBox(height: 14.0),

                    // Section 2: LOKASI KENDALA
                    const Text(
                      'LOKASI KENDALA',
                      style: TextStyle(
                        fontSize: 11.0,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      report.locationName ?? 'Gedung Parkir TULT (Lantai 1)',
                      style: const TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    if (report.specificLocation != null) ...[
                      const SizedBox(height: 2.0),
                      Text(
                        report.specificLocation!,
                        style: const TextStyle(
                          fontSize: 12.5,
                          color: AppColors.textSecondary,
                          height: 1.3,
                        ),
                      ),
                    ],
                    const SizedBox(height: 14.0),
                    const Divider(height: 1.0, color: Color(0xFFF1F3F5)),
                    const SizedBox(height: 14.0),

                    // Section 3: DESKRIPSI KENDALA
                    const Text(
                      'DESKRIPSI KENDALA',
                      style: TextStyle(
                        fontSize: 11.0,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 6.0),
                    Text(
                      report.description,
                      style: const TextStyle(
                        fontSize: 13.0,
                        color: AppColors.textPrimary,
                        height: 1.45,
                      ),
                    ),
                    const SizedBox(height: 14.0),
                    const Divider(height: 1.0, color: Color(0xFFF1F3F5)),
                    const SizedBox(height: 14.0),

                    // Section 4: FOTO BUKTI TERLAMPIR
                    const Text(
                      'FOTO BUKTI TERLAMPIR',
                      style: TextStyle(
                        fontSize: 11.0,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          _buildEvidencePreview(),
                          if (hasPhoto)
                            Container(
                              margin: const EdgeInsets.all(10.0),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10.0,
                                vertical: 4.5,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.65),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.image_outlined,
                                    color: Colors.white,
                                    size: 13.0,
                                  ),
                                  const SizedBox(width: 5.0),
                                  Text(
                                    report.attachmentBadge,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 11.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20.0),

              // Bottom Button: Batalkan Laporan
              SizedBox(
                width: double.infinity,
                height: 48.0,
                child: ElevatedButton(
                  onPressed: () => _confirmCancel(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryRed,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  child: const Text(
                    'Batalkan Laporan',
                    style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
