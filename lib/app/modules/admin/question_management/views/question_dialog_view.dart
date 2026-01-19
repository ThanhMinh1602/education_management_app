import 'package:blooket/app/core/utils/dialogs.dart';
import 'package:blooket/app/data/model/question_model.dart';
import 'package:blooket/app/data/model/request/create_question_request.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:blooket/app/core/constants/app_color.dart';
import 'package:blooket/app/data/enum/question_type.dart';
import 'package:blooket/app/modules/admin/question_management/widgets/answer_form/answer_multi_chose.dart';
import 'package:blooket/app/modules/admin/question_management/widgets/answer_form/answer_rearrange.dart';
import 'package:blooket/app/modules/admin/question_management/widgets/answer_form/answer_true_false.dart';
import 'package:blooket/app/modules/admin/question_management/widgets/answer_form/answer_typing.dart';
import 'package:blooket/app/modules/admin/question_management/widgets/bordered_stat_widget.dart';
import 'package:blooket/app/modules/admin/question_management/widgets/time_limit_dialog_content.dart';

class QuestionDialogView extends StatefulWidget {
  final String setId;
  final QuestionModel? initialData;
  final Function(QuestionRequest) onSave;

  const QuestionDialogView({
    super.key,
    required this.setId,
    required this.onSave,
    this.initialData,
  });

  @override
  State<QuestionDialogView> createState() => _QuestionDialogViewState();
}

class _QuestionDialogViewState extends State<QuestionDialogView> {
  late QuestionType selectedType;
  final contentCtrl = TextEditingController();
  int timeLimit = 30;
  bool isRandom = false;

  List<String> _currentOptions = [];
  List<String> _currentAnswers = [];

  @override
  void initState() {
    super.initState();
    if (widget.initialData != null) {
      selectedType = widget.initialData!.type ?? QuestionType.multipleChoice;
      contentCtrl.text = widget.initialData!.content ?? '';
      timeLimit = widget.initialData!.timeLimit ?? 30;
      isRandom = widget.initialData!.isRandom ?? false;

      _currentOptions = widget.initialData!.options ?? [];
      _currentAnswers = widget.initialData!.answers ?? [];
    } else {
      selectedType = QuestionType.multipleChoice;
    }
  }

  @override
  void dispose() {
    contentCtrl.dispose();
    super.dispose();
  }

  // --- 1. Hàm hiển thị Dialog Cảnh Báo ---
  void _showWarningDialog(String message) {
    AppDialogs.showWarning(message);
  }

  // --- 2. Hàm Validate và Save ---
  void _validateAndSave() {
    // 2.1 Kiểm tra nội dung câu hỏi (trừ loại sắp xếp vì nội dung nằm trong options)
    if (selectedType != QuestionType.rearrange &&
        contentCtrl.text.trim().isEmpty) {
      _showWarningDialog("Vui lòng nhập nội dung câu hỏi.");
      return;
    }

    // 2.2 Kiểm tra logic từng loại câu hỏi
    switch (selectedType) {
      case QuestionType.multipleChoice:
        // Phải có ít nhất 2 lựa chọn không rỗng
        final validOptions = _currentOptions
            .where((op) => op.trim().isNotEmpty)
            .toList();
        if (validOptions.length < 4) {
          _showWarningDialog("Cần nhập đủ 4 phương án lựa chọn.");
          return;
        }
        // Phải chọn ít nhất 1 đáp án đúng
        if (_currentAnswers.isEmpty) {
          _showWarningDialog("Vui lòng tích chọn ít nhất 1 đáp án đúng.");
          return;
        }
        break;

      case QuestionType.typing:
        // Phải nhập ít nhất 1 đáp án chấp nhận
        final validAnswers = _currentAnswers
            .where((ans) => ans.trim().isNotEmpty)
            .toList();
        if (validAnswers.isEmpty) {
          _showWarningDialog("Vui lòng nhập câu trả lời đúng.");
          return;
        }
        break;

      case QuestionType.rearrange:
        // Với loại sắp xếp, answers chính là các từ cần sắp xếp
        if (_currentAnswers.isEmpty || _currentAnswers.length < 2) {
          _showWarningDialog("Vui lòng nhập ít nhất 2 từ để sắp xếp.");
          return;
        }
        break;

      case QuestionType.trueFalse:
        // True/False thường mặc định là True nếu chưa chọn, nên ít lỗi
        if (_currentAnswers.isEmpty) {
          _currentAnswers = ["true"];
        }
        break;
    }

    // 2.3 Save nếu tất cả hợp lệ
    final questionReq = QuestionRequest(
      setId: widget.setId,
      type: selectedType.value,
      content: contentCtrl.text.trim(),
      timeLimit: timeLimit,
      isRandom: isRandom,
      options: _currentOptions,
      answers: _currentAnswers,
    );

    widget.onSave(questionReq);
    Get.back(); // Đóng dialog chính
  }

