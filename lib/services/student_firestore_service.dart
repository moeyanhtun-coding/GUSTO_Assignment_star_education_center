import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:star_education_center/models/student_model.dart';
import 'package:uuid/uuid.dart';

// Abstraction for the Student Database
abstract class StudentDatabase {
  Future<void> registerStudent(StudentModel student);
  Stream<QuerySnapshot> searchStudentsByName(String searchQuery);
  Stream<QuerySnapshot> getStudents();
  Future<void> deleteStudent(String documentId);
  Future<DocumentSnapshot> getStudentById(String studentId);
  Future<void> updateStudent(String documentId, StudentModel student);
  Future<void> updateCourseStudent(String documentId, List<String> courseName);
}

// Firebase Firestore implementation
class FirestoreStudentDatabase implements StudentDatabase {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final CollectionReference students =
      FirebaseFirestore.instance.collection("Students");
  final Uuid uuid = const Uuid(); // For generating UUIDs

  // Register student
  @override
  // SRP (Single Responsibility Principle (SRP) ) Apply
  Future<void> registerStudent(StudentModel student) {
    return students.add({
      'sId': 'S-${uuid.v4()}', // Generate unique UUID
      'name': student.name,
      'email': student.email,
      'phone': student.phone,
      'courseName': student.courseName,
      'section': student.section,
      'timeStep': Timestamp.now(),
    });
  }

  // Search students by name
  @override
  Stream<QuerySnapshot> searchStudentsByName(String searchQuery) {
    final studentStream = students
        .where('name', isGreaterThanOrEqualTo: searchQuery)
        .where('name', isLessThanOrEqualTo: '$searchQuery\uf8ff')
        .orderBy('name')
        .snapshots();

    log('Search Query: $searchQuery, Data: ${studentStream.toString()}');
    return studentStream;
  }

  // Get all students
  @override
  Stream<QuerySnapshot> getStudents() {
    return students.orderBy('timeStep', descending: true).snapshots();
  }

  // Delete a student
  @override
  Future<void> deleteStudent(String documentId) {
    return students.doc(documentId).delete().then((_) {
      log("Student with ID: $documentId deleted");
    }).catchError((error) {
      log("Failed to delete student: $error");
    });
  }

  // Get a student by their ID
  // SRP (Single Responsibility Principle (SRP) ) Apply
  @override
  Future<DocumentSnapshot> getStudentById(String studentId) async {
    try {
      QuerySnapshot querySnapshot =
          await students.where('sId', isEqualTo: studentId).get();

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first;
      } else {
        throw Exception("No student found with ID: $studentId");
      }
    } catch (error) {
      log("Failed to retrieve student: $error");
      throw error;
    }
  }

  // Update student information
  // SRP (Single Responsibility Principle (SRP) ) Apply
  @override
  Future<void> updateStudent(String documentId, StudentModel student) {
    return students.doc(documentId).update({
      'name': student.name,
      'email': student.email,
      'phone': student.phone,
      'section': student.section,
      'timeStep': Timestamp.now(),
      'courseName': student.courseName
    }).then((_) {
      log("Student with ID: $documentId updated");
    }).catchError((error) {
      log("Failed to update student: $error");
    });
  }

  // Update student's course list
  // SRP (Single Responsibility Principle (SRP) ) Apply
  @override
  Future<void> updateCourseStudent(String documentId, List<String> courseName) {
    return students
        .doc(documentId)
        .update({'courseName': courseName}).then((_) {
      log("Student with ID: $documentId updated");
    }).catchError((error) {
      log("Failed to update student: $error");
    });
  }
}
