import 'package:flutter/material.dart';
import 'package:blooket/app/core/constants/app_colors.dart'; // Đảm bảo import đúng

class CustomIconButton extends StatelessWidget {
  final VoidCallback? onTap;
  final IconData icon;
  final Color? backgroundColor;
  final Color? iconColor; // Đóng vai trò là foregroundColor
  final double iconSize;
  final double borderRadius;
  final String? label;
  final EdgeInsetsGeometry? padding; // Thêm để tùy chỉnh padding nếu cần

  const CustomIconButton({
    super.key,
    this.onTap,
    required this.icon,
    this.backgroundColor,
    this.iconColor,
    this.iconSize = 20.0,
    this.borderRadius = 14.0, // Đồng bộ với CustomButton (14.0)
    this.label,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    // Màu mặc định giống CustomButton
    final finalBgColor = backgroundColor ?? AppColors.primary;
    final finalFgColor = iconColor ?? AppColors.white;

    final buttonStyle = ElevatedButton.styleFrom(
      backgroundColor: finalBgColor,
      foregroundColor: finalFgColor,
      fixedSize: Size(double.infinity, 50),
      elevation:
          0, // CustomButton mặc định có thể có elevation, ở đây set 0 cho phẳng hoặc tùy chỉnh
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
      ),
      // Padding mặc định: Nếu có label thì rộng hơn, nếu chỉ có icon thì vừa phải
      padding:
          padding ??
          (label != null
              ? const EdgeInsets.symmetric(horizontal: 12, vertical: 10)
              : const EdgeInsets.all(10)),
      // TextStyle cho Label
      textStyle: Theme.of(
        context,
      ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
    );

    if (label != null && label!.isNotEmpty) {
      return ElevatedButton.icon(
        style: buttonStyle,
        onPressed: onTap,
        icon: Icon(icon, size: iconSize, color: finalFgColor),
        label: Text(label!),
      );
    } else {
      return ElevatedButton(
        style: buttonStyle,
        onPressed: onTap,
        // Dùng SizedBox để đảm bảo nút vuông vắn hơn nếu cần, hoặc để mặc định
        child: Icon(icon, size: iconSize, color: finalFgColor),
      );
    }
  }
}
