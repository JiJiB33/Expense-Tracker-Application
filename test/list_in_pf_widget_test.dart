import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:savvy_expense_tracker_app/widgets/list_in_pf_widget.dart';

void main() {
  testWidgets('ListInPFWidget widget test', (WidgetTester tester) async {
    // Define a callback function to handle the onPressed event.
    VoidCallback onPressed = () {
      // Implement your logic here if needed.
    };

    // Build our widget and trigger a frame.
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ListInPFWidget(
            title: 'Test Item',
            icon: Icons.manage_history,
            onPress: onPressed,
            endIcon: true,
          ),
        ),
      ),
    );

    // Verify that the widget is displayed.
    expect(find.text('Test Item'), findsOneWidget);
    expect(find.byIcon(Icons.manage_history), findsOneWidget);
  });
}
