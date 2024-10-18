import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'package:star_education_center/models/course_model.dart';

// Abstract class for course services (DIP)
abstract class CourseService {
  Future<void> createCourse(CourseModel course);
  Stream<QuerySnapshot> getCourses();
  Future<DocumentSnapshot> getCourseByName(String courseName);
}

// Separate service for generating UUID (SRP)
abstract class UuidService {
  String generateUuid();
}

class DefaultUuidService implements UuidService {
  final Uuid _uuid = Uuid();

  @override
  String generateUuid() {
    return 'C -' + _uuid.v4(); // Prepend "C -" to the UUID
  }
}

// Separate class for logging (SRP)
class LoggerService {
  void logError(String message) {
    log("Error: $message");
  }
}

// CourseFirestoreService adhering to SOLID principles
class CourseFirestoreService implements CourseService {
  final FirebaseFirestore _db;
  final UuidService _uuidService;
  final LoggerService _loggerService;

  CourseFirestoreService({
    required FirebaseFirestore db,
    required UuidService uuidService,
    required LoggerService loggerService,
  })  : _db = db,
        _uuidService = uuidService,
        _loggerService = loggerService;

  CollectionReference get _courses => _db.collection("Courses");

  // Create a course (SRP applied: UUID generation and logging separated)
  @override
  Future<void> createCourse(CourseModel course) {
    return _courses.add({
      'cId':
          _uuidService.generateUuid(), // Use the UUID service for ID generation
      'courseName': course.courseName,
      'courseDuration': course.courseDuration,
      'fees': course.fees,
      'timeStep': Timestamp.now(),
    });
  }

  // Fetch courses (ISP applied: specific interface for fetching courses)
  @override
  Stream<QuerySnapshot> getCourses() {
    return _courses.orderBy('timeStep', descending: true).snapshots();
  }

  // Fetch a course by name (SRP and DIP applied: Logger service handles logging)
  @override
  Future<DocumentSnapshot> getCourseByName(String courseName) async {
    try {
      QuerySnapshot querySnapshot =
          await _courses.where('courseName', isEqualTo: courseName).get();

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first;
      } else {
        throw Exception("No course found with name: $courseName");
      }
    } catch (error) {
      _loggerService.logError("Failed to retrieve course: $error");
      throw error;
    }
  }
}
