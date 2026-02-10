import 'package:blooket/app/core/components/dialog/base_form_dialog.dart';
import 'package:blooket/app/core/components/dialog/form_common_widgets.dart';
import 'package:blooket/app/core/constants/app_color.dart';
import 'package:blooket/app/data/model/class_model.dart';
import 'package:blooket/app/data/model/request/class/class_request.dart';
import 'package:blooket/app/modules/admin/class_management/controller/class_management_controller.dart';
import 'package:blooket/app/modules/admin/class_management/widgets/schedule_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ClassFormWidget extends StatefulWidget {
  final ClassModel? classModel;
  final ClassManagementController controller;

  const ClassFormWidget({super.key, this.classModel, required this.controller});

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
    // Logic khởi tạo dữ liệu giữ nguyên
    nameCtrl = TextEditingController(text: widget.classModel?.name ?? '');
    descriptionCtrl = TextEditingController(
      text: widget.classModel?.description ?? '',
    );
    thumbnailCtrl = TextEditingController(
      text: widget.classModel?.thumbnail ?? '',
    );

    if (widget.classModel != null) {
      schedule = widget.classModel!.schedule;
      scheduleRequests = schedule
          .map(
            (e) => ClassScheduleRequest(
              dayOfWeek: e.dayOfWeek,
              startTime: e.startTime,
              endTime: e.endTime,
              room: e.room,
            ),
          )
          .toList();
    }
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

    if (name.isEmpty) {
      Get.snackbar(
        'Cảnh báo',
        'Vui lòng nhập tên lớp',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    final request = ClassRequest(
      name: name,
      description: descriptionCtrl.text.trim(),
      thumbnail: thumbnailCtrl.text.trim(),
      schedule: scheduleRequests,
    );

    bool isSuccess;
    if (widget.classModel != null) {
      isSuccess = await widget.controller.updateClass(
        id: widget.classModel!.id,
        classRequest: request,
      );
    } else {
      isSuccess = await widget.controller.createClass(request);
    }

    if (isSuccess) Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return BaseFormDialog(
      title: widget.classModel != null ? 'CẬP NHẬT LỚP HỌC' : 'THÊM LỚP MỚI',
      subtitle: widget.classModel != null
          ? 'Chỉnh sửa thông tin lớp học hiện tại'
          : 'Nhập thông tin để tạo lớp học mới',
      icon: Icons.school_rounded,
      onSave: _onSubmit,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Phần 1: Thông tin chung
          const FormSectionTitle(
            title: "Thông tin chung",
            icon: Icons.info_outline_rounded,
            color: Colors.blueAccent,
          ),
          const SizedBox(height: 16),

          FormInputWithIcon(
            controller: nameCtrl,
            label: "Tên lớp học",
            icon: Icons.edit_note_rounded,
            iconColor: Colors.orangeAccent,
          ),
          const SizedBox(height: 16),

          FormInputWithIcon(
            controller: descriptionCtrl,
            label: "Mô tả",
            icon: Icons.description_outlined,
            iconColor: Colors.teal,
            maxLines: 2,
          ),
          const SizedBox(height: 16),

          FormInputWithIcon(
            controller: thumbnailCtrl,
            label: "Link hình ảnh",
            icon: Icons.image_rounded,
            iconColor: Colors.pinkAccent,
          ),

          const SizedBox(height: 30),

          // Phần 2: Lịch học
          const FormSectionTitle(
            title: "Lịch học",
            icon: Icons.calendar_month_rounded,
            color: Colors.purpleAccent,
          ),
          const SizedBox(height: 4),
          const Text(
            "Chạm vào các ngày trong tuần để thêm/sửa giờ học.",
            style: TextStyle(
              color: Colors.grey,
              fontSize: 13,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 16),

          // Widget Lịch học
          ScheduleWidget(
            isEditable: true,
            scheduleInitial: schedule,
            onChanged: (values) => scheduleRequests = values,
            backgroundColor: const Color(0xFFF8F9FA),
            borderColor: Colors.grey.shade300,
            activeColor: AppColor.primary,
            activeTextColor: Colors.white,
            inactiveTextColor: AppColor.primary,
            timeColor: AppColor.primary,
          ),
        ],
      ),
    );
  }
}
