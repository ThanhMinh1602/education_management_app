import 'package:blooket/app/core/components/custom_date_time_picker.dart';
import 'package:blooket/app/core/components/dropdown/custom_dropdown_field.dart';
import 'package:blooket/app/core/components/text_field/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:blooket/app/core/constants/app_colors.dart';
import 'package:blooket/app/core/constants/app_text_styles.dart';
import '../controllers/assignment_controller.dart';

class CreateAssignmentDialog extends StatefulWidget {
  const CreateAssignmentDialog({super.key});

  @override
  State<CreateAssignmentDialog> createState() => _CreateAssignmentDialogState();
}

class _CreateAssignmentDialogState extends State<CreateAssignmentDialog> {
  final _formKey = GlobalKey<FormState>();
  final titleCtrl = TextEditingController();
  final descCtrl = TextEditingController();

  String? selectedClassId;
  String? selectedSetId;
  DateTime? selectedDate;

  late AssignmentController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<AssignmentController>();
  }

  Future<void> _pickDateTime(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );
    if (date == null) return;

    if (!context.mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 23, minute: 59),
    );
    if (time == null) return;

    setState(() {
      selectedDate = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (selectedClassId == null ||
        selectedSetId == null ||
        selectedDate == null) {
      Get.snackbar(
        "Thiếu thông tin",
        "Vui lòng chọn đầy đủ Lớp, Bộ đề và Hạn nộp",
        backgroundColor: Colors.orange.withOpacity(0.5),
      );
      return;
    }

    final success = await controller.createAssignment(
      title: titleCtrl.text.trim(),
      description: descCtrl.text.trim(),
      classId: selectedClassId!,
      setId: selectedSetId!,
      dueDate: selectedDate!,
    );

    if (success) Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 550),
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Giao bài tập mới',
                  style: AppTextStyles.dialogTitle,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                CustomTextField(
                  controller: titleCtrl,
                  validator: (v) => v!.isEmpty ? 'Nhập tiêu đề' : null,
                  labelText: 'Tên bài tập',
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: descCtrl,
                  labelText: 'Mô tả/Ghi chú',
                ),
                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: Obx(
                        () => CustomDropdownField<String>(
                          labelText: 'Chọn lớp học',
                          prefixIcon: Icons.class_outlined,
                          value: selectedClassId,
                          items: controller.availableClasses.map((e) {
                            return DropdownMenuItem<String>(
                              value: e.id,
                              child: Text(
                                e.name ?? 'Lớp không rõ',
                                style: const TextStyle(fontSize: 16),
                                overflow: TextOverflow.ellipsis,
                              ),
                            );
                          }).toList(),
                          onChanged: (val) {
                            setState(() => selectedClassId = val);
                          },
                          validator: (v) =>
                              v == null ? 'Vui lòng chọn lớp' : null,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Obx(
                        () => CustomDropdownField<String>(
                          value: selectedSetId,
                          items: controller.availableSets
                              .map(
                                (e) => DropdownMenuItem(
                                  value: e.id,
                                  child: Text(
                                    e.name ?? '',
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (val) =>
                              setState(() => selectedSetId = val),
                          validator: (v) => v == null ? 'Chọn bộ đề' : null,
                          labelText: 'Chọn bộ đề',
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                InkWell(
                  onTap: () => _pickDateTime(context),
                  child: CustomDateTimePicker(
                    labelText: 'Hạn chót nộp bài (Deadline)',
                    selectedDate: selectedDate,
                    onTap: () => _pickDateTime(context),
                  ),
                ),

                const SizedBox(height: 32),

                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: Get.back,
                        child: const Text('Hủy'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.action,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        onPressed: _submit,
                        child: const Text(
                          'GIAO BÀI',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
