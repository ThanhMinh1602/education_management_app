import 'package:blooket/app/core/components/appbar/app_header.dart';
import 'package:blooket/app/core/components/header/custom_page_header.dart';
import 'package:blooket/app/core/components/sidebar/side_bar.dart';
import 'package:blooket/app/modules/admin/class_management/controller/class_management_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/class_card.dart';
import 'package:blooket/app/core/utils/dialogs.dart';
import 'package:blooket/app/core/utils/ui_dialogs.dart';

class ClassManagementView extends GetView<ClassManagementController> {
  const ClassManagementView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDCD6F7),
      appBar: AppHeader(),
      body: Row(
        children: [
          Expanded(
            flex: 1,
            child: SideBarWidget(currentItem: SideBarItem.classManagement),
          ),
          Expanded(
            flex: 6,
            child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: Column(
                children: [
                  // 1. Tiêu đề lớn
                  CustomPageHeader(
                    title: 'Quản lý lớp học',
                    subtitle: 'Danh sách lớp học hiện có',
                    buttonLabel: 'Thêm mới',
                    onButtonPressed: () async {
                      final res = await UiDialogs.showClassForm();
                      if (res != null) {
                        await Future.delayed(const Duration(milliseconds: 300));
                        await controller.createClass(
                          className: res['className']!,
                          subject: res['subject'] ?? '',
                          schedule: res['schedule'] ?? '',
                        );
                      }
                    },
                  ),

                  const SizedBox(height: 40),

                  // 2. GridView Builder
                  // BẮT BUỘC: Dùng Expanded để GridView chiếm hết phần còn lại của Column
                  Expanded(
                    child: Obx(() {
                      // Nếu list rỗng thì hiện thông báo (Optional)
                      if (controller.classList.isEmpty) {
                        return const Center(
                          child: Text(
                            "Chưa có lớp học nào",
                            style: TextStyle(color: Colors.grey, fontSize: 16),
                          ),
                        );
                      }
                      return GridView.builder(
                        // Tối ưu hiệu năng thay vì Wrap
                        itemCount: controller.classList.length,
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent:
                                  400, // Chiều rộng tối đa của mỗi thẻ (pixel)
                              childAspectRatio:
                                  1.5, // Tỷ lệ khung hình (Rộng / Cao). Chỉnh số này để thẻ không bị méo.
                              crossAxisSpacing: 30, // Khoảng cách ngang
                              mainAxisSpacing: 30, // Khoảng cách dọc
                            ),
                        itemBuilder: (context, index) {
                          final item = controller.classList[index];

                          // StreamBuilder đặt trong này vẫn hoạt động tốt
                          return StreamBuilder<int>(
                            stream: controller.getClassStudentCount(item.id),
                            initialData: 0,
                            builder: (context, snapshot) {
                              final count = snapshot.data ?? 0;
                              return ClassCard(
                                className: item.className,
                                subject: item.subject,
                                schedule: item.schedule,
                                studentCount: count,
                                onEnterClass: () =>
                                    controller.enterClass(item.id),
                                onEdit: () async {
                                  final res = await UiDialogs.showClassForm(
                                    title: 'CHỈNH SỬA LỚP',
                                    initialName: item.className,
                                    initialSubject: item.subject,
                                    initialSchedule: item.schedule,
                                  );
                                  if (res != null) {
                                    await Future.delayed(
                                      const Duration(milliseconds: 300),
                                    );
                                    await controller.updateClass(
                                      id: item.id,
                                      className: res['className']!,
                                      subject: res['subject'] ?? '',
                                      schedule: res['schedule'] ?? '',
                                    );
                                  }
                                },
                                onDelete: () {
                                  AppDialogs.showConfirm(
                                    title: "Xác nhận xóa",

                                    middleText:
                                        "Bạn có chắc muốn xóa lớp học này không?\nDữ liệu không thể khôi phục.",
                                    textConfirm: "Xóa ngay",
                                    textCancel: "Hủy",
                                    onConfirm: () async {
                                      await Future.delayed(
                                        const Duration(milliseconds: 300),
                                      );
                                      await controller.deleteClass(item.id);
                                    },
                                  );
                                },
                              );
                            },
                          );
                        },
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
