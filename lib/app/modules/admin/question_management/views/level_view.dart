import 'package:blooket/app/data/model/request/content/level_request.dart';
import 'package:blooket/app/modules/admin/question_management/controller/level_controller.dart';
import 'package:blooket/app/modules/admin/question_management/widgets/level/level_info_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:blooket/app/core/components/appbar/app_header.dart';
import 'package:blooket/app/core/components/header/custom_page_header.dart';
import 'package:blooket/app/core/components/sidebar/side_bar.dart';
import 'package:blooket/app/core/utils/ui_dialogs.dart';

class LevelView extends GetView<LevelController> {
  const LevelView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDCD6F7),
      appBar: AppHeader(),
      body: Row(
        children: [
          Expanded(
            flex: 1,
            child: SideBarWidget(currentItem: SideBarItem.question),
          ),

          Expanded(
            flex: 6,
            child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomPageHeader(
                    title: 'Quản lý cấp độ',
                    subtitle: 'Danh sách các cấp độ (Levels) hiện có',
                    buttonLabel: 'Tạo cấp độ mới',
                    onButtonPressed: () async {
                      final name = await UiDialogs.showQuestionSetName(
                        title: 'TẠO LEVEL MỚI',
                      );
                      if (name != null) {
                        await Future.delayed(const Duration(milliseconds: 300));
                        await controller.createLevel(LevelRequest(name: name));
                      }
                    },
                  ),

                  const SizedBox(height: 40),

                  Expanded(
                    child: Obx(() {
                      if (controller.levels.isEmpty) {
                        return const Center(
                          child: Text(
                            "Chưa có cấp độ nào",
                            style: TextStyle(color: Colors.grey, fontSize: 16),
                          ),
                        );
                      }

                      return GridView.builder(
                        itemCount: controller.levels.length,
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 350,
                              childAspectRatio: 1,
                              crossAxisSpacing: 30,
                              mainAxisSpacing: 30,
                            ),
                        itemBuilder: (context, index) {
                          final item = controller.levels[index];

                          return LevelInfoCard(
                            isDetail: false,
                            levelModel: item,
                            onViewDetail: () {
                              controller.onTapDetail(item.id);
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
