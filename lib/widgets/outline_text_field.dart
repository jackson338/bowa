import 'package:flutter/material.dart';

InputDecoration outlineTextField({
  required BuildContext context,
  required Color stagnant,
  required Color selected,
  String? hintText,
}) {
  return InputDecoration(
    hintText: hintText,
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(
        width: 2,
        color: stagnant,
      ),
      borderRadius: BorderRadius.circular(20),
    ),
    border: OutlineInputBorder(
      borderSide: BorderSide(
        width: 2,
        color: selected,
      ),
      borderRadius: BorderRadius.circular(20),
    ),
  );
}
