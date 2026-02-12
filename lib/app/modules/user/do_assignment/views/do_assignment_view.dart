import 'package:blooket/app/data/model/request/content/question_content_request.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// --- CORE & CONSTANTS ---
import 'package:blooket/app/core/components/appbar/custom_app_bar.dart';
import 'package:blooket/app/core/constants/app_color.dart';

// --- ENUMS & MODELS ---
import 'package:blooket/app/data/enum/question_type.dart';
import 'package:blooket/app/data/model/question_model.dart';
import 'package:blooket/app/data/model/question_content_model.dart';
import 'package:blooket/app/data/model/request/assignments/submit_assignment_request.dart'; // Để dùng class AnswerContent

// --- CONTROLLER ---
import '../controller/do_assignment_controller.dart';

// --- WIDGETS TRẢ LỜI (QUIZ) ---
import '../widgets/answer_forms/quiz_multiple_choice.dart';
import '../widgets/answer_forms/quiz_typing.dart';
import '../widgets/answer_forms/quiz_rearrange.dart';

class DoAssignmentView extends GetView<DoAssignmentController> {
  const DoAssignmentView({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Chặn nút Back cứng để tránh thoát nhầm
        if (controller.isSubmitting.value) return false;
        _showExitConfirm();
        return false;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC), // Màu nền xám nhẹ dễ chịu mắt
        appBar: const CustomAppBar(title: 'Làm bài tập'),
        body: SafeArea(
          child: Obx(() {
            // 1. Loading
            if (controller.isLoading.value) {
              return const Center(
                child: CircularProgressIndicator(color: AppColor.primary),
              );
            }
            // 2. Empty
            if (controller.questions.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.assignment_late_outlined,
                      size: 60,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 16),
                    Text(
                      "Bài tập chưa có câu hỏi nào.",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              );
            }

            final currentQ = controller.currentQuestion!;

            return Column(
              children: [
                // A. Header (Timer & Progress Bar)
                _buildHeader(),

                // B. Body (Nội dung câu hỏi)
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Label: Câu 1/10
                        Text(
                          "Câu hỏi ${controller.currentQuestionIndex.value + 1}",
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Nội dung câu hỏi
                        Text(
                          currentQ.content.question,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF334155),
                            height: 1.4,
                          ),
                        ),

                        // Hình ảnh (Nếu có)
                        if (currentQ.mediaUrl != null &&
                            currentQ.mediaUrl!.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.network(
                                currentQ.mediaUrl!,
                                height: 200,
                                fit: BoxFit.contain, // Hiển thị trọn ảnh
                                loadingBuilder: (_, child, loading) {
                                  if (loading == null) return child;
                                  return Container(
                                    height: 200,
                                    color: Colors.grey.shade100,
                                    child: const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  );
                                },
                                errorBuilder: (_, __, ___) => const SizedBox(),
                              ),
                            ),
                          ),

                        const SizedBox(height: 24),

                        // Khu vực trả lời (Switch Widget theo loại câu hỏi)
                        _buildAnswerWidget(currentQ),
                      ],
                    ),
                  ),
                ),

                // C. Footer (Nút điều hướng)
                _buildFooter(),
              ],
            );
          }),
        ),
      ),
    );
  }

  // --- WIDGET LOGIC ---

  Widget _buildAnswerWidget(QuestionModel question) {
    // Lấy câu trả lời đã lưu trong controller (nếu có)
    final savedAnswer = controller.userAnswers[question.id];

    switch (question.type) {
      // 1. TRẮC NGHIỆM
      case QuestionType.multipleChoice:
        final content = question.content as MultipleChoiceContent;
        String? selectedOptionIdOrText;

        if (savedAnswer is SelectionAnswer) {
          selectedOptionIdOrText = savedAnswer.selectedOptionId;
        }

        return QuizMultipleChoice(
          // Hiển thị danh sách Text
          options: content.options.map((e) => e.text).toList(),
          selectedAnswer: selectedOptionIdOrText,
          onSelected: (text) {
            // Lưu Text (hoặc ID tùy logic backend của bạn)
            controller.onSelectOption(question.id, text);
          },
        );

      // 2. ĐÚNG / SAI
      case QuestionType.trueFalse:
        String? selectedOptionIdOrText;
        if (savedAnswer is SelectionAnswer) {
          selectedOptionIdOrText = savedAnswer.selectedOptionId;
        }

        return QuizMultipleChoice(
          options: const ["True", "False"],
          selectedAnswer: selectedOptionIdOrText,
          onSelected: (val) {
            controller.onSelectOption(question.id, val);
          },
        );

      // 3. ĐIỀN TỪ
      case QuestionType.typing:
        String? initialText;
        if (savedAnswer is TextAnswer) {
          initialText = savedAnswer.text;
        }

        return QuizTyping(
          initialValue: initialText,
          onChanged: (text) {
            controller.onTypeAnswer(question.id, text);
          },
        );

      // 4. SẮP XẾP CÂU
      case QuestionType.arrange:
        final content = question.content as ArrangeContent;

        // [FIX LỖI TYPE]: Chuyển đổi từ QuestionSegment -> SegmentRequest
        List<SegmentRequest> displaySegments = content.segments.map((s) {
          return SegmentRequest(id: s.id, text: s.text);
        }).toList();

        // 2. Nếu đã có câu trả lời cũ, sắp xếp lại theo thứ tự đó
        if (savedAnswer is OrderedAnswer) {
          final savedIds = savedAnswer.orderedIds; // List<int>
          if (savedIds.isNotEmpty) {
            // Tạo Map để tra cứu nhanh: ID -> SegmentRequest
            final segmentMap = {
              for (var s in displaySegments) int.parse(s.id.toString()): s,
            };

            List<SegmentRequest> reordered = [];
            for (var id in savedIds) {
              if (segmentMap.containsKey(id)) {
                reordered.add(segmentMap[id]!);
              }
            }

            // Nếu tìm đủ số lượng thì dùng danh sách đã sắp xếp
            if (reordered.length == displaySegments.length) {
              displaySegments = reordered;
            }
          }
        }

        return QuizRearrange(
          initialSegments: displaySegments,
          onOrderChanged: (orderedIds) {
            controller.onArrangeAnswer(question.id, orderedIds);
          },
        );
      default:
        return Container(
          padding: const EdgeInsets.all(16),
          color: Colors.red.shade50,
          child: const Text("Loại câu hỏi chưa được hỗ trợ trên Mobile."),
        );
    }
  }

  // --- UI COMPONENTS ---

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 4),
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        children: [
          // Timer Box
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.red.shade100),
            ),
            child: Row(
              children: [
                const Icon(Icons.timer_outlined, size: 18, color: Colors.red),
                const SizedBox(width: 6),
                Obx(
                  () => Text(
                    controller.formattedTime,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                      fontFeatures: [
                        FontFeature.tabularFigures(),
                      ], // Số không bị nhảy
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 20),

          // Progress Bar
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "${controller.currentQuestionIndex.value + 1}/${controller.questions.length}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value:
                        (controller.currentQuestionIndex.value + 1) /
                        controller.questions.length,
                    backgroundColor: Colors.grey.shade200,
                    color: AppColor.primary,
                    minHeight: 8,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Nút Quay Lại (Ẩn nếu là câu đầu)
          if (controller.currentQuestionIndex.value > 0)
            ElevatedButton(
              onPressed: controller.previousQuestion,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black87,
                elevation: 0,
                side: BorderSide(color: Colors.grey.shade300),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text("Quay lại"),
            )
          else
            const SizedBox(width: 10), // Placeholder
          // Nút Tiếp theo / Nộp bài
          if (controller.currentQuestionIndex.value <
              controller.questions.length - 1)
            ElevatedButton(
              onPressed: controller.nextQuestion,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.primary,
                foregroundColor: Colors.white,
                elevation: 2,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Row(
                children: [
                  Text(
                    "Tiếp theo",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward_rounded, size: 18),
                ],
              ),
            )
          else
            ElevatedButton.icon(
              onPressed: _showSubmitConfirm,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                elevation: 4,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.check_circle_outline, size: 20),
              label: const Text(
                "NỘP BÀI",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
        ],
      ),
    );
  }

  // --- DIALOGS ---

  void _showSubmitConfirm() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("Xác nhận nộp bài"),
        content: const Text(
          "Bạn có chắc chắn muốn nộp bài không? Bạn sẽ không thể sửa lại sau khi nộp.",
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text("Hủy", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back(); // Đóng dialog confirm
              controller.submitAssignment(); // Gọi hàm nộp
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text("Nộp ngay"),
          ),
        ],
      ),
    );
  }

  void _showExitConfirm() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          "Thoát bài tập?",
          style: TextStyle(color: Colors.red),
        ),
        content: const Text(
          "Tiến độ làm bài của bạn sẽ KHÔNG được lưu. Bạn có chắc muốn thoát?",
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text(
              "Ở lại",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          TextButton(
            onPressed: () {
              Get.back(); // Đóng dialog
              Get.back(); // Thoát màn hình làm bài
            },
            child: const Text("Thoát", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
