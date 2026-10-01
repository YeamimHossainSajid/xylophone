import 'package:flutter_test/flutter_test.dart';
import 'package:xylophone/main.dart';

void main() {
  testWidgets('XylophoneApp renders title and xylophone keys', (WidgetTester tester) async {
    await tester.pumpWidget(const XylophoneApp());

    // Verify app title renders
    expect(find.text('Pocket Xylophone'), findsOneWidget);
    expect(find.text('Harmonic Rainbow Keys'), findsOneWidget);

    // Verify default letter notes render (C, D, E, F, G, A, B)
    expect(find.text('C'), findsOneWidget);
    expect(find.text('D'), findsOneWidget);
    expect(find.text('E'), findsOneWidget);
    expect(find.text('F'), findsOneWidget);
    expect(find.text('G'), findsOneWidget);
    expect(find.text('A'), findsOneWidget);
    expect(find.text('B'), findsOneWidget);
  });
}
