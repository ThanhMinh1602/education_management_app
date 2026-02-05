// 1. CLASS CHA (Wrapper cho toàn bộ request)
class SubmitAssignmentRequest {
  final List<StudentAnswerItem> answers;

  SubmitAssignmentRequest({required this.answers});

  Map<String, dynamic> toJson() {
    return {'answers': answers.map((e) => e.toJson()).toList()};
  }
}

// 2. ITEM TRẢ LỜI (Gồm questionId và phần answer đa hình)
class StudentAnswerItem {
  final String questionId;
  final AnswerContent answer; // <--- Đa hình ở đây

  StudentAnswerItem({required this.questionId, required this.answer});

  Map<String, dynamic> toJson() {
    return {'questionId': questionId, 'answer': answer.toJson()};
  }
}

// 3. ABSTRACT CONTENT (Lớp trừu tượng cho nội dung trả lời)
abstract class AnswerContent {
  Map<String, dynamic> toJson();
}

// --- CÁC LOẠI TRẢ LỜI CỤ THỂ ---

// A. Dùng cho Trắc nghiệm (Multiple Choice) & Đúng/Sai (True/False)
class SelectionAnswer extends AnswerContent {
  final String selectedOptionId; // Ví dụ: "A", "B" hoặc "true", "false"

  SelectionAnswer(this.selectedOptionId);

  @override
  Map<String, dynamic> toJson() => {'selectedOptionId': selectedOptionId};
}

// B. Dùng cho Sắp xếp (Arrange)
class OrderedAnswer extends AnswerContent {
  final List<int> orderedIds; // Ví dụ: [2, 3, 1, 4]

  OrderedAnswer(this.orderedIds);

  @override
  Map<String, dynamic> toJson() => {'orderedIds': orderedIds};
}

// C. Dùng cho Điền từ (Typing)
class TextAnswer extends AnswerContent {
  final String text; // Ví dụ: "Good morning"

  TextAnswer(this.text);

  @override
  Map<String, dynamic> toJson() => {'text': text};
}
