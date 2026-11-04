import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:poseidon/core/constants/app_colors.dart';
import 'package:poseidon/ui/core/widgets/drag_handle.dart';
import 'package:poseidon/ui/core/widgets/poseidon_sub_app_bar.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpFaqItem {
  final String id;
  final String question;
  final String answerBeforeBrand;
  final String brandHighlight;
  final String answerAfterBrand;
  final String tag;

  const HelpFaqItem({
    required this.id,
    required this.question,
    required this.answerBeforeBrand,
    this.brandHighlight = 'Tel-U Park',
    required this.answerAfterBrand,
    required this.tag,
  });

  bool matchesQuery(String rawQuery) {
    final q = rawQuery.trim().toLowerCase();
    if (q.isEmpty) return true;
    return question.toLowerCase().contains(q) ||
        answerBeforeBrand.toLowerCase().contains(q) ||
        brandHighlight.toLowerCase().contains(q) ||
        answerAfterBrand.toLowerCase().contains(q) ||
        tag.toLowerCase().contains(q);
  }
}

class HelpCenterScreen extends StatefulWidget {
  final Future<bool> Function(Uri uri)? urlLauncherOverride;

  const HelpCenterScreen({
    super.key,
    this.urlLauncherOverride,
  });

  static const String supportPhoneNumber = '+6281210714320';
  static const String supportWhatsAppDigits = '6281210714320';

  static MaterialPageRoute<void> route() {
    return MaterialPageRoute<void>(
      builder: (_) => const HelpCenterScreen(),
    );
  }

  static const List<HelpFaqItem> defaultFaqs = [
    HelpFaqItem(
      id: 'faq_1',
      question:
          "Mengapa jumlah slot parkir tidak tersedia atau bertuliskan 'Kapasitas belum diketahui'?",
      answerBeforeBrand:
          'Keterangan ini muncul bila zona parkir belum terpasang sensor otomatis, atau sistem sedang memverifikasi data lapangan. ',
      brandHighlight: 'Tel-U Park',
      answerAfterBrand:
          ' tidak pernah menampilkan angka 0 fiktif untuk menjaga keakuratan informasi bagi mahasiswa.',
      tag: 'Epistemic Sensor Logic',
    ),
    HelpFaqItem(
      id: 'faq_2',
      question: "Apa arti status 'Sensor Offline' pada area parkir?",
      answerBeforeBrand:
          'Status ini menandakan koneksi perangkat gateway di kantong parkir tersebut sedang dalam pemeliharaan atau mengalami gangguan jaringan. ',
      brandHighlight: 'Tel-U Park',
      answerAfterBrand:
          ' tetap menampilkan titik parkirnya di peta agar lokasi fisiknya tetap dapat ditemukan.',
      tag: 'Kondisi Sensor',
    ),
    HelpFaqItem(
      id: 'faq_3',
      question: 'Bagaimana cara melaporkan kendaraan yang menghalangi jalan?',
      answerBeforeBrand:
          'Buka halaman Laporan, pilih Buat Laporan, tentukan kategori kendala serta area parkirnya, lalu lampirkan foto dari kamera atau galeri. Petugas lapangan ',
      brandHighlight: 'Tel-U Park',
      answerAfterBrand: ' akan menindaklanjuti laporan yang masuk.',
      tag: 'Pelaporan Parkir',
    ),
    HelpFaqItem(
      id: 'faq_4',
      question: 'Bagaimana cara melihat perkembangan laporan yang saya kirim?',
      answerBeforeBrand:
          'Status laporan mulai dari Sedang Ditinjau, Ditindaklanjuti, hingga Selesai dapat dilihat pada daftar Riwayat Laporan maupun halaman Notifikasi di ',
      brandHighlight: 'Tel-U Park',
      answerAfterBrand: '.',
      tag: 'Riwayat Laporan',
    ),
    HelpFaqItem(
      id: 'faq_5',
      question: 'Apakah saya harus login SSO Tel-U untuk mencari parkir?',
      answerBeforeBrand:
          'Peta parkir dan pencarian gedung tujuan dapat digunakan langsung. Akun kampus pada ',
      brandHighlight: 'Tel-U Park',
      answerAfterBrand:
          ' dipakai saat Anda menyimpan daftar kendaraan atau mengirim laporan ketertiban parkir.',
      tag: 'Akun Kampus',
    ),
  ];

  @override
  State<HelpCenterScreen> createState() => _HelpCenterScreenState();
}

