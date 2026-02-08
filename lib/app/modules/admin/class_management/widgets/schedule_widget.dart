import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:blooket/app/data/model/class_model.dart';
import 'package:blooket/app/data/model/request/class/class_request.dart';

class ScheduleWidget extends StatefulWidget {
  const ScheduleWidget({
    super.key,
    required this.scheduleInitial,
    this.onChanged,
    this.isEditable = false,
  });

  final List<ClassSchedule> scheduleInitial;

  final Function(List<ClassScheduleRequest>)? onChanged;

  final bool isEditable;

  @override
  State<ScheduleWidget> createState() => _ScheduleWidgetState();
}

class _ScheduleWidgetState extends State<ScheduleWidget> {
  late List<ClassScheduleRequest> _localSchedules;

  @override
  void initState() {
    super.initState();

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
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: _buildWeekDays(context),
      ),
    );
  }

  List<Widget> _buildWeekDays(BuildContext context) {
    final weekOrder = [1, 2, 3, 4, 5, 6, 0];

    return weekOrder.map((dayIndex) {
      final scheduleItem = _localSchedules.firstWhereOrNull(
        (s) => s.dayOfWeek == dayIndex,
      );

      final isActive = scheduleItem != null;

      String tooltipMessage;
      if (isActive) {
        tooltipMessage =
            '${_getDayFullName(dayIndex)}\n'
            '⏰ ${scheduleItem.startTime} - ${scheduleItem.endTime}';
        if (scheduleItem.room != null && scheduleItem.room!.isNotEmpty) {
          tooltipMessage += '\n📍 ${scheduleItem.room}';
        }
      } else {
        tooltipMessage = '${_getDayFullName(dayIndex)}\n(Chạm để thêm)';
      }

      return Expanded(
        child: GestureDetector(
          onTap: () => widget.isEditable
              ? _showEditDialog(context, dayIndex, scheduleItem)
              : null,

          child: Tooltip(
            message: tooltipMessage,
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(top: 10),
            showDuration: const Duration(seconds: 2),
            decoration: BoxDecoration(
              color: const Color(0xFF2D3436).withOpacity(0.95),
              borderRadius: BorderRadius.circular(8),
            ),
            textStyle: const TextStyle(color: Colors.white, fontSize: 12),
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
        ),
      );
    }).toList();
  }

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

    if (widget.onChanged != null) {
      widget.onChanged!(_localSchedules);
    }
  }

  void _removeSchedule(int dayIndex) {
    setState(() {
      _localSchedules.removeWhere((s) => s.dayOfWeek == dayIndex);
    });
    if (widget.onChanged != null) {
      widget.onChanged!(_localSchedules);
    }
  }

  void _showEditDialog(
    BuildContext context,
    int dayIndex,
    ClassScheduleRequest? currentItem,
  ) {
    TimeOfDay startTime = TimeOfDay(hour: 19, minute: 0);
    TimeOfDay endTime = TimeOfDay(hour: 21, minute: 0);
    TextEditingController roomController = TextEditingController();

    if (currentItem != null) {
      startTime = _stringToTime(currentItem.startTime);
      endTime = _stringToTime(currentItem.endTime);
      roomController.text = currentItem.room ?? '';
    }

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Text(
                currentItem == null ? "Thêm lịch" : "Sửa lịch",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Thứ: ${_getDayFullName(dayIndex)}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey,
                    ),
                  ),
                  const SizedBox(height: 16),

                  _buildTimePickerRow(context, "Bắt đầu", startTime, (picked) {
                    setDialogState(() => startTime = picked);
                  }),

                  _buildTimePickerRow(context, "Kết thúc", endTime, (picked) {
                    setDialogState(() => endTime = picked);
                  }),

                  const SizedBox(height: 8),
                  TextField(
                    controller: roomController,
                    decoration: const InputDecoration(
                      labelText: "Phòng (VD: Google Meet)",
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
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
    Function(TimeOfDay) onPicked,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 14)),
          TextButton(
            onPressed: () async {
              final picked = await showTimePicker(
                context: context,
                initialTime: time,
                builder: (context, child) {
                  return MediaQuery(
                    data: MediaQuery.of(
                      context,
                    ).copyWith(alwaysUse24HourFormat: true),
                    child: child!,
                  );
                },
              );
              if (picked != null) onPicked(picked);
            },
            style: TextButton.styleFrom(
              backgroundColor: Colors.grey.shade100,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            child: Text(
              _timeToString(time),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _timeToString(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  TimeOfDay _stringToTime(String timeStr) {
    try {
      final parts = timeStr.split(':');
      return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
    } catch (e) {
      return TimeOfDay.now();
    }
  }

  String _getDayFullName(int dayIndex) =>
      dayIndex == 0 ? 'Chủ Nhật' : 'Thứ ${dayIndex + 1}';
  String _getDayShortName(int dayIndex) =>
      dayIndex == 0 ? 'CN' : 'T${dayIndex + 1}';

  String _formatTimeShort(String time) {
    final parts = time.split(':');
    if (parts.length >= 2) {
      if (parts[1] == '00') return '${parts[0]}h';
      return '${parts[0]}h${parts[1]}';
    }
    return time;
  }
}
