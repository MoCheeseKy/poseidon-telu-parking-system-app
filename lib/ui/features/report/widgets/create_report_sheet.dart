import 'package:flutter/material.dart';
import 'package:poseidon/core/constants/app_colors.dart';
import 'package:poseidon/data/mock/mock_parking_data.dart';
import 'package:poseidon/data/models/report_item.dart';
import 'package:poseidon/ui/core/widgets/drag_handle.dart';

class CreateReportSheet extends StatefulWidget {
  final ValueChanged<ReportItem> onReportCreated;

  const CreateReportSheet({super.key, required this.onReportCreated});

  static Future<void> show(
    BuildContext context, {
    required ValueChanged<ReportItem> onReportCreated,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CreateReportSheet(onReportCreated: onReportCreated),
    );
  }

  @override
  State<CreateReportSheet> createState() => _CreateReportSheetState();
}

class _CreateReportSheetState extends State<CreateReportSheet> {
  final _formKey = GlobalKey<FormState>();
  final _descController = TextEditingController();

  String _selectedCategory = 'Parkir di Luar Marka';
  String _selectedLocation = MockParkingData.allLocations.first.name;
  bool _isSubmitting = false;

  final List<String> _categories = [
    'Parkir di Luar Marka',
    'Menghalangi Akses / Jalur',
    'Helm / Barang Tertinggal',
    'Kerusakan Fasilitas / Sensor',
    'Lainnya',
  ];

  @override
  void dispose() {
    _descController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isSubmitting = true);

      Future.delayed(const Duration(milliseconds: 350), () {
        if (!mounted) return;
        final newReport = ReportItem(
          id: 'rep_${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
          title: _selectedCategory,
          description: _descController.text.trim().isEmpty
              ? 'Laporkan anomali yang anda temukan di sekitar area parkir untuk kami tindak lanjuti'
              : _descController.text.trim(),
          status: ReportStatus.sedangDitinjau,
          timestamp: 'Hari Ini, ${TimeOfDay.now().format(context)} WIB',
          locationName: _selectedLocation,
          category: _selectedCategory,
          notes: 'Laporan baru sedang dalam antrean verifikasi petugas.',
        );

        widget.onReportCreated(newReport);
        Navigator.pop(context);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppColors.textPrimary,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            content: const Text(
              'Laporan Anda berhasil dikirim untuk ditinjau.',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        );
      });
    }
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
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const DragHandle(),

                const Text(
                  'Buat Laporan Anomali',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4.0),
                const Text(
                  'Bantu jaga ketertiban area parkir kampus dengan melaporkan anomali.',
                  style: TextStyle(
                    fontSize: 13.0,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 20.0),

                // Category Dropdown
                const Text(
                  'Kategori Anomali',
                  style: TextStyle(
                    fontSize: 13.0,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 6.0),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14.0),
                  decoration: BoxDecoration(
                    color: AppColors.cardSurface,
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: _selectedCategory,
                      items: _categories.map((cat) {
                        return DropdownMenuItem(
                          value: cat,
                          child: Text(
                            cat,
                            style: const TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setState(() => _selectedCategory = val);
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),

                // Location Selector
                const Text(
                  'Lokasi Parkir Terkait',
                  style: TextStyle(
                    fontSize: 13.0,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 6.0),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14.0),
                  decoration: BoxDecoration(
                    color: AppColors.cardSurface,
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: _selectedLocation,
                      items: MockParkingData.allLocations.map((loc) {
                        return DropdownMenuItem(
                          value: loc.name,
                          child: Text(
                            loc.name,
                            style: const TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setState(() => _selectedLocation = val);
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),

                // Description Input
                const Text(
                  'Detail / Keterangan Masalah',
                  style: TextStyle(
                    fontSize: 13.0,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 6.0),
                TextFormField(
                  controller: _descController,
                  maxLines: 3,
                  style: const TextStyle(fontSize: 14.0),
                  decoration: InputDecoration(
                    hintText:
                        'Contoh: Sepeda motor terparkir di jalur keluar mobil atau melewati garis marka...',
                    hintStyle: const TextStyle(
                      fontSize: 13.0,
                      color: AppColors.textMuted,
                    ),
                    filled: true,
                    fillColor: AppColors.cardSurface,
                    contentPadding: const EdgeInsets.all(14.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: const BorderSide(color: AppColors.border),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: const BorderSide(color: AppColors.border),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: const BorderSide(
                        color: AppColors.primaryRed,
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24.0),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  height: 50.0,
                  child: ElevatedButton(
                    onPressed: _isSubmitting ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryRed,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    child: _isSubmitting
                        ? const SizedBox(
                            width: 22.0,
                            height: 22.0,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
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
      ),
    );
  }
}
