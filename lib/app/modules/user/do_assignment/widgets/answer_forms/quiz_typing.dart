import 'package:flutter/material.dart';
import 'package:blooket/app/core/constants/app_color.dart';

class QuizTyping extends StatefulWidget {
  final Function(String) onChanged;
  final String? initialValue;

  const QuizTyping({super.key, required this.onChanged, this.initialValue});

  @override
  State<QuizTyping> createState() => _QuizTypingState();
}

class _QuizTypingState extends State<QuizTyping> {
  late TextEditingController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(text: widget.initialValue);
  }

  @override
  void didUpdateWidget(covariant QuizTyping oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != oldWidget.initialValue &&
        widget.initialValue != _ctrl.text) {
      _ctrl.text = widget.initialValue ?? "";
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Nhập câu trả lời của bạn:",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _ctrl,
          onChanged: widget.onChanged,
          maxLines: 3,
          style: const TextStyle(fontSize: 16),
          decoration: InputDecoration(
            hintText: "Gõ câu trả lời vào đây...",
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColor.primary, width: 2),
            ),
            contentPadding: const EdgeInsets.all(16),
          ),
        ),
      ],
    );
  }
}
