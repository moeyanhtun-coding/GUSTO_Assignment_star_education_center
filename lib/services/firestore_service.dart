import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:star_education_center/models/student_model.dart';
import 'package:uuid/uuid.dart';

final FirebaseFirestore db = FirebaseFirestore.instance;
final Uuid uuid = Uuid(); // Create an instance of Uuid

class FirestoreService {
  final CollectionReference students = db.collection("Students");

  // registerStudent
  Future<void> registerStudent(NewStudent student) {
    return students.add({
      'sId': uuid.v4(), // Generate a unique UUID string
      'name': student.name,
      'email': student.email,
      'phone': student.phone,
      'section': student.section,
      'timeStep': Timestamp.now()
    });
  }

  Stream<QuerySnapshot> searchStudentsByName(String searchQuery) {
    String searchLower = searchQuery.toLowerCase();

    final studentStream = students
        .where('name', isGreaterThanOrEqualTo: searchLower)
        .where('name', isLessThanOrEqualTo: searchLower + '\uf8ff')
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
}
