import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:star_education_center/models/course_model.dart';
import 'package:star_education_center/models/student_model.dart';
import 'package:star_education_center/pages/courses_page.dart';
import 'package:star_education_center/pages/student_page.dart';
import 'package:star_education_center/services/course_firestore_service.dart';
import 'package:star_education_center/services/student_firestore_service.dart';
import 'package:star_education_center/ulti.dart';
import 'package:uuid/uuid.dart';

// Variables for storing user input data
String studentEmail = "";
String studentPhone = "";
String studentName = "";
String studentStartDate = "";

String courseName = "";
double courseFees = 0;
String courseDuration = "";

int currentTabIndex =
    0; // To track the current selected tab in bottom navigation bar

// Firebase services for handling data
final StudentDatabase studentDatabase = FirestoreStudentDatabase();

// Initialize the dependencies
final FirebaseFirestore _db = FirebaseFirestore.instance;
final UuidService _uuidService =
    DefaultUuidService(); // Using the default implementation
final LoggerService _loggerService = LoggerService();

// Create an instance of CourseFirestoreService with the required dependencies
final CourseFirestoreService _coursesService = CourseFirestoreService(
  db: _db,
  uuidService: _uuidService,
  loggerService: _loggerService,
);
const Uuid uuidGenerator = Uuid(); // For generating unique IDs
final Uuid uuid = Uuid();

// Certificate description for UI display
List<String> certificateDescription = [
  "Both Physical & Digital Certificates for All Students",
  "Enrolled at Star Education Center! We offer a wide",
  "range of programming and IT-related courses, with",
  "certificates awarded upon completion of each course.",
  "Whether you’re learning for personal growth or career",
  "advancement, enjoy your learning experience with",
  "us and gain recognition for your achievements."
];

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // List of pages to navigate through the BottomNavigationBar
  final List<Widget> _pages = [
    const HomeContent(), // First page - home content
    const CoursesPage(), // Second page - courses page
    const StudentPage(), // Third page - student page
  ];

  // Controllers for handling text inputs
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController courseNameController = TextEditingController();
  final TextEditingController courseFeesController = TextEditingController();
  final TextEditingController courseDurationController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    // Show a snack bar message when the user logs in
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (currentTabIndex == 0) {
        _showSnackBar('Login Successful.');
      }
    });
  }

  // Shows a SnackBar with a custom message
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        shape: const Border(left: BorderSide(width: 2)),
        backgroundColor: Colors.blue,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    void newStudent() {
      // Builds the form content for adding a new student
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
                  controller: nameController,
                  decoration: InputDecoration(
                    label: Text("Name"),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
                margin(width: 0, height: 20),
                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    label: Text("Email"),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
                margin(width: 0, height: 20),
                TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    label: Text("Phone"),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
                margin(width: 0, height: 20),
                DateOfBirthPicker(),
                margin(width: 0, height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Cancle"),
                      style: ButtonStyle(
                        backgroundColor:
                            WidgetStatePropertyAll(Colors.redAccent),
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
                        studentName = nameController.text;
                        studentPhone = phoneController.text;
                        studentEmail = emailController.text;
                        studentStartDate = _dateController.text;

                        // Ensure uuid is initialized
                        String studentId = uuid.v4(); // Generate unique ID

                        List<String> courseId = [];

                        // Method to create and save a new student in Firebase
                        studentDatabase.registerStudent(NewStudent(
                          studentId,
                          studentName,
                          studentEmail,
                          studentPhone,
                          studentStartDate,
                          courseId,
                        ));

                        nameController.clear();
                        phoneController.clear();
                        emailController.clear();
                        _dateController.clear();

                        Navigator.pop(context);
                      },
                      child: Text(
                        "Create",
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(Colors.blue),
                        shape: WidgetStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      );
    }

    void newCourse() {
      // Shows the dialog to add a new course
      showDialog(
        context: context,
        builder: (context) => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            width: double.infinity,
            height: 350,
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TextField(
                  controller: courseNameController,
                  decoration: InputDecoration(
                    label: Text("Course Name"),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
                margin(width: 0, height: 20),
                TextField(
                  controller: courseFeesController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    label: Text("Fees"),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
                margin(width: 0, height: 20),
                TextField(
                  controller: courseDurationController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    label: Text("Duration"),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
                margin(width: 0, height: 20),
                ElevatedButton(
                  onPressed: () {
                    courseName = courseNameController.text;
                    courseFees = double.parse(courseFeesController.text);
                    courseDuration = courseDurationController.text;

                    String courseId = uuid.v4();

                    // Method to create and save a new course in Firebase
                    _coursesService.createCourse(CourseModel(
                        courseId, courseName, courseFees, courseDuration));

                    courseNameController.clear();
                    courseFeesController.clear();
                    courseDurationController.clear();

                    Navigator.pop(context);
                  },
                  child: Text(
                    "Create",
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(Colors.blue),
                    shape: WidgetStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      // Builds a floating action button based on the current tab
      floatingActionButton: () {
        if (currentTabIndex == 2) {
          // If on Student Page, show FAB to add new student
          return FloatingActionButton(
            onPressed: newStudent,
            foregroundColor: Colors.white,
            backgroundColor: Colors.blue,
            child: const Icon(
              Icons.person_add,
              size: 26,
            ),
          );
        } else if (currentTabIndex == 1) {
          // If on Course Page, show FAB to add new course
          return FloatingActionButton(
            onPressed: newCourse,
            foregroundColor: Colors.white,
            backgroundColor: Colors.blue,
            child: const Icon(
              Icons.video_collection_rounded,
            ),
          );
        } else {
          return _nothing(); // Handle the default case when no valid value is matched
        }
      }(),
      appBar: _buildAppBar(),
      body: _pages[currentTabIndex],
      bottomNavigationBar: SizedBox(
        height: 80,
        child: _buildBottomNavigationBar(),
      ),
    );
  }

  Widget _nothing() {
    return Container();
  }

// Builds the app bar dynamically based on the current tab
  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.black,
      title: _buildTitle(),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.search, size: 30, color: Colors.white),
        ),
      ],
    );
  }

// Returns the appropriate header based on the current page
  Widget _buildTitle() {
    switch (currentTabIndex) {
      case 1:
        return _header("Courses Page");
      // Add more cases here if needed for other indexes
      case 2:
        return _header("Students Page");
      default:
        return _header("Home Page"); // Fallback title if index doesn't match
    }
  }

  Widget _header(String title) {
    return Text(
      title,
      style: TextStyle(color: Colors.white),
    );
  }

  // Builds the BottomNavigationBar and handles tab switching
  BottomNavigationBar _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: currentTabIndex,
      onTap: (index) {
        setState(() {
          currentTabIndex = index;
        });
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(
            icon: Icon(Icons.add_shopping_cart), label: 'Courses'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Student'),
      ],
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.white,
      backgroundColor: Colors.black,
    );
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 0, 17, 32),
      child: const SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 60),
            HeaderGroup(),
            SizedBox(height: 50),
            EnrollNowButton(),
            PageImage(),
            SizedBox(height: 50),
            TotalGroup(),
            SizedBox(height: 40),
            HeaderGroup2(),
            SizedBox(height: 20),
            SizedBox(
              height: 550,
              child: CourseCarousel(),
            ),
            CertificateSection(),
            SizedBox(height: 40),
            StartLearningButton(),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

// HeaderGroup widget: Displays a header with two text lines
class HeaderGroup extends StatelessWidget {
  const HeaderGroup({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Text(
          "Let's Start The Programmer Journey",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22),
        ),
        SizedBox(height: 10),
        Text(
          "With Star Education Center",
          style: TextStyle(
              color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 22),
        ),
      ],
    );
  }
}

