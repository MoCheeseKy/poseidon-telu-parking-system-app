import 'package:flutter/material.dart';
import 'package:poseidon/core/constants/app_colors.dart';
import 'package:poseidon/data/models/report_item.dart';
import 'package:poseidon/ui/core/widgets/drag_handle.dart';

class ReviewReportSheet extends StatelessWidget {
  final ReportItem draftReport;
  final VoidCallback onConfirmSend;

  const ReviewReportSheet({
    super.key,
    required this.draftReport,
    required this.onConfirmSend,
  });

  static Future<void> show(
    BuildContext context, {
    required ReportItem draftReport,
    required VoidCallback onConfirmSend,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ReviewReportSheet(
        draftReport: draftReport,
        onConfirmSend: onConfirmSend,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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

              // Title & Subtitle
              const Text(
                'Tinjau Laporan',
                style: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.4,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4.0),
              const Text(
                'Cek dulu laporan kamu sebelum dikirim ya!',
                style: TextStyle(
                  fontSize: 13.0,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 16.0),

              // Review White Card Container
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
                    // KATEGORI KENDALA
                    const Text(
                      'KATEGORI KENDALA',
                      style: TextStyle(
                        fontSize: 11.0,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      draftReport.category ?? draftReport.title,
                      style: const TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 14.0),
                    const Divider(height: 1.0, color: Color(0xFFF1F3F5)),
                    const SizedBox(height: 14.0),

                    // LOKASI KENDALA
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
                      draftReport.locationName ?? 'Gedung Parkir TULT (Lantai 1)',
                      style: const TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    if (draftReport.specificLocation != null &&
                        draftReport.specificLocation!.isNotEmpty) ...[
                      const SizedBox(height: 2.0),
                      Text(
                        draftReport.specificLocation!,
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

                    // DESKRIPSI KENDALA
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
                      draftReport.description.isEmpty
                          ? 'Tidak ada rincian tambahan.'
                          : draftReport.description,
                      style: const TextStyle(
                        fontSize: 13.0,
                        color: AppColors.textPrimary,
                        height: 1.45,
                      ),
                    ),
                    const SizedBox(height: 14.0),
                    const Divider(height: 1.0, color: Color(0xFFF1F3F5)),
                    const SizedBox(height: 14.0),

                    // FOTO BUKTI TERLAMPIR
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
                          Image.asset(
                            draftReport.imageAttachment ??
                                'assets/images/parking_evidence.jpg',
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
                          ),
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
                                  draftReport.attachmentBadge,
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
                    const SizedBox(height: 10.0),

                    // Verification Check Text
                    Row(
                      children: const [
                        Icon(
                          Icons.check_circle_outline,
                          size: 16.0,
                          color: Color(0xFF16A34A),
                        ),
                        SizedBox(width: 6.0),
                        Expanded(
                          child: Text(
                            '1 foto terverifikasi siap diunggah',
                            style: TextStyle(
                              fontSize: 12.0,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF16A34A),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20.0),

              // Kirim Laporan Button
              SizedBox(
                width: double.infinity,
                height: 48.0,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // close review sheet
                    onConfirmSend();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryRed,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  child: const Text(
                    'Kirim Laporan',
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
