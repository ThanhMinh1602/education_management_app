import 'package:blooket/app/modules/admin/question_management/controller/level_detail_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

// Imports UI Components
import 'package:blooket/app/core/components/appbar/custom_app_bar.dart';
import 'package:blooket/app/core/components/button/custom_button.dart';
import 'package:blooket/app/core/constants/app_color.dart';
import 'package:blooket/app/core/utils/dialogs.dart';
import 'package:blooket/app/modules/admin/question_management/widgets/level/level_card.dart';

class LevelDetailView extends GetView<LevelDetailController> {
  final String levelId;

  const LevelDetailView({super.key, required this.levelId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(
        0xFFF0F2F5,
      ), // Màu nền xám nhạt (Detail Mode)
      appBar: CustomAppBar(
        title: 'Chi Tiết Cấp Độ',
        onLeadingPressed: () {
          Get.back(result: controller.isDataChanged);
        },
      ),
      body: Obx(() {
        if (controller.levelDetail.value == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final currentLevel = controller.levelDetail.value!;
        // Danh sách bộ đề (Giả sử model Level có list questionPacks)
        final packs = controller.questionPacks;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- CỘT TRÁI (THÔNG TIN LEVEL) ---
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    // Hiển thị Card Level (Có thể chỉnh sửa LevelCard để hỗ trợ edit mode nếu muốn)
                    LevelCard(
                      name: currentLevel.name ?? "",
                      description: currentLevel.description ?? "",
                      order: currentLevel.order ?? 0,
                      isActive: currentLevel.isActive ?? true,
                      createdAt: currentLevel.createdAt ?? DateTime.now(),
                      onEdit: () {
                        // Logic sửa thông tin Level
                      },
                      onDelete: () {
                        // Logic xóa (thường ẩn đi ở view này vì nút xóa to ở dưới rồi)
                      },
                    ),

                    const SizedBox(height: 24),

                    // Thống kê nhanh
                    _buildQuickStats(context, packs.length),

                    const SizedBox(height: 24),

                    // Nút xóa Level
                    CustomButton(
                      text: 'Xóa Cấp Độ',
                      backgroundColor: AppColor.falseRed,
                      foregroundColor: AppColor.white,
                      onPressed: () {
                        AppDialogs.showDeleteConfirm(
                          onConfirm: () async {
                            // await controller.deleteLevel();
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 32),

              // --- CỘT PHẢI (DANH SÁCH BỘ ĐỀ) ---
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildToolbar(context),
                    const SizedBox(height: 16),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.03),
                              offset: const Offset(0, 4),
                              blurRadius: 20,
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: packs.isEmpty
                              ? _buildEmptyState()
                              : _buildDataTable(context, packs),
                        ),
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

  // --- CÁC WIDGET CON (Copy style từ ClassDetailView) ---

  Widget _buildToolbar(BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Danh Sách Bộ Đề',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
                color: const Color(0xFF2D3436),
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Quản lý các bộ câu hỏi thuộc cấp độ này',
              style: TextStyle(color: Colors.grey[600], fontSize: 13),
            ),
          ],
        ),
        const Spacer(),
        // Ô tìm kiếm
        Container(
          width: 250,
          height: 44,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Row(
            children: [
              Icon(Icons.search, color: Colors.grey[400], size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Tìm bộ đề...',
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: Colors.grey[400], fontSize: 13),
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                  onChanged: (val) {},
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        // Nút thêm bộ đề vào Level
        CustomButton(
          text: "+ Thêm Bộ Đề",
          backgroundColor: AppColor.primary,
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.folder_off_outlined, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            "Cấp độ này chưa có bộ đề nào",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataTable(BuildContext context, List<dynamic> packs) {
    // Thay dynamic bằng Model QuestionPack của bạn
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.grey.shade100),
      child: SingleChildScrollView(
        padding: EdgeInsets.zero,
        child: DataTable(
          headingRowColor: MaterialStateProperty.all(const Color(0xFFFAFAFA)),
          dataRowColor: MaterialStateProperty.resolveWith<Color?>((states) {
            if (states.contains(MaterialState.hovered))
              return AppColor.primary.withOpacity(0.05);
            return Colors.white;
          }),
          headingRowHeight: 52,
          dataRowHeight: 72,
          columnSpacing: 24,
          horizontalMargin: 24,
          columns: [
            _buildHeader('Tên Bộ Đề'),
            _buildHeader('Số câu hỏi', alignCenter: true),
            _buildHeader('Ngày tạo', alignCenter: true),
            _buildHeader('Hành động', alignEnd: true),
          ],
          rows: packs.map<DataRow>((pack) {
            return DataRow(
              cells: [
                DataCell(
                  Text(
                    pack.name ?? 'Unknown',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Color(0xFF2D3436),
                    ),
                  ),
                ),
                DataCell(Center(child: Text("${pack.questionCount ?? 0}"))),
                DataCell(
                  Center(
                    child: Text(
                      DateFormat(
                        'dd/MM/yyyy',
                      ).format(pack.createdAt ?? DateTime.now()),
                    ),
                  ),
                ),
                DataCell(
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.edit_note_rounded,
                          color: Colors.blue,
                        ),
                        onPressed: () {}, // Edit Pack logic
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(
                          Icons.link_off_rounded,
                          color: Colors.redAccent,
                        ),
                        tooltip: "Gỡ khỏi Level",
                        onPressed: () {},
                        // controller.removePackFromLevel(pack.id),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  DataColumn _buildHeader(
    String text, {
    bool alignEnd = false,
    bool alignCenter = false,
  }) {
    return DataColumn(
      numeric: alignEnd,
      label: Expanded(
        child: Text(
          text.toUpperCase(),
          textAlign: alignCenter
              ? TextAlign.center
              : (alignEnd ? TextAlign.end : TextAlign.start),
          style: TextStyle(
            color: Colors.grey[500],
            fontWeight: FontWeight.w700,
            fontSize: 12,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  Widget _buildQuickStats(BuildContext context, int packCount) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            offset: const Offset(0, 4),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Thống kê nhanh",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Tổng số bộ đề",
                style: TextStyle(color: Colors.grey[600], fontSize: 13),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.blueAccent.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "$packCount",
                  style: const TextStyle(
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
