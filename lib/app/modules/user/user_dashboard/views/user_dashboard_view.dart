import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:blooket/app/core/components/appbar/custom_app_bar.dart';
import 'package:blooket/app/core/constants/app_color.dart';
import '../controller/user_dashboard_controller.dart';

class UserDashboardView extends GetView<UserDashboardController> {
  const UserDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 1000;

    return Scaffold(
      backgroundColor: AppColor.secondary,
      appBar: CustomAppBar(title: 'Học Tập', showBackButton: false),
      body: Padding(
        padding: EdgeInsetsGeometry.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (isDesktop)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildModuleCard(
                    title: 'Bài Tập Luyện Tập',
                    subtitle: 'Luyện tập các bài tập từ các bộ câu hỏi',
                    icon: Icons.school,
                    color: AppColor.pink,
                    onTap: controller.goToExercises,
                  ),
                  const SizedBox(width: 40),
                  _buildModuleCard(
                    title: 'Bài Tập Giao Về Nhà',
                    subtitle: 'Làm các bài tập được giao từ giáo viên',
                    icon: Icons.assignment,
                    color: const Color(0xFF6C63FF),
                    onTap: controller.goToAssignments,
                  ),
                ],
              )
            else
              Column(
                children: [
                  _buildModuleCard(
                    title: 'Bài Tập Luyện Tập',
                    subtitle: 'Luyện tập các bài tập từ các bộ câu hỏi',
                    icon: Icons.school,
                    color: AppColor.pink,
                    onTap: controller.goToExercises,
                  ),
                  const SizedBox(height: 24),
                  _buildModuleCard(
                    title: 'Bài Tập Giao Về Nhà',
                    subtitle: 'Làm các bài tập được giao từ giáo viên',
                    icon: Icons.assignment,
                    color: const Color(0xFF6C63FF),
                    onTap: controller.goToAssignments,
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildModuleCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Expanded(
        child: Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          padding: const EdgeInsets.all(32),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(20),
                child: Icon(icon, size: 60, color: Colors.white),
              ),
              const SizedBox(height: 24),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.85),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white.withOpacity(0.3)),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Text(
                  'Bắt đầu',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
