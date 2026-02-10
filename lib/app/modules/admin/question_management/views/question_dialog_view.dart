import 'package:flutter/material.dart';
import 'package:get/get.dart';

// --- IMPORTS ---
import 'package:blooket/app/core/constants/app_color.dart';
import 'package:blooket/app/core/utils/dialogs.dart';
import 'package:blooket/app/data/enum/media_type.dart';
import 'package:blooket/app/data/enum/question_type.dart';
import 'package:blooket/app/data/model/question_content_model.dart'; // Model chuẩn hóa
import 'package:blooket/app/data/model/question_model.dart';
import 'package:blooket/app/data/model/request/content/create_question_request.dart';
import 'package:blooket/app/data/model/request/content/question_content_request.dart';
import 'package:blooket/app/data/model/request/content/update_question_request.dart';

// --- WIDGETS ---
import 'package:blooket/app/modules/admin/question_management/widgets/answer_form/answer_multi_chose.dart';
import 'package:blooket/app/modules/admin/question_management/widgets/answer_form/answer_rearrange.dart';
import 'package:blooket/app/modules/admin/question_management/widgets/answer_form/answer_true_false.dart';
import 'package:blooket/app/modules/admin/question_management/widgets/answer_form/answer_typing.dart';
import 'package:blooket/app/modules/admin/question_management/widgets/bordered_stat_widget.dart';
import 'package:blooket/app/modules/admin/question_management/widgets/time_limit_dialog_content.dart';

class QuestionDialogView extends StatefulWidget {
  final String packId;
  final QuestionModel? initialData; // Dữ liệu cũ (nếu Edit)
  final Function(dynamic request)? onSave;

  const QuestionDialogView({
    super.key,
    required this.packId,
    this.initialData,
    this.onSave,
  });

  @override
  State<QuestionDialogView> createState() => _QuestionDialogViewState();
}

class _QuestionDialogViewState extends State<QuestionDialogView> {
  late QuestionType selectedType;
  final contentCtrl = TextEditingController();
  int timeLimit = 30;
  bool isRandom = false;
  int points = 1;

  // Biến tạm để hứng dữ liệu từ các Form con
  List<String> _currentOptions = [];
  List<String> _currentAnswers = [];

  @override
  void initState() {
    super.initState();
    _initData();
  }

  // --- LOGIC QUAN TRỌNG: KHỞI TẠO DỮ LIỆU ---
  void _initData() {
    if (widget.initialData != null) {
      final q = widget.initialData!;

      // 1. Map dữ liệu chung
      selectedType = q.type;
      contentCtrl.text = q.content.question; // Lấy từ class cha QuestionContent
      timeLimit = q.timeLimit;
      isRandom = q.isRandom;
      points = q.point;

      // 2. Map dữ liệu riêng theo từng loại Content
      final content = q.content;

      if (content is MultipleChoiceContent) {
        // Trắc nghiệm
        if (selectedType == QuestionType.trueFalse) {
          // True/False (Logic đặc biệt: Option cố định, chỉ lấy Answer)
          _currentOptions = ["True", "False"];
          final correctOpt = content.options.firstWhereOrNull(
            (e) => e.isCorrect,
          );
          _currentAnswers = correctOpt != null ? [correctOpt.text] : ["True"];
        } else {
          // Multiple Choice thường
          _currentOptions = content.options.map((e) => e.text).toList();
          _currentAnswers = content.options
              .where((e) => e.isCorrect)
              .map((e) => e.text)
              .toList();
        }
      } else if (content is TypingContent) {
        // Typing: Chỉ có đáp án chấp nhận
        _currentAnswers = List.from(content.acceptableAnswers);
        _currentOptions = [];
      } else if (content is ArrangeContent) {
        // Arrange: Segments là danh sách từ cần sắp xếp
        _currentAnswers = content.segments.map((e) => e.text).toList();
        _currentOptions = [];
      }
    } else {
      // 3. Tạo mới (Mặc định)
      selectedType = QuestionType.multipleChoice;
    }
  }

  @override
  void dispose() {
    contentCtrl.dispose();
    super.dispose();
  }

