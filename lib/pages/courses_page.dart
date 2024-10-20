import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:star_education_center/services/course_firestore_service.dart';
import 'package:star_education_center/ulti.dart';
import 'package:uuid/uuid.dart';

// Initialize Firebase Firestore instance
final FirebaseFirestore _db = FirebaseFirestore.instance;
// Initialize UUID service for unique IDs
final UuidService _uuidService =
    DefaultUuidService(); // Using the default implementation
// Logger service for logging
final LoggerService _loggerService = LoggerService();
// Uuid instance for generating unique IDs
final Uuid uuid = Uuid();

// Initialize CourseFirestoreService with required services (Firestore, UUID, Logger)
final CourseFirestoreService _coursesService = CourseFirestoreService(
  db: _db,
  uuidService: _uuidService,
  loggerService: _loggerService,
);

// Stateful widget for displaying the Courses Page
class CoursesPage extends StatefulWidget {
  const CoursesPage({super.key});

  @override
  State<CoursesPage> createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  // Main widget for the courses page
  @override
  Widget build(BuildContext context) {
    return _coursesPage();
  }

  // Method to build the layout of the courses page
  Widget _coursesPage() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: const Color.fromARGB(255, 0, 17, 32), // Dark background color
      child: const SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(width: 0, height: 30), // Spacing
            Header1(), // First header widget
            SizedBox(width: 0, height: 20), // Spacing
            Header2(), // Second header widget
            SizedBox(width: 0, height: 30), // Spacing
            SearchBar(), // Search bar widget
            SizedBox(width: 0, height: 20), // Spacing
            CourseList() // List of courses
          ],
        ),
      ),
    );
  }
}

// Stateless widget for displaying the first header
class Header1 extends StatelessWidget {
  const Header1({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        // Title text for the Education Center
        Text(
          "Star Education Center's",
          style: TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
        // Subtitle text for courses
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

// Stateless widget for displaying the second header
class Header2 extends StatelessWidget {
  const Header2({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        // Informational text about students
        Text(
          "Above 4,500 students are learning at Star Education",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        // Call to action for the user
        Text(
          "Center. Why are you waiting for?",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

// Stateless widget for the search bar
class SearchBar extends StatelessWidget {
  const SearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding:
          EdgeInsets.symmetric(horizontal: 25), // Padding around the search bar
      child: TextField(
        style: TextStyle(color: Colors.white), // White text color for the input
        decoration: InputDecoration(
          // Border styling for enabled state
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue), // Blue border
            borderRadius: BorderRadius.all(
              Radius.circular(25),
            ),
          ),
          hintText: "What are you looking for?", // Placeholder text
          hintStyle: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.bold,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: Colors.blue, // Blue search icon
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

// Stateless widget for displaying the list of courses
class CourseList extends StatelessWidget {
  const CourseList({super.key});

  @override
  Widget build(BuildContext context) {
    // StreamBuilder to fetch courses from Firestore in real-time
    return StreamBuilder<QuerySnapshot>(
      stream: _coursesService.getCourses(), // Fetch courses stream
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<DocumentSnapshot> coursesList = snapshot.data!.docs;

          // If no courses are available, show a message
          if (coursesList.isEmpty) {
            return const Center(
              child: Text(
                'No Courses found',
                style: TextStyle(
                  color: Colors.red, // Red text for no courses
                ),
              ),
            );
          }

          // Build a list of course widgets
          return ListView.builder(
            shrinkWrap: true, // Shrink wrap for embedding in scrollable widget
            physics: const NeverScrollableScrollPhysics(),
            itemCount: coursesList.length,
            itemBuilder: (context, index) {
              DocumentSnapshot document = coursesList[index];
              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;

              // Extract course details or default values if missing
              String courseName = data['courseName'] ?? 'No Name';
              double courseFees = data['fees'] ?? 'No Email';
              String courseDuration = data['courseDuration'] ?? 'No Data';

              // Display individual course item
              return Course(
                courseName: courseName,
                fees: courseFees,
                courseDuration: courseDuration,
              );
            },
          );
        } else if (snapshot.hasError) {
          log('Error: ${snapshot.error.toString()}'); // Log errors
          return const Center(
            child: Text(
              'Error loading students',
              style: TextStyle(color: Colors.red), // Error message styling
            ),
          );
        } else {
          // Show loading indicator while fetching data
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

// Stateless widget for displaying individual course details
class Course extends StatelessWidget {
  String courseDuration;
  String courseName;
  double fees;

  // Constructor for the Course widget
  Course({
    super.key,
    required this.courseName,
    required this.fees,
    required this.courseDuration,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Container to style the course card
        Container(
          width: MediaQuery.of(context).size.width,
          margin:
              const EdgeInsets.symmetric(horizontal: 5.0), // Horizontal margins
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.blue, // Blue border
            ),
            borderRadius: const BorderRadius.all(
              Radius.circular(18),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 10), // Padding inside the card
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                margin(width: 0, height: 20), // Spacing
                // Course image with rounded corners
                ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child:
                      Image.asset('assets/courses/JS.png'), // Placeholder image
                ),
                margin(width: 0, height: 10), // Spacing
                // Display course name and duration
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        courseName,
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      'Duration - $courseDuration months',
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
                margin(width: 0, height: 20), // Spacing
                // Display course fees and enroll button
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
                        onPressed: () {}, // Placeholder for enroll action
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(
                              Colors.blue), // Blue background
                          shape: WidgetStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(12), // Rounded corners
                            ),
                          ),
                        ),
                        child: const Text(
                          "Enroll Now",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                margin(width: 0, height: 20), // Spacing
              ],
            ),
          ),
        ),
        margin(width: 0, height: 15), // Spacing between course cards
      ],
    );
  }
}
