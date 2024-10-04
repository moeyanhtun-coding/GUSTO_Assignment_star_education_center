import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:star_education_center/pages/home_page.dart';

class StudentPage extends StatelessWidget {
  const StudentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: const Color.fromARGB(255, 0, 17, 32),
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            Header(),
            StudentList(),
          ],
        ),
      ),
    );
  }
}

class Header extends StatelessWidget {
  const Header({super.key});

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
          "Students",
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

class StudentList extends StatelessWidget {
  const StudentList({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: firestoreService.getStudents(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          // Specify the type of the list explicitly
          List<DocumentSnapshot> studentLists = snapshot.data!.docs;

          return ListView.builder(
            itemCount: studentLists.length,
            itemBuilder: (context, index) {
              // Get individual doc
              DocumentSnapshot document = studentLists[index];
              String docID = document.id;

              // Get student data from each document
              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;

              // Fix the field name, assuming it's `name`
              String studentName =
                  data['name'] ?? "No Name"; // Use a default value if null

              // Display as list
              return ListTile(
                title: Text(studentName),
              );
            },
          );
        } else {
          return const Text(
            "There are no Students",
            style: TextStyle(color: Colors.blue),
          );
        }
      },
    );
  }
}

class Student extends StatelessWidget {
  const Student({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blue),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            // Add content here like student name or details
            Text(
              'Student Details',
              style: TextStyle(color: Colors.blue),
            ),
          ],
        ),
      ),
    );
  }
}
