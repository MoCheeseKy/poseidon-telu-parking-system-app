import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:poseidon/core/theme/app_theme.dart';
import 'package:poseidon/main.dart';
import 'package:poseidon/ui/features/detail/views/parking_detail_sheet.dart';
import 'package:poseidon/ui/features/search/views/search_destination_sheet.dart';

void main() {
  group('Screen A: Beranda / Peta Page Tests', () {
    testWidgets('renders all visual elements on Beranda', (
      WidgetTester tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(400, 850));
      await tester.pumpWidget(const PoseidonApp());
      await tester.pumpAndSettle();

      // App Bar elements
      expect(find.text('Poseidon Smart Parking'), findsOneWidget);
      expect(find.byIcon(Icons.notifications_none_outlined), findsOneWidget);
      expect(find.byIcon(Icons.person), findsOneWidget);

      // Map canvas & controls
      expect(find.byIcon(Icons.my_location), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
      expect(find.byIcon(Icons.remove), findsOneWidget);

      // Bottom sheet contents
      expect(find.text('Halo! Rifky'), findsOneWidget);
      expect(
        find.text(
          'Pastikan parkir ditempat terbaik sebelum menuju gedung tujuan ya!',
        ),
        findsOneWidget,
      );
      expect(find.text('Motor'), findsWidgets);
      expect(find.text('Mobil'), findsOneWidget);

      // Favorite & Motor parking locations section
      expect(find.text('FAVORIT TERSIMPAN'), findsOneWidget);
      expect(find.text('SEMUA LOKASI PARKIR'), findsOneWidget);
      expect(find.text('Parkiran GKU (Motor)'), findsOneWidget);
      expect(find.text('Parkiran TULT (Motor)'), findsNWidgets(2));

      // Scroll sheet up to reveal remaining Motor list items
      await tester.drag(
        find.text('SEMUA LOKASI PARKIR'),
        const Offset(0, -320),
      );
      await tester.pumpAndSettle();

      expect(find.text('Parkiran Asrama Putra (Motor)'), findsOneWidget);
      expect(find.text('Parkiran TJ Mart (Motor)'), findsOneWidget);
      expect(find.text('Parkiran MSU (Motor)'), findsOneWidget);

      // Bottom navigation tabs
      expect(find.text('Peta'), findsOneWidget);
      expect(find.text('Laporan'), findsOneWidget);
      expect(find.text('Aktivitas'), findsOneWidget);
      expect(find.text('Akun'), findsOneWidget);
    });

    testWidgets('toggles vehicle type between Motor and Mobil in HomeMapScreen', (
      WidgetTester tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(400, 850));
      await tester.pumpWidget(const PoseidonApp());
      await tester.pumpAndSettle();

      // Tap "Mobil" toggle -> updates list & map to Mobil locations
      await tester.tap(find.text('Mobil'));
      await tester.pumpAndSettle();

      expect(find.text('Parkiran GKU (Mobil)'), findsOneWidget);
      expect(find.text('Parkiran TULT (Mobil)'), findsNWidgets(2));

      // Tap "Motor" toggle back -> restores Motor locations
      await tester.tap(find.text('Motor'));
      await tester.pumpAndSettle();

      expect(find.text('Parkiran GKU (Motor)'), findsOneWidget);
    });
  });

  group('Screen B: Cari Gedung Tujuan Tests', () {
    testWidgets('renders all visual elements in SearchDestinationSheet', (
      WidgetTester tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(400, 850));
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const Scaffold(body: SearchDestinationSheet()),
        ),
      );
      await tester.pumpAndSettle();

      // Title & Subtitle
      expect(find.text('Cari Gedung Tujuan'), findsOneWidget);
      expect(
        find.text(
          'Cari gedung tujuan kamu, untuk kami bantu cari parkiran terbaik untukmu!',
        ),
        findsOneWidget,
      );

      // Search input field prefilled with "Gedung TULT"
      expect(find.text('Gedung TULT'), findsOneWidget);
      expect(find.byIcon(Icons.search), findsOneWidget);
      expect(find.byIcon(Icons.cancel), findsOneWidget);

      // Recommendation Card
      expect(find.text('Rekomendasi'), findsOneWidget);
      expect(find.text('Parkiran TULT'), findsOneWidget);
      expect(find.text('Slot 12'), findsOneWidget);
      expect(find.text('160 m dari tujuan'), findsOneWidget);
      expect(find.text('Motor & Mobil'), findsOneWidget);
      expect(find.text('Pilih & Mulai Rute ke Parkir'), findsOneWidget);

      // Alternatives Section
      expect(find.text('ALTERNATIF TERDEKAT LAINNYA'), findsOneWidget);
      expect(find.text('Parkiran GKU (Motor)'), findsOneWidget);
      expect(find.text('46 slot tersedia'), findsOneWidget);
      expect(find.text('Parkiran FIT (Motor)'), findsOneWidget);
      expect(find.text('52 slot tersedia'), findsOneWidget);
    });
  });

  group('Screen C: Parking Area Detail Sheet Tests', () {
    testWidgets('renders all visual metrics for TULT Parking', (
      WidgetTester tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(400, 850));
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const Scaffold(body: ParkingDetailSheet()),
        ),
      );
      await tester.pumpAndSettle();

      // Title and subArea
      expect(find.text('Lapangan Parkir TULT'), findsOneWidget);
      expect(
        find.text(
          'Kawasan Fakultas Informatika (FIF) & Fakultas Kedokteran (FK)',
        ),
        findsOneWidget,
      );

      // Gate & Vehicle
      expect(find.text('Masuk Dari Gate 1'), findsOneWidget);
      expect(find.text('Motor'), findsOneWidget);

      // Capacity numbers (84 + 166 = 250)
      expect(find.text('84'), findsOneWidget);
      expect(find.text('slot tersedia'), findsOneWidget);
      expect(find.text('166 terisi'), findsOneWidget);
      expect(find.text('Kapasitas Total 250 slot'), findsOneWidget);

      // Nearest buildings
      expect(find.text('Jarak ke Gedung Terdekat'), findsOneWidget);
      expect(find.text('Gedung TULT'), findsOneWidget);
      expect(find.text('160 m'), findsOneWidget);
      expect(find.text('Gedung Fakultas Kedokteran'), findsOneWidget);
      expect(find.text('280 m'), findsOneWidget);
      expect(find.text('Asrama Pria'), findsOneWidget);
      expect(find.text('350 m'), findsOneWidget);

      // Bottom actions
      expect(find.text('Mulai Navigasi ke Parkir'), findsOneWidget);
      expect(find.byIcon(Icons.bookmark_outline), findsOneWidget);

      // Test Bookmark toggle
      await tester.ensureVisible(find.byIcon(Icons.bookmark_outline));
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.bookmark_outline));
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.bookmark), findsOneWidget);
    });
  });

  group('Navigation & Interactivity Flow Tests', () {
    testWidgets('tapping center action button opens Search Destination Sheet', (
      WidgetTester tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(400, 850));
      await tester.pumpWidget(const PoseidonApp());
      await tester.pumpAndSettle();

      // Tap central red FAB
      await tester.tap(find.byIcon(Icons.near_me_outlined));
      await tester.pumpAndSettle();

      // Verify Screen B is opened
      expect(find.text('Cari Gedung Tujuan'), findsOneWidget);
      expect(find.text('Pilih & Mulai Rute ke Parkir'), findsOneWidget);

      // Tap "Pilih & Mulai Rute ke Parkir" to open Screen C
      await tester.tap(find.text('Pilih & Mulai Rute ke Parkir'));
      await tester.pumpAndSettle();

      // Verify Screen C is opened
      expect(find.text('Parkiran TULT (Motor)'), findsWidgets);
      expect(find.text('Masuk Dari Gate 1'), findsOneWidget);
    });

    testWidgets('tapping parking item from Home opens Parking Detail Sheet', (
      WidgetTester tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(400, 850));
      await tester.pumpWidget(const PoseidonApp());
      await tester.pumpAndSettle();

      // Tap "Parkiran GKU (Motor)"
      await tester.tap(find.text('Parkiran GKU (Motor)'));
      await tester.pumpAndSettle();

      // Verify Screen C opened for Parkiran GKU (Motor)
      expect(find.text('Parkiran GKU (Motor)'), findsWidgets);
      expect(find.text('Masuk Dari Gate Barat'), findsOneWidget);
    });
  });
}
