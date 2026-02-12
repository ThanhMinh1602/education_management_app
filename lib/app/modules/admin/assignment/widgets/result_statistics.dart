// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../controllers/assignment_results_controller.dart';

// class ResultStatistics extends GetView<AssignmentResultsController> {
//   const ResultStatistics({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Obx(() {
//       final stats = controller.getStatistics();
//       final avgScore = controller.getAverageScore();

//       return GridView.count(
//         crossAxisCount: 4,
//         mainAxisSpacing: 12,
//         crossAxisSpacing: 12,
//         shrinkWrap: true,
//         physics: const NeverScrollableScrollPhysics(),
//         children: [
//           _StatCard(
//             title: 'Tổng cộng',
//             value: stats['total'].toString(),
//             color: Colors.blue,
//             icon: Icons.people,
//           ),
//           _StatCard(
//             title: 'Đã nộp',
//             value: stats['submitted'].toString(),
//             color: Colors.green,
//             icon: Icons.check_circle,
//           ),
//           _StatCard(
//             title: 'Đang làm',
//             value: stats['started'].toString(),
//             color: Colors.orange,
//             icon: Icons.schedule,
//           ),
//           _StatCard(
//             title: 'Điểm TB',
//             value: avgScore.toStringAsFixed(1),
//             color: Colors.purple,
//             icon: Icons.assessment,
//           ),
//         ],
//       );
//     });
//   }
// }

// class _StatCard extends StatelessWidget {
//   final String title;
//   final String value;
//   final Color color;
//   final IconData icon;

//   const _StatCard({
//     required this.title,
//     required this.value,
//     required this.color,
//     required this.icon,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 2,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Container(
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(12),
//           border: Border(top: BorderSide(color: color, width: 4)),
//         ),
//         padding: const EdgeInsets.all(12),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(icon, color: color, size: 28),
//             const SizedBox(height: 8),
//             Text(
//               value,
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//                 color: color,
//               ),
//             ),
//             const SizedBox(height: 4),
//             Text(
//               title,
//               textAlign: TextAlign.center,
//               style: const TextStyle(fontSize: 11, color: Colors.grey),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
