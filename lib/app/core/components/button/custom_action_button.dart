import 'package:flutter/material.dart';

class CustomActionButton extends StatelessWidget {
  final VoidCallback onTap;
  final String text;
  final IconData? icon;
  final Color? color;
  final double? width;
  final double fontSize;

  const CustomActionButton({
    super.key,
    required this.onTap,
    this.text = 'TẠO MỚI', // Mặc định là TẠO MỚI
    this.icon = Icons.add_circle_outline, // Mặc định icon cộng
    this.color, // Nếu không truyền sẽ dùng màu mặc định bên dưới
    this.width = 200, // Độ rộng mặc định
    this.fontSize = 20,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: width,
          height: 50,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          decoration: BoxDecoration(
            // Dùng màu truyền vào, nếu không có thì dùng màu hồng gốc
            color: color ?? const Color(0xFFEDBBC6),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                offset: const Offset(0, 4),
                blurRadius: 8,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Chỉ hiện icon nếu icon không null
              if (icon != null) ...[
                Icon(icon, color: Colors.white, size: 28),
                const SizedBox(width: 8),
              ],
              Text(
                text,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: fontSize,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
