import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:star_education_center/models/student_model.dart';
import 'package:star_education_center/pages/student_detail_page.dart';
import 'package:star_education_center/services/student_firestore_service.dart';
import 'package:star_education_center/ulti.dart';

final StudentDatabase _studentService = FirestoreStudentDatabase();

class StudentPage extends StatefulWidget {
  const StudentPage({super.key});

  @override
  State<StudentPage> createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _dateController = TextEditingController();

  void updateStudent(String documentId, String studentId) {
    // Clear the controllers before opening the dialog
    _nameController.clear();
    _emailController.clear();
    _phoneController.clear();
    _dateController.clear();

    // Open dialog
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          width: double.infinity,
          height: 400,
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  label: const Text("Name"),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              const SizedBox(height: 20), // Updated margin method
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  label: const Text("Email"),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  label: const Text("Phone"),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _dateController,
                readOnly: true,
                decoration: InputDecoration(
                  label: const Text("Start Date"),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900), // Limit the first date
                    lastDate: DateTime.now(),
                  );

                  if (pickedDate != null) {
                    String formattedDate =
                        "${pickedDate.toLocal()}".split(' ')[0]; // Format date
                    _dateController.text =
                        formattedDate; // Set the date in the controller
                  }
                },
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Cancle"),
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(Colors.redAccent),
                      foregroundColor: WidgetStateProperty.all(Colors.white),
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  margin(height: 0, width: 10),
                  ElevatedButton(
                    onPressed: () {
                      String name = _nameController.text;
                      String email = _emailController.text;
                      String phone = _phoneController.text;
                      String date = _dateController.text;
                      List<String> courseName = [];

                      // Update the student details
                      _studentService.updateStudent(
                        documentId, // Pass the documentId of the student
                        StudentModel(studentId, name, email, phone, date,
                            courseName), // Pass the updated StudentModel
                      );

                      // Clear the text fields
                      _nameController.clear();
                      _phoneController.clear();
                      _emailController.clear();
                      _dateController.clear();

                      Navigator.pop(context); // Close the dialog
                    },
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Colors.blue),
                      shape: WidgetStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    child: const Text(
                      "Update",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

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
              searchString: searchString,
              updateStudent:
                  updateStudent, // Pass the updateStudent function here
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
  final Function(String, String)
      updateStudent; // Define the updateStudent function type

  const StudentList(
      {super.key, required this.searchString, required this.updateStudent});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: searchString.isNotEmpty
          ? _studentService.searchStudentsByName(searchString)
          : _studentService.getStudents(),
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
              String studentId = data['sId'];
              String studentPhone = data['phone'] ?? 'No Phone';
              String section = data['section'] ?? 'No Phone';
              List<String> courseList =
                  List<String>.from(data['courseName'] ?? []);

              return Student(
                studentId: studentId,
                documentId: documentId,
                name: studentName,
                email: studentEmail,
                updateStudent: updateStudent,
                phone: studentPhone,
                section: section,
                courseName: courseList, // Pass the function to the Student
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
  final String studentId;
  final String section;
  final List<String> courseName;
  final Function(String, String)
      updateStudent; // Correctly define the updateStudent function type
  final String phone;

  const Student({
    super.key,
    required this.name,
    required this.email,
    required this.documentId,
    required this.studentId,
    required this.updateStudent,
    required this.phone,
    required this.section,
    required this.courseName,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StudentDetailsPage(
                name: name,
                email: email,
                studentId: studentId,
                phone: phone,
                section: section,
                courseName: courseName,
                documentId: documentId),
          ),
        );
        log(name);
        log(courseName.toString());
      },
      child: Padding(
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
                              child: SizedBox(
                                width: 400,
                                height: 120,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Row(
                                      children: [
                                        Text(
                                          "Are you sure want to Delete?",
                                          style: TextStyle(fontSize: 19),
                                        ),
                                        Icon(
                                          Icons.dangerous,
                                          color: Colors.redAccent,
                                          size: 30,
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        ElevatedButton(
                                          style: ButtonStyle(
                                            shape: WidgetStateProperty.all(
                                              const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(10),
                                                ),
                                              ),
                                            ),
                                            backgroundColor:
                                                WidgetStateProperty.all(
                                              Colors.blue,
                                            ),
                                          ),
                                          onPressed: () {
                                            _studentService
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
                                              const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(10),
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
                                          child: const SizedBox(
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
                      onPressed: () {
                        // Call updateStudent when edit button is pressed
                        updateStudent(documentId, studentId);
                      },
                      icon: const Icon(
                        Icons.edit,
                        color: Colors.blue,
                        size: 30,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
