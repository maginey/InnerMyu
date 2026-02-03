import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:innermyu/main.dart';

void main() {
  testWidgets('InnerMyu app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const InnerMyuApp());

    // Verify that InnerMyu title exists
    expect(find.text('Inner'), findsOneWidget);
    expect(find.text('Myu'), findsOneWidget);

    // Verify bottom navigation exists
    expect(find.text('타로'), findsOneWidget);
    expect(find.text('오라클'), findsOneWidget);
    expect(find.text('영상'), findsOneWidget);
  });
}
