import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:star_education_center/pages/home_page.dart';

class StudentPage extends StatefulWidget {
  const StudentPage({super.key});

  @override
  State<StudentPage> createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {
  String searchString = ''; // To store search query

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: const Color.fromARGB(255, 0, 17, 32),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 30),
            const Header(),
            const SizedBox(height: 10),
            SearchBar(
              onChanged: (value) {
                setState(() {
                  searchString = value; // Update search query
                });
              },
            ),
            const SizedBox(height: 20),
            StudentList(
              searchString: searchString, // Pass search query to StudentList
            ),
          ],
        ),
      ),
    );
  }
}

class SearchBar extends StatelessWidget {
  final Function(String) onChanged;
  const SearchBar({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: TextField(
        onChanged: onChanged, // Triggered on text change
        style: const TextStyle(color: Colors.white),
        decoration: const InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue),
            borderRadius: BorderRadius.all(Radius.circular(25)),
          ),
          hintText: "Search Students...",
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
  final String searchString;

  const StudentList({super.key, required this.searchString});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: searchString.isNotEmpty
          ? firestoreService.searchStudentsByName(searchString)
          : firestoreService.getStudents(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<DocumentSnapshot> studentLists = snapshot.data!.docs;

          if (studentLists.isEmpty) {
            return const Center(
              child: Text(
                'No students found',
                style: TextStyle(color: Colors.red),
              ),
            );
          }

          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: studentLists.length,
            itemBuilder: (context, index) {
              DocumentSnapshot document = studentLists[index];
              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;

              String studentName = data['name'] ?? 'No Name';
              String studentEmail = data['email'] ?? 'No Email';
              String documentId = document.id;

              return Student(
                documentId: documentId,
                name: studentName,
                email: studentEmail,
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

class Student extends StatelessWidget {
  final String name;
  final String email;
  final String documentId;

  const Student({
    super.key,
    required this.name,
    required this.email,
    required this.documentId,
  });

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
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    email,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => Dialog(
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Container(
                              width: 400,
                              height: 120,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "Are you sure want to Delete ? ",
                                        style: TextStyle(fontSize: 19),
                                      ),
                                      Icon(
                                        Icons.dangerous,
                                        color: Colors.redAccent,
                                        size: 30,
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      ElevatedButton(
                                        style: ButtonStyle(
                                          shape: WidgetStateProperty.all(
                                            RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(
                                                  10,
                                                ),
                                              ),
                                            ),
                                          ),
                                          backgroundColor:
                                              WidgetStateProperty.all(
                                            Colors.blue,
                                          ),
                                        ),
                                        onPressed: () {
                                          firestoreService
                                              .deleteStudent(documentId);

                                          Navigator.pop(context);
                                        },
                                        child: const SizedBox(
                                          width: 50,
                                          child: Center(
                                            child: Text(
                                              "Yes",
                                              style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      ElevatedButton(
                                        style: ButtonStyle(
                                          shape: WidgetStateProperty.all(
                                            RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(
                                                  10,
                                                ),
                                              ),
                                            ),
                                          ),
                                          backgroundColor:
                                              WidgetStateProperty.all(
                                            Colors.redAccent,
                                          ),
                                        ),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Container(
                                          width: 50,
                                          child: Center(
                                            child: Text(
                                              "No",
                                              style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.delete,
                      size: 30,
                      color: Colors.redAccent,
                    ),
                  ),
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.account_circle_rounded,
                        color: Colors.blue,
                        size: 30,
                      ))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
