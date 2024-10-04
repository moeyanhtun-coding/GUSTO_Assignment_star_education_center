import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/route_manager.dart';
import 'package:star_education_center/models/student_model.dart';
import 'package:star_education_center/pages/courses_page.dart';
import 'package:star_education_center/pages/student_page.dart';
import 'package:star_education_center/services/firestore_service.dart';
import 'package:star_education_center/ulti.dart';
import 'package:uuid/uuid.dart';

String email = "";
String phone = "";
String name = "";
String date = "";
int _currentIndex = 0;

final FirestoreService firestoreService = FirestoreService();
final Uuid uuid = Uuid();

List<String> certificateText = [
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
  final List<Widget> _pages = [
    const HomeContent(),
    const CoursesPage(),
    const StudentPage(),
  ];

  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    void newStudent() {
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
                    label: Text("Name"),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
                margin(width: 0, height: 20),
                TextField(
                  controller: _emailController,
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
                  controller: _phoneController,
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
                ElevatedButton(
                  onPressed: () {
                    name = _nameController.text;
                    phone = _phoneController.text;
                    email = _emailController.text;
                    date = _dateController.text;
                    String studentId = uuid.v4();
                    firestoreService.registerStudent(
                        NewStudent(studentId, name, email, phone, date));

                    _nameController.clear();
                    _phoneController.clear();
                    _emailController.clear();
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
                )
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      floatingActionButton: _currentIndex == 2
          ? FloatingActionButton(
              onPressed: newStudent,
              foregroundColor: Colors.white,
              backgroundColor: Colors.blue,
              child: Icon(
                Icons.person_add,
              ),
            )
          : _nothing(),
      appBar: _buildAppBar(),
      body: _pages[_currentIndex],
      bottomNavigationBar: SizedBox(
        height: 80,
        child: _buildBottomNavigationBar(),
      ),
    );
  }

  Widget _nothing() {
    return Container();
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.black,
      title: const Text(
        "Home Page",
        style: TextStyle(color: Colors.white),
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.search, size: 30, color: Colors.white),
        ),
      ],
    );
  }

  BottomNavigationBar _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: (index) {
        setState(() {
          _currentIndex = index;
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
            SizedBox(height: 40),
            CourseCarousel(),
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

class TotalCategory extends StatelessWidget {
  final IconData icon;
  final String total;
  final String name;

  const TotalCategory(
      {super.key, required this.icon, required this.total, required this.name});

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
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
        ),
        Text(
          name,
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.normal, fontSize: 10),
        ),
      ],
    );
  }
}

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

class CourseCarousel extends StatelessWidget {
  const CourseCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        height: 460,
        aspectRatio: 16 / 10,
        viewportFraction: 0.87,
        initialPage: 0,
        enableInfiniteScroll: true,
        reverse: false,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 3),
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
        autoPlayCurve: Curves.fastOutSlowIn,
        enlargeCenterPage: true,
        enlargeFactor: 0.25,
        scrollDirection: Axis.horizontal,
      ),
      items: [1, 2, 3, 4, 5].map((i) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.symmetric(horizontal: 5.0),
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.blue,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(18))),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
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
                    margin(width: 0, height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
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
                  ],
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }
}

class CertificateSection extends StatelessWidget {
  const CertificateSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 60),
        const Text(
          "Certificate of Completion",
          style: TextStyle(
              color: Colors.blue, fontSize: 28, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 30),
        ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Image.asset('assets/certificate/certificate.jpg', width: 380),
        ),
        const SizedBox(height: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: certificateText.map((text) {
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

class StartLearningButton extends StatelessWidget {
  const StartLearningButton({super.key});

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

TextEditingController _dateController = TextEditingController();

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
