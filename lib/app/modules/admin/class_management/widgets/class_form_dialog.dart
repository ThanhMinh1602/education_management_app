import 'package:blooket/app/core/constants/app_colors.dart';
import 'package:blooket/app/core/constants/app_text_styles.dart';
import 'package:blooket/app/data/model/class_model.dart';
import 'package:blooket/app/modules/admin/class_management/controller/class_management_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ClassFormWidget extends StatefulWidget {
  final String title;
  final ClassModel? classModel;
  final VoidCallback? onCancel;
  final ClassManagementController controller;

  const ClassFormWidget({
    super.key,
    this.title = 'THÊM LỚP MỚI',
    this.classModel,
    this.onCancel,
    required this.controller,
  });

  @override
  State<ClassFormWidget> createState() => _ClassFormWidgetState();
}

class _ClassFormWidgetState extends State<ClassFormWidget> {
  late TextEditingController nameCtrl;
  late TextEditingController subjectCtrl;
  late TextEditingController scheduleCtrl;

  @override
  void initState() {
    super.initState();
    nameCtrl = TextEditingController(text: widget.classModel?.name ?? '');
    subjectCtrl = TextEditingController(text: widget.classModel?.subject ?? '');
    scheduleCtrl = TextEditingController(
      text: widget.classModel?.schedule ?? '',
    );
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    subjectCtrl.dispose();
    scheduleCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(widget.title, style: AppTextStyles.dialogTitle),
              const SizedBox(height: 16),

              TextField(
                controller: nameCtrl,
                decoration: InputDecoration(
                  labelText: 'Tên lớp (VD: Tiếng Trung K15)',
                  prefixIcon: const Icon(
                    Icons.class_,
                    color: AppColors.primary,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                ),
              ),
              const SizedBox(height: 12),

              TextField(
                controller: subjectCtrl,
                decoration: InputDecoration(
                  labelText: 'Môn học (VD: HSK 3)',
                  prefixIcon: const Icon(Icons.book, color: AppColors.primary),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: scheduleCtrl,
                decoration: InputDecoration(
                  labelText: 'Lịch học (VD: 2-4-6 19:30)',
                  prefixIcon: const Icon(
                    Icons.access_time,
                    color: AppColors.primary,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                ),
              ),
              const SizedBox(height: 18),

              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: widget.onCancel ?? () => Get.back(),
                      child: const Text(
                        'Hủy',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.action,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () async {
                        final name = nameCtrl.text.trim();
                        final subject = subjectCtrl.text.trim();
                        final schedule = scheduleCtrl.text.trim();

                        if (name.isEmpty &&
                            subject.isEmpty &&
                            schedule.isEmpty) {
                          Get.snackbar(
                            'Lỗi',
                            'Vui lòng nhập tên lớp',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.redAccent.withOpacity(0.1),
                            colorText: Colors.red,
                          );
                          return;
                        }
                        if (widget.classModel != null) {
                          final success = await widget.controller.updateClass(
                            id: widget.classModel!.id,
                            classModel: ClassModel.create(
                              name: name,
                              subject: subject,
                              schedule: schedule,
                            ),
                          );
                          if (success) {
                            Get.back();
                          }
                        } else {
                          final success = await widget.controller.createClass(
                            ClassModel.create(
                              name: name,
                              subject: subject,
                              schedule: schedule,
                            ),
                          );
                          if (success) {
                            Get.back();
                          }
                        }
                      },
                      child: const Text(
                        'LƯU',
                        style: AppTextStyles.buttonWhite,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
