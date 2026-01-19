import 'package:blooket/app/core/constants/app_color.dart';
import 'package:flutter/material.dart';

class AnswerMultiChose extends StatefulWidget {
  final Function(List<String> options, List<String> correctAnswers)? onChanged;
  final List<String>? initialOptions;
  final List<String>? initialCorrectAnswers;

  const AnswerMultiChose({
    super.key,
    this.onChanged,
    this.initialOptions,
    this.initialCorrectAnswers,
  });

  @override
  State<AnswerMultiChose> createState() => _AnswerMultiChoseState();
}

class _AnswerMultiChoseState extends State<AnswerMultiChose> {
  int _selectedAnswerIndex = 0;
  late List<TextEditingController> _controllers;

  // Biến lưu trạng thái hover
  final List<bool> _isHovering = List.generate(4, (index) => false);

  @override
  void initState() {
    super.initState();

    // 1. Khởi tạo Controllers với dữ liệu cũ (nếu có)
    _controllers = List.generate(4, (index) {
      String text = '';
      if (widget.initialOptions != null &&
          index < widget.initialOptions!.length) {
        text = widget.initialOptions![index];
      }
      return TextEditingController(text: text);
    });

    // 2. Xác định đáp án đúng ban đầu (nếu có)
    if (widget.initialCorrectAnswers != null &&
        widget.initialCorrectAnswers!.isNotEmpty &&
        widget.initialOptions != null) {
      // Tìm xem đáp án đúng nằm ở index nào trong options
      final correctText = widget.initialCorrectAnswers!.first;
      final index = widget.initialOptions!.indexOf(correctText);
      if (index != -1) {
        _selectedAnswerIndex = index;
      }
    }

    // 3. Lắng nghe thay đổi text
    for (var controller in _controllers) {
      controller.addListener(_notifyChange);
    }
  }

  // Hàm notify cập nhật dữ liệu ra bên ngoài
  void _notifyChange() {
    if (widget.onChanged != null) {
      // Lấy toàn bộ text từ 4 ô nhập
      final options = _controllers.map((e) => e.text).toList();

      // Lấy text của ô đang được chọn làm đáp án đúng
      final correctAnswerText = options[_selectedAnswerIndex];

      // Trả về dữ liệu
      widget.onChanged!(options, [correctAnswerText]);
    }
  }

  void _onSelectAnswer(int index) {
    setState(() {
      _selectedAnswerIndex = index;
    });
    _notifyChange(); // Gọi callback khi đổi đáp án đúng
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = 2;
        final spacing = 20.0;
        final totalSpacing = spacing * (crossAxisCount - 1);
        final itemWidth =
            (constraints.maxWidth - totalSpacing) / crossAxisCount;
        const itemHeight = 80.0;
        final ratio = itemWidth / itemHeight;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          itemCount: 4,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: ratio,
            crossAxisSpacing: spacing,
            mainAxisSpacing: spacing,
          ),
          itemBuilder: (context, index) {
            return _buildWebAnswerItem(index);
          },
        );
      },
    );
  }

  Widget _buildWebAnswerItem(int index) {
    final isSelected = _selectedAnswerIndex == index;
    final isHovering = _isHovering[index];

    Color borderColor;
    double borderWidth;
    Color backgroundColor;

    if (isSelected) {
      borderColor = AppColor.pink;
      borderWidth = 2.5;
      backgroundColor = AppColor.pink.withOpacity(0.08);
    } else if (isHovering) {
      borderColor = Colors.grey.shade500;
      borderWidth = 1.5;
      backgroundColor = Colors.grey.shade50;
    } else {
      borderColor = Colors.grey.shade300;
      borderWidth = 1.0;
      backgroundColor = Colors.white;
    }

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovering[index] = true),
      onExit: (_) => setState(() => _isHovering[index] = false),
      child: GestureDetector(
        onTap: () => _onSelectAnswer(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          decoration: BoxDecoration(
            color: backgroundColor,
            border: Border.all(color: borderColor, width: borderWidth),
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: isSelected || isHovering
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [],
          ),
          child: Row(
            children: [
              Transform.scale(
                scale: 1.2,
                child: Radio<int>(
                  value: index,
                  groupValue: _selectedAnswerIndex,
                  activeColor: AppColor.pink,
                  splashRadius: 20,
                  onChanged: (val) => _onSelectAnswer(val!),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _controllers[index],
                  mouseCursor: SystemMouseCursors.text,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: isSelected
                        ? FontWeight.w600
                        : FontWeight.normal,
                    color: Colors.black87,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    hintText: 'Option ${index + 1}',
                    hintStyle: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 15,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                ),
              ),
              if (isSelected)
                const Icon(Icons.check_circle, color: AppColor.pink, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
