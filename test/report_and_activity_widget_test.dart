import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:poseidon/core/theme/app_theme.dart';
import 'package:poseidon/main.dart';
import 'package:poseidon/ui/features/activity/views/activity_screen.dart';
import 'package:poseidon/ui/features/report/views/report_screen.dart';

void main() {
  group('Screen: Lapor Page Tests', () {
    testWidgets('renders all visual elements on Lapor page', (
      WidgetTester tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(400, 850));
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const ReportScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // App bar & titles
      expect(find.text('Poseidon Smart Parking'), findsOneWidget);
      expect(find.text('Lapor'), findsOneWidget);
      expect(
        find.text(
          'Laporkan anomali yang anda temukan di sekitar area parkir untuk kami tindak lanjuti',
        ),
        findsWidgets,
      );

      // Action button
      expect(find.text('Buat Laporan'), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);

      // Riwayat section & counter
      expect(find.text('Riwayat Laporan'), findsOneWidget);
      expect(find.text('3 laporan'), findsOneWidget);

      // Report items and statuses matching the screenshot
      expect(find.text('Parkir di Luar Marka'), findsWidgets);
      expect(find.text('Selesai'), findsOneWidget);
      expect(find.text('Sedang Ditinjau'), findsOneWidget);
      expect(find.text('Ditindaklanjuti'), findsOneWidget);
      expect(find.text('18 Agustur 1945, 18:00 WIB'), findsWidgets);
    });

    testWidgets('tapping report card opens ReportDetailSheet with exact design', (
      WidgetTester tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(400, 850));
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const ReportScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Tap on the first report item
      await tester.tap(find.text('Selesai'));
      await tester.pumpAndSettle();

      // Verify detail sheet opened matching Image 1
      expect(find.text('Parkir Menghalangi Akses Keluar Parkiran'), findsWidgets);
      expect(find.text('Laporan #R-00001-020326'), findsOneWidget);
      expect(find.text('TANGGAL LAPORAN'), findsOneWidget);
      expect(find.text('18 Agustus 1945'), findsOneWidget);
      expect(find.text('LOKASI KENDALA'), findsOneWidget);
      expect(find.text('Gedung Parkir TULT (Lantai 1)'), findsWidgets);
      expect(find.text('DESKRIPSI KENDALA'), findsOneWidget);

      // Scroll inside detail sheet to reveal photo and button
      await tester.scrollUntilVisible(
        find.text('Batalkan Laporan'),
        200.0,
        scrollable: find.byType(Scrollable).last,
      );
      await tester.pumpAndSettle();

      expect(find.text('FOTO BUKTI TERLAMPIR'), findsOneWidget);
      expect(find.text('1 Lampiran (JPG)'), findsOneWidget);
      expect(find.text('Batalkan Laporan'), findsOneWidget);
    });

    testWidgets('tapping Buat Laporan opens CreateReportScreen and ReviewReportSheet flow', (
      WidgetTester tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(400, 850));
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const ReportScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Tap "+ Buat Laporan"
      await tester.tap(find.text('Buat Laporan'));
      await tester.pumpAndSettle();

      // Verify CreateReportScreen opened matching Image 2
      expect(find.textContaining('Pilih Kategori Kendala'), findsOneWidget);
      expect(find.text('Parkir menghalangi akses'), findsOneWidget);
      expect(find.textContaining('Lokasi Kendala'), findsOneWidget);
      expect(find.text('Titik Spesifik'), findsOneWidget);
      expect(find.text('Deskripsi Tambahan'), findsOneWidget);

      // Scroll to reveal lower cards in CreateReportScreen
      await tester.scrollUntilVisible(
        find.text('Foto Bukti'),
        200.0,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();
      expect(find.text('Foto Bukti'), findsOneWidget);

      await tester.scrollUntilVisible(
        find.text('Tinjau Laporan'),
        200.0,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();
      expect(find.text('Tinjau Laporan'), findsOneWidget);

      // Tap "Tinjau Laporan"
      await tester.tap(find.text('Tinjau Laporan'));
      await tester.pumpAndSettle();

      // Verify ReviewReportSheet opened matching Image 3
      expect(find.text('Tinjau Laporan'), findsWidgets);
      expect(find.text('Cek dulu laporan kamu sebelum dikirim ya!'), findsOneWidget);
      expect(find.text('KATEGORI KENDALA'), findsOneWidget);

      // Scroll inside review sheet to reveal Kirim Laporan button
      await tester.scrollUntilVisible(
        find.text('Kirim Laporan'),
        200.0,
        scrollable: find.byType(Scrollable).last,
      );
      await tester.pumpAndSettle();

      expect(find.text('1 foto terverifikasi siap diunggah'), findsOneWidget);
      expect(find.text('Kirim Laporan'), findsOneWidget);

      // Tap Kirim Laporan
      await tester.tap(find.text('Kirim Laporan'));
      await tester.pumpAndSettle();

      // Verify report count incremented from 3 to 4
      expect(find.text('4 laporan'), findsOneWidget);
    });
  });

  group('Screen: Aktivitas Page Tests', () {
    testWidgets('renders all visual elements on Aktivitas page', (
      WidgetTester tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(400, 850));
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const ActivityScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Title & Subtitle
      expect(find.text('Aktivitas'), findsOneWidget);
      expect(find.text('Analitik penggunaan parkir kampus'), findsOneWidget);

      // Filter chips
      expect(find.text('7 Hari Terakhir'), findsOneWidget);
      expect(find.text('30 Hari Terakhir'), findsOneWidget);
      expect(find.text('Motor'), findsOneWidget);
      expect(find.text('Mobil'), findsOneWidget);

      // Metric Summary Cards
      expect(find.text('Rata-rata Keterisian'), findsOneWidget);
      expect(find.text('73'), findsOneWidget);
      expect(find.text('%'), findsOneWidget);
      expect(find.text('Hari kerja / Jam kuliah aktif'), findsOneWidget);

      expect(find.text('Area Terpantau'), findsOneWidget);
      expect(find.text('5'), findsOneWidget);
      expect(find.text('Lokasi'), findsOneWidget);
      expect(find.text('Sensor valid & terkalibrasi'), findsOneWidget);

      expect(find.text('Puncak Kepadatan'), findsOneWidget);
      expect(find.text('09.30 – 11.30'), findsOneWidget);
      expect(find.text('WIB (Zona Kuliah Sesi 1 & 2)'), findsOneWidget);

      // Trend Occupancy Chart
      expect(find.text('Tren Okupansi Harian'), findsOneWidget);
      expect(
        find.text('Pola rata-rata keterisian slot parkir motor'),
        findsOneWidget,
      );
      expect(find.text('Puncak 10.00 WIB, 86% Keterisian'), findsOneWidget);
      expect(find.text('100%'), findsOneWidget);
      expect(find.text('80%'), findsOneWidget);
      expect(find.text('07:00'), findsOneWidget);
      expect(find.text('11:00'), findsOneWidget);
      expect(find.text('17:00'), findsOneWidget);

      // Chart Legend
      expect(find.text('Rendah'), findsWidgets);
      expect(find.text('(<60%)'), findsOneWidget);
      expect(find.text('Menengah'), findsWidgets);
      expect(find.text('(60–80%)'), findsOneWidget);
      expect(find.text('Puncak'), findsOneWidget);
      expect(find.text('(>80%)'), findsOneWidget);

      // Scroll down to reveal Busiest Time Patterns
      await tester.scrollUntilVisible(
        find.text('Pola Waktu Tersibuk'),
        200.0,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();

      // Busiest Time Patterns
      expect(find.text('Pola Waktu Tersibuk'), findsOneWidget);
      expect(find.text('Berdasarkan rekap sensor harian'), findsOneWidget);
      expect(find.text('01'), findsOneWidget);
      expect(find.text('Pagi (08.30 – 11.30 WIB)'), findsOneWidget);
      expect(find.text('Padat'), findsOneWidget);
      expect(find.text('02'), findsOneWidget);
      expect(find.text('Siang (12.00 – 14.30 WIB)'), findsOneWidget);
      expect(find.text('03'), findsOneWidget);
      expect(find.text('Sore (15.00 – 17.30 WIB)'), findsOneWidget);
    });

    testWidgets('toggles vehicle filter to Mobil in Aktivitas', (
      WidgetTester tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(400, 850));
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const ActivityScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Tap Mobil filter
      await tester.tap(find.text('Mobil'));
      await tester.pumpAndSettle();

      // Verify mobil metrics loaded (e.g. 61%)
      expect(find.text('61'), findsOneWidget);
      expect(find.text('4'), findsOneWidget);
    });
  });

  group('Bottom Navigation Tab Switching Tests', () {
    testWidgets('switching tabs between Peta, Laporan, and Aktivitas', (
      WidgetTester tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(400, 850));
      await tester.pumpWidget(const PoseidonApp());
      await tester.pumpAndSettle();

      // Initial tab is Peta
      expect(find.text('Halo! Rifky'), findsOneWidget);

      // Tap "Laporan" tab
      await tester.tap(find.text('Laporan'));
      await tester.pumpAndSettle();

      // Verify Lapor screen is displayed
      expect(find.text('Lapor'), findsOneWidget);
      expect(find.text('Riwayat Laporan'), findsOneWidget);
      expect(find.text('Buat Laporan'), findsOneWidget);

      // Tap "Aktivitas" tab
      await tester.tap(find.text('Aktivitas'));
      await tester.pumpAndSettle();

      // Verify Aktivitas screen is displayed
      expect(find.text('Aktivitas'), findsWidgets);
      expect(find.text('Analitik penggunaan parkir kampus'), findsOneWidget);
      expect(find.text('Rata-rata Keterisian'), findsOneWidget);

      // Tap "Peta" tab back
      await tester.tap(find.text('Peta'));
      await tester.pumpAndSettle();

      // Verify returned to Peta
      expect(find.text('Halo! Rifky'), findsOneWidget);
    });
  });
}
