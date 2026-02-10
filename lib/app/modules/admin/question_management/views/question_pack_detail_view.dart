import 'dart:ui';

import 'package:blooket/app/core/components/header/custom_page_header.dart';
import 'package:blooket/app/core/utils/dialogs.dart';
import 'package:blooket/app/core/utils/ui_dialogs.dart';
import 'package:blooket/app/modules/admin/question_management/views/question_dialog_view.dart';
import 'package:blooket/app/modules/admin/question_management/widgets/question_list_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:blooket/app/core/components/button/custom_action_button.dart';
import 'package:blooket/app/core/constants/app_color.dart';
import 'package:blooket/app/core/components/appbar/custom_app_bar.dart';
import 'package:blooket/app/modules/admin/question_management/controller/question_pack_detail_controller.dart';
import 'package:intl/intl.dart';

class QuestionPackDetailView extends GetView<QuestionPackDetailController> {
  const QuestionPackDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: controller.bgColor,
      appBar: const CustomAppBar(title: 'Chi Tiết Bộ Đề'),
      body: Padding(
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(width: 320, child: _buildLeftWidget()),
            const SizedBox(width: 20),
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
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          subtitle: 'Quản lý các câu hỏi trong bộ đề',
          buttonLabel: 'Thêm câu hỏi mới',
          onButtonPressed: () {
            // SHOW DIALOG TẠO MỚI
            Get.dialog(
              barrierDismissible: false,
              QuestionDialogView(
                packId: controller.packsId,
                onSave: (request) async {
                  await controller.addQuestion(request);
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
                      QuestionDialogView(
                        packId: controller.packsId,

                        initialData: question, // TRUYỀN DỮ LIỆU CŨ VÀO ĐÂY

                        onSave: (request) async {
                          // request lúc này là UpdateQuestionRequest
                          await controller.updateQuestion(request, question.id);
                        },
                      ),
                      barrierDismissible: false,
                    );
                  },
                  onDelete: () {
                    AppDialogs.showDeleteConfirm(
                      onConfirm: () => controller.deleteQuestion(question.id),
                    );
                  },
                  onCopy: () {}, // Logic copy nếu cần
                  onUp: () {}, // Logic sắp xếp nếu cần
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
    return Obx(() {
      final pack = controller.questionPackModel.value;

      // Nếu chưa load xong data thì hiện loading hoặc rỗng
      if (pack == null) {
        return const Center(
          child: CircularProgressIndicator(color: AppColor.primary),
        );
      }

      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColor.primary,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Thumbnail Image
            Center(
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                  image: pack.thumbnail.isNotEmpty
                      ? DecorationImage(
                          image: NetworkImage(pack.thumbnail),
                          fit: BoxFit.cover,
                        )
                      : null,
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 2,
                  ),
                ),
                child: pack.thumbnail.isEmpty
                    ? const Icon(
                        Icons.image_not_supported_outlined,
                        color: Colors.white70,
                        size: 40,
                      )
                    : null,
              ),
            ),

            const SizedBox(height: 16),

            // 2. Title & Status
            Center(
              child: Column(
                children: [
                  Text(
                    pack.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildStatusBadge(pack.isPublic),
                ],
              ),
            ),

            const SizedBox(height: 24),
            const Divider(color: Colors.white24, height: 1),
            const SizedBox(height: 20),

            // 3. Metadata Info (Level, Teacher, Date)
            _buildInfoRow(Icons.layers_rounded, "Level:", pack.levelName),
            const SizedBox(height: 12),
            _buildInfoRow(Icons.person_rounded, "Giáo viên:", pack.teacherName),
            const SizedBox(height: 12),
            if (pack.createdAt != null)
              _buildInfoRow(
                Icons.calendar_month_rounded,
                "Ngày tạo:",
                // Cần import 'package:intl/intl.dart';
                DateFormat('dd/MM/yyyy').format(pack.createdAt!),
              ),

            const SizedBox(height: 20),
            const Divider(color: Colors.white24, height: 1),
            const SizedBox(height: 20),

            // 4. Description
            const Text(
              "MÔ TẢ",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 11,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.0,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              (pack.description == null || pack.description!.isEmpty)
                  ? "Chưa có mô tả cho bộ đề này."
                  : pack.description!,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                height: 1.5,
                fontStyle: FontStyle.italic,
              ),
            ),

            const SizedBox(height: 32),

            // 5. Actions Buttons (Giữ nguyên logic cũ)
            CustomActionButton(
              width: double.infinity,
              onTap: () => Get.back<bool>(result: controller.isDataChanged),
              icon: Icons.save_outlined,
              text: 'SAVE & CLOSE', // Đổi tên cho rõ nghĩa
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _buildGlassButton(
                    icon: Icons.edit_outlined,
                    text: 'Sửa tên',
                    onTap: () async {},
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildGlassButton(
                    icon: Icons.settings_outlined,
                    text: 'Cài đặt',
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
    });
  }

  // --- Widget phụ: Dòng thông tin (Icon - Label - Value) ---
  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.white70, size: 16),
        const SizedBox(width: 10),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 13),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  // --- Widget phụ: Badge trạng thái Public/Private ---
  Widget _buildStatusBadge(bool isPublic) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isPublic ? Colors.greenAccent.withOpacity(0.2) : Colors.black26,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isPublic
              ? Colors.greenAccent.withOpacity(0.6)
              : Colors.white30,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isPublic ? Icons.public : Icons.lock_outline,
            color: isPublic ? Colors.greenAccent : Colors.white70,
            size: 12,
          ),
          const SizedBox(width: 6),
          Text(
            isPublic ? "Công khai" : "Riêng tư",
            style: TextStyle(
              color: isPublic ? Colors.greenAccent : Colors.white70,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlassButton({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(16),
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
