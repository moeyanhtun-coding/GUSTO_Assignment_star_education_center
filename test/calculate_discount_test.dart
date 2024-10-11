import 'package:flutter_test/flutter_test.dart';

// The calculateDiscount function
double calculateDiscount(
  List<String> selectedCoursesList,
  List<String> existingCourse,
  double totalPrice,
) {
  double discount = 0;

  if (selectedCoursesList.isNotEmpty && existingCourse.isEmpty) {
    // New student - full fee
    discount = 0;
  } else if (existingCourse.isNotEmpty) {
    // Returning student
    if (existingCourse.length == 1) {
      discount = (totalPrice * 5) / 100; // 5% discount for 1 course
    } else if (existingCourse.length == 2) {
      discount = (totalPrice * 10) / 100; // 10% discount for 2 courses
    } else if (existingCourse.length >= 3) {
      discount = (totalPrice * 20) / 100; // 20% discount for 3 or more courses
    } else {
      discount = 0; // No discount if none of the above conditions are met
    }
  } else {
    discount = 0; // No discount for new students
  }

  return discount;
}

void main() {
  group('Discount Calculation Tests', () {
    test('No discount for new student', () {
      List<String> selectedCourses = ['Math'];
      List<String> existingCourses = [];
      double totalPrice = 100.0;

      double result =
          calculateDiscount(selectedCourses, existingCourses, totalPrice);
      expect(result, 0);
    });

    test('5% discount for returning student with 1 course', () {
      List<String> selectedCourses = ['Math', 'Science'];
      List<String> existingCourses = ['Math'];
      double totalPrice = 200.0;

      double result =
          calculateDiscount(selectedCourses, existingCourses, totalPrice);
      expect(result, 10.0); // 5% of 200 is 10
    });

    test('10% discount for returning student with 2 courses', () {
      List<String> selectedCourses = ['Math', 'Science'];
      List<String> existingCourses = ['Math', 'Science'];
      double totalPrice = 300.0;

      double result =
          calculateDiscount(selectedCourses, existingCourses, totalPrice);
      expect(result, 30.0); // 10% of 300 is 30
    });

    test('20% discount for returning student with 3 or more courses', () {
      List<String> selectedCourses = ['Math', 'Science'];
      List<String> existingCourses = ['Math', 'Science', 'English'];
      double totalPrice = 500.0;

      double result =
          calculateDiscount(selectedCourses, existingCourses, totalPrice);
      expect(result, 100.0); // 20% of 500 is 100
    });

    test('20% discount for returning student more than 3 courses', () {
      List<String> selectedCourses = ['Math'];
      List<String> existingCourses = ['Math', 'Science', 'English', 'English'];
      double totalPrice = 1000.0;

      double result =
          calculateDiscount(selectedCourses, existingCourses, totalPrice);
      expect(result, 200.0); // 20% of 500 is 100
    });
  });
}
