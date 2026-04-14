import 'package:financas/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Caminho feliz para adicionar uma despesa', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.byIcon(Icons.add), findsOneWidget);
    await tester.tap(find.byIcon(Icons.add));
    tester.pump;
  });
}