// EnrollNowButton widget: Custom button for enrollment action
class EnrollNowButton extends StatelessWidget {
  const EnrollNowButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      height: 50,
      decoration: const BoxDecoration(boxShadow: [
        BoxShadow(color: Colors.blue, blurRadius: 25, spreadRadius: 0.2),
      ]),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: () {},
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(Icons.code, color: Colors.white, size: 25),
            Text(
              "Enroll Now",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// PageImage widget: Displays an image from an SVG asset
class PageImage extends StatelessWidget {
  const PageImage({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 350,
      child: SvgPicture.asset('assets/svgs/programming1.svg',
          width: 300, height: 300),
    );
  }
}

// TotalGroup widget: Displays a row of categories with total values and icons
class TotalGroup extends StatelessWidget {
  const TotalGroup({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 380,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 0, 17, 32),
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [BoxShadow(color: Colors.blue, blurRadius: 4)],
        border: Border.all(color: Colors.blue),
      ),
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const TotalCategory(
            icon: Icons.person,
            total: '+ 2000',
            name: 'Students',
          ),
          Container(
            height: 70,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 0, 17, 32),
              borderRadius: BorderRadius.circular(15),
              boxShadow: const [BoxShadow(color: Colors.blue, blurRadius: 4)],
              border: Border.all(color: Colors.blue),
            ),
          ),
          const TotalCategory(
            icon: Icons.video_collection_rounded,
            total: '+ 10',
            name: 'Courses',
          ),
          Container(
            height: 70,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 0, 17, 32),
              borderRadius: BorderRadius.circular(15),
              boxShadow: const [BoxShadow(color: Colors.blue, blurRadius: 4)],
              border: Border.all(color: Colors.blue),
            ),
          ),
          const TotalCategory(
            icon: Icons.contact_emergency,
            total: '+ 1500',
            name: 'Completed',
          ),
        ],
      ),
    );
  }
}

