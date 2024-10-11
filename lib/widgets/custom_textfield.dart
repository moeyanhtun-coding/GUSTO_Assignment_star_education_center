import 'package:flutter/material.dart';

Widget customTextField({
  required TextEditingController controller,
  required String hintText,
  required String label,
  IconData? icon,
  bool secure = false,
  TextInputType keyboardType = TextInputType.text,
  EdgeInsetsGeometry? iconPadding,
}) {
  return TextFormField(
    style: TextStyle(color: Colors.white),
    controller: controller,
    obscureText: secure,
    keyboardType: keyboardType,
    decoration: InputDecoration(
      prefixIcon: icon != null
          ? Padding(
              padding: iconPadding ?? const EdgeInsets.all(0),
              child: Icon(
                icon,
                color: Colors.blue,
              ),
            )
          : null,
      labelText: label,
      labelStyle: TextStyle(color: Colors.blue),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide:
            const BorderSide(color: Colors.blue), // Default border color
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: Colors.blue,
        ), // Color when field is not focused
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
            color: Colors.white), // Color when field is focused
      ),
    ),
  );
}
