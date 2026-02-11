import 'package:blooket/app/core/components/common/app_tooltip.dart';
import 'package:blooket/app/core/components/button/custom_delete_button.dart';
import 'package:blooket/app/core/utils/dialogs.dart';
import 'package:blooket/app/data/model/question_pack_model.dart';
import 'package:blooket/app/modules/admin/question_management/controller/level_detail_controller.dart';
import 'package:blooket/app/modules/admin/question_management/widgets/level/level_info_card.dart';
import 'package:blooket/app/modules/admin/question_management/widgets/question_pack_form_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:blooket/app/core/components/appbar/custom_app_bar.dart';
import 'package:blooket/app/core/constants/app_color.dart';
import 'package:blooket/app/core/components/table/admin_table.dart';

class LevelDetailView extends GetView<LevelDetailController> {
  const LevelDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: CustomAppBar(
        title: 'Chi Tiết Cấp Độ',
        onLeadingPressed: () {
          Get.back(result: controller.isDataChanged.value);
        },
      ),
      body: Obx(() {
        if (controller.levelDetail.value == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final currentLevel = controller.levelDetail.value!;
        final packs = controller.questionPacks;

        return Padding(
          padding: const EdgeInsets.all(32.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    LevelInfoCard(
                      isDetail: true,
                      levelModel: currentLevel,
                      onSave: (request) async {
                        await controller.updateLevel(request);
                      },
                    ),
                    const SizedBox(height: 24),
                    _buildQuickStats(context, packs.length),
                    SizedBox(height: 24.0),
                    CustomDeleteButton(
                      onPressed: () {
                        AppDialogs.showDeleteConfirm(
                          onConfirm: () {
                            controller.deleteLevel(currentLevel.id);
                          },
                        );
                      },
                      text: 'Xóa cấp độ',
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 32),
              Expanded(
                flex: 7,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildToolbar(context),
                    const SizedBox(height: 24),

                    Expanded(
                      child: AdminTable(
                        columns: const [
                          'Thông tin bộ đề',
                          'Câu hỏi',
                          'Ngày tạo',
                          'Hành động',
                        ],
                        rows: _generateRows(packs),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  List<DataRow> _generateRows(List<QuestionPackModel> packs) {
    return packs.map((pack) {
      return DataRow(
        cells: [
          DataCell(
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: const Icon(
                    Icons.library_books_rounded,
                    color: Color(0xFF6C63FF),
                    size: 22,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        pack.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "ID: ${pack.id.length > 6 ? '...${pack.id.substring(pack.id.length - 6)}' : pack.id}",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[500],
                          fontFamily: "monospace",
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          DataCell(
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: (pack.totalQuestions ?? 0) > 0
                    ? const Color(0xFFDEF7EC)
                    : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                "${pack.totalQuestions ?? 0} câu",
                style: TextStyle(
                  color: (pack.totalQuestions ?? 0) > 0
                      ? const Color(0xFF03543F)
                      : Colors.grey[600],
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ),
          ),

          DataCell(
            Text(
              DateFormat('dd/MM/yyyy').format(pack.createdAt ?? DateTime.now()),
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),

          DataCell(
            _actionButton(Icons.edit_rounded, Colors.blue, "Sửa", () {
              controller.onTapPackDetail(pack.id);
            }),
          ),
        ],
      );
    }).toList();
  }

  Widget _actionButton(
    IconData icon,
    Color color,
    String tooltipText,
    VoidCallback onTap,
  ) {
    return AppTooltip(
      message: tooltipText,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          hoverColor: color.withOpacity(0.1),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: color.withOpacity(0.2), width: 1),
            ),
            child: Icon(icon, size: 18, color: color),
          ),
        ),
      ),
    );
  }

  Widget _buildToolbar(BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Danh Sách Bộ Đề',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
                color: const Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Quản lý nội dung học tập',
              style: TextStyle(color: Colors.grey[500], fontSize: 13),
            ),
          ],
        ),

        const Spacer(),

        Container(
          width: 260,
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Row(
            children: [
              Icon(Icons.search, size: 18, color: Colors.grey[400]),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Tìm kiếm...',
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    hintStyle: TextStyle(fontSize: 13, color: Colors.grey[400]),
                  ),
                  style: const TextStyle(fontSize: 13),
                  onChanged: (val) {},
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 16),

        ElevatedButton.icon(
          onPressed: () {
            Get.dialog(
              QuestionPackFormWidget(
                levelId: controller.levelId,
                onSave: (request) async {
                  await controller.createQuestionPack(request);
                },
              ),
            );
          },
          icon: const Icon(Icons.add, size: 18, color: Colors.white),
          label: const Text(
            "Thêm Bộ Đề",
            style: TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColor.primary,
            elevation: 2,
            shadowColor: AppColor.primary.withOpacity(0.3),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickStats(BuildContext context, int count) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF909CC2).withOpacity(0.08),
            offset: const Offset(0, 4),
            blurRadius: 24,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Tổng quan",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(height: 16),
          _statItem("Tổng bộ đề", "$count", Colors.blue),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(height: 1),
          ),
          _statItem("Đang hoạt động", "$count", Colors.green),
        ],
      ),
    );
  }

  Widget _statItem(String label, String value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            value,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }
}
