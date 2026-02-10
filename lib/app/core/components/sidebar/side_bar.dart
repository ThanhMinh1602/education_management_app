import 'package:blooket/app/routes/app_routes.dart';
import 'package:flutter/material.dart';

// 1. Định nghĩa Enum
enum SideBarItem {
  userManagement,
  question,
  classManagement,
  settings,
  assignment,
}

class SideBarWidget extends StatelessWidget {
  final SideBarItem currentItem; // Chỉ cần truyền vào item hiện tại

  const SideBarWidget({super.key, required this.currentItem});

  // 2. Hàm xử lý điều hướng tập trung
  void _onItemPressed(BuildContext context, SideBarItem item) {
    // Nếu bấm vào đúng trang đang đứng thì không làm gì cả
    if (item == currentItem) return;

    // Map từ Enum sang Route Name
    String routeName = '';
    switch (item) {
      case SideBarItem.question:
        routeName = AppRoutes.LEVEL;
        break;
      case SideBarItem.userManagement:
        routeName = AppRoutes.STUDENT_MANAGEMENT;
        break;

      case SideBarItem.classManagement:
        routeName = AppRoutes.CLASS_MANAGEMENT;
        break;
      case SideBarItem.settings:
        routeName = AppRoutes.SETTINGS;
        break;
      case SideBarItem.assignment:
        routeName = AppRoutes.ASSIGNMENT;
    }

    if (routeName.isNotEmpty) {
      Navigator.of(context).pushReplacementNamed(routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      color: Colors.white,
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                _buildMenuItem(
                  context,
                  SideBarItem.question,
                  'Tài liệu của tôi',
                  Icons.class_outlined,
                  Icons.class_,
                ),
                _buildMenuItem(
                  context,
                  SideBarItem.userManagement,
                  'Quản lý học viên',
                  Icons.people_outline,
                  Icons.people,
                ),

                _buildMenuItem(
                  context,
                  SideBarItem.classManagement,
                  'Quản lý lớp học',
                  Icons.class_outlined,
                  Icons.class_,
                ),
                _buildMenuItem(
                  context,
                  SideBarItem.assignment,
                  'Bài tập',
                  Icons.class_outlined,
                  Icons.class_,
                ),
              ],
            ),
          ),

          // FOOTER
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                _buildMenuItem(
                  context,
                  SideBarItem.settings,
                  'Settings',
                  Icons.settings_outlined,
                  Icons.settings,
                ),
                const SizedBox(height: 8),
                ListTile(
                  onTap: () {
                    // Xử lý Logout riêng, thường là pushReplacement về Login
                    // Navigator.of(context).pushReplacementNamed('/login');
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  leading: const Icon(Icons.logout, color: Colors.redAccent),
                  title: const Text(
                    'Logout',
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    SideBarItem item,
    String label,
    IconData icon,
    IconData activeIcon,
  ) {
    final isSelected = item == currentItem;
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        // Gọi hàm xử lý nội bộ
        onTap: () => _onItemPressed(context, item),

        selected: isSelected,
        selectedTileColor: colorScheme.primary.withOpacity(0.1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        leading: Icon(
          isSelected ? activeIcon : icon,
          color: isSelected ? colorScheme.primary : Colors.grey[600],
        ),
        title: Text(
          label,
          style: TextStyle(
            color: isSelected ? colorScheme.primary : Colors.grey[700],
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
