import 'package:axtoolbar/axtoolbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AxToolbar', () {
    const tools = [
      AxTool(id: 'pen', icon: Icon(Icons.edit), label: 'Pen'),
      AxTool(id: 'shape', icon: Icon(Icons.square_outlined), label: 'Shape'),
      AxTool(id: 'text', icon: Icon(Icons.text_fields), label: 'Text'),
    ];

    testWidgets('renders all tools with icon + label', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: AxToolbar(tools: tools, selectedId: 'pen'),
            ),
          ),
        ),
      );

      expect(find.text('Pen'), findsOneWidget);
      expect(find.text('Shape'), findsOneWidget);
      expect(find.text('Text'), findsOneWidget);
      expect(find.byIcon(Icons.edit), findsOneWidget);
    });

    testWidgets('tapping a tool fires onSelected with its id', (tester) async {
      String? selected = 'pen';
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: StatefulBuilder(
                builder: (context, setState) => AxToolbar(
                  tools: tools,
                  selectedId: selected,
                  onSelected: (id) => setState(() => selected = id),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Text'));
      await tester.pumpAndSettle();
      expect(selected, 'text');
    });

    testWidgets('disabled tool does not fire onSelected', (tester) async {
      String? selected;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: AxToolbar(
                tools: const [
                  AxTool(id: 'a', label: 'A'),
                  AxTool(id: 'b', label: 'B', enabled: false),
                ],
                onSelected: (id) => selected = id,
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('B'));
      await tester.pumpAndSettle();
      expect(selected, isNull);

      await tester.tap(find.text('A'));
      await tester.pumpAndSettle();
      expect(selected, 'a');
    });

    testWidgets('vertical axis lays out tools in a column', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: AxToolbar(
                axis: Axis.vertical,
                tools: tools,
                selectedId: 'pen',
              ),
            ),
          ),
        ),
      );

      final penPos = tester.getCenter(find.text('Pen'));
      final textPos = tester.getCenter(find.text('Text'));
      // Vertical: same x, increasing y.
      expect(textPos.dy, greaterThan(penPos.dy));
    });

    testWidgets('respects AxToolbarTheme override', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.light().copyWith(
            extensions: const [
              AxToolbarTheme(
                style: AxToolbarStyle(indicator: AxToolbarIndicator.pill),
              ),
            ],
          ),
          home: const Scaffold(
            body: Center(child: AxToolbar(tools: tools, selectedId: 'pen')),
          ),
        ),
      );
      expect(find.byType(AxToolbar), findsOneWidget);
    });

    test('AxToolbarStyle.merge prefers non-null overrides', () {
      const base = AxToolbarStyle(itemSpacing: 4, elevation: 0);
      const override = AxToolbarStyle(elevation: 4);
      final merged = base.merge(override);
      expect(merged.itemSpacing, 4);
      expect(merged.elevation, 4);
    });
  });

  group('AxFloatingToolbar', () {
    testWidgets('renders inside a Stack', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Stack(
              children: [
                const SizedBox.expand(),
                AxFloatingToolbar(
                  child: AxToolbar(
                    tools: const [AxTool(id: 'a', label: 'A')],
                    selectedId: 'a',
                  ),
                ),
              ],
            ),
          ),
        ),
      );
      expect(find.text('A'), findsOneWidget);
    });
  });
}
