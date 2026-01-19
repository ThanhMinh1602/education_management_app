import 'package:flutter/material.dart';
import 'package:blooket/app/core/components/button/custom_icon_button.dart';
import 'package:blooket/app/core/constants/app_color.dart';
import 'package:blooket/app/core/constants/app_colors.dart';
import 'package:blooket/app/data/model/question_model.dart';
import 'package:blooket/app/modules/admin/question_management/widgets/up_down_controls.dart';

class QuestionListItem extends StatelessWidget {
  const QuestionListItem({
    super.key,
    required this.questionModel,
    required this.index,
    this.onEdit,
    this.onDelete,
    this.onCopy,
    this.onUp,
    this.onDown,
  });

  final QuestionModel questionModel;
  final int index;

  // Callback actions để Controller xử lý logic
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onCopy;
  final VoidCallback? onUp;
  final VoidCallback? onDown;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        spacing: 8.0,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // --- Cột Nút Bấm ---
          Expanded(
            flex: 1,
            child: Column(
              spacing: 8,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Nút Edit
                CustomIconButton(
                  icon: Icons.edit_outlined,
                  iconColor: Colors.white,
                  backgroundColor: AppColor.pink,
                  label: 'Edit',
                  onTap: onEdit, // Gọi callback từ bên ngoài
                ),
                // 2. Hàng nút Delete/Copy
                Row(
                  spacing: 8,
                  children: [
                    Expanded(
                      child: CustomIconButton(
                        icon: Icons.delete_outline,
                        iconColor: Colors.white,
                        backgroundColor: AppColors.primary,
                        onTap: onDelete,
                      ),
                    ),
                    Expanded(
                      child: CustomIconButton(
                        icon: Icons.copy_outlined,
                        iconColor: Colors.white,
                        backgroundColor: AppColors.primary,
                        onTap: onCopy,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // --- Cột Nội Dung ---
          Expanded(
            flex: 8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  questionModel.content ?? 'Nội dung câu hỏi trống',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  "Loại: ${questionModel.type?.title}",
                  style: const TextStyle(color: Colors.grey),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          // --- Cột Up/Down ---
          UpDownControls(onUp: onUp, onDown: onDown),
        ],
      ),
    );
  }
}
