import 'package:blooket/app/core/constants/app_colors.dart';
import 'package:blooket/app/core/constants/app_text_styles.dart';
import 'package:blooket/app/data/model/class_model.dart';
import 'package:blooket/app/data/model/request/class/class_request.dart';
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
  late TextEditingController scheduleCtrl;

  @override
  void initState() {
    super.initState();
    nameCtrl = TextEditingController(text: widget.classModel?.name ?? '');

    scheduleCtrl = TextEditingController(
      text: widget.classModel?.description ?? '',
    );
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    scheduleCtrl.dispose();
    super.dispose();
  }

  Future<void> _onSubmit() async {
    FocusScope.of(context).unfocus();

    final name = nameCtrl.text.trim();
    final schedule = scheduleCtrl.text.trim();

    if (name.isEmpty) {
      Get.snackbar(
        'Thiếu thông tin',
        'Vui lòng nhập tên lớp',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withOpacity(0.1),
        colorText: Colors.red,
        margin: const EdgeInsets.all(10),
      );
      return;
    }

    final request = ClassRequest(
      name: name,
      description: schedule,
      thumbnail:
          'https://media.istockphoto.com/id/1425103315/vi/anh/ng%C6%B0%E1%BB%9Di-ph%E1%BB%A5-n%E1%BB%AF-ch%C3%A2u-%C3%A1-m%E1%BA%B7c-v%C4%83n-h%C3%B3a-vi%E1%BB%87t-nam-truy%E1%BB%81n-th%E1%BB%91ng-t%E1%BA%A1i-tam-c%E1%BB%91c-vi%E1%BB%87t-nam.jpg?s=612x612&w=0&k=20&c=xZDKlDmMiYEv7r5z0KNgMYfEe19Ozr7s1JXc040TR0Y=',
    );

    bool isSuccess = false;

    if (widget.classModel != null) {
      isSuccess = await widget.controller.updateClass(
        id: widget.classModel!.id,
        classRequest: request,
      );
    } else {
      isSuccess = await widget.controller.createClass(request);
    }

    if (isSuccess) {
      Get.back();
    }
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
                      onPressed: _onSubmit,
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
