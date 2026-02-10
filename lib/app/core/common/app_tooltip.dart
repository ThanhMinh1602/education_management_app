import 'package:flutter/material.dart';

class AppTooltip extends StatelessWidget {
  final String message;
  final Widget child;
  final Color? backgroundColor;
  final Color? textColor;

  const AppTooltip({
    super.key,
    required this.message,
    required this.child,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: message,
      // 1. QUAN TRỌNG: Đặt là false để Tooltip hiện lên trên (tránh bị chuột che)
      preferBelow: false,

      // 2. Tăng khoảng cách giữa Tooltip và Widget (mặc định là 24, tăng lên để thoáng hơn)
      verticalOffset: 20,

      // Các thuộc tính làm đẹp giữ nguyên
      waitDuration: const Duration(milliseconds: 300),
      showDuration: const Duration(milliseconds: 1500),
      textStyle: TextStyle(
        color: textColor ?? Colors.white,
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      decoration: BoxDecoration(
        color: backgroundColor ?? const Color(0xFF1E293B), // Slate-800
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            offset: const Offset(0, 4),
            blurRadius: 10,
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      // margin: const EdgeInsets.all(10), // Có thể thêm margin nếu muốn nó cách xa cạnh màn hình
      child: child,
    );
  }
}
