import 'package:flutter/material.dart';
import 'package:star_education_center/ulti.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 10,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.search,
              size: 30,
            ),
          ),
          margin(width: 20, height: 0),
        ],
        title: Text("Home Page"),
      ),
      body: Column(
        children: [
          _headerGroup(),
          _enrollNow(),
          _totalGroup(),
          _header2(),
        ],
      ),
    );
  }

  Widget _headerGroup() {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _header(
            "Let's Start The Programmer Journey",
            Colors.black,
            FontWeight.bold,
            18,
          ),
          _header(
            "With Star Education Center",
            Colors.black,
            FontWeight.bold,
            18,
          ),
        ],
      ),
    );
  }

  Widget _header(
    String text,
    Color color,
    FontWeight weight,
    double size,
  ) {
    return Text(
      text,
      style: TextStyle(fontWeight: weight, color: color, fontSize: size),
    );
  }

  Widget _enrollNow() {
    return Container(
      width: 150,
      child: ElevatedButton(
        style: ButtonStyle(),
        onPressed: () {},
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(Icons.code),
            Text("Enroll Now"),
          ],
        ),
      ),
    );
  }

  Widget _totalGroup() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: BorderRadius.circular(15),
        ),
        height: 120,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: _totalCategory(Icons.person, '+ 2000', 'Students'),
            ),
            Container(
              width: 1,
              height: 60,
              color: Colors.black,
            ),
            Expanded(
              child: _totalCategory(
                  Icons.video_collection_rounded, '+ 10', 'Course'),
            ),
            Container(
              width: 1,
              height: 60,
              color: Colors.black,
            ),
            Expanded(
              child: _totalCategory(
                  Icons.contact_emergency, '+ 1500', 'Completed'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _totalCategory(IconData icon, String total, String name) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 39,
        ),
        Text(
          total,
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        Text(
          name,
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.normal,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _header2() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Star Education Center's",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(" Courses"),
      ],
    );
  }
}
