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
        borderRadius: BorderRadius.circular(16), // Bo góc mềm hơn chút
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            offset: const Offset(0, 4),
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        spacing: 16.0,
        crossAxisAlignment:
            CrossAxisAlignment.start, // Căn lề trên để đẹp hơn khi nội dung dài
        children: [
          // --- CỘT 1: CÁC NÚT THAO TÁC (Đã tăng Flex để nút rộng rãi hơn) ---
          Expanded(
            flex: 1,
            child: Column(
              spacing: 8, // Khoảng cách giữa nút Edit và hàng dưới
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Nút Edit
                CustomIconButton(
                  icon: Icons.edit_note_rounded, // Icon đẹp hơn
                  iconColor: Colors.white,
                  backgroundColor: AppColor.pink,
                  label: 'Sửa', // Tiếng Việt
                  onTap: onEdit,
                ),

                // 2. Hàng nút Xóa/Copy
                Row(
                  spacing: 8,
                  children: [
                    Expanded(
                      child: CustomIconButton(
                        icon: Icons.delete_outline_rounded,
                        iconColor: Colors.white,
                        backgroundColor:
                            AppColors.primary, // Hoặc màu đỏ nhạt nếu muốn
                        onTap: onDelete,
                        // height: 36,
                      ),
                    ),
                    Expanded(
                      child: CustomIconButton(
                        icon: Icons.copy_rounded,
                        iconColor: Colors.white,
                        backgroundColor: AppColors.primary,
                        onTap: onCopy,
                        // height: 36,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // --- CỘT 2: NỘI DUNG CÂU HỎI ---
          Expanded(
            flex: 13, // Giảm flex xuống để chia sẻ không gian
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Số thứ tự + Nội dung
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${index + 1}. ",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: AppColor.primary,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        // FIX LOGIC: Lấy từ content.question
                        questionModel.content.question.isEmpty
                            ? 'Nội dung câu hỏi đang trống...'
                            : questionModel.content.question,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16, // Font to hơn dễ đọc
                          color: Color(0xFF2D3436),
                          height: 1.3, // Giãn dòng nhẹ
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // Loại câu hỏi + Đáp án (Hiển thị nhỏ bên dưới)
                Wrap(
                  spacing: 12,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Text(
                        // FIX LOGIC: Lấy tên Enum
                        questionModel.type.label.toUpperCase(),
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    // Hiển thị sơ lược đáp án
                    Text(
                      "•  Đáp án: ${questionModel.content.answersDisplay.join(', ')}",
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 13,
                        fontStyle: FontStyle.italic,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ],
            ),
          ),

          // --- CỘT 3: ĐIỀU KHIỂN LÊN/XUỐNG ---
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              border: Border(left: BorderSide(color: Colors.grey.shade100)),
            ),
            child: UpDownControls(
              onUp: onUp,
              onDown: onDown,
              iconSize: 20, // Icon nhỏ gọn lại
              iconColor: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}
