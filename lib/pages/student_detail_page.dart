// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

import 'package:star_education_center/pages/courses_add_page.dart';
import 'package:star_education_center/services/student_firestore_service.dart';
import 'package:star_education_center/ulti.dart';

final StudentFirestoreService _studentFirestoreService =
    StudentFirestoreService();

class StudentDetailsPage extends StatelessWidget {
  final String name;
  final String email;
  final String studentId;
  final String phone;
  final String section;
  final List<String> courseName;
  final String documentId;

  const StudentDetailsPage({
    super.key,
    required this.name,
    required this.email,
    required this.studentId,
    required this.phone,
    required this.section,
    required this.courseName,
    required this.documentId,
  });

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
          child: SingleChildScrollView(
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
                              _about("Name", name),
                              margin(width: 0, height: 40),
                              _about("Email", email),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                margin(width: 0, height: 30),
                _enrolled(),
                margin(width: 0, height: 30),
                Center(
                  child: _newEnroll(context),
                )
              ],
            ),
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
    return const Column(
      children: [
        Center(
          child: Text(
            "Enrolled Courses",
            style: TextStyle(
                color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 26),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        CourseList(),
        Text(
          "There is no enrolled courses",
          style: TextStyle(color: Colors.red),
        ),
      ],
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
                studentId: studentId,
                section: section,
                name: name,
                email: email,
                phone: phone,
                courseName: courseName,
                documentId: documentId,
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
  const CourseList({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: student.getStudents(),
      builder: (context, snapshot) {
        // Check if there's data from the snapshot
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          log('Error: ${snapshot.error.toString()}');
          return const Center(
            child: Text('Error loading students',
                style: TextStyle(color: Colors.red)),
          );
        }

        // Handle the case where data is available
        if (snapshot.hasData) {
          List<DocumentSnapshot> coursesList = snapshot.data!.docs;

          // Check if coursesList is empty
          if (coursesList.isEmpty) {
            return const Center(
              child: Text(
                'No Courses found',
                style: TextStyle(color: Colors.red),
              ),
            );
          }

          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: coursesList.length,
            itemBuilder: (context, index) {
              DocumentSnapshot document = coursesList[index];
              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;

              // Check if 'courseName' exists and is a list, and if it contains any items
              if (data['courseName'] is List &&
                  (data['courseName'] as List).isNotEmpty) {
                // Get the first course name
                String courseName =
                    (data['courseName'] as List<dynamic>).first.toString();

                return Course(
                  courseName: courseName, // Pass the valid course name
                );
              }

              // Return an empty container if there are no valid course names
              return Container();
            },
          );
        } else {
          return const Center(
            child:
                Text('No Courses found', style: TextStyle(color: Colors.red)),
          );
        }
      },
    );
  }
}

class Course extends StatelessWidget {
  final String courseName; // Now a single string instead of a list

  Course({
    super.key,
    required this.courseName,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.symmetric(horizontal: 5.0),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.blue,
            ),
            borderRadius: const BorderRadius.all(
              Radius.circular(18),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                margin(width: 0, height: 20),
                ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Image.asset('assets/courses/JS.png'),
                ),
                margin(width: 0, height: 10),

                // Display the course name
                Text(
                  courseName,
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                margin(width: 0, height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {},
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              Colors.blue), // Blue background
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        child: const Text(
                          "Enroll Now",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                margin(width: 0, height: 20),
              ],
            ),
          ),
        ),
        margin(width: 0, height: 20),
      ],
    );
  }
}
