import 'package:blooket/app/core/components/text_field/custom_text_field.dart';
import 'package:flutter/material.dart';

class FormSectionTitle extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;

  const FormSectionTitle({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(width: 8),
        Text(
          title.toUpperCase(),
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade700,
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(child: Divider(color: Colors.grey.shade200, thickness: 1)),
      ],
    );
  }
}

class FormInputWithIcon extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final Color iconColor;
  final int maxLines;

  const FormInputWithIcon({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    required this.iconColor,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment:
          CrossAxisAlignment.start, // Căn trên cùng nếu maxLines > 1
      children: [
        Container(
          margin: const EdgeInsets.only(top: 8), // Canh chỉnh với Textfield
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: CustomTextField(controller: controller, labelText: label),
        ),
      ],
    );
  }
}
