// create_assignment_dialog.dart
import 'package:blooket/app/core/components/custom_date_time_picker.dart';
import 'package:blooket/app/core/components/dropdown/custom_dropdown_field.dart';
import 'package:blooket/app/core/components/text_field/custom_text_field.dart';
import 'package:blooket/app/data/model/request/assignments/assignment_settings.dart';
import 'package:blooket/app/data/model/request/assignments/create_assignment_request.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  // Controllers
  final titleCtrl = TextEditingController();
  final durationCtrl = TextEditingController(text: "45"); // Mặc định 45 phút
  final attemptsCtrl = TextEditingController(text: "1"); // Mặc định 1 lần

  // Selection Variables
  String? selectedClassId;
  String? selectedPackId;
  DateTime? selectedDate;
  bool showResultImmediately = true;

  late AssignmentController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<AssignmentController>();
    // Gọi lại fetch data nếu cần đảm bảo dữ liệu mới nhất
    // controller.fetchDropdownData();
  }

  Future<void> _pickDateTime(BuildContext context) async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: now.add(const Duration(days: 1)),
      firstDate: now,
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
        selectedPackId == null ||
        selectedDate == null) {
      Get.snackbar(
        "Thiếu thông tin",
        "Vui lòng chọn Lớp, Bộ đề và Hạn nộp",
        backgroundColor: Colors.orange.withOpacity(0.8),
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // 1. Tạo Settings
    final settings = AssignmentSettings(
      showResultImmediately: showResultImmediately,
      maxAttempts: int.tryParse(attemptsCtrl.text) ?? 1,
      durationMinutes: int.tryParse(durationCtrl.text) ?? 45,
    );

    // 2. Tạo Request
    final request = CreateAssignmentRequest(
      title: titleCtrl.text.trim(),
      classId: selectedClassId!,
      questionPackId: selectedPackId!,
      dueDate: selectedDate!,
      settings: settings,
    );

    // 3. Gọi Controller
    final success = await controller.createAssignment(request);
    if (success) Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 600),
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Giao Bài Tập Mới',
                  style: AppTextStyles.dialogTitle,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),

                // --- THÔNG TIN CHUNG ---
                CustomTextField(
                  controller: titleCtrl,
                  validator: (v) =>
                      v!.isEmpty ? 'Vui lòng nhập tên bài tập' : null,
                  labelText: 'Tên bài tập',
                ),
                const SizedBox(height: 16),

                Row(
                  children: [
                    // Dropdown chọn Lớp
                    Expanded(
                      child: Obx(
                        () => CustomDropdownField<String>(
                          labelText: 'Lớp học',
                          prefixIcon: Icons.class_outlined,
                          value: selectedClassId,
                          items: controller.availableClasses.map((e) {
                            return DropdownMenuItem(
                              value: e.id,
                              child: Text(
                                e.name, // Sửa thành field name đúng trong ClassModel
                                overflow: TextOverflow.ellipsis,
                              ),
                            );
                          }).toList(),
                          onChanged: (val) =>
                              setState(() => selectedClassId = val),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Dropdown chọn Bộ đề
                    Expanded(
                      child: Obx(
                        () => CustomDropdownField<String>(
                          labelText: 'Bộ đề',
                          prefixIcon: Icons.quiz_outlined,
                          value: selectedPackId,
                          items: controller.availablePacks.map((e) {
                            return DropdownMenuItem(
                              value: e.id,
                              child: Text(
                                e.title, // Sửa thành field title trong PackModel
                                overflow: TextOverflow.ellipsis,
                              ),
                            );
                          }).toList(),
                          onChanged: (val) =>
                              setState(() => selectedPackId = val),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                InkWell(
                  onTap: () => _pickDateTime(context),
                  child: CustomDateTimePicker(
                    labelText: 'Hạn chót (Deadline)',
                    selectedDate: selectedDate,
                    onTap: () => _pickDateTime(context),
                  ),
                ),

                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 12),

                // --- CÀI ĐẶT NÂNG CAO (AssignmentSettings) ---
                const Text(
                  "Cài đặt bài tập",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 16),

                Row(
                  children: [
                    // Thời gian làm bài
                    Expanded(
                      child: CustomTextField(
                        controller: durationCtrl,
                        labelText: 'Thời gian (phút)',
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        suffixIcon: const Icon(Icons.timer_outlined, size: 20),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Số lần làm bài
                    Expanded(
                      child: CustomTextField(
                        controller: attemptsCtrl,
                        labelText: 'Số lần làm tối đa',
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        suffixIcon: const Icon(Icons.repeat_rounded, size: 20),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Switch: Xem kết quả ngay
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text("Xem kết quả ngay sau khi nộp"),
                  subtitle: const Text("Học sinh sẽ biết điểm ngay lập tức"),
                  value: showResultImmediately,
                  activeColor: AppColors.primary,
                  onChanged: (val) =>
                      setState(() => showResultImmediately = val),
                ),

                const SizedBox(height: 32),

                // --- ACTIONS ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: Get.back,
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16,
                        ),
                      ),
                      child: const Text(
                        'Hủy bỏ',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: _submit,
                      child: const Text(
                        'GIAO BÀI TẬP',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
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
