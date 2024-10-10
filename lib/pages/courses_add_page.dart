import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:intl/intl.dart';
import 'package:star_education_center/models/student_model.dart';
import 'package:star_education_center/pages/home_page.dart';
import 'package:star_education_center/pages/student_page.dart';
import 'package:star_education_center/services/course_firestore_service.dart';
import 'package:star_education_center/services/student_firestore_service.dart';
import 'package:star_education_center/ulti.dart';

List<String> selectedCoursesList = [];
List<String> existingCourse = [];
List<double> selectedPriceList = [];
double discount = 0;
double totalPrice = 0.0;
final StudentDatabase _studentService = FirestoreStudentDatabase();

class CoursesAddPage extends StatefulWidget {
  final String section;
  final String studentId;
  final String name;
  final String email;
  final String phone;
  final List<String> courseName;
  final String documentId;

  const CoursesAddPage({
    Key? key,
    required this.name,
    required this.email,
    required this.phone,
    required this.courseName,
    required this.documentId,
    required this.section,
    required this.studentId,
  }) : super(key: key);

  @override
  State<CoursesAddPage> createState() => _CoursesAddPageState();
}

class _CoursesAddPageState extends State<CoursesAddPage> {
  // Use Firestore implementation
  final CourseFirestoreService _coursesService = CourseFirestoreService();

  @override
  void initState() {
    setState(() {
      totalPrice = 0;
      selectedCoursesList = [];
      selectedPriceList = [];
      _fetchExistingCourses();
      print(existingCourse);

      log("${widget.email} ${widget.documentId} ${widget.name} ${widget.phone}");
    });
    super.initState();
  }

  void _fetchExistingCourses() async {
    try {
      DocumentSnapshot<Object?> querySnapshot =
          await _studentService.getStudentById(widget.studentId);

      List<dynamic> courseNameList = querySnapshot.get('courseName') ?? [];
      setState(() {
        existingCourse = List<String>.from(courseNameList);
      });
    } catch (e) {
      log('Error fetching existing courses: $e');
    }
  }

  void updateTotalPrice(double courseFees, bool isSelected) {
    setState(() {
      totalPrice += isSelected ? courseFees : -courseFees;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text("Courses Enrollment"),
      ),
      bottomNavigationBar: BottomContainer(
        section: widget.section,
        studentId: widget.studentId,
        name: widget.name,
        email: widget.email,
        phone: widget.phone,
        total: totalPrice,
        courseName: selectedCoursesList,
        documentId: widget.documentId,
      ),
      backgroundColor: const Color.fromARGB(255, 0, 17, 32),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Column(
      children: [
        margin(width: 0, height: 20),
        _header(),
        margin(width: 0, height: 20),
        _searchBar(),
        margin(width: 0, height: 20),
        Expanded(child: _streamCourses(context)),
      ],
    );
  }

  Widget _header() {
    return Center(
      child: Column(
        children: [
          Text(
            "${widget.name}'s ",
            style: const TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
              fontSize: 27,
            ),
          ),
          const Text(
            "Courses Enrollment Section",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 27,
            ),
          ),
        ],
      ),
    );
  }

  Widget _searchBar() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 25),
      child: TextField(
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue),
            borderRadius: BorderRadius.all(Radius.circular(25)),
          ),
          hintText: "What are you looking for?",
          hintStyle: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.bold,
          ),
          prefixIcon: Icon(Icons.search, color: Colors.blue),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(25)),
          ),
        ),
      ),
    );
  }

  Widget _streamCourses(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _coursesService.getCourses(),
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
            itemCount: coursesList.length,
            itemBuilder: (context, index) {
              DocumentSnapshot document = coursesList[index];
              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;

              String courseName = data['courseName'] ?? 'No Name';
              double courseFees = data['fees'] ?? 0.0;

              return CourseEnroll(
                courseFees: courseFees,
                courseName: courseName,
                onSelectionChanged: (isSelected, courseFees) {
                  updateTotalPrice(courseFees, isSelected);
                },
              );
            },
          );
        } else if (snapshot.hasError) {
          log('Error: ${snapshot.error.toString()}');
          return const Center(
            child: Text('Error loading courses',
                style: TextStyle(color: Colors.red)),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

class CourseEnroll extends StatefulWidget {
  final String courseName;
  final double courseFees;
  final Function(bool isSelected, double courseFees) onSelectionChanged;

  const CourseEnroll({
    Key? key,
    required this.courseFees,
    required this.courseName,
    required this.onSelectionChanged,
  }) : super(key: key);

  @override
  State<CourseEnroll> createState() => _CourseEnrollState();
}

class _CourseEnrollState extends State<CourseEnroll> {
  bool _isSelected = false;

  void _toggleSelection() {
    setState(
      () {
        _isSelected = !_isSelected;

        // Notify parent widget about the selection change
        widget.onSelectionChanged(_isSelected, widget.courseFees);

        // Add or remove the course name based on selection
        if (_isSelected) {
          selectedCoursesList.add(widget.courseName);
          selectedPriceList.add(widget.courseFees);
        } else {
          selectedCoursesList.remove(widget.courseName);
          selectedPriceList.remove(widget.courseFees);
        }
      },
    );
    print(selectedCoursesList);
    print(selectedPriceList);
    print(totalPrice);
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
              border: Border.all(color: Colors.blue),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    onPressed: _toggleSelection,
                    icon: Icon(
                      _isSelected
                          ? Icons.check
                          : Icons.add_shopping_cart_rounded,
                      color: Colors.white,
                    ),
                    color: _isSelected ? Colors.green : Colors.blue,
                  ),
                ],
              ),
            ),
          ),
          margin(width: 0, height: 15)
        ],
      ),
    );
  }
}

