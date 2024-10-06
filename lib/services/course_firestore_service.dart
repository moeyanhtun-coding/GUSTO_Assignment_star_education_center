import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:star_education_center/models/course_model.dart';
import 'package:uuid/uuid.dart';

final FirebaseFirestore db = FirebaseFirestore.instance;
final Uuid uuid = Uuid(); // Create a

class CourseFirestoreService {
  final CollectionReference courses = db.collection("Courses");

  // create course
  Future<void> createCourse(CourseModel course) {
    return courses.add(
      {
        'cId': 'C -' + uuid.v4(), // Generate a unique UUID string
        'courseName': course.courseName,
        'fees': course.fees,
        'timeStep': Timestamp.now(),
      },
    );
  }

  // read Student
  Stream<QuerySnapshot> getCourses() {
    final courseStream =
        courses.orderBy('timeStep', descending: true).snapshots();
    return courseStream;
  }
}
