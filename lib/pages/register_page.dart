// Import section //
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:star_education_center/widgets/custom_textfield.dart';

// Register Page class //
class RegisterPage extends StatelessWidget {
  // Controller section //
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  RegisterPage({super.key});

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

  // Register Form section with TextField Decorator //
  Widget _registerForm(context) {
    // Validation logic for error messages
    String? emailError =
        emailController.text.isEmpty ? 'Email is required' : null;
    String? passwordError =
        passwordController.text.isEmpty ? 'Password is required' : null;
    String? confirmPasswordError =
        confirmPasswordController.text != passwordController.text
            ? 'Passwords do not match'
            : null;

    return Column(
      children: [
        // Decorated Email TextField //
        TextFieldDecorator(
          textField: customTextField(
            controller: emailController,
            hintText: "example@gmail.com",
            secure: false,
            label: "Email",
            icon: Icons.mail,
          ),
          errorMessage: emailError,
        ),
        _margin(0, 20),

        // Decorated Password TextField //
        TextFieldDecorator(
          textField: customTextField(
            controller: passwordController,
            hintText: "********",
            secure: true,
            label: "Password",
            icon: Icons.password,
          ),
          errorMessage: passwordError,
        ),
        _margin(0, 20),

        // Decorated Confirm Password TextField //
        TextFieldDecorator(
          textField: customTextField(
            controller: confirmPasswordController,
            hintText: "********",
            secure: true,
            label: "Confirm Password",
            icon: Icons.password,
          ),
          errorMessage: confirmPasswordError,
        ),
        _margin(0, 20),

        _registerButton(),
        _margin(0, 20),
        _signIn()
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
        onPressed: () {
          // Perform register action or validation
        },
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
  Widget _signIn() {
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
            "Sign In",
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

// TextField Decorator Class //
class TextFieldDecorator extends StatelessWidget {
  final Widget textField;
  final String? errorMessage;

  TextFieldDecorator({required this.textField, this.errorMessage});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        textField, // Original Text Field
        if (errorMessage != null) // Add error message if present
          Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: Text(
              errorMessage!,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }
}
