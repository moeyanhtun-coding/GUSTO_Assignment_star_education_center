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
    controller: controller,
    obscureText: secure,
    keyboardType: keyboardType,
    decoration: InputDecoration(
      prefixIcon: icon != null
          ? Padding(
              padding: iconPadding ?? const EdgeInsets.all(0),
              child: Icon(icon),
            )
          : null,
      labelText: label,
      border: const OutlineInputBorder(),
    ),
  );
}
