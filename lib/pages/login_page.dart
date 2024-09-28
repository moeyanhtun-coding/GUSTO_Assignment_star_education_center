// Import section //
import 'package:flutter/material.dart';
import 'package:star_education_center/ulti.dart';
import 'package:star_education_center/widgets/custom_textfield.dart';
import 'package:get/route_manager.dart';

// Login Page class //
class LoginPage extends StatelessWidget {
  // Controller section //
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  LoginPage({super.key});

  @override
  // Build method section //
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
          controller: emailController,
          hintText: "example@gmail.com",
          secure: false,
          label: "Email",
          icon: Icons.mail,
        ),
        margin(width: 0, height: 20),
        // Password TextField //
        customTextField(
          controller: passwordController,
          hintText: "********",
          secure: true,
          label: "Password",
          icon: Icons.password,
        ),
        margin(width: 0, height: 20),
        // Login Button //
        _loginButton(),
        margin(width: 0, height: 20),
        // Sign Up Section //
        _signUp()
      ],
    );
  }

  // Login Button Widget //
  Widget _loginButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          Get.offAllNamed('/home');
        },
        child: const Text("Login"),
      ),
    );
  }

  // Sign Up Widget //
  Widget _signUp() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have an account? "),
        GestureDetector(
          onTap: () => Get.offAllNamed('/register'),
          child: const Text(
            "Register Now",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        )
      ],
    );
  }
}