  Widget _getAnswerFromType() {
    return KeyedSubtree(
      key: ValueKey(selectedType),
      child: switch (selectedType) {
        QuestionType.multipleChoice => AnswerMultiChose(
          initialOptions: widget.initialData?.options,
          initialCorrectAnswers: widget.initialData?.answers,
          onChanged: (options, answers) {
            _currentOptions = options;
            _currentAnswers = answers;
          },
        ),
        QuestionType.rearrange => AnswerRearrange(
          initialWords: widget.initialData?.answers,
          onChanged: (words) {
            setState(() {
              contentCtrl.text = words.join(' - ');
              _currentAnswers = words;
              // Rearrange không dùng options, có thể clear hoặc gán giống answer
              _currentOptions = [];
            });
          },
        ),
        QuestionType.trueFalse => AnswerTrueFalse(
          initialValue: bool.parse(
            widget.initialData?.answers?.first ?? 'true',
          ),
          onChanged: (isTrue) {
            // True/False không cần options, chỉ cần answers
            _currentAnswers = [isTrue.toString()];
            _currentOptions = [];
          },
        ),
        // Sửa lại đoạn này để hứng dữ liệu từ Typing Form
        QuestionType.typing => AnswerTyping(
          initialAnswers: widget.initialData?.answers, // Truyền data cũ nếu có
          onChanged: (answers) {
            _currentAnswers = answers;
            _currentOptions = []; // Typing không có options
          },
        ),
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final dialogWidth = screenWidth > 950 ? 900.0 : screenWidth * 0.95;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.all(16),
      child: Container(
        width: dialogWidth,
        constraints: BoxConstraints(
          maxHeight: screenHeight * 0.9,
          minHeight: 400,
        ),
        child: Column(
          children: [
            _buildDialogHeaderControl(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (selectedType != QuestionType.rearrange)
                      _buildInputQuestion(),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: _getAnswerFromType(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDialogHeaderControl() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: const BoxDecoration(
        color: AppColor.pink,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          BorderedStatWidget(
            title: 'Time Limit',
            value: '${timeLimit}s',
            icon: Icons.timer_outlined,
            onTap: () async {
              final newTimeLimit = await showTimeLimitDialog(
                defaultValue: timeLimit,
              );
              if (newTimeLimit != null) {
                setState(() => timeLimit = newTimeLimit);
              }
            },
          ),
          const SizedBox(width: 12),
          BorderedStatWidget(
            title: 'Random',
            icon: Icons.shuffle,
            trailing: SizedBox(
              height: 24,
              width: 24,
              child: Checkbox(
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
                activeColor: AppColor.white,
                checkColor: AppColor.pink,
                side: const BorderSide(color: AppColor.white, width: 2.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                value: isRandom,
                onChanged: (val) => setState(() => isRandom = val ?? false),
              ),
            ),
          ),
          const SizedBox(width: 12),
          if (widget.initialData == null)
            BorderedStatWidget(
              title: selectedType.title,
              icon: Icons.category_outlined,
              onTap: () async {
                final type = await Get.dialog<QuestionType>(
                  _buildTypeSelectionDialog(),
                );

                if (type != null && type != selectedType) {
                  setState(() {
                    selectedType = type;
                    _currentOptions = [];
                    _currentAnswers = [];
                  });
                }
              },
            ),
          const Spacer(),
          const SizedBox(width: 20),
          Container(height: 40, width: 1, color: Colors.white.withOpacity(0.5)),
          const SizedBox(width: 20),
          const Spacer(),
          BorderedStatWidget(
            title: 'Cancel',
            icon: Icons.close,
            onTap: () => Get.back(),
          ),
          const SizedBox(width: 12),
          BorderedStatWidget(
            title: 'Save',
            icon: Icons.check_circle_outline,
            // GỌI HÀM VALIDATE MỚI Ở ĐÂY
            onTap: _validateAndSave,
          ),
        ],
      ),
    );
  }

  // ... (Giữ nguyên _buildInputQuestion và _buildTypeSelectionDialog)
  Widget _buildInputQuestion() {
    return Container(
      alignment: Alignment.center,
      constraints: const BoxConstraints(minHeight: 150),
      padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 32.0),
      child: TextField(
        controller: contentCtrl,
        textAlign: TextAlign.center,
        maxLines: null,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "Nhập câu hỏi ở đây...",
          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 20),
          fillColor: Colors.grey.withOpacity(0.05),
          filled: true,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColor.pink.withOpacity(0.3)),
          ),
        ),
      ),
    );
  }

  Widget _buildTypeSelectionDialog() {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      backgroundColor: Colors.white,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          width: 300,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16.0),
                width: double.infinity,
                color: Colors.grey.shade50,
                child: const Text(
                  "Select Question Type",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const Divider(height: 1),
              ...QuestionType.values.map((qt) {
                final isSelected = qt == selectedType;
                return InkWell(
                  onTap: () => Get.back(result: qt),
                  child: Container(
                    color: isSelected
                        ? AppColor.pink.withOpacity(0.1)
                        : Colors.transparent,
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 4,
                      ),
                      title: Text(
                        qt.title,
                        style: TextStyle(
                          color: isSelected ? AppColor.pink : Colors.black87,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                      trailing: isSelected
                          ? const Icon(
                              Icons.check_circle,
                              color: AppColor.pink,
                              size: 20,
                            )
                          : null,
                    ),
                  ),
                );
              }),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
