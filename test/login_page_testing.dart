import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:star_education_center/pages/login_page.dart';

void main() {
  // Set up a test environment with GetX
  setUpAll(() {
    Get.testMode = true;
  });

  group('LoginPage Widget Tests', () {
    // Verify Email TextField is present
    testWidgets('should find Email TextField', (WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          home: LoginPage(),
        ),
      );
      expect(find.bySemanticsLabel('Email'), findsOneWidget);
    });

    // Verify Password TextField is present
    testWidgets('should find Password TextField', (WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          home: LoginPage(),
        ),
      );
      expect(find.bySemanticsLabel('Password'), findsOneWidget);
    });

    // Check for SnackBar on invalid login
    testWidgets('should show SnackBar on invalid login',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          home: LoginPage(),
        ),
      );
      await tester.enterText(find.bySemanticsLabel('Email'), 'wrong@gmail.com');
      await tester.enterText(find.bySemanticsLabel('Password'), 'wrongpass');
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();
      expect(find.text('Invalid email or password'), findsOneWidget);
    });

    // Verify navigation to /home on successful login
    testWidgets('should navigate to /home on successful login',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          home: LoginPage(),
        ),
      );
      await tester.enterText(find.bySemanticsLabel('Email'), 'admin@gmail.com');
      await tester.enterText(find.bySemanticsLabel('Password'), 'admin@123?');
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();
      expect(Get.currentRoute, "/HomePage");
    });

    // Verify navigation to /register on tapping "Register Now"
    testWidgets('should navigate to /register on tapping "Register Now"',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          home: LoginPage(),
        ),
      );
      await tester.tap(find.text('Register Now'));
      await tester.pumpAndSettle();
      expect(Get.currentRoute, '/RegisterPage');
    });
  });
}