  // --- VALIDATE & SAVE ---
  void _validateAndSave() {
    // 1. Validate Câu hỏi
    if (selectedType != QuestionType.arrange &&
        contentCtrl.text.trim().isEmpty) {
      AppDialogs.showWarning("Vui lòng nhập nội dung câu hỏi.");
      return;
    }

    QuestionContentRequest? contentRequest;

    // 2. Build Content Request & Validate Chi tiết
    switch (selectedType) {
      case QuestionType.multipleChoice:
      case QuestionType.trueFalse:
        if (selectedType == QuestionType.multipleChoice &&
            _currentOptions.length < 2) {
          AppDialogs.showWarning("Cần ít nhất 2 lựa chọn.");
          return;
        }
        if (_currentAnswers.isEmpty) {
          AppDialogs.showWarning("Vui lòng chọn đáp án đúng.");
          return;
        }

        // Map sang OptionRequest
        List<OptionRequest> optionsList = [];
        for (int i = 0; i < _currentOptions.length; i++) {
          final text = _currentOptions[i];
          optionsList.add(
            OptionRequest(
              id: i, // Fake ID hoặc null
              text: text,
              isCorrect: _currentAnswers.contains(text),
            ),
          );
        }

        contentRequest = MultipleChoiceContentRequest(
          question: contentCtrl.text.trim(),
          options: optionsList,
        );
        break;

      case QuestionType.typing:
        if (_currentAnswers.isEmpty) {
          AppDialogs.showWarning("Vui lòng nhập ít nhất 1 đáp án.");
          return;
        }
        contentRequest = TypingContentRequest(
          question: contentCtrl.text.trim(),
          acceptableAnswers: _currentAnswers,
        );
        break;

      case QuestionType.arrange:
        if (_currentAnswers.length < 2) {
          AppDialogs.showWarning("Cần ít nhất 2 từ để sắp xếp.");
          return;
        }

        List<SegmentRequest> segments = [];
        List<int> correctOrder = [];
        for (int i = 0; i < _currentAnswers.length; i++) {
          segments.add(SegmentRequest(id: i, text: _currentAnswers[i]));
          correctOrder.add(i);
        }

        contentRequest = ArrangeContentRequest(
          question: "Sắp xếp câu",
          segments: segments,
          correctOrder: correctOrder,
          correctText: _currentAnswers.join(" "),
        );
        break;

      default:
        return;
    }

    // 3. Callback về Controller
    if (widget.initialData == null) {
      // Create Request
      final request = CreateQuestionRequest(
        packId: widget.packId,
        type: selectedType,
        point: points,
        mediaType: MediaType.none,
        content: contentRequest!,
      );
      widget.onSave?.call(request);
    } else {
      // Update Request
      final request = UpdateQuestionRequest(
        type: selectedType,
        point: points,
        mediaType: MediaType.none,
        content: contentRequest!,
      );
      widget.onSave?.call(request);
    }

    Get.back();
  }

  // --- UI ---
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final dialogWidth = screenWidth > 950 ? 900.0 : screenWidth * 0.95;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.all(16),
      child: Container(
        width: dialogWidth,
        constraints: BoxConstraints(
          maxHeight: Get.height * 0.9,
          minHeight: 500,
        ),
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    if (selectedType != QuestionType.arrange)
                      _buildQuestionInput(),
                    const SizedBox(height: 24),
                    _buildAnswerForm(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: AppColor.pink,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Row(
        children: [
          BorderedStatWidget(
            title: 'Time',
            value: '${timeLimit}s',
            icon: Icons.timer_outlined,
            onTap: () async {
              final val = await showTimeLimitDialog(defaultValue: timeLimit);
              if (val != null) setState(() => timeLimit = val);
            },
          ),
          const SizedBox(width: 12),
          // Chỉ cho đổi loại câu hỏi khi TẠO MỚI (để tránh lỗi data structure)
          if (widget.initialData == null)
            BorderedStatWidget(
              title: selectedType.name.toUpperCase(),
              icon: Icons.category_outlined,
              onTap: _showTypeSelector,
            ),
          const Spacer(),
          IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.close, color: Colors.white),
          ),
          const SizedBox(width: 12),
          ElevatedButton.icon(
            onPressed: _validateAndSave,
            icon: const Icon(Icons.save, size: 18),
            label: const Text("Lưu"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppColor.pink,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionInput() {
    return TextField(
      controller: contentCtrl,
      textAlign: TextAlign.center,
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
      decoration: InputDecoration(
        hintText: "Nhập câu hỏi...",
        filled: true,
        fillColor: Colors.grey.shade50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildAnswerForm() {
    // KeyedSubtree để buộc rebuild widget khi đổi type hoặc load data edit
    return KeyedSubtree(
      key: ValueKey("${selectedType}_${widget.initialData?.id}"),
      child: switch (selectedType) {
        QuestionType.multipleChoice => AnswerMultiChose(
          initialOptions: _currentOptions.isNotEmpty ? _currentOptions : null,
          initialCorrectAnswers: _currentAnswers.isNotEmpty
              ? _currentAnswers
              : null,
          onChanged: (opts, ans) {
            _currentOptions = opts;
            _currentAnswers = ans;
          },
        ),
        QuestionType.trueFalse => AnswerTrueFalse(
          initialValue: _currentAnswers.isNotEmpty
              ? (_currentAnswers.first.toLowerCase() == 'true')
              : null,
          onChanged: (val) {
            _currentAnswers = [val.toString()];
            _currentOptions = ["True", "False"];
          },
        ),
        QuestionType.typing => AnswerTyping(
          initialAnswers: _currentAnswers.isNotEmpty ? _currentAnswers : null,
          onChanged: (ans) {
            _currentAnswers = ans;
            _currentOptions = [];
          },
        ),
        QuestionType.arrange => AnswerRearrange(
          initialWords: _currentAnswers.isNotEmpty ? _currentAnswers : null,
          onChanged: (words) {
            _currentAnswers = words;
            _currentOptions = [];
          },
        ),
        _ => const SizedBox(),
      },
    );
  }

  void _showTypeSelector() async {
    final type = await Get.dialog<QuestionType>(
      Dialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: QuestionType.values
              .where((e) => e != QuestionType.unknown)
              .map(
                (e) => ListTile(
                  title: Text(e.name.toUpperCase()),
                  onTap: () => Get.back(result: e),
                ),
              )
              .toList(),
        ),
      ),
    );
    if (type != null && type != selectedType) {
      setState(() {
        selectedType = type;
        _currentOptions = [];
        _currentAnswers = [];
        contentCtrl.clear();
      });
    }
  }
}
