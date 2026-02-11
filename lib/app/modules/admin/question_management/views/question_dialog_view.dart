import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'package:blooket/app/core/constants/app_color.dart';
import 'package:blooket/app/core/utils/dialogs.dart';
import 'package:blooket/app/data/enum/media_type.dart';
import 'package:blooket/app/data/enum/question_type.dart';
import 'package:blooket/app/data/model/question_content_model.dart';
import 'package:blooket/app/data/model/question_model.dart';
import 'package:blooket/app/data/model/request/content/create_question_request.dart';
import 'package:blooket/app/data/model/request/content/question_content_request.dart';
import 'package:blooket/app/data/model/request/content/update_question_request.dart';

import 'package:blooket/app/modules/admin/question_management/widgets/answer_form/answer_multi_chose.dart';
import 'package:blooket/app/modules/admin/question_management/widgets/answer_form/answer_rearrange.dart';
import 'package:blooket/app/modules/admin/question_management/widgets/answer_form/answer_true_false.dart';
import 'package:blooket/app/modules/admin/question_management/widgets/answer_form/answer_typing.dart';
import 'package:blooket/app/modules/admin/question_management/widgets/bordered_stat_widget.dart';
import 'package:blooket/app/modules/admin/question_management/widgets/time_limit_dialog_content.dart';

class QuestionDialogView extends StatefulWidget {
  final String packId;
  final QuestionModel? initialData;
  final Function(dynamic request)? onSave;
  final QuestionType? initialType;

  const QuestionDialogView({
    super.key,
    required this.packId,
    this.initialData,
    this.onSave,
    this.initialType,
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

  List<String> _currentOptions = [];
  List<String> _currentAnswers = [];
  String? _currentImage;

  List<String> _arrangePreviewWords = [];

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _initData();
  }

  void _initData() {
    if (widget.initialData != null) {
      final q = widget.initialData!;

      selectedType = q.type;
      contentCtrl.text = q.content.question;
      timeLimit = q.timeLimit;
      isRandom = q.isRandom;
      points = q.point;
      _currentImage = q.mediaUrl;

      final content = q.content;

      if (content is MultipleChoiceContent) {
        if (selectedType == QuestionType.trueFalse) {
          _currentOptions = ["True", "False"];
          final correctOpt = content.options.firstWhereOrNull(
            (e) => e.isCorrect,
          );
          final correctText = (correctOpt?.text ?? "True").trim();
          _currentAnswers = [correctText];
        } else {
          _currentOptions = content.options.map((e) => e.text).toList();
          _currentAnswers = content.options
              .where((e) => e.isCorrect)
              .map((e) => e.text)
              .toList();
        }
      } else if (content is TypingContent) {
        _currentAnswers = List.from(content.acceptableAnswers);
        _currentOptions = [];
      } else if (content is ArrangeContent) {
        final byId = <int, String>{
          for (final s in content.segments) int.parse(s.id.toString()): s.text,
        };
        _currentAnswers = content.correctOrder
            .map((id) => (byId[id] ?? '').trim())
            .where((t) => t.isNotEmpty)
            .toList();

        _arrangePreviewWords = content.segments
            .map((s) => s.text.trim())
            .where((t) => t.isNotEmpty)
            .toList();

        _currentOptions = [];
      }
    } else {
      selectedType = widget.initialType ?? QuestionType.multipleChoice;
    }

    if (selectedType == QuestionType.trueFalse) {
      _currentOptions = ["True", "False"];
    }
  }

  @override
  void dispose() {
    contentCtrl.dispose();
    super.dispose();
  }

  void _validateAndSave() {
    if (selectedType != QuestionType.arrange &&
        contentCtrl.text.trim().isEmpty) {
      AppDialogs.showWarning("Vui lòng nhập nội dung câu hỏi.");
      return;
    }

    QuestionContentRequest? contentRequest;

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

        final options = (selectedType == QuestionType.trueFalse)
            ? ["True", "False"]
            : _currentOptions;

        final optionsList = <OptionRequest>[];
        for (int i = 0; i < options.length; i++) {
          final text = options[i];
          final isCorrect = _currentAnswers.contains(text);
          optionsList.add(
            OptionRequest(id: i, text: text, isCorrect: isCorrect),
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

        final correctOrder = List<int>.generate(
          _currentAnswers.length,
          (i) => i,
        );

        Map<String, List<int>> wordToIdMap = {};
        for (int i = 0; i < _currentAnswers.length; i++) {
          final word = _currentAnswers[i];
          if (!wordToIdMap.containsKey(word)) {
            wordToIdMap[word] = [];
          }
          wordToIdMap[word]!.add(i);
        }

        List<SegmentRequest> segments = [];

        final wordsToUse =
            (_arrangePreviewWords.isNotEmpty &&
                _arrangePreviewWords.length == _currentAnswers.length)
            ? _arrangePreviewWords
            : List<String>.from(_currentAnswers);

        for (String word in wordsToUse) {
          if (wordToIdMap.containsKey(word) && wordToIdMap[word]!.isNotEmpty) {
            int id = wordToIdMap[word]!.removeAt(0);
            segments.add(SegmentRequest(id: id, text: word));
          } else {
            segments.add(SegmentRequest(id: -1, text: word));
          }
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

    final hasImage = (_currentImage?.trim().isNotEmpty ?? false);
    final mediaType = hasImage ? MediaType.image : MediaType.none;
    final mediaUrl = hasImage ? _currentImage!.trim() : null;

    if (widget.initialData == null) {
      final request = CreateQuestionRequest(
        packId: widget.packId,
        type: selectedType,
        point: points,
        mediaType: mediaType,
        mediaUrl: mediaUrl,
        content: contentRequest,
      );
      widget.onSave?.call(request);
    } else {
      final request = UpdateQuestionRequest(
        type: selectedType,
        point: points,
        mediaType: mediaType,
        content: contentRequest,
        mediaUrl: mediaUrl,
      );
      widget.onSave?.call(request);
    }

    Get.back();
  }

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
          initialQuestionImageUrl: _currentImage,
          onQuestionImageUrlChanged: (imageUrl) {
            _currentImage = imageUrl;
          },
        ),

        QuestionType.trueFalse => AnswerTrueFalse(
          initialValue: _currentAnswers.isNotEmpty
              ? (_currentAnswers.first.toLowerCase() == 'true')
              : null,
          onChanged: (val) {
            _currentAnswers = [val ? "True" : "False"];
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
          initialCorrectWords: _currentAnswers.isNotEmpty
              ? _currentAnswers
              : null,
          initialPreviewWords: _arrangePreviewWords.isNotEmpty
              ? _arrangePreviewWords
              : null,

          onChanged: (correctWords, previewWords) {
            _currentAnswers = correctWords;
            _arrangePreviewWords = previewWords;
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
        _currentImage = null;
        _arrangePreviewWords = [];
        contentCtrl.clear();

        if (selectedType == QuestionType.trueFalse) {
          _currentOptions = ["True", "False"];
        }
      });
    }
  }
}
