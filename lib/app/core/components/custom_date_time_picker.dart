import 'package:blooket/app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomDateTimePicker extends StatelessWidget {
  final String labelText;
  final DateTime? selectedDate;
  final VoidCallback onTap;
  final String? errorText;

  const CustomDateTimePicker({
    super.key,
    required this.labelText,
    required this.selectedDate,
    required this.onTap,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    final outlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: Colors.grey),
    );

    final focusedBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: AppColors.primary, width: 2),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: labelText,
              filled: true,
              fillColor: Colors.white,
              prefixIcon: const Icon(
                Icons.calendar_today,
                color: AppColors.primary,
              ),
              border: outlineInputBorder,
              enabledBorder: outlineInputBorder,
              focusedBorder: selectedDate != null
                  ? focusedBorder
                  : outlineInputBorder,
              errorText: errorText,
              labelStyle: TextStyle(color: Colors.grey[600]),
              floatingLabelStyle: const TextStyle(color: AppColors.primary),
            ),
            child: Text(
              selectedDate == null
                  ? 'Chọn thời gian...'
                  : DateFormat('dd/MM/yyyy HH:mm').format(selectedDate!),
              style: TextStyle(
                fontSize: 16,
                color: selectedDate == null ? Colors.grey[700] : Colors.black,
                fontWeight: selectedDate == null
                    ? FontWeight.normal
                    : FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
