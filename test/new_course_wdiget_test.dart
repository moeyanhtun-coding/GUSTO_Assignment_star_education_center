import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Course Dialog Test', () {
    testWidgets('Display new course dialog and input fields',
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
                          key: Key('courseNameField'),
                          decoration: InputDecoration(
                            label: Text("Course Name"),
                          ),
                        ),
                        SizedBox(height: 20),
                        TextField(
                          key: Key('courseFeesField'),
                          decoration: InputDecoration(
                            label: Text("Fees"),
                          ),
                        ),
                        SizedBox(height: 20),
                        TextField(
                          key: Key('courseDurationField'),
                          decoration: InputDecoration(
                            label: Text("Duration"),
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
      expect(find.byKey(Key('courseNameField')), findsOneWidget);
      expect(find.byKey(Key('courseFeesField')), findsOneWidget);
      expect(find.byKey(Key('courseDurationField')), findsOneWidget);

      // Verify that the "Create" button is displayed
      expect(find.text('Create'), findsOneWidget);
    });
  });
}
