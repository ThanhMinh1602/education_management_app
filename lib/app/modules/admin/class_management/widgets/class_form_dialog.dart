import 'package:blooket/app/core/components/text_field/custom_text_field.dart';
import 'package:blooket/app/core/constants/app_colors.dart';
import 'package:blooket/app/core/constants/app_text_styles.dart';
import 'package:blooket/app/data/model/class_model.dart';
import 'package:blooket/app/data/model/request/class/class_request.dart';
import 'package:blooket/app/modules/admin/class_management/controller/class_management_controller.dart';
import 'package:blooket/app/modules/admin/class_management/widgets/schedule_widget.dart';
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
  late TextEditingController descriptionCtrl;
  late TextEditingController thumbnailCtrl;

  List<ClassScheduleRequest> scheduleRequests = [];
  List<ClassSchedule> schedule = [];

  @override
  void initState() {
    super.initState();
    nameCtrl = TextEditingController(text: widget.classModel?.name ?? '');
    descriptionCtrl = TextEditingController(
      text: widget.classModel?.description ?? '',
    );
    thumbnailCtrl = TextEditingController(
      text: widget.classModel?.thumbnail ?? '',
    );
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    descriptionCtrl.dispose();
    thumbnailCtrl.dispose();
    super.dispose();
  }

  Future<void> _onSubmit() async {
    FocusScope.of(context).unfocus();

    final name = nameCtrl.text.trim();
    final description = descriptionCtrl.text.trim();
    final thumbnail = thumbnailCtrl.text.trim();

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
      description: description,
      thumbnail: thumbnail,
      schedule: scheduleRequests,
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
              CustomTextField(controller: nameCtrl, labelText: 'Tên lớp'),
              const SizedBox(height: 12),
              CustomTextField(controller: descriptionCtrl, labelText: 'Mô tả'),
              const SizedBox(height: 12),
              CustomTextField(
                controller: thumbnailCtrl,
                labelText: 'Thumbnail',
              ),
              SizedBox(height: 20.0),
              ScheduleWidget(
                isEditable: true,
                scheduleInitial: schedule,
                onChanged: (values) {
                  values.map((e) => print(e));
                  setState(() {
                    scheduleRequests = values;
                  });
                },
              ),
              SizedBox(height: 20.0),
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
