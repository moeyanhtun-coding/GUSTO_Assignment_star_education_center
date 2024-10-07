// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:star_education_center/pages/courses_add_page.dart';
import 'package:star_education_center/ulti.dart';

class StudentDetailsPage extends StatelessWidget {
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
                Center(child: _newEnroll(context))
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
                    documentId: documentId),
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
          )),
    );
  }
}
