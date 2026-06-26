import 'package:flutter_test/flutter_test.dart';
import 'package:spotifly/main.dart';

void main() {
  testWidgets('Spotifly smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const SpotiflyApp());
    expect(find.text('Spotifly'), findsOneWidget);
  });
}