import 'package:flutter/material.dart';
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
      bottomNavigationBar: _navigationBar(),
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            _headerGroup(),
            _enrollNow(),
            _totalGroup(),
            _header2(),
            _carouselCourses(),
            _certificateSection(),
            _reviewSection(),
            _reviewList()
          ],
        ),
      ),
    );
  }

  Widget _navigationBar() {
    return NavigationBar(destinations: [
      Container(
        color: Colors.blueAccent,
      ),
      Container(
        color: Colors.redAccent,
      ),
      Container(
        color: Colors.greenAccent,
      ),
      Container(
        color: Colors.pinkAccent,
      ),
    ]);
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Star Education Center's",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          "Popular Courses",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _carouselCourses() {
    return CarouselSlider(
      options: CarouselOptions(
        height: 240,
        aspectRatio: 16 / 9,
        viewportFraction: 0.8,
        initialPage: 0,
        enableInfiniteScroll: true,
        reverse: false,
        autoPlay: true,
        autoPlayInterval: Duration(seconds: 3),
        autoPlayAnimationDuration: Duration(milliseconds: 800),
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
                margin: EdgeInsets.symmetric(horizontal: 5.0),
                decoration: BoxDecoration(color: Colors.amber),
                child: Text(
                  'text $i',
                  style: TextStyle(fontSize: 16.0),
                ));
          },
        );
      }).toList(),
    );
  }

  Widget _certificateSection() {
    return Container(
      child: Column(
        children: [
          Text(
            "Certificate of Completion",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Container(
            width: 300,
            height: 400,
            color: Colors.amberAccent,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              for (int i = 0; i < text.length; i++)
                Text(
                  text[i],
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.6,
                  ),
                ),
            ],
          ),
          ElevatedButton(
            onPressed: () {},
            child: Text("Start Learning"),
          )
        ],
      ),
    );
  }

  Widget _reviewSection() {
    return Text(
      "Our Students' Reviews",
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _reviewList() {
    return Container(
      height: 100, // Specify a height for the horizontal list
      child: ListView.builder(
        scrollDirection: Axis.horizontal, // Set scroll direction to horizontal
        itemCount: 10,
        itemBuilder: (context, index) {
          return Container(
            width: 100,
            margin: EdgeInsets.all(8.0),
            color: Colors.blueAccent,
            child: Center(
              child: Text(
                'Item $index',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          );
        },
      ),
    );
  }
}
