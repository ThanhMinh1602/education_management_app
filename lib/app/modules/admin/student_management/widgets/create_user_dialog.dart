import 'package:blooket/app/core/constants/app_colors.dart';
import 'package:blooket/app/core/constants/app_text_styles.dart';
import 'package:blooket/app/core/utils/dialogs.dart';
import 'package:blooket/app/data/enum/user_role.dart';
import 'package:blooket/app/data/model/user_model.dart';
import 'package:blooket/app/modules/admin/student_management/controllers/student_management_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateUserDialog extends StatefulWidget {
  const CreateUserDialog({super.key, this.userModel});
  final UserModel? userModel;

  @override
  State<CreateUserDialog> createState() => _CreateUserDialogState();
}

class _CreateUserDialogState extends State<CreateUserDialog> {
  late final TextEditingController nameCtrl;
  late final TextEditingController userCtrl;
  late final StudentManagementController studentManagementCtrl;
  UserRole selectedRole = UserRole.student;

  @override
  void initState() {
    super.initState();
    nameCtrl = TextEditingController();
    userCtrl = TextEditingController();
    studentManagementCtrl = Get.find();
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    userCtrl.dispose();
    super.dispose();
  }

  Future<void> onCreateUser() async {
    if (nameCtrl.text.isEmpty || userCtrl.text.isEmpty) {
      AppDialogs.showWarning('Vui lòng nhập đầy đủ thông tin!');
      return;
    }
    final isSuccess = await studentManagementCtrl.createUser(
      fullName: nameCtrl.text.trim(),
      username: userCtrl.text.trim(),
      role: selectedRole.value,
    );
    if (isSuccess) {
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Thêm học viên', style: AppTextStyles.dialogTitle),
              const SizedBox(height: 12),
              TextField(
                controller: nameCtrl,
                decoration: InputDecoration(
                  labelText: 'Họ và tên',
                  prefixIcon: const Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: userCtrl,
                decoration: InputDecoration(
                  labelText: 'Username',
                  prefixIcon: const Icon(Icons.alternate_email),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<UserRole>(
                value: selectedRole,
                decoration: InputDecoration(
                  labelText: 'Vai trò',
                  prefixIcon: const Icon(
                    Icons.security,
                    color: AppColors.primary,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                ),
                items: [
                  DropdownMenuItem(
                    value: UserRole.student,
                    child: Text('Học viên'),
                  ),
                  DropdownMenuItem(
                    value: UserRole.admin,
                    child: Text('Quản trị viên'),
                  ),
                  DropdownMenuItem(
                    value: UserRole.teacher,
                    child: Text('Giáo viên'),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) selectedRole = value;
                },
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.orange, size: 20),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Mật khẩu mặc định: 123456',
                        style: TextStyle(
                          color: Colors.orange,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Get.back(),
                      child: const Text(
                        'Hủy',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.action,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: onCreateUser,
                      child: const Text(
                        'TẠO TÀI KHOẢN',
                        style: AppTextStyles.buttonWhite,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
