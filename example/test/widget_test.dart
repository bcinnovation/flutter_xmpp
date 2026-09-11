import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_xmpp_example/main.dart';

void main() {
  testWidgets('shows example label', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('flutter_xmpp example'), findsOneWidget);
  });
}
