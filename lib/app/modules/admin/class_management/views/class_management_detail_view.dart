import 'package:blooket/app/core/common/app_tooltip.dart';
import 'package:blooket/app/core/components/appbar/custom_app_bar.dart';
import 'package:blooket/app/core/components/button/custom_delete_button.dart';
import 'package:blooket/app/core/components/table/admin_table.dart';
import 'package:blooket/app/core/constants/app_color.dart';
import 'package:blooket/app/data/model/user_model.dart';
import 'package:blooket/app/modules/admin/class_management/controller/class_management_detail_controller.dart';
import 'package:blooket/app/modules/admin/class_management/widgets/class_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:blooket/app/core/utils/dialogs.dart';

class ClassManagementDetailView
    extends GetView<ClassManagementDetailController> {
  const ClassManagementDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: CustomAppBar(
        title: 'Chi Tiết Lớp Học',
        onLeadingPressed: () {
          Get.back(result: controller.isDataChanged);
        },
      ),
      body: Obx(() {
        if (controller.classDetail.value == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final currentClass = controller.classDetail.value!;

        return Padding(
          padding: const EdgeInsets.all(32.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    ClassCard(
                      isDetail: true,
                      classModel: currentClass,
                      onSave: (classRequest) {
                        controller.updateClass(classRequest);
                      },
                    ),

                    const SizedBox(height: 24),

                    _buildQuickStats(context, currentClass.students),

                    const SizedBox(height: 24),

                    CustomDeleteButton(
                      onPressed: () {
                        AppDialogs.showDeleteConfirm(
                          onConfirm: () {
                            controller.deleteClass();
                          },
                        );
                      },
                      text: 'Xóa lớp học',
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
                          'Họ và tên',
                          'Username',
                          'Điểm TB',
                          'Hành động',
                        ],
                        rows: _generateRows(currentClass.students),
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

  Widget _buildToolbar(BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Danh Sách Học Viên',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
                color: const Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Quản lý thành viên và điểm số',
              style: TextStyle(color: Colors.grey[500], fontSize: 13),
            ),
          ],
        ),

        const Spacer(),

        Container(
          width: 260,
          height: 44,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                offset: const Offset(0, 2),
                blurRadius: 8,
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(Icons.search, size: 20, color: Colors.grey[400]),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Tìm học viên...',
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

        Container(
          height: 44,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: const LinearGradient(
              colors: [Color(0xFF6C63FF), Color(0xFF4834D4)],
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF6C63FF).withOpacity(0.3),
                offset: const Offset(0, 4),
                blurRadius: 10,
              ),
            ],
          ),
          child: ElevatedButton.icon(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: const Icon(
              Icons.person_add_alt_1_rounded,
              size: 18,
              color: Colors.white,
            ),
            label: const Text(
              "Thêm Học Viên",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<DataRow> _generateRows(List<UserModel> students) {
    return students.map((user) {
      return DataRow(
        cells: [
          DataCell(
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey[100],
                    border: Border.all(color: Colors.white, width: 2),
                    boxShadow: [
                      BoxShadow(color: Colors.black12, blurRadius: 4),
                    ],
                    image: user.avatar.isNotEmpty
                        ? DecorationImage(
                            image: NetworkImage(user.avatar),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: user.avatar.isEmpty
                      ? const Icon(Icons.person, color: Colors.grey)
                      : null,
                ),
                const SizedBox(width: 16),
                Text(
                  user.name ?? 'Unknown',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Color(0xFF1E293B),
                  ),
                ),
              ],
            ),
          ),

          DataCell(
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Text(
                '@${user.username}',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                  fontFamily: 'monospace',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),

          DataCell(Center(child: _buildScoreBadge(user.avgScore ?? 0))),

          DataCell(
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _actionButton(
                  Icons.edit_note_rounded,
                  Colors.blue,
                  "Xem chi tiết",
                  () {},
                ),
                const SizedBox(width: 8),
                _actionButton(
                  Icons.person_remove_rounded,
                  Colors.red,
                  "Xóa khỏi lớp",
                  () {
                    AppDialogs.showDeleteConfirm(
                      onConfirm: () async {
                        await controller.removeStudentFromClass(user.id);
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      );
    }).toList();
  }

  Widget _actionButton(
    IconData icon,
    Color color,
    String tooltip,
    VoidCallback onTap,
  ) {
    return AppTooltip(
      message: tooltip,
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
              border: Border.all(color: color.withOpacity(0.2)),
            ),
            child: Icon(icon, size: 18, color: color),
          ),
        ),
      ),
    );
  }

  Widget _buildScoreBadge(double score) {
    Color color;
    Color bg;

    if (score >= 8) {
      color = const Color(0xFF00B894);
      bg = const Color(0xFFE3F9F4);
    } else if (score >= 5) {
      color = const Color(0xFFFDCB6E);
      bg = const Color(0xFFFFF6E0);
    } else {
      color = const Color(0xFFFF7675);
      bg = const Color(0xFFFFEAEA);
    }

    return Container(
      width: 48,
      height: 28,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        score.toString(),
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
      ),
    );
  }

  Widget _buildQuickStats(BuildContext context, List students) {
    int excellent = students.where((s) => (s.avgScore ?? 0) >= 8).length;
    int warning = students.where((s) => (s.avgScore ?? 0) < 5).length;

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
          const Row(
            children: [
              Icon(Icons.analytics_rounded, size: 20, color: Color(0xFF6C63FF)),
              SizedBox(width: 8),
              Text(
                "Thống kê học lực",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _statRow("Giỏi", excellent, Colors.green),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Divider(height: 1),
          ),
          _statRow("Cần chú ý", warning, Colors.redAccent),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Divider(height: 1),
          ),
          _statRow("Sĩ số", students.length, Colors.blueGrey),
        ],
      ),
    );
  }

  Widget _statRow(String label, int value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            value.toString(),
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
