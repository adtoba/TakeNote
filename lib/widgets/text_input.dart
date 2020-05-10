import 'package:flutter/material.dart';
import 'package:tasker/utils/colors.dart';

class TextInput extends StatelessWidget {
  const TextInput({
    @required this.controller,
    @required this.hint,
    @required this.maxLines,
    this.onChanged
  });

  final TextEditingController controller;
  final String hint;
  final int maxLines;
  final Function(String) onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines ?? 1,
      onChanged: onChanged,
      decoration: InputDecoration(
        fillColor: Colors.white,
        filled: true,
        hintText: hint,
        hintStyle: TextStyle(
          color: XColors.hintTextColor
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(12.0)
        )
      ),
    );
  }
}