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
    final description = descriptionCtrl.text.trim();
    final thumbnail = thumbnailCtrl.text.trim();

    if (name.isEmpty) {
      Get.snackbar(
        'Thiếu thông tin',
        'Vui lòng nhập tên lớp',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        icon: const Icon(Icons.warning_amber_rounded, color: Colors.white),
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

    if (isSuccess) Get.back();
  }

  @override
  Widget build(BuildContext context) {
    // Màu chủ đạo
    const primaryColor = Color(0xFF6C63FF);
    const secondaryColor = Color(0xFF2D3436);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      elevation: 10,
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent, // Fix lỗi ám màu trên Material 3
      child: Container(
        constraints: const BoxConstraints(maxWidth: 550),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // --- HEADER ---
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
                border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.school_rounded,
                      color: primaryColor,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: secondaryColor,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Nhập thông tin chi tiết lớp học",
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.close_rounded),
                    color: Colors.grey,
                    tooltip: "Đóng",
                  ),
                ],
              ),
            ),

            // --- BODY ---
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle(
                      "Thông tin chung",
                      Icons.info_outline_rounded,
                      Colors.blueAccent,
                    ),
                    const SizedBox(height: 16),
                    _buildInputWithIcon(
                      controller: nameCtrl,
                      label: "Tên lớp học",
                      icon: Icons.edit_note_rounded,
                      iconColor: Colors.orangeAccent,
                    ),
                    const SizedBox(height: 16),
                    _buildInputWithIcon(
                      controller: descriptionCtrl,
                      label: "Mô tả",
                      icon: Icons.description_outlined,
                      iconColor: Colors.teal,
                    ),
                    const SizedBox(height: 16),
                    _buildInputWithIcon(
                      controller: thumbnailCtrl,
                      label: "Link hình ảnh",
                      icon: Icons.image_rounded,
                      iconColor: Colors.pinkAccent,
                    ),

                    const SizedBox(height: 30),

                    _buildSectionTitle(
                      "Lịch học",
                      Icons.calendar_month_rounded,
                      Colors.purpleAccent,
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

                    // --- WIDGET LỊCH HỌC ĐƯỢC PHỐI MÀU ---
                    ScheduleWidget(
                      isEditable: true,
                      scheduleInitial: schedule,
                      onChanged: (values) {
                        setState(() {
                          scheduleRequests = values;
                        });
                      },

                      // --- CẤU HÌNH MÀU CHO FORM NỀN TRẮNG ---
                      backgroundColor: const Color(
                        0xFFF8F9FA,
                      ), // Nền xám rất nhạt
                      borderColor: Colors.grey.shade300, // Viền xám

                      activeColor: primaryColor, // Chip màu Tím (Primary)
                      activeTextColor: Colors.white, // Chữ trắng

                      inactiveColor: const Color(
                        0xFFEEEEEE,
                      ), // Chip màu xám nhạt (khi chưa chọn)
                      inactiveTextColor: Colors.grey, // Chữ xám

                      timeColor: primaryColor, // Giờ hiển thị màu Tím
                    ),
                  ],
                ),
              ),
            ),

            // --- FOOTER ---
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Colors.grey.shade100)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: widget.onCancel ?? () => Get.back(),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        foregroundColor: Colors.grey.shade600,
                      ),
                      child: const Text(
                        'Hủy bỏ',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: const LinearGradient(
                          colors: [Color(0xFF6C63FF), Color(0xFF4834D4)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF6C63FF).withOpacity(0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: _onSubmit,
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'LƯU THÔNG TIN',
                              style: AppTextStyles.buttonWhite,
                            ),
                            SizedBox(width: 8),
                            Icon(
                              Icons.arrow_forward_rounded,
                              color: Colors.white,
                              size: 18,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon, Color color) {
    return Row(
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(width: 8),
        Text(
          title.toUpperCase(),
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade700,
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(child: Divider(color: Colors.grey.shade200, thickness: 1)),
      ],
    );
  }

  Widget _buildInputWithIcon({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required Color iconColor,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: CustomTextField(controller: controller, labelText: label),
        ),
      ],
    );
  }
}
