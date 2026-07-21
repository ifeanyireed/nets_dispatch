import 'package:flutter_test/flutter_test.dart';
import 'package:rider_app/main.dart';

void main() {
  testWidgets('NetsDispatchApp smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const NetsDispatchApp());

    // Verify that the login screen title or text exists.
    expect(find.text('WELCOME BACK'), findsOneWidget);
  });
}
