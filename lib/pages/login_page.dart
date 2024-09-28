import 'package:flutter/material.dart';
import 'package:star_education_center/widgets/custom_textfield.dart';
import 'package:get/route_manager.dart';

class LoginPage extends StatelessWidget {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  LoginPage({super.key});

  @override
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

  Widget _loginForm(context) {
    return Column(
      children: [
        customTextField(
          controller: emailController,
          hintText: "example@gmail.com",
          secure: false,
          label: "Email",
          icon: Icons.mail,
        ),
        _margin(0, 20),
        customTextField(
          controller: passwordController,
          hintText: "********",
          secure: true,
          label: "Password",
          icon: Icons.password,
        ),
        _margin(0, 20),
        _loginButton(),
        _margin(0, 20),
        _signUp()
      ],
    );
  }

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

  Widget _margin(double width, double height) {
    return SizedBox(
      height: height,
      width: width,
    );
  }

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
