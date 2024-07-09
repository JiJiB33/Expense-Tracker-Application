import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:savvy_expense_tracker_app/views/login_view.dart';

void main() {
  testWidgets('LoginView widget test', (WidgetTester tester) async {
    // Build our widget and trigger a frame.
    await tester.pumpWidget(LoginView());

    // Verify that the text fields are displayed.
    expect(find.text('Username'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);

  });
}
