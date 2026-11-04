import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:poseidon/ui/core/widgets/app_bottom_nav_bar.dart';

void main() {
  group('AppBottomNavBar Widget Tests', () {
    testWidgets('renders all 4 tabs and center floating button with exact design', (
      WidgetTester tester,
    ) async {
      int selectedTab = 0;
      bool centerActionTriggered = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            bottomNavigationBar: AppBottomNavBar(
              currentIndex: selectedTab,
              onTabSelected: (index) => selectedTab = index,
              onCenterAction: () => centerActionTriggered = true,
            ),
          ),
        ),
      );

      // Verify 4 labels
      expect(find.text('Peta'), findsOneWidget);
      expect(find.text('Laporan'), findsOneWidget);
      expect(find.text('Aktivitas'), findsOneWidget);
      expect(find.text('Akun'), findsOneWidget);

      // Verify icons
      expect(find.byIcon(Icons.map_outlined), findsOneWidget);
      expect(find.byIcon(Icons.flag_outlined), findsOneWidget);
      expect(find.byIcon(Icons.history), findsOneWidget);
      expect(find.byIcon(Icons.person_outline), findsOneWidget);

      // Verify center floating action button with outlined near_me icon
      expect(find.byIcon(Icons.near_me_outlined), findsOneWidget);

      // Tap on center button
      await tester.tap(find.byIcon(Icons.near_me_outlined));
      expect(centerActionTriggered, isTrue);

      // Tap on Laporan tab
      await tester.tap(find.text('Laporan'));
      expect(selectedTab, equals(1));

      // Tap on Aktivitas tab
      await tester.tap(find.text('Aktivitas'));
      expect(selectedTab, equals(2));

      // Tap on Akun tab
      await tester.tap(find.text('Akun'));
      expect(selectedTab, equals(3));
    });
  });
}

