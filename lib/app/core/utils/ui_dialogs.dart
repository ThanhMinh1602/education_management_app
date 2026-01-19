import 'package:blooket/app/core/components/text_field/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:blooket/app/core/constants/app_colors.dart';
import 'package:blooket/app/core/constants/app_text_styles.dart';

/// Small collection of reusable UI dialogs. Keep dialogs UI-only and return
/// selected/entered values to the caller so controllers stay logic-only.
class UiDialogs {
  UiDialogs._();

  /// Show a dialog to create or edit a Class. If [initial*] values are
  /// provided, the dialog works as an edit form.
  /// Returns a map with keys: 'className','subject','schedule' or null when
  /// cancelled.
  static Future<Map<String, String>?> showClassForm({
    String title = 'THÊM LỚP MỚI',
    String? initialName,
    String? initialSubject,
    String? initialSchedule,
  }) async {
    final nameCtrl = TextEditingController(text: initialName ?? '');
    final subjectCtrl = TextEditingController(text: initialSubject ?? '');
    final scheduleCtrl = TextEditingController(text: initialSchedule ?? '');

    final result = await Get.dialog<Map<String, String>>(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(title, style: AppTextStyles.dialogTitle),
                const SizedBox(height: 16),
                TextField(
                  controller: nameCtrl,
                  decoration: InputDecoration(
                    labelText: 'Tên lớp (VD: Tiếng Trung K15)',
                    prefixIcon: const Icon(
                      Icons.class_,
                      color: AppColors.primary,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: subjectCtrl,
                  decoration: InputDecoration(
                    labelText: 'Môn học (VD: HSK 3)',
                    prefixIcon: const Icon(
                      Icons.book,
                      color: AppColors.primary,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: scheduleCtrl,
                  decoration: InputDecoration(
                    labelText: 'Lịch học (VD: 2-4-6 19:30)',
                    prefixIcon: const Icon(
                      Icons.access_time,
                      color: AppColors.primary,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade50,
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
                        onPressed: () {
                          final name = nameCtrl.text.trim();
                          if (name.isEmpty) {
                            Get.snackbar(
                              'Lỗi',
                              'Vui lòng nhập tên lớp',
                              snackPosition: SnackPosition.BOTTOM,
                            );
                            return;
                          }
                          Get.back(
                            result: {
                              'className': name,
                              'subject': subjectCtrl.text.trim(),
                              'schedule': scheduleCtrl.text.trim(),
                            },
                          );
                        },
                        child: const Text(
                          'LƯU',
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
      ),
    );

    return result;
  }

  /// Show a simple input dialog for creating/renaming a question set.
  /// Returns the entered name or null when cancelled.
  static Future<String?> showQuestionSetName({
    String title = 'TÊN BỘ ĐỀ',
    String? initial,
    Function(String)? onSubmitted,
  }) async {
    final ctrl = TextEditingController(text: initial ?? '');
    final res = await Get.dialog<String>(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(title, style: AppTextStyles.dialogTitle),
                const SizedBox(height: 12),
                CustomTextField(
                  labelText: title,
                  controller: ctrl,
                  onSubmitted: onSubmitted,
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
                        onPressed: () {
                          final name = ctrl.text.trim();
                          if (name.isEmpty) {
                            Get.snackbar(
                              'Lỗi',
                              'Vui lòng nhập tên bộ đề',
                              snackPosition: SnackPosition.BOTTOM,
                            );
                            return;
                          }
                          Get.back(result: name);
                        },
                        child: const Text(
                          'LƯU',
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
      ),
    );

    return res;
  }

  /// Show an assign dialog where user selects a ClassModel and a date range.
  /// Returns a map: { 'class': ClassModel, 'start': DateTime, 'end': DateTime } or null.
  static Future<Map<String, dynamic>?> showAssignDialog({
    required List<dynamic> classes,
    required Color actionColor,
    required String title,
    String? questionSetName,
  }) async {
    dynamic selectedClass;
    DateTime startDate = DateTime.now();
    DateTime endDate = DateTime.now().add(const Duration(days: 7));
    final dateTextCtrl = TextEditingController(
      text:
          "${startDate.day}/${startDate.month}/${startDate.year} - ${endDate.day}/${endDate.month}/${endDate.year}",
    );

    final res = await Get.dialog<Map<String, dynamic>>(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.dialogTitle),
                const SizedBox(height: 12),
                if (questionSetName != null)
                  Text(
                    'Bộ đề: $questionSetName',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                const SizedBox(height: 8),
                DropdownButtonFormField<dynamic>(
                  decoration: InputDecoration(
                    labelText: 'Chọn lớp áp dụng',
                    prefixIcon: Icon(Icons.class_, color: AppColors.primary),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                  ),
                  items: classes
                      .map(
                        (c) => DropdownMenuItem(
                          value: c,
                          child: Text(
                            (c.className ?? '').toString(),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (val) => selectedClass = val,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: dateTextCtrl,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Thời gian làm bài',
                    prefixIcon: Icon(
                      Icons.date_range,
                      color: AppColors.primary,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                  ),
                  onTap: () async {
                    final picked = await showDateRangePicker(
                      context: Get.context!,
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2030),
                      initialDateRange: DateTimeRange(
                        start: startDate,
                        end: endDate,
                      ),
                      builder: (context, child) => Theme(
                        data: ThemeData.light().copyWith(
                          primaryColor: actionColor,
                          colorScheme: ColorScheme.light(primary: actionColor),
                        ),
                        child: child!,
                      ),
                    );
                    if (picked != null) {
                      startDate = picked.start;
                      endDate = picked.end;
                      dateTextCtrl.text =
                          "${startDate.day}/${startDate.month}/${startDate.year} - ${endDate.day}/${endDate.month}/${endDate.year}";
                    }
                  },
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
                          backgroundColor: actionColor,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          if (selectedClass == null) {
                            Get.snackbar(
                              'Lỗi',
                              'Vui lòng chọn lớp học',
                              snackPosition: SnackPosition.BOTTOM,
                            );
                            return;
                          }
                          Get.back(
                            result: {
                              'class': selectedClass,
                              'start': startDate,
                              'end': endDate,
                            },
                          );
                        },
                        child: const Text(
                          'XÁC NHẬN',
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
      ),
    );

    return res;
  }

  /// Show Add Student form and return map with keys: fullName, username, role
  static Future<Map<String, String>?> showAddStudentForm({
    String title = 'CẤP TÀI KHOẢN MỚI',
  }) async {
    final nameCtrl = TextEditingController();
    final userCtrl = TextEditingController();
    String selectedRole = 'student';

    final res = await Get.dialog<Map<String, String>>(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(title, style: AppTextStyles.dialogTitle),
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
                DropdownButtonFormField<String>(
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
                  items: const [
                    DropdownMenuItem(value: 'student', child: Text('Học viên')),
                    DropdownMenuItem(
                      value: 'admin',
                      child: Text('Quản trị viên'),
                    ),
                  ],
                  onChanged: (v) {
                    if (v != null) selectedRole = v;
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
                        onPressed: () {
                          if (nameCtrl.text.isEmpty || userCtrl.text.isEmpty) {
                            Get.snackbar(
                              'Lỗi',
                              'Vui lòng nhập đầy đủ thông tin',
                              snackPosition: SnackPosition.BOTTOM,
                            );
                            return;
                          }
                          Get.back(
                            result: {
                              'fullName': nameCtrl.text.trim(),
                              'username': userCtrl.text.trim(),
                              'role': selectedRole,
                            },
                          );
                        },
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
      ),
    );

    return res;
  }
}