// TotalCategory widget: Displays an icon, total value, and name for a category
class TotalCategory extends StatelessWidget {
  final IconData icon;
  final String total;
  final String name;

  const TotalCategory({
    super.key,
    required this.icon,
    required this.total,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 30, color: Colors.blue),
        const SizedBox(height: 6),
        Text(
          total,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        Text(
          name,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.normal,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}

// HeaderGroup2 widget: Displays a secondary header with two text lines
class HeaderGroup2 extends StatelessWidget {
  const HeaderGroup2({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Star Education Center's",
          style: TextStyle(
            fontSize: 26,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        margin(width: 0, height: 4),
        const Text(
          "Popular Courses",
          style: TextStyle(
            fontSize: 26,
            color: Colors.blue,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

// CourseCarousel widget: Displays a carousel slider of courses
class CourseCarousel extends StatelessWidget {
  const CourseCarousel({super.key});

  // Function to fetch courses from Firebase Firestore
  Future<List<Map<String, dynamic>>> fetchCourses() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('Courses').get();
      return snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      print("Error fetching courses: $e");
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: fetchCourses(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error loading courses'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No courses available'));
        } else {
          var courseList = snapshot.data!;

          // Return a CarouselSlider to display the courses
          return CarouselSlider(
            options: CarouselOptions(
              height: 540,
              viewportFraction: 1,
              initialPage: 0,
              enableInfiniteScroll: true,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 3),
              autoPlayAnimationDuration: const Duration(milliseconds: 800),
              autoPlayCurve: Curves.fastOutSlowIn,
              enlargeCenterPage: true,
              enlargeFactor: 0.25,
              scrollDirection: Axis.horizontal,
            ),
            items: courseList.map((course) {
              return Builder(
                builder: (BuildContext context) {
                  return CourseList(
                    course: course,
                  );
                },
              );
            }).toList(),
          );
        }
      },
    );
  }
}

// This widget represents the Certificate Section.
class CertificateSection extends StatelessWidget {
  const CertificateSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          "Certificate of Completion",
          style: TextStyle(
              color: Colors.blue, fontSize: 28, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 30),

        // Display a certificate image with rounded corners
        ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Image.asset('assets/certificate/certificate.jpg', width: 380),
        ),
        const SizedBox(height: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: certificateDescription.map((text) {
            return Text(
              text,
              style: const TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            );
          }).toList(),
        ),
      ],
    );
  }
}

// This widget represents a custom button for "Start Learning"8
class StartLearningButton extends StatelessWidget {
  const StartLearningButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      height: 50,
      decoration: const BoxDecoration(boxShadow: [
        BoxShadow(
          color: Colors.blue,
          blurRadius: 25,
          spreadRadius: 0.2,
        ),
      ]),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: () {},
        child: const Text(
          "Start Learning",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}

// TextEditingController to control the date input field
TextEditingController _dateController = TextEditingController();

// This widget represents a date picker for selecting the date of birth
class DateOfBirthPicker extends StatefulWidget {
  @override
  _DateOfBirthPickerState createState() => _DateOfBirthPickerState();
}

class _DateOfBirthPickerState extends State<DateOfBirthPicker> {
  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // Default date when the picker is shown
      firstDate: DateTime(1900), // Earliest date that can be picked
      lastDate: DateTime.now(), // Latest date that can be picked
    );
    if (picked != null) {
      setState(() {
        _dateController.text =
            "${picked.toLocal()}".split(' ')[0]; // Format date
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _dateController,
      decoration: InputDecoration(
        label: Text("Start Date"),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      readOnly: true, // Makes sure the keyboard doesn't appear
      onTap: () => _selectDate(context), // Opens the date picker on tap
    );
  }
}

// This widget represents a list of courses
class CourseList extends StatelessWidget {
  final Map<String, dynamic> course;

  const CourseList({Key? key, required this.course}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Course(
        courseName: course['courseName'],
        fees: course['fees'],
        courseDuration: course['courseDuration']);
  }
}

// This widget represents the details of a course
class Course extends StatelessWidget {
  String courseDuration;
  String courseName;
  double fees;
  Course(
      {super.key,
      required this.courseName,
      required this.fees,
      required this.courseDuration});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Container for course details with styling and padding
        Container(
          height: 490,
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
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Text(
                      'Duration - $courseDuration months',
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 15,
                          fontWeight: FontWeight.normal),
                    ),
                  ],
                ),
                margin(width: 0, height: 20),
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
              ],
            ),
          ),
        ),
      ],
    );
  }
}
