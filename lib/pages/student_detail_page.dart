// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

import 'package:star_education_center/pages/courses_add_page.dart';
import 'package:star_education_center/services/course_firestore_service.dart';
import 'package:star_education_center/services/student_firestore_service.dart';
import 'package:star_education_center/ulti.dart';

final StudentDatabase _studentService =
    FirestoreStudentDatabase(); // Use Firestore implementation

final CourseFirestoreService _courseFirestoreService = CourseFirestoreService();

class StudentDetailsPage extends StatefulWidget {
  final String name;
  final String email;
  final String studentId;
  final String phone;
  final String section;
  final List<String> courseName;
  final String documentId;

  const StudentDetailsPage({
    Key? key,
    required this.name,
    required this.email,
    required this.studentId,
    required this.phone,
    required this.section,
    required this.courseName,
    required this.documentId,
  }) : super(key: key);

  @override
  State<StudentDetailsPage> createState() => _StudentDetailsPageState();
}

class _StudentDetailsPageState extends State<StudentDetailsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,
        title: const Text(
          "Student Details",
        ),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: const Color.fromARGB(255, 0, 17, 32),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              margin(width: 0, height: 20),
              Center(
                child: Column(
                  children: [
                    const Text(
                      "Star Education Center's",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                    ),
                    margin(width: 0, height: 10),
                    const Text(
                      "Student",
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                    ),
                  ],
                ),
              ),
              margin(width: 0, height: 30),
              Container(
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(20)),
                width: double.infinity,
                height: 220,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            const Text(
                              "Star Education Center",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                            margin(width: 0, height: 20),
                            SvgPicture.asset(
                              'assets/svgs/studentCard.svg',
                              width: 80,
                              height: 90,
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            _about("Name", widget.name),
                            margin(width: 0, height: 40),
                            _about("Email", widget.email),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              margin(width: 0, height: 30),
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Container(
                  height: 70,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [_enrolled(), _newEnroll(context)],
                  ),
                ),
              ),
              if (widget.courseName.isEmpty)
                Center(
                  child: Text(
                    "There is no enrolled courses",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              margin(width: 0, height: 20),
              Expanded(
                child: SingleChildScrollView(
                  child: CourseList(
                    coruseList: widget.courseName,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _about(String title, String about) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 11),
        ),
        Text(
          about,
          style: const TextStyle(fontSize: 15),
        ),
      ],
    );
  }

  Widget _enrolled() {
    return Text(
      "Enrolled Courses",
      style: TextStyle(
          color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 26),
    );
  }

  Widget _newEnroll(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(boxShadow: [
        BoxShadow(color: Colors.blue, blurRadius: 25, spreadRadius: 0.2),
      ]),
      width: 140,
      height: 50,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CoursesAddPage(
                studentId: widget.studentId,
                section: widget.section,
                name: widget.name,
                email: widget.email,
                phone: widget.phone,
                courseName: widget.courseName,
                documentId: widget.documentId,
              ),
            ),
          );
        },
        style: ButtonStyle(
          backgroundColor: const WidgetStatePropertyAll(Colors.blue),
          foregroundColor: const WidgetStatePropertyAll(Colors.white),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
        child: const Text(
          "New Enroll",
          style: TextStyle(fontSize: 17),
        ),
      ),
    );
  }
}

class CourseList extends StatelessWidget {
  final List<String> coruseList;
  const CourseList({super.key, required this.coruseList});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int i = 0; i < coruseList.length; i++)
          Course(
            courseName: coruseList[i],
          ),
      ],
    );
  }
}

class Course extends StatefulWidget {
  final String courseName;
  Course({
    Key? key,
    required this.courseName,
  }) : super(key: key);

  @override
  _CourseState createState() => _CourseState();
}

class _CourseState extends State<Course> {
  String? courseDuration; // To store the duration
  bool isLoading = true; // To track the loading state

  @override
  void initState() {
    super.initState();
    fetchCourseDuration(); // Fetch course duration on widget initialization
  }

  // Method to fetch the course duration from Firebase
  Future<void> fetchCourseDuration() async {
    try {
      DocumentSnapshot courseData =
          await _courseFirestoreService.getCourseByName(widget.courseName);
      setState(() {
        courseDuration = courseData[
            'courseDuration']; // Assuming 'duration' is the field name
        isLoading = false;
      });
    } catch (error) {
      print('Error fetching course duration: $error');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blue),
            borderRadius: BorderRadius.circular(20),
          ),
          width: double.infinity,
          height: 80,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.courseName,
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                isLoading
                    ? CircularProgressIndicator() // Show loading indicator while data is fetching
                    : Text(
                        courseDuration != null
                            ? 'Course Duration - $courseDuration months' // Display the duration if fetched
                            : 'Duration not available',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
              ],
            ),
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }
}
