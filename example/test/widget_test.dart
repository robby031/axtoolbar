import 'package:axtoolbar_example/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Demo app boots and shows the edit tools', (tester) async {
    await tester.pumpWidget(const AxToolbarDemoApp());
    await tester.pumpAndSettle();
    expect(find.text('Pen'), findsWidgets);
    expect(find.text('Design'), findsWidgets);
  });
}
