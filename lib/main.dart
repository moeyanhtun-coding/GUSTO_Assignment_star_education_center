import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:star_education_center/pages/home_page.dart';
import 'package:star_education_center/pages/login_page.dart';
import 'package:star_education_center/pages/register_page.dart';

void main() {
  runApp(const MyApp());
}

final routes = [
  GetPage(name: '/login', page: () => LoginPage()),
  GetPage(name: '/register', page: () => RegisterPage()),
  GetPage(name: '/home', page: () => HomePage())
];

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      getPages: routes,
      home: LoginPage(),
    );
  }
}
