import 'dart:ui';

import 'package:blooket/app/core/components/button/custom_icon_button.dart';
import 'package:blooket/app/core/components/dropdown/custom_dropdown_field.dart';
import 'package:blooket/app/core/components/header/custom_page_header.dart';
import 'package:blooket/app/core/utils/dialogs.dart';
import 'package:blooket/app/data/enum/question_type.dart';
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _buildTotalCounter(),
            const SizedBox(width: 16),
            _buildFilterDropdown(),

            const SizedBox(width: 16),
            Spacer(),
            const SizedBox(width: 16),

            _buildAddButton(),
          ],
        ),

        const SizedBox(height: 16),

        Expanded(
          child: Obx(() {
            if (controller.filteredQuestions.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.filter_list_off,
                      size: 48,
                      color: Colors.grey.shade300,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Không tìm thấy câu hỏi nào.",
                      style: TextStyle(color: Colors.grey.shade500),
                    ),
                  ],
                ),
              );
            }

            return ListView.separated(
              itemCount: controller.filteredQuestions.length,
              itemBuilder: (context, index) {
                final question = controller.filteredQuestions[index];
                return QuestionListItem(
                  index: index,
                  questionModel: question,
                  onEdit: () {
                    Get.dialog(
                      QuestionDialogView(
                        packId: controller.packsId,
                        initialData: question,
                        onSave: (request) async {
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
                  onCopy: () {},
                  onUp: () {},
                  onDown: () {},
                );
              },
              separatorBuilder: (_, __) => const SizedBox(height: 12),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildTotalCounter() {
    return Container(
      height: 50, // Cao bằng Dropdown/Button
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14), // Bo góc 14 giống Dropdown
        border: Border.all(color: Colors.grey), // Viền xám giống Dropdown
      ),
      alignment: Alignment.center, // Căn giữa nội dung
      child: Obx(
        () => Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.format_list_numbered_rounded,
              color: AppColor.primary,
              size: 22,
            ),
            const SizedBox(width: 8),
            Text(
              // Hiển thị: "Tổng: 15"
              "Tổng: ${controller.questions.length}",
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterDropdown() {
    return SizedBox(
      width: 250,
      child: Obx(
        () => CustomDropdownField<QuestionType?>(
          labelText: "Lọc theo loại",
          prefixIcon: Icons.filter_alt_outlined,
          value: controller.filterType.value,

          items: [
            const DropdownMenuItem(
              value: null,
              child: Text(
                "Tất cả",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            ...QuestionType.values.where((e) => e != QuestionType.unknown).map((
              type,
            ) {
              return DropdownMenuItem(value: type, child: Text(type.label));
            }),
          ],
          onChanged: (newValue) => controller.setFilter(newValue),
        ),
      ),
    );
  }

  Widget _buildAddButton() {
    return CustomIconButton(
      onTap: () {
        Get.dialog(
          barrierDismissible: false,
          QuestionDialogView(
            packId: controller.packsId,
            initialType: controller.filterType.value,
            onSave: (request) async {
              await controller.addQuestion(request);
            },
          ),
        );
      },
      icon: Icons.add,
      label: 'Thêm câu hỏi',
    );
  }

  Widget _buildLeftWidget() {
    return Obx(() {
      final pack = controller.questionPackModel.value;

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

            _buildInfoRow(Icons.layers_rounded, "Level:", pack.levelName),
            const SizedBox(height: 12),
            _buildInfoRow(Icons.person_rounded, "Giáo viên:", pack.teacherName),
            const SizedBox(height: 12),
            if (pack.createdAt != null)
              _buildInfoRow(
                Icons.calendar_month_rounded,
                "Ngày tạo:",

                DateFormat('dd/MM/yyyy').format(pack.createdAt!),
              ),

            const SizedBox(height: 20),
            const Divider(color: Colors.white24, height: 1),
            const SizedBox(height: 20),

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

            CustomActionButton(
              width: double.infinity,
              onTap: () => Get.back<bool>(result: controller.isDataChanged),
              icon: Icons.save_outlined,
              text: 'SAVE & CLOSE',
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
