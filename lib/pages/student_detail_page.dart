import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:star_education_center/ulti.dart';

class StudentDetailsPage extends StatelessWidget {
  final String name;
  final String email;
  final String studentId;
  final String phone;
  final String section;

  const StudentDetailsPage({
    Key? key,
    required this.name,
    required this.email,
    required this.studentId,
    required this.phone,
    required this.section,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,
        title: Text(
          "Student Details",
        ),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: Color.fromARGB(255, 0, 17, 32),
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
                      Text(
                        "Star Education Center's",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
                      ),
                      margin(width: 0, height: 10),
                      Text(
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
                              Text(
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
                margin(width: 0, height: 60),
                Center(child: _newEnroll())
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
          style: TextStyle(fontSize: 11),
        ),
        Text(
          about,
          style: TextStyle(fontSize: 15),
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

  Widget _newEnroll() {
    return Container(
      decoration: const BoxDecoration(boxShadow: [
        BoxShadow(color: Colors.blue, blurRadius: 25, spreadRadius: 0.2),
      ]),
      width: 140,
      height: 50,
      child: ElevatedButton(
          onPressed: () {},
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(Colors.blue),
            foregroundColor: WidgetStatePropertyAll(Colors.white),
            shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
          child: Text(
            "New Enroll",
            style: TextStyle(fontSize: 17),
          )),
    );
  }
}
