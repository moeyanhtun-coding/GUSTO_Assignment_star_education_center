import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:star_education_center/pages/home_page.dart';
import 'package:star_education_center/services/course_firestore_service.dart';
import 'package:star_education_center/ulti.dart';

List<String> selectedCoursesList = [];
List<double> selectedPriceList = [];
double totalPrice = 0.0;

final CourseFirestoreService courses = CourseFirestoreService();

class CoursesAddPage extends StatefulWidget {
  final String name;
  final String email;
  final String phone;

  const CoursesAddPage({
    super.key,
    required this.name,
    required this.email,
    required this.phone,
  });

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
  void initState() {
    setState(() {
      totalPrice = 0;
      selectedCoursesList = [];
      selectedPriceList = [];
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomContainer(
          name: widget.name,
          email: widget.email,
          phone: widget.phone,
          total: totalPrice),
      backgroundColor: const Color.fromARGB(255, 0, 17, 32),
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text(
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
        _serachBar(context),
        margin(width: 0, height: 26),
        Expanded(
          child: SingleChildScrollView(
            child: _streamCourses(context),
          ),
        ),
      ],
    );
  }

  Widget _header() {
    return Center(
      child: Column(
        children: [
          Text(
            "${widget.name} 's ",
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
                  name: name,
                  email: email,
                  phone: phone,
                  totalPrice: totalPrice,
                  onSelectionChanged: (isSelected, courseFees) {
                    updateTotalPrice(courseFees, isSelected);
                  },
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

  Widget _serachBar(BuildContext context) {
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
  final String name;
  final String email;
  final String phone;
  final double totalPrice;
  final Function(bool isSelected, double courseFees) onSelectionChanged;
// Add the selectedCoursesList

  const CourseEnroll({
    super.key,
    required this.courseFees,
    required this.courseName,
    required this.onSelectionChanged,
    required this.name,
    required this.email,
    required this.phone,
    required this.totalPrice,
    // Add selectedCoursesList to constructor
  });

  @override
  State<CourseEnroll> createState() => _CourseEnrollState();
}

class _CourseEnrollState extends State<CourseEnroll> {
  // State variable to track if the icon is selected
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
                      foregroundColor: WidgetStateProperty.all(Colors.white),
                      backgroundColor: WidgetStateProperty.all(
                        _isSelected
                            ? Colors.green
                            : Colors.blue, // Change color based on selection
                      ),
                      shape: WidgetStateProperty.all(
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
          const SizedBox(height: 20)
        ],
      ),
    );
  }
}

class BottomContainer extends StatelessWidget {
  final String name;
  final String email;
  final String phone;
  final double total;

  const BottomContainer({
    super.key,
    required this.name,
    required this.email,
    required this.phone,
    required this.total,
    // Add selectedCoursesList to constructor
  });
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
                  _voucherTotalDetail(totalPrice),
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
            Text("Name - $name"),
            Text("Email - $email"),
            Text("Phone - $phone"),
          ],
        ),
      ],
    );
  }

  Widget _voucherDetail() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (int i = 0; i < selectedCoursesList.length; i++)
                  Column(
                    children: [
                      Text(selectedCoursesList[i]),
                      margin(width: 0, height: 4),
                    ],
                  ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (int i = 0; i < selectedCoursesList.length; i++)
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
          ],
        ),
      ],
    );
  }

  Widget _voucherTotalDetail(double totalPrice) {
    return Container(
      height: 150,
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
        ],
      ),
    );
  }
}
