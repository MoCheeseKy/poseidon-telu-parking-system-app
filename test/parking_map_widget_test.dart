import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:poseidon/core/theme/app_theme.dart';
import 'package:poseidon/data/mock/mock_parking_data.dart';
import 'package:poseidon/main.dart';
import 'package:poseidon/ui/core/widgets/interactive_map_canvas.dart';
import 'package:poseidon/ui/core/widgets/parking_tooltip_marker.dart';

void main() {
  group('Custom Geographic Parking Map Tests', () {
    test('configures all 18 surveyed Telkom University Bandung parking locations', () {
      expect(MockParkingData.allLocations.length, equals(18));
      expect(MockParkingData.motorLocations.length, equals(9));
      expect(MockParkingData.mobilLocations.length, equals(9));

      // Spot-check surveyed coordinates
      expect(MockParkingData.gkuMotorParking.latitude, closeTo(-6.971657, 1e-6));
      expect(MockParkingData.gkuMotorParking.longitude, closeTo(107.629751, 1e-6));
      expect(MockParkingData.tultMobilParking.latitude, closeTo(-6.969427, 1e-6));
      expect(MockParkingData.tultMobilParking.longitude, closeTo(107.628468, 1e-6));
      expect(MockParkingData.gedungEfMobilParking.latitude, closeTo(-6.976591, 1e-6));
      expect(MockParkingData.gedungEfMobilParking.longitude, closeTo(107.630792, 1e-6));
    });

    testWidgets(
      'renders FlutterMap, OpenStreetMap attribution, and filters Motor vs Mobil markers',
      (WidgetTester tester) async {
        await tester.binding.setSurfaceSize(const Size(400, 850));
        await tester.pumpWidget(const PoseidonApp());
        await tester.pumpAndSettle();

        // Map & Attribution layer
        expect(find.byType(FlutterMap), findsOneWidget);
        expect(find.byType(TileLayer), findsOneWidget);
        expect(find.byType(MarkerLayer), findsOneWidget);
        expect(find.text('OpenStreetMap contributors'), findsOneWidget);

        // Default Motor view renders all 9 Motor parking markers
        expect(
          find.byType(ParkingTooltipMarker),
          findsNWidgets(MockParkingData.motorLocations.length),
        );
        expect(find.text('TULT'), findsOneWidget);
        expect(find.text('Asrama Putra'), findsOneWidget);
        expect(find.text('TJ Mart'), findsOneWidget);
        expect(find.text('MSU'), findsOneWidget);
        expect(find.text('FKS'), findsOneWidget);

        // Switch to Mobil -> map markers update to the 9 Mobil parking markers
        await tester.tap(find.text('Mobil'));
        await tester.pumpAndSettle();

        expect(
          find.byType(ParkingTooltipMarker),
          findsNWidgets(MockParkingData.mobilLocations.length),
        );
        expect(find.text('TUCH'), findsOneWidget);
        expect(find.text('Cacuk'), findsOneWidget);
        expect(find.text('Damar'), findsOneWidget);
        expect(find.text('Penambulai'), findsOneWidget);
        expect(find.text('Gedung E & F'), findsOneWidget);
      },
    );

    testWidgets(
      'markers remain geographically anchored when panning, zooming, and resetting map position',
      (WidgetTester tester) async {
        await tester.binding.setSurfaceSize(const Size(400, 850));
        await tester.pumpWidget(const PoseidonApp());
        await tester.pumpAndSettle();

        final tultFinder = find.byKey(
          const ValueKey('parking_marker_tult_motor'),
        );
        final fitFinder = find.byKey(
          const ValueKey('parking_marker_fit_motor'),
        );

        final initialTultPos = tester.getRect(tultFinder).bottomCenter;
        final initialFitPos = tester.getRect(fitFinder).bottomCenter;
        final initialDistance = (initialFitPos - initialTultPos).distance;

        // Pan the map in the visible upper viewport -> markers move together accurately
        await tester.dragFrom(const Offset(200, 120), const Offset(45, 25));
        await tester.pumpAndSettle();

        final pannedTultPos = tester.getRect(tultFinder).bottomCenter;
        expect((pannedTultPos - initialTultPos).distance, greaterThan(20.0));

        // Zoom in via map control button -> geographic screen distance increases
        await tester.tap(find.byKey(const Key('zoom_in_map_button')));
        await tester.pumpAndSettle();

        final zoomedTultPos = tester.getRect(tultFinder).bottomCenter;
        final zoomedFitPos = tester.getRect(fitFinder).bottomCenter;
        final zoomedDistance = (zoomedFitPos - zoomedTultPos).distance;

        expect(zoomedDistance, greaterThan(initialDistance));

        // Reset to initial campus position -> restores original coordinates on screen
        await tester.tap(find.byKey(const Key('reset_map_position_button')));
        await tester.pumpAndSettle();

        final resetTultPos = tester.getRect(tultFinder).bottomCenter;
        expect((resetTultPos - initialTultPos).distance, lessThan(1.0));
      },
    );

    testWidgets(
      'tapping markers highlights selection, shows compact bottom sheet, switches markers, focuses, and dismisses cleanly',
      (WidgetTester tester) async {
        await tester.binding.setSurfaceSize(const Size(400, 850));
        await tester.pumpWidget(const PoseidonApp());
        await tester.pumpAndSettle();

        // Initially no marker is selected; default list sheet is visible
        expect(
          find.byKey(const Key('selected_parking_compact_sheet')),
          findsNothing,
        );
        expect(find.text('Halo! Rifky'), findsOneWidget);

        // Tap TULT (Motor) marker on the map
        await tester.tap(
          find.byKey(const ValueKey('parking_marker_tult_motor')),
        );
        await tester.pumpAndSettle();

        // Compact bottom sheet is shown while map stays interactive
        expect(
          find.byKey(const Key('selected_parking_compact_sheet')),
          findsOneWidget,
        );
        expect(find.text('84 dari 250 slot tersedia'), findsOneWidget);
        expect(find.text('Tersedia'), findsOneWidget);

        final tultWidget = tester.widget<ParkingTooltipMarker>(
          find.ancestor(
            of: find.byKey(const ValueKey('parking_marker_tult_motor')),
            matching: find.byType(ParkingTooltipMarker),
          ),
        );
        expect(tultWidget.isSelected, isTrue);

        // Tap a different marker (TJ Mart Motor) while compact sheet is open -> updates without overlapping sheets
        await tester.tap(
          find.byKey(const ValueKey('parking_marker_tj_mart_motor')),
        );
        await tester.pumpAndSettle();

        expect(
          find.byKey(const Key('selected_parking_compact_sheet')),
          findsOneWidget,
        );
        expect(find.text('14 dari 100 slot tersedia'), findsOneWidget);
        expect(find.text('Terbatas'), findsOneWidget);

        // Focus on selected parking location using map navigation button
        final beforeFocusPos = tester
            .getRect(find.byKey(const ValueKey('parking_marker_tj_mart_motor')))
            .bottomCenter;
        await tester.tap(
          find.byKey(const Key('focus_selected_parking_button')),
        );
        await tester.pumpAndSettle();
        final afterFocusPos = tester
            .getRect(find.byKey(const ValueKey('parking_marker_tj_mart_motor')))
            .bottomCenter;
        expect((afterFocusPos - beforeFocusPos).distance, greaterThan(1.0));

        // Open full ParkingDetailSheet from compact sheet
        await tester.tap(find.byKey(const Key('open_parking_detail_button')));
        await tester.pumpAndSettle();
        expect(find.text('Mulai Navigasi ke Parkir'), findsOneWidget);

        // Close modal detail sheet
        Navigator.of(
          tester.element(find.text('Mulai Navigasi ke Parkir')),
        ).pop();
        await tester.pumpAndSettle();

        // Dismiss selected state using close button on compact sheet
        await tester.tap(
          find.byKey(const Key('close_selected_parking_button')),
        );
        await tester.pumpAndSettle();

        expect(
          find.byKey(const Key('selected_parking_compact_sheet')),
          findsNothing,
        );
        expect(find.text('Halo! Rifky'), findsOneWidget);
      },
    );

    testWidgets('handles empty parking data gracefully across screen sizes', (
      WidgetTester tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(320, 640));
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const Scaffold(body: InteractiveMapCanvas(locations: [])),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(FlutterMap), findsOneWidget);
      expect(find.byType(ParkingTooltipMarker), findsNothing);
      expect(find.text('Belum ada lokasi parkir tersedia'), findsOneWidget);
    });
  });
}
