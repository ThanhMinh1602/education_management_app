import 'package:blooket/app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class CustomDropdownField<T> extends StatelessWidget {
  final String labelText;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final String? Function(T?)? validator;
  final IconData? prefixIcon;

  const CustomDropdownField({
    super.key,
    required this.labelText,
    required this.value,
    required this.items,
    required this.onChanged,
    this.validator,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    // Tái sử dụng style từ CustomTextField của bạn
    final outlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: Colors.grey),
    );

    final focusedBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: AppColors.primary, width: 2),
    );

    return DropdownButtonFormField<T>(
      value: value,
      items: items,
      onChanged: onChanged,
      validator: validator,
      // Style đồng bộ
      decoration: InputDecoration(
        labelText: labelText,
        filled: true,
        fillColor: Colors.white,
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, color: AppColors.primary)
            : null,

        // Border đồng bộ
        border: outlineInputBorder,
        enabledBorder: outlineInputBorder,
        focusedBorder: focusedBorder,

        labelStyle: TextStyle(color: Colors.grey[600]),
        floatingLabelStyle: const TextStyle(color: AppColors.primary),

        // Khoảng cách đệm bên trong để không bị sát biên
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 15,
        ),
      ),

      // Tùy chỉnh icon mũi tên dropdown
      icon: const Icon(Icons.arrow_drop_down, color: AppColors.primary),

      // Giúp text không bị tràn khi tên lớp quá dài
      isExpanded: true,

      // Style cho menu dropdown hiện ra
      borderRadius: BorderRadius.circular(14),
      dropdownColor: Colors.white,
    );
  }
}
