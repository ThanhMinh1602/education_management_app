import 'dart:ui';
import 'package:blooket/app/core/components/header/custom_page_header.dart';
import 'package:blooket/app/core/utils/dialogs.dart';
import 'package:blooket/app/core/utils/ui_dialogs.dart';
import 'package:blooket/app/data/model/question_model.dart';
import 'package:blooket/app/data/model/request/create_question_request.dart';
import 'package:blooket/app/modules/admin/question_management/views/question_dialog_view.dart';
import 'package:blooket/app/modules/admin/question_management/widgets/question_list_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:blooket/app/core/components/button/custom_action_button.dart';
import 'package:blooket/app/core/constants/app_color.dart';
import 'package:blooket/app/core/components/appbar/custom_app_bar.dart';
import 'package:blooket/app/modules/admin/question_management/controller/question_management_detail_controller.dart';

class QuestionManagementDetailView
    extends GetView<QuestionManagementDetailController> {
  const QuestionManagementDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: controller.bgColor,
      appBar: const CustomAppBar(title: 'Chi Tiết Bộ Đề'),
      body: Padding(
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start, // Căn lề trên cùng
          children: [
            // Cột bên trái: Menu điều khiển
            SizedBox(
              width: 320, // Fix chiều rộng cho cột trái để giao diện ổn định
              child: _buildLeftWidget(),
            ),

            const SizedBox(width: 20), // Khoảng cách giữa 2 cột
            // Cột bên phải: Nội dung chính (Placeholder màu hồng)
            Expanded(flex: 2, child: _buildRightWidget()),
          ],
        ),
      ),
    );
  }

  Widget _buildRightWidget() {
    return Column(
      children: [
        CustomPageHeader(
          extraWidget: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
            ),
            child: Obx(
              () => Text(
                '${controller.questions.length} câu hỏi',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            ),
          ),
          subtitle: 'Quản lý các câu hỏi trong bộ đề',
          buttonLabel: 'Thêm câu hỏi mới',
          onButtonPressed: () {
            Get.dialog(
              barrierDismissible: false,
              QuestionDialogView(
                setId: controller.setId,
                onSave: (questionModel) {
                  controller.addQuestion(questionModel);
                },
              ),
            );
          },
        ),
        const SizedBox(height: 20),
        Expanded(
          child: Obx(
            () => ListView.separated(
              itemCount: controller.questions.length,
              itemBuilder: (context, index) {
                final question = controller.questions[index];

                return QuestionListItem(
                  index: index,
                  questionModel: question,
                  onEdit: () {
                    Get.dialog(
                      barrierDismissible: false,
                      QuestionDialogView(
                        setId: controller.setId,
                        initialData: question,
                        onSave: (formData) {
                          final updateRequest = QuestionRequest(
                            content: formData.content,
                            timeLimit: formData.timeLimit,
                            isRandom: formData.isRandom,
                            options: formData.options,
                            answers: formData.answers,
                            type: formData.type,
                          );
                          controller.updateQuestion(updateRequest, question.id);
                        },
                      ),
                    );
                  },
                  onDelete: () {
                    AppDialogs.showDeleteConfirm(
                      onConfirm: () => controller.deleteQuestion(question.id),
                    );
                  },
                  onCopy: () {},
                  onUp: () {},
                  onDown: () {},
                );
              },
              separatorBuilder: (_, __) => const SizedBox(height: 12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLeftWidget() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColor.primary,
        borderRadius: BorderRadius.circular(20),
        // Thêm bóng đổ nhẹ cho nổi khối
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Ôm sát nội dung
        children: [
          // 1. Tên bộ đề
          Text(
            controller.setName,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 24), // Khoảng cách
          // 2. Nút Save (Nút chính)
          CustomActionButton(
            width: double.infinity, // Tự động giãn full chiều ngang
            onTap: () => Get.back(),
            icon: Icons.save_outlined,
            text: 'SAVE',
          ),

          const SizedBox(height: 16), // Khoảng cách
          // 3. Hai nút phụ (Hiệu ứng kính)
          Row(
            children: [
              // Nút Edit
              Expanded(
                child: _buildGlassButton(
                  icon: Icons.edit_outlined,
                  text: 'Chỉnh sửa',
                  onTap: () async {
                    final result = await UiDialogs.showQuestionSetName(
                      title: 'Sửa tên bộ đề',
                      initial: controller.setName,
                    );
                  },
                ),
              ),

              const SizedBox(width: 12), // Khoảng cách giữa 2 nút nhỏ
              // Nút Time Limit
              Expanded(
                child: _buildGlassButton(
                  icon: Icons.timer_outlined,
                  text: 'Thời gian',
                  onTap: () {
                    AppDialogs.showDeveloping();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Widget tạo nút hiệu ứng kính mờ (Frosted Glass)
  Widget _buildGlassButton({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    // ClipRRect để bo góc cho hiệu ứng mờ không bị tràn
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0), // Độ nhòe kính
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                // Màu trắng mờ (độ trong suốt thấp vì đã có blur)
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(16),
                // Viền trắng mờ tạo cảm giác kính dày
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 1.5,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, color: Colors.white, size: 22),
                  const SizedBox(height: 6),
                  Text(
                    text,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
