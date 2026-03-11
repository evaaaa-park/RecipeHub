import 'package:flutter_test/flutter_test.dart';

import 'package:recipehub/app/app.dart';

void main() {
  testWidgets('App starts on dashboard route shell', (WidgetTester tester) async {
    await tester.pumpWidget(const RecipeHubApp());

    expect(find.text('Dashboard'), findsOneWidget);
    expect(find.text('Ingredients'), findsOneWidget);
  });
}
