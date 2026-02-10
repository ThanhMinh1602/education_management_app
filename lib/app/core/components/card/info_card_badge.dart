import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class InfoCardBadge extends StatelessWidget {
  final String label;
  final String content;
  final Color contentColor;

  const InfoCardBadge({
    super.key,
    required this.label,
    required this.content,
    this.contentColor = const Color(0xFFFFE082),
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(6),
        onTap: () {
          Clipboard.setData(ClipboardData(text: content));
          Get.snackbar(
            "Sao chép",
            "$label: $content",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.black54,
            colorText: Colors.white,
            duration: const Duration(seconds: 1),
            margin: const EdgeInsets.all(10),
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.2),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$label: $content',
                style: TextStyle(
                  color: contentColor,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(width: 6),
              const Icon(Icons.copy_rounded, color: Colors.white70, size: 12),
            ],
          ),
        ),
      ),
    );
  }
}
