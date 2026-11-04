import 'package:flutter_test/flutter_test.dart';
import 'package:poseidon/main.dart';

void main() {
  testWidgets('PoseidonApp renders smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const PoseidonApp());
    await tester.pumpAndSettle();

    expect(find.text('Poseidon Smart Parking'), findsOneWidget);
  });
}
