import 'package:blooket/app/data/model/class_model.dart';
import 'package:blooket/app/data/model/request/class/class_request.dart';
import 'package:blooket/app/modules/admin/class_management/widgets/schedule_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ClassCard extends StatefulWidget {
  final ClassModel? classModel;
  final bool isDetail;

  final String? className;
  final String? code;
  final int? studentCount;
  final List<ClassSchedule>? schedule;

  final VoidCallback? onEnterClass;
  final VoidCallback? onDelete;
  final Function(String)? onNameChanged;
  final Function(String)? onDescriptionChanged;
  final Function(bool)? onStatusChanged;
  final Function(List<ClassScheduleRequest>)? onScheduleChanged;

  const ClassCard({
    super.key,
    this.classModel,
    this.isDetail = false,
    this.className,
    this.code,
    this.studentCount,
    this.schedule,
    this.onEnterClass,
    this.onDelete,
    this.onNameChanged,
    this.onDescriptionChanged,
    this.onStatusChanged,
    this.onScheduleChanged,
  });

  @override
  State<ClassCard> createState() => _ClassCardState();
}

class _ClassCardState extends State<ClassCard> {
  late TextEditingController _nameCtrl;
  late TextEditingController _descCtrl;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: _getName());
    _descCtrl = TextEditingController(
      text: widget.classModel?.description ?? '',
    );
  }

  @override
  void didUpdateWidget(covariant ClassCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.classModel?.name != oldWidget.classModel?.name) {
      _nameCtrl.text = widget.classModel?.name ?? '';
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  String _getName() =>
      widget.classModel?.name ?? widget.className ?? 'Unknown Class';
  String _getCode() => widget.classModel?.code ?? widget.code ?? '---';
  int _getCount() =>
      widget.classModel?.studentCount ?? widget.studentCount ?? 0;
  List<ClassSchedule> _getSchedule() =>
      widget.classModel?.schedule ?? widget.schedule ?? [];
  String? _getTeacher() => widget.classModel?.teacher?.name;

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
            Positioned(
              top: -30,
              right: -30,
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  shape: BoxShape.circle,
                ),
              ),
            ),

            widget.isDetail
                ? _buildContent(context)
                : Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 16, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildHeaderCompact(),
                        const SizedBox(height: 16),
                        Expanded(child: _buildBodyCompact()),
                        if (widget.onEnterClass != null) _buildFooterCompact(),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCompact() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCodeBadge(_getCode()),
              const SizedBox(height: 8),
              Text(
                _getName(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),
              if (_getTeacher() != null) ...[
                const SizedBox(height: 4),
                _buildTeacherRow(_getTeacher()!),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBodyCompact() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ScheduleWidget(scheduleInitial: _getSchedule()),
        const Spacer(),
        _buildStudentCountRow(),
      ],
    );
  }

  Widget _buildFooterCompact() {
    return ElevatedButton(
      onPressed: widget.onEnterClass,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFEDBBC6),
        foregroundColor: const Color(0xFF6A4C53),
        padding: const EdgeInsets.symmetric(vertical: 12),
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'XEM LỚP HỌC',
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
          ),
          SizedBox(width: 8),
          Icon(Icons.arrow_forward_rounded, size: 16),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.classModel?.thumbnail.isNotEmpty == true)
                Container(
                  width: 60,
                  height: 60,
                  margin: const EdgeInsets.only(right: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: NetworkImage(widget.classModel!.thumbnail),
                      fit: BoxFit.cover,
                      onError: (_, __) {},
                    ),
                    border: Border.all(color: Colors.white24),
                  ),
                ),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildCodeBadge(_getCode()),
                        Transform.scale(
                          scale: 0.8,
                          child: Switch(
                            value: widget.classModel?.isActive ?? true,
                            activeColor: const Color(0xFF00B894),
                            onChanged: widget.onStatusChanged,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (_getTeacher() != null) _buildTeacherRow(_getTeacher()!),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),
          _buildEditableField(
            controller: _nameCtrl,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w800,
            ),
            hint: "Tên lớp học",
            onChanged: widget.onNameChanged,
          ),

          const SizedBox(height: 20),

          const Text(
            "Mô tả:",
            style: TextStyle(
              color: Colors.white70,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white12),
            ),
            child: _buildEditableField(
              controller: _descCtrl,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                height: 1.4,
              ),
              hint: "Chưa có mô tả...",
              maxLines: 3,
              onChanged: widget.onDescriptionChanged,
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            "Lịch học:",
            style: TextStyle(
              color: Colors.white70,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          ScheduleWidget(
            scheduleInitial: _getSchedule(),
            onChanged: widget.onScheduleChanged,
            isEditable: widget.isDetail,
          ),

          const SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStudentCountRow(),
              if (widget.classModel?.createdAt != null)
                Tooltip(
                  message:
                      "Ngày tạo: ${DateFormat('dd/MM/yyyy HH:mm').format(widget.classModel!.createdAt!)}",
                  child: Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        color: Colors.white38,
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        DateFormat(
                          'dd/MM/yyyy',
                        ).format(widget.classModel!.createdAt!),
                        style: const TextStyle(
                          color: Colors.white38,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCodeBadge(String code) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(6),
        onTap: () {
          Clipboard.setData(ClipboardData(text: code));
          Get.snackbar(
            "Sao chép",
            "Code: $code",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.black54,
            colorText: Colors.white,
            duration: const Duration(seconds: 1),
            margin: const EdgeInsets.all(10),
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.2),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
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
              const Icon(Icons.copy_rounded, color: Colors.white70, size: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTeacherRow(String name) {
    return Row(
      children: [
        const Icon(Icons.person_rounded, color: Colors.white70, size: 14),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            name,
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
    );
  }

  Widget _buildStudentCountRow() {
    return Row(
      children: [
        const Icon(Icons.people_alt_rounded, color: Colors.white60, size: 16),
        const SizedBox(width: 6),
        Text(
          '${_getCount()} học viên',
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildEditableField({
    required TextEditingController controller,
    required TextStyle style,
    String? hint,
    int maxLines = 1,
    Function(String)? onChanged,
  }) {
    return TextFormField(
      controller: controller,
      style: style,
      maxLines: maxLines,
      onChanged: onChanged,
      cursorColor: const Color(0xFFFFE082),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: style.copyWith(color: Colors.white30),
        border: InputBorder.none,
        isDense: true,
        contentPadding: EdgeInsets.zero,
      ),
    );
  }
}
