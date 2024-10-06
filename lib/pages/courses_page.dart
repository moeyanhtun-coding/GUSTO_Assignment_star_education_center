import 'dart:developer';
import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:star_education_center/pages/home_page.dart';
import 'package:star_education_center/services/course_firestore_service.dart';
import 'package:star_education_center/ulti.dart';

final CourseFirestoreService courses = CourseFirestoreService();

class CoursesPage extends StatefulWidget {
  const CoursesPage({super.key});

  @override
  State<CoursesPage> createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  @override
  Widget build(BuildContext context) {
    return _coursesPage();
  }

  Widget _coursesPage() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: const Color.fromARGB(255, 0, 17, 32),
      child: const SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(width: 0, height: 30),
            Header1(),
            SizedBox(width: 0, height: 20),
            Header2(),
            SizedBox(width: 0, height: 30),
            SearchBar(),
            SizedBox(width: 0, height: 20),
            CourseList()
          ],
        ),
      ),
    );
  }
}

class Header1 extends StatelessWidget {
  const Header1({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Text(
          "Star Education Center's",
          style: TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
        Text(
          "Courses",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
      ],
    );
  }
}

class Header2 extends StatelessWidget {
  const Header2({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Text(
          "Above 4,500 students are learning at Star Eductaion",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        Text(
          "Center. Why are you waiting for ?",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

class SearchBar extends StatelessWidget {
  const SearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 25),
      child: TextField(
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: Colors.blue), // Change to your desired color
            borderRadius: BorderRadius.all(
              Radius.circular(25),
            ),
          ),
          hintText: "What are you looking for ?",
          hintStyle: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.bold,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: Colors.blue,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(25),
            ),
          ),
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
      stream: courses.getCourses(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<DocumentSnapshot> coursesList = snapshot.data!.docs;

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

              String courseName = data['courseName'] ?? 'No Name';
              double courseFees = data['fees'] ?? 'No Email';

              return Course(
                courseName: courseName,
                fees: courseFees,
              );
            },
          );
        } else if (snapshot.hasError) {
          log('Error: ${snapshot.error.toString()}');
          return const Center(
            child: Text('Error loading students',
                style: TextStyle(color: Colors.red)),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

class Course extends StatelessWidget {
  String courseName;
  double fees;
  Course({super.key, required this.courseName, required this.fees});

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
                Text(
                  courseName,
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 19,
                      fontWeight: FontWeight.bold),
                ),
                margin(width: 0, height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Fees - ${NumberFormat('#,###').format(fees)} MMK",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(
                              Colors.blue), // Blue background
                          shape: WidgetStateProperty.all(
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
        margin(width: 0, height: 20)
      ],
    );
  }
}
