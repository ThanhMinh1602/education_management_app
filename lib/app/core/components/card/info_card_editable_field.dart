import 'package:flutter/material.dart';

class InfoCardEditableField extends StatelessWidget {
  final TextEditingController controller;
  final TextStyle style;
  final String? hint;
  final int maxLines;
  final TextInputType keyboardType;

  const InfoCardEditableField({
    super.key,
    required this.controller,
    required this.style,
    this.hint,
    this.maxLines = 1,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      style: style,
      maxLines: maxLines,
      keyboardType: keyboardType,
      cursorColor: const Color(0xFFFFE082),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: style.copyWith(color: Colors.white30),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFFFE082), width: 2),
        ),
        isDense: true,
        contentPadding: const EdgeInsets.only(bottom: 8),
        border: InputBorder.none,
      ),
    );
  }
}
