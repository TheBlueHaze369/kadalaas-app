import 'package:flutter_test/flutter_test.dart';
import 'package:kadalaas/main.dart';

void main() {
  testWidgets('splash shows stacked wordmark then home', (tester) async {
    await tester.pumpWidget(const KadalaasApp());

    expect(find.text('കട'), findsOneWidget);
    expect(find.text('ലാ'), findsOneWidget);
    expect(find.text('സ്'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 2800));
    await tester.pumpAndSettle();

    expect(find.textContaining('is yours'), findsOneWidget);
    expect(find.text('Add a new note'), findsOneWidget);
    expect(find.text('Lazy Mode'), findsOneWidget);
  });
}
