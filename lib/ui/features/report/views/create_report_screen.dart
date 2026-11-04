import 'package:flutter/material.dart';
import 'package:poseidon/core/constants/app_colors.dart';
import 'package:poseidon/data/mock/mock_parking_data.dart';
import 'package:poseidon/data/models/report_item.dart';
import 'package:poseidon/ui/features/report/widgets/review_report_sheet.dart';

class CategoryOption {
  final String title;
  final IconData icon;

  const CategoryOption({required this.title, required this.icon});
}

class CreateReportScreen extends StatefulWidget {
  final ValueChanged<ReportItem> onReportCreated;

  const CreateReportScreen({
    super.key,
    required this.onReportCreated,
  });

  static MaterialPageRoute route({
    required ValueChanged<ReportItem> onReportCreated,
  }) {
    return MaterialPageRoute(
      builder: (_) => CreateReportScreen(onReportCreated: onReportCreated),
    );
  }

  @override
  State<CreateReportScreen> createState() => _CreateReportScreenState();
}

class _CreateReportScreenState extends State<CreateReportScreen> {
  final _specificLocationController = TextEditingController();
  final _descController = TextEditingController();

  final List<CategoryOption> _categories = const [
    CategoryOption(
      title: 'Parkir menghalangi akses',
      icon: Icons.do_not_disturb_on_outlined,
    ),
    CategoryOption(
      title: 'Parkir di luar marka',
      icon: Icons.grid_off_outlined,
    ),
    CategoryOption(
      title: 'Parkir sembarangan',
      icon: Icons.warning_amber_rounded,
    ),
    CategoryOption(
      title: 'Fasilitas parkir rusak',
      icon: Icons.build_outlined,
    ),
    CategoryOption(
      title: 'Lainnya',
      icon: Icons.more_horiz,
    ),
  ];

  late String _selectedCategory;
  late String _selectedLocation;
  bool _hasPhotoAttached = true; // Default true as per design preview

  late final List<String> _parkingLocations = MockParkingData.allLocations
      .map((loc) => loc.name)
      .toList();

  @override
  void initState() {
    super.initState();
    _selectedCategory = _categories.first.title;
    _selectedLocation = _parkingLocations.first;
    _specificLocationController.text =
        'Blok B3 dekat akses tangga keluar darurat barat';
    _descController.text =
        'Satu unit sepeda motor diparkir melintang tepat di depan jalur keluar darurat lorong barat, menghambat akses pejalan kaki.';
  }

