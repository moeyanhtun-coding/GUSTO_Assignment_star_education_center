import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:star_education_center/pages/courses_page.dart';
import 'package:star_education_center/pages/home_page.dart';
import 'package:star_education_center/services/course_firestore_service.dart';
import 'package:star_education_center/ulti.dart';

List<String> selectedCoursesList = [];
double totalPrice = 0;

final CourseFirestoreService courses = CourseFirestoreService();

class CoursesAddPage extends StatefulWidget {
  final String name;
  CoursesAddPage({super.key, required this.name});

  @override
  State<CoursesAddPage> createState() => _CoursesAddPageState();
}

class _CoursesAddPageState extends State<CoursesAddPage> {
  void updateTotalPrice(double courseFees, bool isSelected) {
    setState(() {
      if (isSelected) {
        totalPrice += courseFees; // Add course fee to total price
      } else {
        totalPrice -= courseFees; // Subtract course fee from total price
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomContainer(),
      backgroundColor: const Color.fromARGB(255, 0, 17, 32),
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(
          "Courses Enrollement",
          style: TextStyle(),
        ),
      ),
      body: _buildUI(context),
    );
  }

  Widget _buildUI(BuildContext context) {
    return Column(
      children: [
        margin(width: 0, height: 26),
        _header(),
        margin(width: 0, height: 26),
        SearchBar(),
        margin(width: 0, height: 26),
        Expanded(child: SingleChildScrollView(child: _streamCourses(context)))
      ],
    );
  }

  Widget _header() {
    return Center(
      child: Column(
        children: [
          Text(
            "${widget.name} 's ",
            style: TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
              fontSize: 27,
            ),
          ),
          Text(
            "Courses Enrollment Section",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 27,
            ),
          )
        ],
      ),
    );
  }

  Widget _streamCourses(BuildContext context) {
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
                double courseFees = data['fees'] ?? 0.0; // Changed to double

                return CourseEnroll(
                  courseFees: courseFees,
                  courseName: courseName,
                );
              });
        } else if (snapshot.hasError) {
          log('Error: ${snapshot.error.toString()}');
          return const Center(
            child:
                Text('Error loading courses', // Changed 'students' to 'courses'
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

class CourseEnroll extends StatefulWidget {
  final String courseName;
  final double courseFees;
// Add the selectedCoursesList

  CourseEnroll({
    super.key,
    required this.courseFees,
    required this.courseName,
    // Add selectedCoursesList to constructor
  });

  @override
  State<CourseEnroll> createState() => _CourseEnrollState();
}

class _CourseEnrollState extends State<CourseEnroll> {
  // State variable to track if the icon is selected
  bool _isSelected = false;

  void _toggleSelection() {
    setState(() {
      _isSelected = !_isSelected; // Toggle the selection state

      // Add or remove the course name based on selection
      if (_isSelected) {
        selectedCoursesList
            .add(widget.courseName); // Add course name to the list
      } else {
        selectedCoursesList
            .remove(widget.courseName); // Remove course name from the list
      }
    });
    print(selectedCoursesList);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 120,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.blue,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.courseName,
                        style: const TextStyle(
                          color: Colors.blue,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Fees - ${NumberFormat('#,###').format(widget.courseFees)} MMK",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all(Colors.white),
                      backgroundColor: MaterialStateProperty.all(
                        _isSelected
                            ? Colors.green
                            : Colors.blue, // Change color based on selection
                      ),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    onPressed:
                        _toggleSelection, // Call toggle function on press
                    icon: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Icon(
                        _isSelected
                            ? Icons.check
                            : Icons
                                .add_shopping_cart_rounded, // Change icon based on selection
                        size: 25,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20)
        ],
      ),
    );
  }
}

class BottomContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.black, // Background color of the container
        height: 100, // Height of the container
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Text(
                "Total Price  ",
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              ),
              Text(
                "Total Price  ",
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              ),
            ],
          ),
        ));
  }
}
