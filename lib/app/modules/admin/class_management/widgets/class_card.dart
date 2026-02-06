// lib/app/modules/admin/class_management/widgets/class_card.dart

import 'package:blooket/app/data/model/class_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Để dùng Clipboard
import 'package:get/get.dart';

class ClassCard extends StatelessWidget {
  final String className;
  final String code;
  final String? teacherName;
  final List<ClassSchedule> schedule;
  final int studentCount;
  final VoidCallback onEnterClass;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const ClassCard({
    super.key,
    required this.className,
    required this.code,
    this.teacherName,
    required this.schedule,
    required this.studentCount,
    required this.onEnterClass,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF909CC2), Color(0xFF6876A0)],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6876A0).withOpacity(0.4),
            offset: const Offset(0, 8),
            blurRadius: 16,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            // --- Trang trí nền (Hình tròn mờ góc phải) ---
            Positioned(
              top: -30,
              right: -30,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  shape: BoxShape.circle,
                ),
              ),
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ==============================
                // 1. HEADER (Tên, Mã lớp, GV)
                // ==============================
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 16, 0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Badge Mã lớp (Bấm để Copy)
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(6),
                                onTap: () {
                                  Clipboard.setData(ClipboardData(text: code));
                                  Get.snackbar(
                                    "Đã sao chép",
                                    "Mã lớp: $code",
                                    snackPosition: SnackPosition.BOTTOM,
                                    backgroundColor: Colors.black87,
                                    colorText: Colors.white,
                                    duration: const Duration(seconds: 1),
                                    margin: const EdgeInsets.all(16),
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.1),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'CODE: $code',
                                        style: const TextStyle(
                                          color: Color(0xFFFFE082),
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1,
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      const Icon(
                                        Icons.copy_rounded,
                                        color: Colors.white70,
                                        size: 12,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            // Tên lớp
                            Text(
                              className,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            // Tên giáo viên
                            if (teacherName != null) ...[
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.person_rounded,
                                    color: Colors.white70,
                                    size: 14,
                                  ),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      teacherName!,
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                      // Nút Sửa / Xóa
                      Column(
                        children: [
                          _buildCircleButton(Icons.edit_rounded, onEdit),
                          const SizedBox(height: 8),
                          _buildCircleButton(
                            Icons.delete_outline_rounded,
                            onDelete,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // ==============================
                // 2. BODY (Thanh lịch học 7 ngày)
                // ==============================
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.1),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: _buildWeekDays(), // Render 7 hình tròn
                          ),
                        ),

                        const Spacer(),

                        // Số học viên
                        Row(
                          children: [
                            const Icon(
                              Icons.people_alt_rounded,
                              color: Colors.white60,
                              size: 16,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '$studentCount học viên',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),

                // ==============================
                // 3. FOOTER BUTTON
                // ==============================
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                  child: ElevatedButton(
                    onPressed: onEnterClass,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFEDBBC6),
                      foregroundColor: const Color(0xFF6A4C53),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'XEM LỚP HỌC',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 13,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward_rounded, size: 16),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // --- LOGIC HELPER ---
  // --- HÀM TẠO DANH SÁCH 7 NGÀY (CÓ TOOLTIP) ---
  List<Widget> _buildWeekDays() {
    final weekOrder = [1, 2, 3, 4, 5, 6, 0];

    return weekOrder.map((dayIndex) {
      final scheduleItem = schedule.firstWhereOrNull(
        (s) => s.dayOfWeek == dayIndex,
      );
      final isActive = scheduleItem != null;

      // Chuẩn bị nội dung cho Tooltip
      String tooltipMessage;
      if (isActive) {
        tooltipMessage =
            '${_getDayFullName(dayIndex)}\n'
            '⏰ ${scheduleItem.startTime} - ${scheduleItem.endTime}';
        if (scheduleItem.room.isNotEmpty) {
          tooltipMessage += '\n📍 ${scheduleItem.room}';
        }
      } else {
        tooltipMessage = '${_getDayFullName(dayIndex)}\n💤 Không có lịch';
      }

      return Expanded(
        // Bọc Tooltip ở đây
        child: Tooltip(
          message: tooltipMessage,
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.only(top: 10), // Cách xa chấm tròn một chút
          showDuration: const Duration(seconds: 3), // Thời gian hiện
          decoration: BoxDecoration(
            color: const Color(0xFF2D3436).withOpacity(0.95),
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          textStyle: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            height: 1.4, // Giãn dòng cho dễ đọc
          ),
          // TriggerMode: longPress cho mobile, manual cho mouse hover
          triggerMode: TooltipTriggerMode.longPress,

          child: Container(
            // Thêm màu nền trong suốt để tăng diện tích nhận cảm ứng cho Tooltip
            color: Colors.transparent,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Hình tròn
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isActive
                        ? const Color(0xFFFFE082)
                        : Colors.white.withOpacity(0.1),
                    boxShadow: isActive
                        ? [
                            BoxShadow(
                              color: const Color(0xFFFFE082).withOpacity(0.4),
                              blurRadius: 6,
                              spreadRadius: 1,
                            ),
                          ]
                        : [],
                  ),
                  child: Center(
                    child: Text(
                      _getDayShortName(dayIndex),
                      style: TextStyle(
                        color: isActive
                            ? const Color(0xFF5D4037)
                            : Colors.white60,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 4),

                // Giờ học
                Text(
                  isActive ? _formatTimeShort(scheduleItem.startTime) : '',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.visible,
                ),
              ],
            ),
          ),
        ),
      );
    }).toList();
  }

  // Helper: Tên ngày đầy đủ cho Tooltip
  String _getDayFullName(int dayIndex) {
    if (dayIndex == 0) return 'Chủ Nhật';
    return 'Thứ ${dayIndex + 1}';
  }

  // Chuyển index sang tên ngày (0->CN, 1->T2...)
  String _getDayShortName(int dayIndex) {
    if (dayIndex == 0) return 'CN';
    return 'T${dayIndex + 1}';
  }

  // Rút gọn giờ (19:00 -> 19h, 19:30 -> 19h30)
  String _formatTimeShort(String time) {
    final parts = time.split(':');
    if (parts.length >= 2) {
      final hour = parts[0];
      final minute = parts[1];
      if (minute == '00') return '${hour}h';
      return '${hour}h$minute';
    }
    return time;
  }

  // Nút tròn nhỏ cho Edit/Delete
  Widget _buildCircleButton(IconData icon, VoidCallback onPressed) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white.withOpacity(0.2)),
          ),
          child: Icon(icon, color: Colors.white, size: 16),
        ),
      ),
    );
  }
}
