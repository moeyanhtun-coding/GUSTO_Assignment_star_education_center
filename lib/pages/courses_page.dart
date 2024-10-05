import 'package:flutter/material.dart';
import 'package:star_education_center/ulti.dart';

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
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          for (int i = 0; i < 10; i++) const Course(),
        ],
      ),
    );
  }
}

class Course extends StatelessWidget {
  const Course({super.key});

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
                const Text(
                  "Programming Basic With JavaScript",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 19,
                      fontWeight: FontWeight.bold),
                ),
                margin(width: 0, height: 6),
                Row(
                  children: [
                    const Text(
                      "Chapters - 6",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    margin(width: 30, height: 0),
                    const Text(
                      "Lessons - 20",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                margin(width: 0, height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Fees - 5000,000 MMK",
                        style: TextStyle(
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
