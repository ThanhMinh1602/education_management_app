import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class QuestionSetCard extends StatelessWidget {
  final String name;
  final int questionCount;
  final DateTime createdAt;
  final VoidCallback onDelete;
  final VoidCallback onEdit;
  final VoidCallback onDetail;

  const QuestionSetCard({
    super.key,
    required this.name,
    required this.questionCount,
    required this.createdAt,
    required this.onDelete,
    required this.onEdit,
    required this.onDetail,
  });

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat('dd/MM/yyyy').format(createdAt);

    // Màu chung cho các nút (Màu hồng chủ đạo của bạn)
    final Color actionButtonColor = const Color(0xFFEDBBC6);

    return GestureDetector(
      onTap: onDetail,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF909CC2),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              offset: const Offset(0, 4),
              blurRadius: 8,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Header: Tên bộ đề
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Text(
                name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  height: 1.2,
                ),
              ),
            ),

            const SizedBox(height: 12),

            // 2. Body: Thông tin
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoRow(Icons.quiz, '$questionCount câu hỏi'),
                  const SizedBox(height: 6),
                  _buildInfoRow(Icons.calendar_month, 'Tạo ngày: $dateStr'),
                ],
              ),
            ),

            const Spacer(),

            // 3. Footer: 3 Nút tròn đều nhau
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(
                  0.05,
                ), // Nền mờ nhẹ ngăn cách footer
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(20),
                ),
              ),
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceEvenly, // Chia đều khoảng cách
                children: [
                  _buildCircleButton(
                    icon: Icons.delete_outline,
                    color: actionButtonColor,
                    onTap: onDelete,
                    tooltip: 'Xóa',
                  ),
                  _buildCircleButton(
                    icon: Icons.edit_outlined,
                    color: actionButtonColor,
                    onTap: onEdit,
                    tooltip: 'Sửa',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.white70, size: 16),
        const SizedBox(width: 8),
        Text(text, style: const TextStyle(color: Colors.white, fontSize: 14)),
      ],
    );
  }

  // Widget nút tròn được chuẩn hóa
  Widget _buildCircleButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    String? tooltip,
  }) {
    const double buttonSize = 45.0; // Kích thước cố định cho tất cả nút

    return Tooltip(
      message: tooltip ?? '',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(50),
          child: Container(
            width: buttonSize,
            height: buttonSize,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              icon,
              color: Colors.white, // Icon màu trắng
              size: 22,
            ),
          ),
        ),
      ),
    );
  }
}
