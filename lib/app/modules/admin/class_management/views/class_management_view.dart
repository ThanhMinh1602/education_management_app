import 'package:blooket/app/core/components/appbar/app_header.dart';
import 'package:blooket/app/core/components/header/custom_page_header.dart';
import 'package:blooket/app/core/components/sidebar/side_bar.dart';
import 'package:blooket/app/modules/admin/class_management/controller/class_management_controller.dart';
import 'package:blooket/app/modules/admin/class_management/widgets/class_form_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/class_card.dart';
import 'package:blooket/app/core/utils/dialogs.dart';

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
                  CustomPageHeader(
                    title: 'Quản lý lớp học',
                    subtitle: 'Danh sách lớp học hiện có',
                    buttonLabel: 'Thêm mới',
                    onButtonPressed: () async {
                      Get.dialog(
                        ClassFormWidget(
                          title: 'THÊM LỚP MỚI',
                          controller: controller,
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 40),

                  Expanded(
                    child: Obx(() {
                      if (controller.classList.isEmpty) {
                        return const Center(
                          child: Text(
                            "Chưa có lớp học nào",
                            style: TextStyle(color: Colors.grey, fontSize: 16),
                          ),
                        );
                      }
                      return GridView.builder(
                        itemCount: controller.classList.length,
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 400,
                              childAspectRatio: 1.3,
                              crossAxisSpacing: 30,
                              mainAxisSpacing: 30,
                            ),
                        itemBuilder: (context, index) {
                          final item = controller.classList[index];

                          return ClassCard(
                            key: ValueKey(item.id),
                            className: item.name,
                            code: item.code,
                            schedule: item.schedule,
                            studentCount: item.studentCount,
                            onEnterClass: () => controller.enterClass(item.id),
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