class _HelpCenterScreenState extends State<HelpCenterScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String? _expandedFaqId;
  final Set<String> _helpfulIds = <String>{};

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _launchContactUri(
    Uri uri, {
    required String fallbackMessage,
  }) async {
    try {
      final launcher = widget.urlLauncherOverride;
      final launched = launcher != null
          ? await launcher(uri)
          : await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!launched && mounted) {
        _showSnackBar(fallbackMessage);
      }
    } catch (_) {
      if (mounted) {
        _showSnackBar(fallbackMessage);
      }
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          backgroundColor: AppColors.textPrimary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          content: Text(
            message,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      );
  }

  void _openContactSheet() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
          ),
          padding: const EdgeInsets.fromLTRB(20.0, 8.0, 20.0, 24.0),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const DragHandle(),
                const Text(
                  'Hubungi Kami',
                  style: TextStyle(
                    fontSize: 18.5,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4.0),
                const Text(
                  'Senin – Jumat (07.30 – 17.00 WIB)',
                  style: TextStyle(
                    fontSize: 12.5,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 16.0),
                const Divider(height: 1.0, color: Color(0xFFF1F3F5)),
                const SizedBox(height: 14.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Nomor Layanan',
                          style: TextStyle(
                            fontSize: 12.0,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        SizedBox(height: 2.0),
                        Text(
                          HelpCenterScreen.supportPhoneNumber,
                          style: TextStyle(
                            fontSize: 15.5,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    TextButton.icon(
                      onPressed: () async {
                        await Clipboard.setData(
                          const ClipboardData(
                            text: HelpCenterScreen.supportPhoneNumber,
                          ),
                        );
                        if (sheetContext.mounted) {
                          Navigator.pop(sheetContext);
                        }
                        _showSnackBar(
                          'Nomor ${HelpCenterScreen.supportPhoneNumber} disalin.',
                        );
                      },
                      icon: const Icon(
                        Icons.copy_rounded,
                        size: 16.0,
                        color: AppColors.textSecondary,
                      ),
                      label: const Text(
                        'Salin',
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                SizedBox(
                  width: double.infinity,
                  height: 48.0,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(sheetContext);
                      final waUri = Uri.parse(
                        'https://wa.me/${HelpCenterScreen.supportWhatsAppDigits}',
                      );
                      _launchContactUri(
                        waUri,
                        fallbackMessage:
                            'Membuka WhatsApp ${HelpCenterScreen.supportPhoneNumber}',
                      );
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
                      'Chat melalui WhatsApp',
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10.0),
                SizedBox(
                  width: double.infinity,
                  height: 48.0,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(sheetContext);
                      final telUri = Uri(
                        scheme: 'tel',
                        path: HelpCenterScreen.supportPhoneNumber,
                      );
                      _launchContactUri(
                        telUri,
                        fallbackMessage:
                            'Memanggil ${HelpCenterScreen.supportPhoneNumber}',
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.textPrimary,
                      side: const BorderSide(color: Color(0xFFE5E7EB)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    child: const Text(
                      'Telepon Langsung',
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredFaqs = HelpCenterScreen.defaultFaqs
        .where((faq) => faq.matchesQuery(_searchQuery))
        .toList();

    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      appBar: const PoseidonSubAppBar(title: 'Pusat Bantuan'),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600.0),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20.0, 18.0, 20.0, 32.0),
              physics: const BouncingScrollPhysics(),
              children: [
                const Text(
                  'Pusat Bantuan',
                  style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 6.0),
                const Text(
                  'Punya pertanyaan? pusat bantuan bisa bantu jawab pertanyaan-pertanyaan kamu!',
                  style: TextStyle(
                    fontSize: 13.0,
                    height: 1.45,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 18.0),

                // Search Box
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14.0),
                    border: Border.all(color: AppColors.subtleCardBorder),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.02),
                        blurRadius: 8.0,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                    style: const TextStyle(
                      fontSize: 13.5,
                      color: AppColors.textPrimary,
                    ),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.search,
                        color: AppColors.textMuted,
                        size: 20.0,
                      ),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              tooltip: 'Bersihkan pencarian',
                              onPressed: () {
                                _searchController.clear();
                                setState(() => _searchQuery = '');
                              },
                              icon: const Icon(
                                Icons.close,
                                size: 18.0,
                                color: AppColors.textMuted,
                              ),
                            )
                          : null,
                      hintText: 'Cari pertanyaan atau kendala...',
                      hintStyle: const TextStyle(
                        fontSize: 13.5,
                        color: AppColors.textMuted,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 14.0,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 22.0),

                // Section Header: PERTANYAAN SERING DIAJUKAN + N Topik
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(
                      child: Text(
                        'PERTANYAAN SERING DIAJUKAN',
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                        vertical: 4.0,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.0),
                        border: Border.all(color: AppColors.subtleCardBorder),
                      ),
                      child: Text(
                        '${filteredFaqs.length} Topik',
                        style: const TextStyle(
                          fontSize: 11.0,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12.0),

                if (filteredFaqs.isEmpty)
                  Container(
                    padding: const EdgeInsets.all(24.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18.0),
                      border: Border.all(color: AppColors.subtleCardBorder),
                    ),
                    child: const Text(
                      'Tidak ada topik yang cocok dengan kata kunci pencarian.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13.0,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  )
                else
                  for (int i = 0; i < filteredFaqs.length; i++) ...[
                    if (i > 0) const SizedBox(height: 12.0),
                    _buildFaqCard(filteredFaqs[i]),
                  ],

                const SizedBox(height: 18.0),

                // Bottom Operational Hours & Hubungi Kami Card
                _buildOperationalHoursCard(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFaqCard(HelpFaqItem faq) {
    final isExpanded = _expandedFaqId == faq.id;
    final isHelpful = _helpfulIds.contains(faq.id);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.0),
        border: Border.all(color: AppColors.subtleCardBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8.0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(18.0),
            onTap: () {
              setState(() {
                _expandedFaqId = isExpanded ? null : faq.id;
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      faq.question,
                      style: const TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w700,
                        height: 1.4,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12.0),
                  Container(
                    width: 30.0,
                    height: 30.0,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF3F4F6),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isExpanded
                          ? Icons.keyboard_arrow_up_rounded
                          : Icons.keyboard_arrow_down_rounded,
                      size: 20.0,
                      color: const Color(0xFF4B5563),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isExpanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Text.rich(
                      TextSpan(
                        text: faq.answerBeforeBrand,
                        style: const TextStyle(
                          fontSize: 13.0,
                          height: 1.5,
                          color: Color(0xFF374151),
                        ),
                        children: [
                          TextSpan(
                            text: faq.brandHighlight,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              color: AppColors.avatarDeepRed,
                            ),
                          ),
                          TextSpan(text: faq.answerAfterBrand),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.verified_outlined,
                              size: 14.5,
                              color: AppColors.textSecondary,
                            ),
                            const SizedBox(width: 5.0),
                            Flexible(
                              child: Text(
                                faq.tag,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        borderRadius: BorderRadius.circular(8.0),
                        onTap: () {
                          setState(() {
                            if (isHelpful) {
                              _helpfulIds.remove(faq.id);
                            } else {
                              _helpfulIds.add(faq.id);
                            }
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6.0,
                            vertical: 4.0,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                isHelpful
                                    ? Icons.thumb_up_alt
                                    : Icons.thumb_up_alt_outlined,
                                size: 14.5,
                                color: isHelpful
                                    ? AppColors.avatarDeepRed
                                    : AppColors.textSecondary,
                              ),
                              const SizedBox(width: 5.0),
                              Text(
                                'Membantu',
                                style: TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w600,
                                  color: isHelpful
                                      ? AppColors.avatarDeepRed
                                      : AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildOperationalHoursCard() {
    return Container(
      padding: const EdgeInsets.all(18.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.0),
        border: Border.all(color: AppColors.subtleCardBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8.0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Jam Operasional',
            style: TextStyle(
              fontSize: 17.5,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6.0),
          const Text(
            'Punya pertanyaan yang belum terjawab?\nHubungi langsung teknis kami!',
            style: TextStyle(
              fontSize: 13.0,
              height: 1.45,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 12.0),
          Row(
            children: const [
              Icon(
                Icons.access_time,
                size: 16.5,
                color: AppColors.avatarDeepRed,
              ),
              SizedBox(width: 7.0),
              Expanded(
                child: Text(
                  'Senin – Jumat (07.30 – 17.00 WIB)',
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          SizedBox(
            width: double.infinity,
            height: 48.0,
            child: TextButton(
              onPressed: _openContactSheet,
              style: TextButton.styleFrom(
                backgroundColor: AppColors.softRedTint,
                foregroundColor: AppColors.textPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.phone_outlined,
                    size: 18.5,
                    color: AppColors.avatarDeepRed,
                  ),
                  SizedBox(width: 8.0),
                  Text(
                    'Hubungi Kami',
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
