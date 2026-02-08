import 'package:blooket/app/core/components/appbar/custom_app_bar.dart';
import 'package:blooket/app/core/constants/app_color.dart';
import 'package:blooket/app/data/model/request/class/class_request.dart';
import 'package:blooket/app/modules/admin/class_management/controller/class_management_detail_controller.dart';
import 'package:blooket/app/modules/admin/class_management/widgets/add_user_to_class.dart';
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
      backgroundColor: const Color(0xFFF0F2F5),
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
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    ClassCard(
                      isDetail: true,
                      classModel: currentClass,
                      onNameChanged: (val) {
                        controller.updateClass(ClassRequest(name: val));
                      },
                      onDescriptionChanged: (val) {
                        controller.updateClass(ClassRequest(description: val));
                      },
                      onStatusChanged: (isActive) {
                        controller.updateClass(
                          ClassRequest(isActive: isActive),
                        );
                      },
                      onScheduleChanged: (newSchedules) {
                        // controller.updateClass(Sce)
                      },
                    ),

                    const SizedBox(height: 24),

                    _buildQuickStats(context, currentClass.students),
                  ],
                ),
              ),

              const SizedBox(width: 32),

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
                          child: currentClass.students.isEmpty
                              ? _buildEmptyState()
                              : _buildDataTable(context, currentClass.students),
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

  Widget _buildToolbar(BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Danh Sách Học Viên',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
                color: const Color(0xFF2D3436),
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Quản lý điểm số và thành viên',
              style: TextStyle(color: Colors.grey[600], fontSize: 13),
            ),
          ],
        ),
        const Spacer(),

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
                    hintText: 'Tìm học viên...',
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: Colors.grey[400], fontSize: 13),
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.groups_3_outlined, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            "Lớp chưa có học viên nào",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 8),
          TextButton.icon(
            onPressed: () => _showAddDialog(Get.context!),
            icon: const Icon(Icons.add),
            label: const Text("Thêm học viên ngay"),
          ),
        ],
      ),
    );
  }

  Widget _buildDataTable(BuildContext context, List<dynamic> students) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.grey.shade100),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(0),
        child: DataTable(
          headingRowColor: MaterialStateProperty.all(const Color(0xFFFAFAFA)),
          dataRowColor: MaterialStateProperty.resolveWith<Color?>((states) {
            if (states.contains(MaterialState.hovered)) {
              return AppColor.primary.withOpacity(0.05);
            }
            return Colors.white;
          }),
          headingRowHeight: 52,
          dataRowHeight: 72,
          columnSpacing: 24,
          horizontalMargin: 24,
          columns: [
            _buildHeader('Họ và tên'),
            _buildHeader('Username'),
            _buildHeader('Điểm TB', alignCenter: true),
            _buildHeader('Hành động', alignEnd: true),
          ],
          rows: students.map<DataRow>((user) {
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
                          color: AppColor.primary.withOpacity(0.1),
                          border: Border.all(color: Colors.white, width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 4,
                            ),
                          ],
                          image: DecorationImage(
                            image: NetworkImage(user.avatar ?? ''),
                            fit: BoxFit.cover,
                            onError: (_, __) {},
                          ),
                        ),
                        child: Center(
                          child: Text(
                            (user.name ?? 'A').substring(0, 1).toUpperCase(),
                            style: TextStyle(
                              color: AppColor.primary,
                              fontWeight: FontWeight.w800,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            user.name ?? 'Unknown',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Color(0xFF2D3436),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                DataCell(
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '@${user.username}',
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 12,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ),
                ),

                DataCell(Center(child: _buildScoreBadge(user.avgScore ?? 0))),

                DataCell(
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      _buildActionButton(
                        icon: Icons.edit_note_rounded,
                        color: Colors.blue,
                        tooltip: "Xem chi tiết",
                        onTap: () {},
                      ),
                      const SizedBox(width: 8),
                      _buildActionButton(
                        icon: Icons.person_remove_rounded,
                        color: Colors.redAccent,
                        tooltip: "Xóa khỏi lớp",
                        onTap: () {
                          AppDialogs.showDeleteConfirm(
                            onConfirm: () async {
                              await Future.delayed(
                                const Duration(milliseconds: 300),
                              );
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
      width: 40,
      height: 28,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          score.toString(),
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required String tooltip,
    required VoidCallback onTap,
  }) {
    return IconButton(
      icon: Icon(icon, size: 20),
      color: color.withOpacity(0.8),
      hoverColor: color.withOpacity(0.1),
      splashRadius: 20,
      tooltip: tooltip,
      onPressed: onTap,
    );
  }

  Widget _buildQuickStats(BuildContext context, List students) {
    int excellent = students.where((s) => (s.avgScore ?? 0) >= 8).length;
    int warning = students.where((s) => (s.avgScore ?? 0) < 5).length;

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
          _buildStatRow("Giỏi", excellent, Colors.green),
          const SizedBox(height: 12),
          _buildStatRow("Cần chú ý", warning, Colors.redAccent),
          const SizedBox(height: 12),
          _buildStatRow("Sĩ số", students.length, Colors.blueGrey),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, int value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            value.toString(),
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }

  void _showAddDialog(BuildContext context) {
    Get.dialog(const AddUserToClass());
  }
}
