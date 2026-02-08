import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:collection/collection.dart'; // Nhớ thêm package: collection vào pubspec.yaml

import 'package:blooket/app/data/model/class_model.dart';
import 'package:blooket/app/data/model/request/class/class_request.dart';

class ScheduleWidget extends StatefulWidget {
  const ScheduleWidget({
    super.key,
    required this.scheduleInitial,
    this.onChanged,
    this.isEditable = false,

    // Các tham số màu tùy chỉnh (Nullable)
    // Nếu null -> Sẽ dùng giao diện Dark mặc định (cho Card)
    this.backgroundColor,
    this.borderColor,
    this.activeColor,
    this.activeTextColor,
    this.inactiveColor,
    this.inactiveTextColor,
    this.timeColor,
  });

  final List<ClassSchedule> scheduleInitial;
  final Function(List<ClassScheduleRequest>)? onChanged;
  final bool isEditable;

  // Color Config
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? activeColor;
  final Color? activeTextColor;
  final Color? inactiveColor;
  final Color? inactiveTextColor;
  final Color? timeColor;

  @override
  State<ScheduleWidget> createState() => _ScheduleWidgetState();
}

class _ScheduleWidgetState extends State<ScheduleWidget> {
  late List<ClassScheduleRequest> _localSchedules;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  @override
  void didUpdateWidget(covariant ScheduleWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.scheduleInitial != oldWidget.scheduleInitial) {
      _initData();
    }
  }

  void _initData() {
    _localSchedules = widget.scheduleInitial.map((e) {
      return ClassScheduleRequest(
        dayOfWeek: e.dayOfWeek,
        startTime: e.startTime,
        endTime: e.endTime,
        room: e.room,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    // --- CẤU HÌNH MÀU SẮC (LOGIC HYBRID) ---

    // 1. Nền & Viền
    final bgColor = widget.backgroundColor ?? Colors.black.withOpacity(0.15);
    final borderCol = widget.borderColor ?? Colors.white.withOpacity(0.1);

    // 2. Màu Active (Ngày có lịch)
    final activeBg = widget.activeColor ?? const Color(0xFFFFE082); // Vàng
    final activeTxt = widget.activeTextColor ?? const Color(0xFF5D4037); // Nâu

    // 3. Màu Inactive (Ngày trống)
    final inactiveBg = widget.inactiveColor ?? Colors.white.withOpacity(0.1);
    final inactiveTxt = widget.inactiveTextColor ?? Colors.white60;

    // 4. Màu Text giờ bên dưới
    final timeTxt = widget.timeColor ?? Colors.white;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderCol),
        boxShadow:
            widget.backgroundColor !=
                null // Chỉ hiện bóng đổ nếu là Light Mode
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  offset: const Offset(0, 4),
                  blurRadius: 10,
                ),
              ]
            : [],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: _buildWeekDays(
          activeBg,
          activeTxt,
          inactiveBg,
          inactiveTxt,
          timeTxt,
        ),
      ),
    );
  }

  List<Widget> _buildWeekDays(
    Color activeBg,
    Color activeTxt,
    Color inactiveBg,
    Color inactiveTxt,
    Color timeTxt,
  ) {
    final weekOrder = [1, 2, 3, 4, 5, 6, 0];

    return weekOrder.map((dayIndex) {
      final scheduleItem = _localSchedules.firstWhereOrNull(
        (s) => s.dayOfWeek == dayIndex,
      );
      final isActive = scheduleItem != null;

      String tooltipMessage;

      // LOGIC TOOLTIP
      if (isActive) {
        // 1. Có lịch: Hiển thị giờ và phòng
        tooltipMessage =
            '${_getDayFullName(dayIndex)}\n⏰ ${scheduleItem.startTime} - ${scheduleItem.endTime}';
        if (scheduleItem.room != null && scheduleItem.room!.isNotEmpty) {
          tooltipMessage += '\n📍 ${scheduleItem.room}';
        }
      } else {
        // 2. Không có lịch
        if (widget.isEditable) {
          // Đang sửa -> Nhắc người dùng bấm để thêm
          tooltipMessage = '${_getDayFullName(dayIndex)}\n(Chạm để thêm)';
        } else {
          // Chỉ xem -> Thông báo không có lịch
          tooltipMessage = '${_getDayFullName(dayIndex)}\n💤 Không có lịch học';
        }
      }

      return Expanded(
        child: GestureDetector(
          // Chỉ cho phép onTap khi đang ở chế độ Edit
          onTap: () => widget.isEditable
              ? _showEditDialog(context, dayIndex, scheduleItem)
              : null,
          child: Tooltip(
            message: tooltipMessage,
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(top: 10),
            showDuration: const Duration(seconds: 2),
            decoration: BoxDecoration(
              // Nếu là mode xem (nền tối) thì tooltip tối, mode sửa (nền sáng) thì tooltip sáng
              color: widget.backgroundColor == null
                  ? const Color(0xFF2D3436).withOpacity(0.95) // Dark tooltip
                  : Colors.white, // Light tooltip
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            textStyle: TextStyle(
              // Đổi màu chữ tương phản với nền tooltip
              color: widget.backgroundColor == null
                  ? Colors.white
                  : const Color(0xFF2D3436),
              fontSize: 12,
            ),
            triggerMode: TooltipTriggerMode.longPress,
            child: Container(
              color: Colors.transparent,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isActive ? activeBg : inactiveBg,
                      border: (!isActive && widget.backgroundColor != null)
                          ? Border.all(color: Colors.grey.shade300)
                          : null,
                      boxShadow: isActive
                          ? [
                              BoxShadow(
                                color: activeBg.withOpacity(0.4),
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
                          color: isActive ? activeTxt : inactiveTxt,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isActive ? _formatTimeShort(scheduleItem.startTime) : '',
                    style: TextStyle(
                      color: timeTxt,
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
        ),
      );
    }).toList();
  }
  // --- LOGIC HELPER ---

  void _saveSchedule(
    int dayIndex,
    TimeOfDay start,
    TimeOfDay end,
    String room,
  ) {
    setState(() {
      _localSchedules.removeWhere((s) => s.dayOfWeek == dayIndex);
      _localSchedules.add(
        ClassScheduleRequest(
          dayOfWeek: dayIndex,
          startTime: _timeToString(start),
          endTime: _timeToString(end),
          room: room,
        ),
      );
      _localSchedules.sort((a, b) => a.dayOfWeek.compareTo(b.dayOfWeek));
    });
    if (widget.onChanged != null) widget.onChanged!(_localSchedules);
  }

  void _removeSchedule(int dayIndex) {
    setState(() {
      _localSchedules.removeWhere((s) => s.dayOfWeek == dayIndex);
    });
    if (widget.onChanged != null) widget.onChanged!(_localSchedules);
  }

  // --- DIALOG EDIT (Luôn dùng Light Theme cho dễ nhìn) ---
  void _showEditDialog(
    BuildContext context,
    int dayIndex,
    ClassScheduleRequest? currentItem,
  ) {
    TimeOfDay startTime = const TimeOfDay(hour: 19, minute: 0);
    TimeOfDay endTime = const TimeOfDay(hour: 21, minute: 0);
    TextEditingController roomController = TextEditingController();

    if (currentItem != null) {
      startTime = _stringToTime(currentItem.startTime);
      endTime = _stringToTime(currentItem.endTime);
      roomController.text = currentItem.room ?? '';
    }

    // Màu chủ đạo cho Dialog (Tím)
    const primaryDialogColor = Color(0xFF6876A0);

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              title: Text(
                currentItem == null ? "Thêm lịch" : "Sửa lịch",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _getDayFullName(dayIndex),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: primaryDialogColor,
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildTimePickerRow(
                      context,
                      "Bắt đầu",
                      startTime,
                      primaryDialogColor,
                      (p) => setDialogState(() => startTime = p),
                    ),
                    const SizedBox(height: 12),
                    _buildTimePickerRow(
                      context,
                      "Kết thúc",
                      endTime,
                      primaryDialogColor,
                      (p) => setDialogState(() => endTime = p),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: roomController,
                      decoration: InputDecoration(
                        labelText: "Phòng",
                        hintText: "VD: P.101...",
                        prefixIcon: const Icon(
                          Icons.meeting_room,
                          color: Colors.grey,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: primaryDialogColor,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                if (currentItem != null)
                  TextButton(
                    onPressed: () {
                      _removeSchedule(dayIndex);
                      Navigator.pop(context);
                    },
                    style: TextButton.styleFrom(foregroundColor: Colors.red),
                    child: const Text("Xóa"),
                  ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(foregroundColor: Colors.grey),
                  child: const Text("Hủy"),
                ),
                ElevatedButton(
                  onPressed: () {
                    _saveSchedule(
                      dayIndex,
                      startTime,
                      endTime,
                      roomController.text,
                    );
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryDialogColor,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text("Lưu"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildTimePickerRow(
    BuildContext context,
    String label,
    TimeOfDay time,
    Color color,
    Function(TimeOfDay) onPicked,
  ) {
    return InkWell(
      onTap: () async {
        final p = await showTimePicker(
          context: context,
          initialTime: time,
          builder: (context, child) => Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: color,
                onPrimary: Colors.white,
                surface: Colors.white,
                onSurface: Colors.black,
              ),
            ),
            child: child!,
          ),
        );
        if (p != null) onPicked(p);
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
            Text(
              _timeToString(time),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: color,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // UTILS
  String _timeToString(TimeOfDay time) =>
      '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  TimeOfDay _stringToTime(String s) {
    try {
      var p = s.split(':');
      return TimeOfDay(hour: int.parse(p[0]), minute: int.parse(p[1]));
    } catch (e) {
      return TimeOfDay.now();
    }
  }

  String _getDayFullName(int d) => d == 0 ? 'Chủ Nhật' : 'Thứ ${d + 1}';
  String _getDayShortName(int d) => d == 0 ? 'CN' : 'T${d + 1}';
  String _formatTimeShort(String time) {
    final parts = time.split(':');
    if (parts.length >= 2) {
      // Ép kiểu sang int để loại bỏ số 0 đầu (VD: "07" -> 7)
      final hour = int.tryParse(parts[0]) ?? parts[0];

      // Nếu phút là 00 thì chỉ hiện giờ (7h), ngược lại hiện cả phút (7h30)
      if (parts[1] == '00') return '${hour}h';
      return '${hour}h${parts[1]}';
    }
    return time;
  }
}
