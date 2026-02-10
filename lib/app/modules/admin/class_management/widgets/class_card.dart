import 'package:blooket/app/core/components/card/base_info_card_wrapper.dart';
import 'package:blooket/app/core/components/card/info_card_badge.dart';
import 'package:blooket/app/core/components/card/info_card_editable_field.dart';
import 'package:blooket/app/data/model/class_model.dart';
import 'package:blooket/app/data/model/request/class/class_request.dart';
import 'package:blooket/app/modules/admin/class_management/widgets/schedule_widget.dart';
import 'package:flutter/material.dart';
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

  final Function(ClassRequest request)? onSave;

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
    this.onSave,
  });

  @override
  State<ClassCard> createState() => _ClassCardState();
}

class _ClassCardState extends State<ClassCard> {
  late TextEditingController _nameCtrl;
  late TextEditingController _descCtrl;

  bool? _tempIsActive;
  List<ClassScheduleRequest>? _tempScheduleRequest;

  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  void _initData() {
    _nameCtrl = TextEditingController(text: _getName());
    _descCtrl = TextEditingController(
      text: widget.classModel?.description ?? '',
    );
    _tempIsActive = widget.classModel?.isActive;
    _tempScheduleRequest = null;
  }

  @override
  void didUpdateWidget(covariant ClassCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.classModel != oldWidget.classModel && !_isEditing) {
      _initData();
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

  void _handleSubmit() {
    if (_isEditing) {
      FocusScope.of(context).unfocus();
      final request = ClassRequest(
        name: _nameCtrl.text != widget.classModel?.name ? _nameCtrl.text : null,
        description: _descCtrl.text != widget.classModel?.description
            ? _descCtrl.text
            : null,
        isActive: _tempIsActive != widget.classModel?.isActive
            ? _tempIsActive
            : null,
        schedule: _tempScheduleRequest,
      );

      if (widget.onSave != null) {
        widget.onSave!(request);
      }
    }
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseInfoCardWrapper(
      isDetail: widget.isDetail,
      isEditing: _isEditing,
      onToggleEdit: _handleSubmit,
      child: widget.isDetail ? _buildDetailContent() : _buildListContent(),
    );
  }

  Widget _buildListContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildHeaderCompact(),
        const SizedBox(height: 16),
        Expanded(child: _buildBodyCompact()),
        if (widget.onEnterClass != null) _buildFooterCompact(),
      ],
    );
  }

  Widget _buildDetailContent() {
    return Column(
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
                  ),
                  border: Border.all(color: Colors.white24),
                ),
              ),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      InfoCardBadge(label: "CODE", content: _getCode()),
                      const SizedBox(width: 12),

                      if (_isEditing)
                        Transform.scale(
                          scale: 0.8,
                          child: Switch(
                            value: _tempIsActive ?? true,
                            activeColor: const Color(0xFF00B894),
                            onChanged: (val) =>
                                setState(() => _tempIsActive = val),
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

        const SizedBox(height: 16),

        _isEditing
            ? InfoCardEditableField(
                controller: _nameCtrl,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                ),
                hint: "Tên lớp học",
              )
            : Text(
                _nameCtrl.text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                ),
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
        _isEditing
            ? Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white12),
                ),
                child: InfoCardEditableField(
                  controller: _descCtrl,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    height: 1.4,
                  ),
                  hint: "Chưa có mô tả...",
                  maxLines: 3,
                ),
              )
            : Text(
                _descCtrl.text.isEmpty ? "Chưa có mô tả..." : _descCtrl.text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  height: 1.4,
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
          isEditable: _isEditing,
          onChanged: (newSchedules) => _tempScheduleRequest = newSchedules,
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
              InfoCardBadge(label: "CODE", content: _getCode()),
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
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildFooterCompact() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: widget.onEnterClass,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFEDBBC6),
          foregroundColor: const Color(0xFF6A4C53),
          padding: const EdgeInsets.symmetric(vertical: 12),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
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
          'Học viên: ${_getCount()}',
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
