import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:star_education_center/pages/courses_page.dart';
import 'package:star_education_center/ulti.dart';
import 'package:carousel_slider/carousel_slider.dart';

List<String> text = [
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 10,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.search,
              size: 30,
              color: Colors.white,
            ),
          ),
          margin(width: 20, height: 0),
        ],
        title: const Text(
          "Home Page",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: CoursesPage(),
    );
  }

  Widget _homePage() {
    return Container(
      color: const Color.fromARGB(255, 0, 17, 32),
      child: SingleChildScrollView(
        child: Column(
          children: [
            margin(width: 0, height: 60),
            _headerGroup(),
            margin(width: 0, height: 40),
            _enrollNow(),
            _image(),
            _totalGroup(),
            margin(width: 0, height: 40),
            _header2(),
            margin(width: 0, height: 40),
            _carouselCourses(),
            _certificateSection(),
            _reviewSection(),
            _reviewList()
          ],
        ),
      ),
    );
  }

  Widget _headerGroup() {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _header(
            "Let's Start The Programmer Journey",
            Colors.white,
            FontWeight.bold,
            22,
          ),
          margin(width: 0, height: 10),
          _header(
            "With Star Education Center",
            const Color.fromRGBO(33, 150, 243, 1),
            FontWeight.bold,
            22,
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
      decoration: const BoxDecoration(boxShadow: [
        BoxShadow(
          color: Colors.blue,
          blurRadius: 25,
          spreadRadius: 0.2,
          offset: Offset(0, 0),
        )
      ]),
      width: 180,
      height: 50,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor:
              WidgetStateProperty.all(Colors.blue), // Blue background
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12), // Rounded corners
            ),
          ),
        ),
        onPressed: () {},
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(
              Icons.code,
              color: Colors.white,
              size: 25,
            ), // Icon color white for visibility
            Text(
              "Enroll Now",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ), // Text color white for visibility
            ),
          ],
        ),
      ),
    );
  }

  Widget _image() {
    return SizedBox(
      height: 300,
      width: 300,
      child: SvgPicture.asset(
        'assets/svgs/programming1.svg',
      ),
    );
  }

  Widget _totalGroup() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 0, 17, 32),
          boxShadow: const [
            BoxShadow(
              color: Colors.blue,
              blurRadius: 4,
            )
          ],
          border: Border.all(
            color: Colors.blue,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        height: 100,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: _totalCategory(Icons.person, '+ 2000', 'Students'),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.blue,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.blue,
                    blurRadius: 4,
                  )
                ],
                border: Border.all(
                  color: Colors.blue,
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              width: 1,
              height: 60,
            ),
            Expanded(
              child: _totalCategory(
                  Icons.video_collection_rounded, '+ 10', 'Course'),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.blue,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.blue,
                    blurRadius: 4,
                  )
                ],
                border: Border.all(
                  color: Colors.blue,
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              width: 1,
              height: 60,
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
          size: 30,
          color: Colors.blue,
        ),
        margin(width: 0, height: 6),
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

  Widget _header2() {
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

  Widget _carouselCourses() {
    return CarouselSlider(
      options: CarouselOptions(
        height: 490,
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
                  ],
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }

  Widget _certificateSection() {
    return Column(
      children: [
        margin(width: 0, height: 60),
        const Text(
          "Certificate of Completion",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        margin(width: 0, height: 30),
        ClipRRect(
          borderRadius:
              BorderRadius.circular(15.0), // Set the border radius here
          child: Image.asset(
            'assets/certificate/certificate.jpg',
            width: 380,
          ),
        ),
        margin(width: 0, height: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            for (int i = 0; i < text.length; i++)
              Text(
                text[i],
                style: const TextStyle(
                    fontSize: 15, height: 1.6, color: Colors.white),
              ),
          ],
        ),
        margin(width: 0, height: 40),
        Container(
          decoration: const BoxDecoration(boxShadow: [
            BoxShadow(
              color: Colors.blue,
              blurRadius: 25,
              spreadRadius: 0.2,
              offset: Offset(0, 0),
            )
          ]),
          width: 180,
          height: 50,
          child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor:
                  WidgetStateProperty.all(Colors.blue), // Blue background
              shape: WidgetStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12), // Rounded corners
                ),
              ),
            ),
            onPressed: () {},
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon color white for visibility
                Text(
                  "Start Learning",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ), // Text color white for visibility
                ),
              ],
            ),
          ),
        ),
        margin(width: 0, height: 40),
      ],
    );
  }

  Widget _reviewSection() {
    return const Text(
      "Our Students' Reviews",
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _reviewList() {
    return SizedBox(
      height: 100, // Specify a height for the horizontal list
      child: ListView.builder(
        scrollDirection: Axis.horizontal, // Set scroll direction to horizontal
        itemCount: 10,
        itemBuilder: (context, index) {
          return Container(
            width: 100,
            margin: const EdgeInsets.all(8.0),
            color: Colors.blueAccent,
            child: Center(
              child: Text(
                'Item $index',
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          );
        },
      ),
    );
  }
}
