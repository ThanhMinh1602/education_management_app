import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:blooket/app/data/model/question_model.dart';
import 'package:blooket/app/data/enum/question_type.dart';
import '../controller/do_assignment_controller.dart';

class QuestionCard extends GetView<DoAssignmentController> {
  final QuestionModel question;

  const QuestionCard({super.key, required this.question});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Loại câu hỏi
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.blue[100],
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                _getQuestionTypeLabel(question.type),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[700],
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Nội dung câu hỏi
            Text(
              question.content,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            // Đáp án
            if (question.type == QuestionType.multipleChoice ||
                question.type == QuestionType.trueFalse)
              _buildMultipleChoice()
            else if (question.type == QuestionType.typing)
              _buildTypingQuestion()
            else
              const Text('Loại câu hỏi không được hỗ trợ'),
          ],
        ),
      ),
    );
  }

  Widget _buildMultipleChoice() {
    return Obx(() {
      final selectedAnswer = controller.answers[question.id];

      return Column(
        children: [
          if (question.options.isNotEmpty)
            Column(
              children: question.options.asMap().entries.map((entry) {
                final option = entry.value;
                final isSelected = selectedAnswer == option;

                return GestureDetector(
                  onTap: () => controller.selectAnswer(question.id, option),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: isSelected ? Colors.blue : Colors.grey[300]!,
                        width: isSelected ? 2 : 1,
                      ),
                      borderRadius: BorderRadius.circular(8),
                      color: isSelected
                          ? Colors.blue.withOpacity(0.1)
                          : Colors.transparent,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected
                                  ? Colors.blue
                                  : Colors.grey[400]!,
                            ),
                            color: isSelected
                                ? Colors.blue
                                : Colors.transparent,
                          ),
                          child: isSelected
                              ? const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 14,
                                )
                              : null,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            option,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
        ],
      );
    });
  }

  Widget _buildTypingQuestion() {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Nhập câu trả lời của bạn',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: const EdgeInsets.all(16),
      ),
      maxLines: 3,
      onChanged: (value) {
        controller.selectAnswer(question.id, value);
      },
    );
  }

  String _getQuestionTypeLabel(QuestionType? type) {
    switch (type) {
      case QuestionType.multipleChoice:
        return 'Trắc nghiệm';
      case QuestionType.trueFalse:
        return 'Đúng/Sai';
      case QuestionType.typing:
        return 'Điền đáp án';
      case QuestionType.rearrange:
        return 'Sắp xếp';
      default:
        return 'Câu hỏi';
    }
  }
}
