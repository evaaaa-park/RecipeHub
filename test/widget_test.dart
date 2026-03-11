import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:recipehub/app/app.dart';

void main() {
  testWidgets('App boots with an initialization shell', (WidgetTester tester) async {
    await tester.pumpWidget(const RecipeHubApp());

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
