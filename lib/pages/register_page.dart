// Import section //
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:star_education_center/ulti.dart';
import 'package:star_education_center/widgets/custom_textfield.dart';

// Register Page class //
class RegisterPage extends StatelessWidget {
  // Controller section //
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  RegisterPage({key});

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
              _registerForm(context),
            ],
          ),
        ),
      ),
    );
  }

  // Register Form section //
  Widget _registerForm(context) {
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
        // Margin between fields //
        margin(width: 0, height: 20),
        // Password TextField //
        customTextField(
          controller: passwordController,
          hintText: "********",
          secure: true,
          label: "Password",
          icon: Icons.password,
        ),
        // Margin between fields //
        margin(width: 0, height: 20),
        // Confirm Password TextField //
        customTextField(
          controller: confirmPasswordController,
          hintText: "********",
          secure: true,
          label: "Confirm Password",
          icon: Icons.password,
        ),
        // Margin before register button //
        margin(width: 0, height: 20),
        // Register Button //
        _registerButton(),
        // Margin before sign-in prompt //
        margin(width: 0, height: 20),
        // Sign In section //
        _singIn()
      ],
    );
  }

  // Register Button Widget //
  Widget _registerButton() {
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
        onPressed: () {},
        child: const Text("Register"),
      ),
    );
  }

  // Custom Margin Widget //
  Widget _margin(double width, double height) {
    return SizedBox(
      height: height,
      width: width,
    );
  }

  // Sign In Widget //
  Widget _singIn() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Already have an account ? ",
          style: TextStyle(color: Colors.white),
        ),
        GestureDetector(
          onTap: () => Get.offAllNamed('login'),
          child: const Text(
            "Sing In",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
        )
      ],
    );
  }
}