  @override
  void dispose() {
    _specificLocationController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _openReviewSheet() {
    final draft = ReportItem(
      id: 'rep_${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      reportNumber: '#R-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}-020326',
      title: _selectedCategory == 'Parkir menghalangi akses'
          ? 'Parkir Menghalangi Akses Keluar Parkiran'
          : _selectedCategory,
      description: _descController.text.trim().isEmpty
          ? 'Laporkan anomali yang anda temukan di sekitar area parkir untuk kami tindak lanjuti'
          : _descController.text.trim(),
      status: ReportStatus.sedangDitinjau,
      timestamp: '18 Agustur 1945, 18:00 WIB',
      reportDate: '18 Agustus 1945',
      reportTime: '18:00 WIB',
      locationName: _selectedLocation,
      specificLocation: _specificLocationController.text.trim().isEmpty
          ? null
          : _specificLocationController.text.trim(),
      category: _selectedCategory,
      imageAttachment: 'assets/images/parking_evidence.jpg',
      attachmentBadge: '1 Lampiran (JPG)',
      notes: 'Laporan telah diteruskan ke petugas patroli lapangan.',
    );

    ReviewReportSheet.show(
      context,
      draftReport: draft,
      onConfirmSend: () {
        widget.onReportCreated(draft);
        Navigator.pop(context); // back from CreateReportScreen
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
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: AppColors.textPrimary,
            size: 22.0,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        titleSpacing: 0,
        title: const Text(
          'Buat Laporan',
          style: TextStyle(
            fontSize: 16.5,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications_none_outlined,
              color: AppColors.textPrimary,
              size: 22.0,
            ),
            onPressed: () {},
          ),
          Container(
            margin: const EdgeInsets.only(right: 16.0, left: 4.0),
            width: 32.0,
            height: 32.0,
            decoration: const BoxDecoration(
              color: AppColors.primaryRed,
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Icon(Icons.person, color: Colors.white, size: 18.0),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600.0),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 24.0),
              physics: const BouncingScrollPhysics(),
              children: [
                // Header Title
                const Text(
                  'Buat Laporan',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.4,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 6.0),
                const Text(
                  'Laporkan anomali yang anda temukan di sekitar area parkir untuk kami tindak lanjuti',
                  style: TextStyle(
                    fontSize: 13.0,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textSecondary,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 20.0),

                // Card 1: Pilih Kategori Kendala *
                _buildCardContainer(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildRequiredLabel('Pilih Kategori Kendala'),
                      const SizedBox(height: 12.0),
                      for (int i = 0; i < _categories.length; i++) ...[
                        if (i > 0 &&
                            _selectedCategory != _categories[i].title &&
                            _selectedCategory != _categories[i - 1].title)
                          const Divider(
                            height: 1.0,
                            color: Color(0xFFF1F3F5),
                            indent: 40.0,
                          ),
                        _buildCategoryRow(_categories[i]),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 16.0),

                // Card 2: Lokasi Kendala *
                _buildCardContainer(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildRequiredLabel('Lokasi Kendala'),
                      const SizedBox(height: 10.0),
                      const Text(
                        'Area Parkir Kampus',
                        style: TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 6.0),
                      _buildLocationDropdown(),
                      const SizedBox(height: 14.0),
                      Row(
                        children: const [
                          Expanded(
                            child: Text(
                              'Titik Spesifik',
                              style: TextStyle(
                                fontSize: 12.0,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textSecondary,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(width: 8.0),
                          Text(
                            'Opsional',
                            style: TextStyle(
                              fontSize: 11.5,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6.0),
                      TextField(
                        controller: _specificLocationController,
                        style: const TextStyle(
                          fontSize: 13.0,
                          color: AppColors.textPrimary,
                        ),
                        decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.location_on_outlined,
                            size: 18.0,
                            color: AppColors.textSecondary,
                          ),
                          hintText:
                              'Contoh: Dekat tangga darurat barat, Blok B3',
                          hintStyle: const TextStyle(
                            fontSize: 12.5,
                            color: AppColors.textMuted,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12.0,
                            vertical: 12.0,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide:
                                const BorderSide(color: Color(0xFFE5E7EB)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide:
                                const BorderSide(color: Color(0xFFE5E7EB)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(
                              color: AppColors.primaryRed,
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16.0),

                // Card 3: Deskripsi Tambahan
                _buildCardContainer(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: const [
                          Expanded(
                            child: Text(
                              'Deskripsi Tambahan',
                              style: TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(width: 8.0),
                          Text(
                            'Opsional',
                            style: TextStyle(
                              fontSize: 11.5,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10.0),
                      TextField(
                        controller: _descController,
                        maxLines: 4,
                        maxLength: 250,
                        style: const TextStyle(
                          fontSize: 13.0,
                          color: AppColors.textPrimary,
                          height: 1.4,
                        ),
                        decoration: InputDecoration(
                          hintText:
                              'Tuliskan rincian kendala secara singkat jika diperlukan...',
                          hintStyle: const TextStyle(
                            fontSize: 12.5,
                            color: AppColors.textMuted,
                          ),
                          counterText: 'Maks. 250 karakter',
                          counterStyle: const TextStyle(
                            fontSize: 11.0,
                            color: AppColors.textMuted,
                          ),
                          filled: true,
                          fillColor: const Color(0xFFF9FAFB),
                          contentPadding: const EdgeInsets.all(12.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide:
                                const BorderSide(color: Color(0xFFE5E7EB)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide:
                                const BorderSide(color: Color(0xFFE5E7EB)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(
                              color: AppColors.primaryRed,
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16.0),

                // Card 4: Foto Bukti
                _buildCardContainer(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: const [
                          Expanded(
                            child: Text(
                              'Foto Bukti',
                              style: TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(width: 8.0),
                          Text(
                            'Opsional',
                            style: TextStyle(
                              fontSize: 11.5,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10.0),
                      _buildPhotoUploadBox(),
                    ],
                  ),
                ),
                const SizedBox(height: 24.0),

                // Bottom Action: Tinjau Laporan ->
                SizedBox(
                  width: double.infinity,
                  height: 50.0,
                  child: ElevatedButton(
                    onPressed: _openReviewSheet,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryRed,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          'Tinjau Laporan',
                          style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(width: 6.0),
                        Icon(Icons.arrow_forward, size: 18.0),
                      ],
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

  Widget _buildCardContainer({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: const Color(0xFFF1F1F1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8.0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildRequiredLabel(String text) {
    return Text.rich(
      TextSpan(
        text: text,
        style: const TextStyle(
          fontSize: 13.5,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
        children: const [
          TextSpan(
            text: ' *',
            style: TextStyle(
              color: AppColors.primaryRed,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryRow(CategoryOption option) {
    final isSelected = _selectedCategory == option.title;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategory = option.title;
        });
      },
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        margin: const EdgeInsets.symmetric(vertical: 3.0),
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFEF2F2) : Colors.transparent,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Row(
          children: [
            Icon(
              option.icon,
              size: 20.0,
              color:
                  isSelected ? AppColors.primaryRed : AppColors.textSecondary,
            ),
            const SizedBox(width: 12.0),
            Expanded(
              child: Text(
                option.title,
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            // Custom Radio Indicator
            Container(
              width: 18.0,
              height: 18.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? Colors.transparent : const Color(0xFFE5E7EB),
                border: isSelected
                    ? Border.all(color: AppColors.primaryRed, width: 2.0)
                    : null,
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 8.0,
                        height: 8.0,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primaryRed,
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: _selectedLocation,
          icon: const Icon(
            Icons.keyboard_arrow_down,
            color: AppColors.textSecondary,
          ),
          items: _parkingLocations.map((loc) {
            return DropdownMenuItem<String>(
              value: loc,
              child: Row(
                children: [
                  Container(
                    width: 22.0,
                    height: 22.0,
                    decoration: BoxDecoration(
                      color: AppColors.primaryRed,
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                    child: const Center(
                      child: Text(
                        'P',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13.0,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  Expanded(
                    child: Text(
                      loc,
                      style: const TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
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
    );
  }

  Widget _buildPhotoUploadBox() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _hasPhotoAttached = !_hasPhotoAttached;
        });
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
        decoration: BoxDecoration(
          color: const Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(
            color: const Color(0xFFE5E7EB),
            style: BorderStyle.solid,
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 44.0,
              height: 44.0,
              decoration: const BoxDecoration(
                color: Color(0xFFFEE2E2),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(
                  Icons.camera_alt_outlined,
                  size: 22.0,
                  color: AppColors.primaryRed,
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            Text(
              _hasPhotoAttached
                  ? 'Foto terlampir: parking_evidence.jpg'
                  : 'Lampirkan foto bukti',
              style: const TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4.0),
            Text(
              _hasPhotoAttached
                  ? 'Ketuk untuk mengganti atau menghapus foto'
                  : 'Format JPG atau PNG, maks. 5MB',
              style: const TextStyle(
                fontSize: 11.5,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
