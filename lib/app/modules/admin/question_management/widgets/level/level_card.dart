import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LevelCard extends StatelessWidget {
  final String name;
  final String description;
  final int order;
  final bool isActive;
  final DateTime createdAt;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const LevelCard({
    super.key,
    required this.name,
    required this.description,
    required this.order,
    required this.isActive,
    required this.createdAt,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat('dd/MM/yyyy').format(createdAt);

    final Color actionButtonColor = const Color(0xFFEDBBC6);

    return Container(
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
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description.isEmpty ? "Không có mô tả" : description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow(Icons.layers_outlined, 'Thứ tự: #$order'),
                const SizedBox(height: 6),
                _buildStatusRow(isActive),
                const SizedBox(height: 6),
                _buildInfoRow(Icons.calendar_month, 'Ngày tạo: $dateStr'),
              ],
            ),
          ),

          const Spacer(),

          Container(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.05),
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(20),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.white70, size: 16),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(color: Colors.white, fontSize: 14),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusRow(bool active) {
    return Row(
      children: [
        Icon(
          active ? Icons.check_circle_outline : Icons.highlight_off_rounded,
          color: active ? Colors.greenAccent : Colors.white70,
          size: 16,
        ),
        const SizedBox(width: 8),
        Text(
          active ? 'Hoạt động' : 'Đang ẩn',
          style: TextStyle(
            color: active ? Colors.white : Colors.white70,
            fontSize: 14,
            fontWeight: active ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildCircleButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    String? tooltip,
  }) {
    const double buttonSize = 45.0;

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
            child: Icon(icon, color: Colors.white, size: 22),
          ),
        ),
      ),
    );
  }
}
