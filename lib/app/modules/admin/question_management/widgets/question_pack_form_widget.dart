import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:blooket/app/core/components/dialog/base_form_dialog.dart';
import 'package:blooket/app/core/components/dialog/form_common_widgets.dart';

import 'package:blooket/app/data/model/question_pack_model.dart';
import 'package:blooket/app/data/model/request/content/question_pack_request.dart';

class QuestionPackFormWidget extends StatefulWidget {
  final String levelId;
  final QuestionPackModel? packModel;
  final Future<void> Function(QuestionPackRequest request) onSave;

  const QuestionPackFormWidget({
    super.key,
    required this.levelId,
    this.packModel,
    required this.onSave,
  });

  @override
  State<QuestionPackFormWidget> createState() => _QuestionPackFormWidgetState();
}

class _QuestionPackFormWidgetState extends State<QuestionPackFormWidget> {
  late TextEditingController _titleCtrl;
  late TextEditingController _descCtrl;
  late TextEditingController _thumbCtrl;

  bool _isPublic = true;

  @override
  void initState() {
    super.initState();

    _titleCtrl = TextEditingController(text: widget.packModel?.title ?? '');
    _descCtrl = TextEditingController(
      text: widget.packModel?.description ?? '',
    );
    _thumbCtrl = TextEditingController(text: widget.packModel?.thumbnail ?? '');
    _isPublic = widget.packModel?.isPublic ?? true;
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _thumbCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (_titleCtrl.text.trim().isEmpty) {
      Get.snackbar(
        "Thiếu thông tin",
        "Vui lòng nhập tên bộ đề",
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    final request = QuestionPackRequest(
      title: _titleCtrl.text.trim(),
      levelId: widget.levelId,
      description: _descCtrl.text.trim(),
      thumbnail: _thumbCtrl.text.trim(),
      isPublic: _isPublic,
    );

    await widget.onSave(request);

    if (Get.isDialogOpen ?? false) Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return BaseFormDialog(
      title: widget.packModel == null ? 'THÊM BỘ ĐỀ MỚI' : 'CẬP NHẬT BỘ ĐỀ',
      subtitle: widget.packModel == null
          ? 'Tạo bộ câu hỏi mới cho cấp độ này'
          : 'Chỉnh sửa thông tin bộ câu hỏi',
      icon: Icons.library_books_rounded,
      iconColor: const Color(0xFF6C63FF),
      onSave: _handleSubmit,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const FormSectionTitle(
            title: "Thông tin chung",
            icon: Icons.info_outline_rounded,
            color: Colors.blueAccent,
          ),
          const SizedBox(height: 16),

          FormInputWithIcon(
            controller: _titleCtrl,
            label: "Tên bộ đề (Ví dụ: Bài 1 - Nhập môn)",
            icon: Icons.title_rounded,
            iconColor: Colors.blue,
          ),

          const SizedBox(height: 16),

          FormInputWithIcon(
            controller: _descCtrl,
            label: "Mô tả nội dung",
            icon: Icons.description_outlined,
            iconColor: Colors.teal,
            maxLines: 3,
          ),

          const SizedBox(height: 16),

          FormInputWithIcon(
            controller: _thumbCtrl,
            label: "Link hình ảnh (Thumbnail)",
            icon: Icons.image_rounded,
            iconColor: Colors.pinkAccent,
          ),

          const SizedBox(height: 24),

          const FormSectionTitle(
            title: "Cấu hình",
            icon: Icons.settings_suggest_rounded,
            color: Colors.orangeAccent,
          ),
          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _isPublic
                        ? Colors.green.withOpacity(0.1)
                        : Colors.grey.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _isPublic ? Icons.public : Icons.public_off,
                    color: _isPublic ? Colors.green : Colors.grey,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Công khai bộ đề",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade800,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        _isPublic
                            ? "Mọi người đều có thể nhìn thấy"
                            : "Chỉ mình bạn thấy (Ẩn)",
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: _isPublic,
                  activeColor: const Color(0xFF00B894),
                  onChanged: (val) {
                    setState(() {
                      _isPublic = val;
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
