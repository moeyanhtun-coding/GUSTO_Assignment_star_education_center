import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:star_education_center/firebase_options.dart';
import 'package:star_education_center/pages/home_page.dart';
import 'package:star_education_center/pages/login_page.dart';
import 'package:star_education_center/pages/register_page.dart';
import 'package:dcdg/dcdg.dart';

// Main function which is the entry point of the app
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase with platform-specific options (Android, iOS, etc.)
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

// Define the routes using GetX's GetPage. Each route is associated with a page.
final routes = [
  GetPage(name: '/login', page: () => LoginPage()),
  GetPage(name: '/register', page: () => RegisterPage()),
  GetPage(name: '/home', page: () => HomePage()),
];

// MyApp widget is the root of your application
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
