import 'package:flutter/material.dart';
import 'package:blooket/app/core/constants/app_color.dart';

class CustomDeleteButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final IconData icon;
  final bool isFullWidth;

  const CustomDeleteButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon = Icons.delete_forever_rounded,
    this.isFullWidth = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      height: 48,
      child: ElevatedButton.icon(
        icon: Icon(icon, color: Colors.white, size: 20),
        label: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColor.falseRed, // Màu đỏ chuẩn của App
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24),
        ),
        onPressed: onPressed,
      ),
    );
  }
}
