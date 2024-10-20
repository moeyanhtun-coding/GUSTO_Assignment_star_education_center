// Import section //
import 'package:flutter/material.dart';
import 'package:star_education_center/pages/home_page.dart';
import 'package:star_education_center/pages/register_page.dart';
import 'package:star_education_center/ulti.dart';
import 'package:star_education_center/widgets/custom_textfield.dart';
import 'package:get/route_manager.dart';

// Singleton class for TextEditingController //
class TextEditingControllerSingleton {
  // Private static field for the singleton instance //
  static final TextEditingControllerSingleton _instance =
      TextEditingControllerSingleton._internal();

  // Private constructor //
  TextEditingControllerSingleton._internal();

  // Public factory constructor to return the same instance //
  factory TextEditingControllerSingleton() {
    return _instance;
  }

  // Singleton instances of TextEditingControllers //
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
}

// Login Page class //
class LoginPage extends StatelessWidget {
  // Singleton Controller instance //
  final controllers = TextEditingControllerSingleton();

  LoginPage({super.key});

  @override
  // Build method section //
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 0, 17, 32),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Star Education Center",
                style: TextStyle(
                    color: Colors.blue,
                    fontSize: 35,
                    fontWeight: FontWeight.bold),
              ),
              margin(width: 0, height: 20),
              _loginForm(context),
            ],
          ),
        ),
      ),
    );
  }

  // Login Form section //
  Widget _loginForm(context) {
    return Column(
      children: [
        // Email TextField //
        customTextField(
          controller: controllers.emailController,
          hintText: "example@gmail.com",
          secure: false,
          label: "Email",
          icon: Icons.mail,
        ),
        margin(width: 0, height: 20),
        // Password TextField //
        customTextField(
          controller: controllers.passwordController,
          hintText: "********",
          secure: true,
          label: "Password",
          icon: Icons.password,
        ),
        margin(width: 0, height: 20),
        // Login Button //
        _loginButton(context),
        margin(width: 0, height: 20),
        // Sign Up Section //
        _signUp()
      ],
    );
  }

  // Login Button Widget with authentication logic //
  Widget _loginButton(context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(Colors.blue),
          foregroundColor: WidgetStatePropertyAll(Colors.white),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
        onPressed: () {
          // Hardcoded email and password for authentication
          if (controllers.emailController.text == "admin@gmail.com" &&
              controllers.passwordController.text == "admin@123?") {
            Get.offAll(HomePage()); // Navigate to home page on successful login
          } else {
            // Show error message if authentication fails
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Invalid email or password')),
            );
          }
        },
        child: const Text(
          "Login",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
    );
  }

  // Sign Up Widget //
  Widget _signUp() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Don't have an account ? ",
          style: TextStyle(color: Colors.white),
        ),
        GestureDetector(
          onTap: () => Get.offAll(RegisterPage()),
          child: const Text(
            "Register Now",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
          ),
        )
      ],
    );
  }
}
