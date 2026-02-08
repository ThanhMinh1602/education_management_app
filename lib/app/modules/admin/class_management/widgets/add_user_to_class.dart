// import 'package:blooket/app/core/constants/app_color.dart';
// import 'package:blooket/app/modules/admin/class_management/controller/class_management_detail_controller.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class AddUserToClass extends StatelessWidget {
//   const AddUserToClass({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.find<ClassManagementDetailController>();
//     return Dialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//       backgroundColor: Colors.white,
//       child: Obx(
//         () => Container(
//           width: 500,
//           height: 600,
//           padding: const EdgeInsets.all(24),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     "CHỌN HỌC VIÊN",
//                     style: TextStyle(
//                       color: AppColor.primary,
//                       fontSize: 24,
//                       fontWeight: FontWeight.w900,
//                     ),
//                   ),
//                   IconButton(
//                     onPressed: () => Get.back(),
//                     icon: const Icon(Icons.close, color: Colors.grey),
//                   ),
//                 ],
//               ),
//               const Divider(height: 30),

//               TextField(
//                 decoration: InputDecoration(
//                   prefixIcon: const Icon(Icons.search, color: Colors.grey),
//                   hintText: "Tìm kiếm tên hoặc username...",
//                   filled: true,
//                   fillColor: Colors.grey.shade100,
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                     borderSide: BorderSide.none,
//                   ),
//                   contentPadding: const EdgeInsets.symmetric(vertical: 0),
//                 ),
//               ),
//               const SizedBox(height: 16),

//               Expanded(
//                 child: controller.classDetail.value?.students == null
//                     ? const Center(
//                         child: Text(
//                           "Không có học viên nào khả dụng",
//                           style: TextStyle(color: Colors.grey),
//                         ),
//                       )
//                     : ListView.separated(
//                         itemCount:
//                             controller.classDetail.value!.students.length,
//                         separatorBuilder: (_, __) => const Divider(height: 1),
//                         itemBuilder: (ctx, index) {
//                           final user =
//                               controller.classDetail.value!.students[index];
//                           return ListTile(
//                             contentPadding: const EdgeInsets.symmetric(
//                               horizontal: 8,
//                               vertical: 4,
//                             ),
//                             leading: CircleAvatar(
//                               backgroundColor: AppColor.primary.withOpacity(
//                                 0.1,
//                               ),
//                               child: Text(
//                                 user.name?[0] ?? 'M',
//                                 style: TextStyle(
//                                   color: AppColor.primary,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ),
//                             title: Text(
//                               user.name,
//                               style: const TextStyle(
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             subtitle: Text(user.username),
//                             trailing: ElevatedButton(
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: AppColor.green,
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(8),
//                                 ),
//                                 elevation: 0,
//                               ),
//                               onPressed: () {},
//                               child: const Text(
//                                 "Thêm",
//                                 style: TextStyle(color: Colors.white),
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
