import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Student Dialog Test', () {
    testWidgets('Display new student dialog and input fields',
        (WidgetTester tester) async {
      // Create a MaterialApp to wrap the widget
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              showDialog(
                context: tester.element(find.byType(FloatingActionButton)),
                builder: (context) => Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Container(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        TextField(
                          key: Key('nameField'),
                          decoration: InputDecoration(
                            label: Text("Name"),
                          ),
                        ),
                        SizedBox(height: 20),
                        TextField(
                          key: Key('emailField'),
                          decoration: InputDecoration(
                            label: Text("Email"),
                          ),
                        ),
                        SizedBox(height: 20),
                        TextField(
                          key: Key('phoneField'),
                          decoration: InputDecoration(
                            label: Text("Phone"),
                          ),
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {},
                          child: Text("Create"),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ));

      // Verify that the FloatingActionButton is displayed
      expect(find.byType(FloatingActionButton), findsOneWidget);

      // Tap the FloatingActionButton to show the dialog
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      // Verify that the dialog and input fields are displayed
      expect(find.byType(Dialog), findsOneWidget);
      expect(find.byKey(Key('nameField')), findsOneWidget);
      expect(find.byKey(Key('emailField')), findsOneWidget);
      expect(find.byKey(Key('phoneField')), findsOneWidget);

      // Verify that the "Create" button is displayed
      expect(find.text('Create'), findsOneWidget);
    });
  });
}
