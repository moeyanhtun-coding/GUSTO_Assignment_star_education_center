import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:star_education_center/models/student_model.dart';
import 'package:uuid/uuid.dart';

final FirebaseFirestore db = FirebaseFirestore.instance;
final Uuid uuid = Uuid(); // Create an instance of Uuid

class StudentFirestoreService {
  final CollectionReference students = db.collection("Students");

  // registerStudent
  Future<void> registerStudent(NewStudent student) {
    return students.add({
      'sId': 'S -' + uuid.v4(), // Generate a unique UUID string
      'name': student.name,
      'email': student.email,
      'phone': student.phone,
      'courseId': student.courseId,
      'section': student.section,
      'timeStep': Timestamp.now(),
    });
  }

// search function
  Stream<QuerySnapshot> searchStudentsByName(String searchQuery) {
    final studentStream = students
        .where('name', isGreaterThanOrEqualTo: searchQuery)
        .where('name', isLessThanOrEqualTo: searchQuery + '\uf8ff')
        .orderBy('name') // Order results by name
        .snapshots();

    log('Search Query: $searchQuery, Data: ${studentStream.toString()}');
    return studentStream;
  }

  // read Student
  Stream<QuerySnapshot> getStudents() {
    final studentStream =
        students.orderBy('timeStep', descending: true).snapshots();
    return studentStream;
  }

// delete function
  Future<void> deleteStudent(String documentId) {
    return students.doc(documentId).delete().then((_) {
      log("Student with ID: $documentId deleted");
    }).catchError((error) {
      log("Failed to delete student: $error");
    });
  }

  // update function
  Future<void> updateStudent(String documentId, StudentModel student) {
    return students.doc(documentId).update({
      'name': student.name,
      'email': student.email,
      'phone': student.phone,
      'section': student.section,
      'timeStep': Timestamp.now() // Update timestamp
    }).then((_) {
      log("Student with ID: $documentId updated");
    }).catchError((error) {
      log("Failed to update student: $error");
    });
  }
}
