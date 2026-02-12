import 'package:flutter/material.dart';
import 'package:blooket/app/core/constants/app_color.dart';
import 'package:blooket/app/data/model/request/content/question_content_request.dart';

class QuizRearrange extends StatefulWidget {
  // Input: Danh sách từ (đã xáo trộn)
  final List<SegmentRequest> initialSegments;

  // Output: Trả về danh sách ID theo thứ tự mới
  final Function(List<int>) onOrderChanged;

  const QuizRearrange({
    super.key,
    required this.initialSegments,
    required this.onOrderChanged,
  });

  @override
  State<QuizRearrange> createState() => _QuizRearrangeState();
}

class _QuizRearrangeState extends State<QuizRearrange> {
  late List<SegmentRequest> _currentOrder;
  bool _isDragging = false; // Trạng thái đang kéo để đổi con trỏ chuột

  @override
  void initState() {
    super.initState();
    _currentOrder = List.from(widget.initialSegments);
  }

  @override
  void didUpdateWidget(covariant QuizRearrange oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialSegments != widget.initialSegments) {
      _currentOrder = List.from(widget.initialSegments);
    }
  }

  // Logic đổi chỗ 2 phần tử
  void _onSwap(int oldIndex, int newIndex) {
    if (oldIndex == newIndex) return;

    setState(() {
      final temp = _currentOrder[oldIndex];
      _currentOrder[oldIndex] = _currentOrder[newIndex];
      _currentOrder[newIndex] = temp;
    });

    // Gửi danh sách ID mới ra ngoài
    final orderedIds = _currentOrder
        .map((e) => int.parse(e.id.toString()))
        .toList();
    widget.onOrderChanged(orderedIds);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Kéo thả các thẻ từ để sắp xếp thành câu đúng:",
          style: TextStyle(fontWeight: FontWeight.w500, color: Colors.grey),
        ),
        const SizedBox(height: 16),

        // Khu vực hiển thị các Chip
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            children: List.generate(_currentOrder.length, (index) {
              return _buildDraggableChip(index, _currentOrder[index]);
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildDraggableChip(int index, SegmentRequest segment) {
    // 1. DragTarget: Nhận khi có Chip khác thả vào đây
    return DragTarget<int>(
      onWillAccept: (data) => data != null && data != index,
      onAccept: (sourceIndex) {
        _onSwap(sourceIndex, index);
      },
      builder: (context, candidateData, rejectedData) {
        // Hiệu ứng khi có Chip khác đang rê chuột lên trên Chip này
        final isHovering = candidateData.isNotEmpty;

        // 2. Draggable: Bản thân Chip này có thể kéo đi
        return MouseRegion(
          cursor: _isDragging
              ? SystemMouseCursors.grabbing
              : SystemMouseCursors.grab,
          child: Draggable<int>(
            data: index,
            onDragStarted: () => setState(() => _isDragging = true),
            onDragEnd: (_) => setState(() => _isDragging = false),

            // A. Widget bay theo chuột khi kéo
            feedback: Material(
              color: Colors.transparent,
              child: Transform.scale(
                scale: 1.1,
                child: Opacity(
                  opacity: 0.9,
                  child: _buildChipUI(segment.text, isDragging: true),
                ),
              ),
            ),

            // B. Widget nằm lại chỗ cũ khi đang kéo (làm mờ đi)
            childWhenDragging: Opacity(
              opacity: 0.3,
              child: _buildChipUI(segment.text, isPlaceholder: true),
            ),

            // C. Widget bình thường (hoặc widget khi đang bị hover)
            child: isHovering
                ? _buildSwapTargetUI(
                    segment.text,
                  ) // Hiển thị khung nét đứt khi hover
                : _buildChipUI(segment.text),
          ),
        );
      },
    );
  }

  // UI của Chip bình thường
  Widget _buildChipUI(
    String text, {
    bool isDragging = false,
    bool isPlaceholder = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: isPlaceholder ? Colors.grey.shade300 : AppColor.primary,
        borderRadius: BorderRadius.circular(12),
        boxShadow: isDragging
            ? [
                BoxShadow(
                  color: AppColor.primary.withOpacity(0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 8),
                ),
              ]
            : [],
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
    );
  }

  // UI khi có Chip khác rê vào (Target) - Viền nét đứt hoặc mờ
  Widget _buildSwapTargetUI(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: AppColor.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColor.primary,
          width: 2,
        ), // Viền để báo hiệu
      ),
      child: Text(
        text,
        style: TextStyle(
          color: AppColor.primary.withOpacity(0.5), // Text mờ đi
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
    );
  }
}
