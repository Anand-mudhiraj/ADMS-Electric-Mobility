import 'package:flutter_test/flutter_test.dart';
import 'package:adms_showroom/main.dart';

void main() {
  testWidgets('ADMS Showroom app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const AdmsShowroomApp());
    await tester.pumpAndSettle();

    // Verify that the title / brand name renders.
    expect(find.text('ADMS'), findsWidgets);
  });
}