class BottomContainer extends StatefulWidget {
  final String studentId;
  final String name;
  final String email;
  final String phone;
  final double total;
  final String section;
  final List<String> courseName;
  final String documentId;

  const BottomContainer({
    super.key,
    required this.name,
    required this.email,
    required this.phone,
    required this.total,
    required this.courseName,
    required this.documentId,
    required this.studentId,
    required this.section,
    // Add selectedCoursesList to constructor
  });

  @override
  State<BottomContainer> createState() => _BottomContainerState();
}

class _BottomContainerState extends State<BottomContainer> {
  double calculateDiscount(
    List<String> selectedCoursesList,
    List<String> existingCourse,
    double totalPrice,
  ) {
    double discount = 0;

    if (selectedCoursesList.isNotEmpty && existingCourse.isEmpty) {
      // New student - full fee
      discount = 0;
    } else if (existingCourse.isNotEmpty) {
      // Returning student
      if (existingCourse.length == 1) {
        discount = (totalPrice * 5) / 100; // 5% discount for 1 course
      } else if (existingCourse.length == 2) {
        discount = (totalPrice * 10) / 100; // 10% discount for 2 courses
      } else if (existingCourse.length >= 3) {
        discount =
            (totalPrice * 20) / 100; // 20% discount for 3 or more courses
      } else {
        discount = 0; // No discount if none of the above conditions are met
      }
    } else {
      discount = 0; // No discount for new students
    }

    return discount;
  }

  void _totalCheckOut(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SizedBox(
              height: 500,
              width: 400,
              child: Column(
                children: [
                  margin(width: 0, height: 20),
                  _headerSection(),
                  _detail(),
                  margin(width: 0, height: 10),
                  Container(
                    width: double.infinity,
                    height: 1,
                    color: Colors.black,
                  ),
                  margin(width: 0, height: 10),
                  Expanded(child: _voucherDetail()),
                  _voucherTotalDetail(totalPrice, widget.courseName,
                      widget.documentId, widget.studentId, widget.section),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black, // Background color of the container
      height: 130, // Height of the container
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Total Price   ",
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Text(
                  '${NumberFormat('#,###').format(totalPrice)} MMK', // Two decimal places
                  style: const TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Colors.blue),
                    foregroundColor: WidgetStatePropertyAll(Colors.white),
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      discount = calculateDiscount(
                          selectedCoursesList, existingCourse, totalPrice);
                      print('Discount: $discount');
                    });

                    _totalCheckOut(context);
                  },
                  child: const Text(
                    "Check Out",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _headerSection() {
    return Column(
      children: [
        const Text(
          "Star Eduction Center",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        margin(width: 0, height: 15),
        Container(
          width: double.infinity,
          height: 1,
          color: Colors.black,
        ),
        margin(width: 0, height: 10),
      ],
    );
  }

  Widget _detail() {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Name - ${widget.name}"),
            Text("Email - ${widget.email}"),
            Text("Phone - ${widget.phone}"),
          ],
        ),
      ],
    );
  }

  Widget _voucherDetail() {
    return Column(
      children: [
        for (int i = 0; i < selectedCoursesList.length; i++)
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          Text(selectedCoursesList[i]),
                          margin(width: 0, height: 4),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        children: [
                          Text(
                            '${NumberFormat('#,###').format(selectedPriceList[i])} MMK',
                          ),
                          margin(width: 0, height: 4),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _voucherTotalDetail(
    double totalPrice,
    List<String> courseName,
    String documentId,
    String studentId,
    String section,
  ) {
    return Container(
      height: 180,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 1,
            color: Colors.black,
          ),
          margin(width: 0, height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Subtotal"),
              Text(
                '${NumberFormat('#,###').format(totalPrice)} MMK',
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Discount"),
              if (existingCourse.length == 1)
                Text("5 %")
              else if (existingCourse.length == 2)
                Text("10 %")
              else if (existingCourse.length >= 3)
                Text("20 %")
              else
                Text("0 %")
            ],
          ),
          margin(width: 0, height: 10),
          Container(
            width: double.infinity,
            height: 1,
            color: Colors.black,
          ),
          margin(width: 0, height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Total"),
              Text(
                '${NumberFormat('#,###').format(totalPrice - discount)} MMK',
              ),
            ],
          ),
          margin(width: 0, height: 20),
          Container(
            width: double.infinity,
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(Colors.blue),
                foregroundColor: WidgetStatePropertyAll(Colors.white),
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              onPressed: () {
                setState(() {
                  existingCourse.addAll(selectedCoursesList);
                });
                _studentService.updateStudent(
                    documentId,
                    StudentModel(studentId, widget.name, widget.email,
                        widget.phone, section, existingCourse));

                Navigator.pop(context);
                Get.toNamed("/home");
              },
              child: const Text(
                "Confrim",
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
