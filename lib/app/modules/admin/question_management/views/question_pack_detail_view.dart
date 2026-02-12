import 'dart:ui';

import 'package:blooket/app/core/components/button/custom_icon_button.dart';
import 'package:blooket/app/core/components/dropdown/custom_dropdown_field.dart';
import 'package:blooket/app/core/utils/dialogs.dart';
import 'package:blooket/app/data/enum/question_type.dart';
import 'package:blooket/app/data/model/request/content/question_pack_request.dart';
import 'package:blooket/app/modules/admin/question_management/views/question_dialog_view.dart';
import 'package:blooket/app/modules/admin/question_management/widgets/question_list_item.dart';
import 'package:blooket/app/modules/admin/question_management/widgets/question_pack_info_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:blooket/app/core/constants/app_color.dart';
import 'package:blooket/app/core/components/appbar/custom_app_bar.dart';
import 'package:blooket/app/modules/admin/question_management/controller/question_pack_detail_controller.dart';

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
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey),
      ),
      alignment: Alignment.center,
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
      return QuestionPackInfoCard(
        pack: pack,
        onSaveInfo: (newTitle, newDesc) {
          final request = QuestionPackRequest(
            title: newTitle,
            description: newDesc,
            levelId: pack?.levelId,
            thumbnail: pack?.thumbnail,
            isPublic: pack?.isPublic ?? true,
          );
          controller.updateQuestionPack(request);
        },
        onSaveAndClose: () {
          Get.back<bool>(result: controller.isDataChanged);
        },
      );
    });
  }
}
