import 'package:flutter/material.dart';
import 'package:poseidon/core/constants/app_colors.dart';
import 'package:poseidon/ui/core/widgets/drag_handle.dart';
import 'package:poseidon/ui/core/widgets/poseidon_brand_logo.dart';
import 'package:poseidon/ui/core/widgets/poseidon_sub_app_bar.dart';

class AppDeveloper {
  final String name;
  final String nim;
  final String imagePath;

  const AppDeveloper({
    required this.name,
    required this.nim,
    required this.imagePath,
  });
}

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  static const String appVersion = 'Versi 1.2.0';

  static const List<AppDeveloper> developers = [
    AppDeveloper(
      name: 'Rifky Muhammad Prayudhi',
      nim: '103022400003',
      imagePath: 'assets/images/rifky_muhammad_prayudhi.jpg',
    ),
    AppDeveloper(
      name: 'Muhamad Naufal Nabillansyah',
      nim: '103022400073',
      imagePath: 'assets/images/muhamad_naufal_nabillansyah.png',
    ),
    AppDeveloper(
      name: 'Joanne Agnesia Nempung',
      nim: '103022400114',
      imagePath: 'assets/images/joanne_agnesia_nempung.png',
    ),
    AppDeveloper(
      name: 'Aruna Jannu Rezasyah',
      nim: '103022430015',
      imagePath: 'assets/images/aruna_jannu_rezasyah.png',
    ),
  ];

  static MaterialPageRoute<void> route() {
    return MaterialPageRoute<void>(
      builder: (_) => const AboutUsScreen(),
    );
  }

  void _showDevelopersSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(sheetContext).size.height * 0.85,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: DragHandle(),
                ),
                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20.0, 4.0, 20.0, 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Tentang Pengembang Aplikasi',
                          style: TextStyle(
                            fontSize: 19.0,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.3,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4.0),
                        const Text(
                          'Tim Pengembang Poseidon • Mobile Programming',
                          style: TextStyle(
                            fontSize: 12.5,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        const Divider(height: 1.0, color: Color(0xFFF1F3F5)),
                        const SizedBox(height: 16.0),
                        const Text(
                          'Aplikasi Poseidon (Tel-U Park) dirancang dan dikembangkan oleh tim mahasiswa Fakultas Informatika Telkom University Bandung:',
                          style: TextStyle(
                            fontSize: 13.5,
                            height: 1.5,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        for (final dev in developers)
                          Container(
                            margin: const EdgeInsets.only(bottom: 12.0),
                            padding: const EdgeInsets.all(12.0),
                            decoration: BoxDecoration(
                              color: AppColors.pageBackground,
                              borderRadius: BorderRadius.circular(16.0),
                              border: Border.all(
                                color: AppColors.subtleCardBorder,
                              ),
                            ),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12.0),
                                  child: Image.asset(
                                    dev.imagePath,
                                    width: 54.0,
                                    height: 54.0,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        width: 54.0,
                                        height: 54.0,
                                        decoration: BoxDecoration(
                                          color: AppColors.avatarDeepRed,
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          dev.name.isNotEmpty
                                              ? dev.name[0]
                                              : 'P',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 20.0,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(width: 14.0),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        dev.name,
                                        style: const TextStyle(
                                          fontSize: 14.5,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                      const SizedBox(height: 3.0),
                                      Text(
                                        'NIM ${dev.nim}',
                                        style: const TextStyle(
                                          fontSize: 12.5,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.primaryRed,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        const SizedBox(height: 14.0),
                        SizedBox(
                          width: double.infinity,
                          height: 46.0,
                          child: ElevatedButton(
                            onPressed: () => Navigator.pop(sheetContext),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryRed,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                            ),
                            child: const Text(
                              'Tutup',
                              style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ],
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

  void _showInfoSheet(
    BuildContext context, {
    required String title,
    required String subtitle,
    required List<({String? heading, String body})> paragraphs,
  }) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(sheetContext).size.height * 0.80,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: DragHandle(),
                ),
                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20.0, 4.0, 20.0, 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 19.0,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.3,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          subtitle,
                          style: const TextStyle(
                            fontSize: 12.5,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        const Divider(height: 1.0, color: Color(0xFFF1F3F5)),
                        const SizedBox(height: 16.0),
                        for (int i = 0; i < paragraphs.length; i++) ...[
                          if (i > 0) const SizedBox(height: 14.0),
                          if (paragraphs[i].heading != null) ...[
                            Text(
                              paragraphs[i].heading!,
                              style: const TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 5.0),
                          ],
                          Text(
                            paragraphs[i].body,
                            style: const TextStyle(
                              fontSize: 13.5,
                              height: 1.55,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                        const SizedBox(height: 22.0),
                        SizedBox(
                          width: double.infinity,
                          height: 46.0,
                          child: ElevatedButton(
                            onPressed: () => Navigator.pop(sheetContext),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryRed,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                            ),
                            child: const Text(
                              'Tutup',
                              style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ],
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
    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      appBar: const PoseidonSubAppBar(title: 'Tentang Kami'),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600.0),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20.0, 28.0, 20.0, 32.0),
              physics: const BouncingScrollPhysics(),
              children: [
                // Centered Brand Hero
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(22.0),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryRed.withValues(alpha: 0.22),
                          blurRadius: 88.0 * 0.22,
                          offset: const Offset(0, 88.0 * 0.08),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(22.0),
                      child: Image.asset(
                        'assets/images/poseidong_logo.jpg',
                        width: 88.0,
                        height: 88.0,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const PoseidonBrandLogo(
                            size: 88.0,
                            borderRadius: 22.0,
                          );
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 18.0),
                const Text(
                  'Poseidon',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 6.0),
                const Text(
                  'Smart Parking System Telkom University Bandung',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13.0,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 14.0),
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14.0,
                      vertical: 5.5,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.0),
                      border: Border.all(color: AppColors.subtleCardBorder),
                    ),
                    child: const Text(
                      appVersion,
                      style: TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF4B5563),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24.0),

                // White Description Card
                Container(
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
                  child: const Text(
                    'Tel-U Park dikembangkan untuk membantu civitas akademika Telkom University menemukan ketersediaan slot parkir motor dan mobil secara transparan, memahami kondisi sensor lapangan, serta mempermudah pelaporan kendala ketertiban parkir di kawasan kampus.',
                    style: TextStyle(
                      fontSize: 13.5,
                      height: 1.55,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                const SizedBox(height: 24.0),

                // Section Title: INFORMASI & LEGALITAS
                const Text(
                  'INFORMASI & LEGALITAS',
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 10.0),

                // Grouped Legal & Info White Card
                Container(
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
                    children: [
                      _buildInfoRow(
                        icon: Icons.gavel_outlined,
                        title: 'Ketentuan Penggunaan Layanan',
                        onTap: () => _showInfoSheet(
                          context,
                          title: 'Ketentuan Penggunaan Layanan',
                          subtitle: 'Layanan parkir kampus Telkom University',
                          paragraphs: const [
                            (
                              heading: 'Data Ketersediaan Parkir',
                              body:
                                  'Angka slot parkir mengacu pada pembacaan sensor di tiap kantong parkir kampus. Area yang belum memiliki sensor aktif diberi keterangan secara terbuka tanpa menampilkan angka perkiraan.',
                            ),
                            (
                              heading: 'Pelaporan Ketertiban',
                              body:
                                  'Fitur laporan ditujukan bagi kendala nyata di lapangan seperti kendaraan yang menutup jalur keluar atau parkir di luar marka. Lampirkan lokasi dan foto yang sesuai agar petugas pos mudah menindaklanjuti.',
                            ),
                            (
                              heading: 'Izin Perangkat',
                              body:
                                  'Akses lokasi GPS hanya dipakai ketika Anda menekan tombol lokasi pada peta, sedangkan akses kamera dan penyimpanan hanya diminta saat Anda melampirkan foto bukti laporan.',
                            ),
                          ],
                        ),
                      ),
                      const Divider(
                        height: 1.0,
                        thickness: 1.0,
                        color: Color(0xFFF3F4F6),
                        indent: 18.0,
                        endIndent: 18.0,
                      ),
                      _buildInfoRow(
                        icon: Icons.code_rounded,
                        title: 'Tentang Pengembang Aplikasi',
                        onTap: () => _showDevelopersSheet(context),
                      ),
                      const Divider(
                        height: 1.0,
                        thickness: 1.0,
                        color: Color(0xFFF3F4F6),
                        indent: 18.0,
                        endIndent: 18.0,
                      ),
                      _buildInfoRow(
                        icon: Icons.history_edu_outlined,
                        title: 'Catatan Rilis Pembaruan (Changelog)',
                        onTap: () => _showInfoSheet(
                          context,
                          title: 'Catatan Rilis Pembaruan',
                          subtitle: appVersion,
                          paragraphs: const [
                            (
                              heading: 'Rilis Antarmuka Aplikasi',
                              body:
                                  'Seluruh tampilan utama aplikasi Poseidon kini telah tersedia dan dapat digunakan secara menyeluruh. Rilis ini mencakup antarmuka peta parkir kampus interaktif, rekomendasi parkir berdasarkan gedung tujuan, ringkasan aktivitas keterisian parkir, alur pembuatan laporan kendala beserta pengambilan foto bukti, hingga halaman notifikasi, pusat bantuan, dan pengelolaan profil pengguna.',
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
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 16.0),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20.0,
              color: const Color(0xFF525866),
            ),
            const SizedBox(width: 14.0),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 13.8,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              size: 20.0,
              color: Color(0xFF6B7280),
            ),
          ],
        ),
      ),
    );
  }
}
