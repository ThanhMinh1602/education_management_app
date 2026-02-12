// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../controllers/assignment_results_controller.dart';

// class ResultTable extends GetView<AssignmentResultsController> {
//   const ResultTable({super.key});

//   Color _getStatusColor(String status) {
//     switch (status) {
//       case 'submitted':
//         return Colors.green;
//       case 'started':
//         return Colors.orange;
//       case 'assigned':
//         return Colors.blue;
//       case 'missed':
//         return Colors.red;
//       default:
//         return Colors.grey;
//     }
//   }

//   String _getStatusLabel(String status) {
//     switch (status) {
//       case 'submitted':
//         return 'Đã nộp';
//       case 'started':
//         return 'Đang làm';
//       case 'assigned':
//         return 'Chưa làm';
//       case 'missed':
//         return 'Quá hạn';
//       default:
//         return 'Không xác định';
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 2,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Obx(() {
//         if (controller.isLoading.value) {
//           return const Padding(
//             padding: EdgeInsets.all(20),
//             child: CircularProgressIndicator(),
//           );
//         }

//         // if (controller.resultsList.isEmpty) {
//         //   return const Padding(
//         //     padding: EdgeInsets.all(20),
//         //     child: Center(child: Text('Chưa có kết quả nào')),
//         //   );
//         // }

//         return SingleChildScrollView(
//           scrollDirection: Axis.horizontal,
//           child: DataTable(
//             columnSpacing: 20,
//             columns: const [
//               DataColumn(
//                 label: Text(
//                   'Sinh viên',
//                   style: TextStyle(fontWeight: FontWeight.bold),
//                 ),
//               ),
//               DataColumn(
//                 label: Text(
//                   'Trạng thái',
//                   style: TextStyle(fontWeight: FontWeight.bold),
//                 ),
//               ),
//               DataColumn(
//                 label: Text(
//                   'Điểm',
//                   style: TextStyle(fontWeight: FontWeight.bold),
//                 ),
//               ),
//               DataColumn(
//                 label: Text(
//                   'Câu đúng',
//                   style: TextStyle(fontWeight: FontWeight.bold),
//                 ),
//               ),
//               DataColumn(
//                 label: Text(
//                   'Thời gian nộp',
//                   style: TextStyle(fontWeight: FontWeight.bold),
//                 ),
//               ),
//             ],
//             rows: [
//               DataRow(
//                 cells: [
//                   DataCell(Text('N/A')),
//                   DataCell(
//                     Container(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 8,
//                         vertical: 4,
//                       ),
//                       decoration: BoxDecoration(
//                         color: _getStatusColor('submitted').withOpacity(0.2),
//                         borderRadius: BorderRadius.circular(6),
//                       ),
//                       child: Text(
//                         _getStatusLabel('submitted'),
//                         style: TextStyle(
//                           fontSize: 12,
//                           fontWeight: FontWeight.bold,
//                           color: _getStatusColor('submitted'),
//                         ),
//                       ),
//                     ),
//                   ),
//                   DataCell(
//                     Text(
//                       '1/100',
//                       style: TextStyle(fontWeight: FontWeight.normal),
//                     ),
//                   ),
//                   DataCell(Text('-')),
//                   DataCell(Text('-', style: const TextStyle(fontSize: 11))),
//                 ],
//               ),
//             ],
//           ),
//         );
//       }),
//     );
//   }
// }
