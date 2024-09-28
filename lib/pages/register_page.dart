import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:star_education_center/widgets/custom_textfield.dart';

class RegisterPage extends StatelessWidget {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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

  Widget _registerForm(context) {
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
        customTextField(
          controller: confirmPasswordController,
          hintText: "********",
          secure: true,
          label: "Confirm Password",
          icon: Icons.password,
        ),
        _margin(0, 20),
        _registerButton(),
        _margin(0, 20),
        _singIn()
      ],
    );
  }

  Widget _registerButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {},
        child: const Text("Register"),
      ),
    );
  }

  Widget _margin(double width, double height) {
    return SizedBox(
      height: height,
      width: width,
    );
  }

  Widget _singIn() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Already have an account? "),
        GestureDetector(
          onTap: () => Get.offAllNamed('login'),
          child: const Text(
            "Sing In",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        )
      ],
    );
  }
}
