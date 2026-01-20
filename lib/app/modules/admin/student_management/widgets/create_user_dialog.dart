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
  final _formKey = GlobalKey<FormState>(); // Key để quản lý Form
  late final TextEditingController nameCtrl;
  late final TextEditingController userCtrl;
  late final StudentManagementController studentManagementCtrl;

  UserRole selectedRole = UserRole.student;
  bool isLoading = false; // Trạng thái loading cục bộ

  bool get isUpdateMode => widget.userModel != null;

  @override
  void initState() {
    super.initState();
    studentManagementCtrl = Get.find();
    nameCtrl = TextEditingController(text: widget.userModel?.name ?? '');
    userCtrl = TextEditingController(text: widget.userModel?.username ?? '');
    if (isUpdateMode) {
      selectedRole = widget.userModel!.role;
    }
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    userCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    // 1. Validate Form
    if (!_formKey.currentState!.validate()) return;

    // 2. Set loading để chặn spam click
    setState(() => isLoading = true);

    bool isSuccess = false;
    final name = nameCtrl.text.trim();
    final username = userCtrl.text.trim();
    final role = selectedRole.value;

    // 3. Gọi API
    if (isUpdateMode) {
      isSuccess = await studentManagementCtrl.updateStudent(
        widget.userModel!.id,
        name: name,
        role: role,
      );
    } else {
      isSuccess = await studentManagementCtrl.createUser(
        fullName: name,
        username: username,
        role: role,
      );
    }

    // 4. Xử lý kết quả
    if (mounted) {
      setState(() => isLoading = false);
      if (isSuccess) Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 520),
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          // Chống lỗi tràn màn hình khi hiện phím
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  isUpdateMode ? 'Cập nhật thông tin' : 'Thêm học viên',
                  style: AppTextStyles.dialogTitle,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),

                // Tách code TextField ra hàm riêng
                _buildTextField(
                  controller: nameCtrl,
                  label: 'Họ và tên',
                  icon: Icons.person,
                  validator: (val) => val == null || val.trim().isEmpty
                      ? 'Vui lòng nhập họ tên'
                      : null,
                ),
                const SizedBox(height: 12),

                _buildTextField(
                  controller: userCtrl,
                  label: 'Username',
                  icon: Icons.alternate_email,
                  // Thường thì username không cho sửa khi update,
                  // nếu muốn chặn sửa hãy thêm: enabled: !isUpdateMode
                  enabled: !isUpdateMode,
                  validator: (val) => val == null || val.trim().isEmpty
                      ? 'Vui lòng nhập username'
                      : null,
                ),
                const SizedBox(height: 12),

                _buildRoleDropdown(),

                const SizedBox(height: 12),
                if (!isUpdateMode) _buildDefaultPasswordNotice(),

                const SizedBox(height: 24),
                _buildActionButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- WIDGETS CON ĐƯỢC TÁCH RA ---

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
    bool enabled = true,
  }) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      validator: validator,
      autovalidateMode:
          AutovalidateMode.onUserInteraction, // Báo lỗi ngay khi gõ
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: enabled ? null : Colors.grey),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: enabled ? Colors.grey.shade50 : Colors.grey.shade200,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
    );
  }

  Widget _buildRoleDropdown() {
    return DropdownButtonFormField<UserRole>(
      value: selectedRole,
      decoration: InputDecoration(
        labelText: 'Vai trò',
        prefixIcon: const Icon(Icons.security, color: AppColors.primary),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
      items: const [
        DropdownMenuItem(value: UserRole.student, child: Text('Học viên')),
        DropdownMenuItem(value: UserRole.admin, child: Text('Quản trị viên')),
        DropdownMenuItem(value: UserRole.teacher, child: Text('Giáo viên')),
      ],
      onChanged: (value) {
        if (value != null) setState(() => selectedRole = value);
      },
    );
  }

  Widget _buildDefaultPasswordNotice() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.orange.withOpacity(0.3)),
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
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: TextButton(
            onPressed: isLoading ? null : () => Get.back(),
            child: const Text('Hủy', style: TextStyle(color: Colors.grey)),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.action,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            onPressed: isLoading ? null : _handleSubmit,
            child: isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : Text(
                    isUpdateMode ? 'CẬP NHẬT' : 'TẠO MỚI',
                    style: AppTextStyles.buttonWhite,
                  ),
          ),
        ),
      ],
    );
  }
}
