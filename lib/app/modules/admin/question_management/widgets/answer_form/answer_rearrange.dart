import 'package:flutter/material.dart';

// Import file chứa SegmentRequest của bạn
import 'package:blooket/app/data/model/request/content/question_content_request.dart';
import 'package:blooket/app/core/constants/app_color.dart';

class AnswerRearrange extends StatefulWidget {
  /// Trả về 2 danh sách:
  /// 1. correctWords: Thứ tự đúng (để lưu vào correctText/Order)
  /// 2. previewWords: Thứ tự hiển thị hiện tại (để lưu vào segments)
  final Function(List<String> correctWords, List<String> previewWords)?
  onChanged;

  final List<String>? initialCorrectWords;
  final List<String>? initialPreviewWords;

  const AnswerRearrange({
    super.key,
    this.onChanged,
    this.initialCorrectWords,
    this.initialPreviewWords,
  });

  @override
  State<AnswerRearrange> createState() => _AnswerRearrangeState();
}

class _AnswerRearrangeState extends State<AnswerRearrange> {
  // [THAY ĐỔI] Dùng SegmentRequest thay cho _Seg
  List<SegmentRequest> _correctSegs = [];
  List<SegmentRequest> _previewSegs = [];

  late final TextEditingController _sentenceController;
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    _sentenceController = TextEditingController();

    final correctWords = widget.initialCorrectWords ?? const <String>[];
    if (correctWords.isNotEmpty) {
      _setCorrectFromWords(correctWords);

      // Input luôn hiển thị câu đúng
      _sentenceController.text = correctWords.join(' ');

      final previewWords = widget.initialPreviewWords;
      if (previewWords != null && previewWords.isNotEmpty) {
        _setPreviewFromWords(previewWords);
      } else {
        _previewSegs = List<SegmentRequest>.from(_correctSegs);
      }

      // Emit dữ liệu ban đầu
      WidgetsBinding.instance.addPostFrameCallback((_) => _emitChange());
    }
  }

  @override
  void dispose() {
    _sentenceController.dispose();
    super.dispose();
  }

  // --- Logic Helper ---

  void _emitChange() {
    widget.onChanged?.call(
      _correctSegs.map((e) => e.text).toList(),
      _previewSegs.map((e) => e.text).toList(),
    );
  }

  void _setCorrectFromWords(List<String> words) {
    // Tạo SegmentRequest với id tăng dần
    _correctSegs = [
      for (int i = 0; i < words.length; i++)
        SegmentRequest(id: i, text: words[i]),
    ];
  }

  void _setPreviewFromWords(List<String> previewWords) {
    // Map text -> danh sách các ID tương ứng trong câu đúng
    final map = <String, List<int>>{};
    for (final seg in _correctSegs) {
      (map[seg.text] ??= []).add(int.parse(seg.id.toString()));
    }

    final built = <SegmentRequest>[];
    for (final w in previewWords) {
      final queue = map[w];
      if (queue == null || queue.isEmpty) continue;

      final id = queue.removeAt(0);
      built.add(SegmentRequest(id: id, text: w));
    }

    // Fallback: Nếu preview thiếu từ nào đó trong correct, thêm nó vào cuối
    if (built.length != _correctSegs.length) {
      final usedIds = built.map((e) => e.id).toSet();
      for (final seg in _correctSegs) {
        if (!usedIds.contains(seg.id)) built.add(seg);
      }
    }
    _previewSegs = built;
  }

  List<String> _splitSentenceToWords(String text) {
    final t = text.trim();
    if (t.isEmpty) return [];

    final temp = <String>[];
    // Regex để giữ cụm từ trong ngoặc [] hoặc tách theo khoảng trắng
    final regExp = RegExp(r'\[([^\]]*)\]|(\S+)');

    for (final m in regExp.allMatches(t)) {
      if (m.group(1) != null) {
        final content = m.group(1)!.trim();
        if (content.isNotEmpty) temp.add(content);
      } else {
        temp.add(m.group(0)!);
      }
    }
    return temp;
  }

  // --- Actions ---

  void _generateChipsFromSentence() {
    final words = _splitSentenceToWords(_sentenceController.text);
    if (words.length < 2) return;

    setState(() {
      _setCorrectFromWords(words);
      // Khi tách lại từ input, reset preview giống hệt correct
      _previewSegs = List<SegmentRequest>.from(_correctSegs);
    });
    _emitChange();
  }

  void _shufflePreview() {
    if (_previewSegs.length < 2) return;
    setState(() => _previewSegs.shuffle());
    _emitChange(); // Cập nhật lại thứ tự preview cho cha
  }

  void _onSwapPreview(int oldIndex, int newIndex) {
    if (oldIndex == newIndex) return;
    setState(() {
      final temp = _previewSegs[oldIndex];
      _previewSegs[oldIndex] = _previewSegs[newIndex];
      _previewSegs[newIndex] = temp;
    });
    _emitChange(); // Cập nhật lại thứ tự sau khi kéo thả
  }

  void _usePreviewAsCorrect() {
    if (_previewSegs.length < 2) return;

    // Lấy thứ tự text hiện tại làm chuẩn
    final newWords = _previewSegs.map((e) => e.text).toList();

    setState(() {
      _setCorrectFromWords(newWords);
      _previewSegs = List<SegmentRequest>.from(_correctSegs);
      _sentenceController.text = newWords.join(' ');
    });
    _emitChange();
  }

  // --- UI ---

  @override
  Widget build(BuildContext context) {
    final hasWords = _previewSegs.isNotEmpty;

    return Column(
      children: [
        _buildChipDisplayArea(),
        const SizedBox(height: 20),
        _buildInputArea(),

        if (hasWords) ...[
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: _usePreviewAsCorrect,
              icon: const Icon(Icons.check_circle_outline),
              label: const Text("Dùng thứ tự hiện tại làm đáp án đúng"),
              style: TextButton.styleFrom(foregroundColor: AppColor.pink),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildChipDisplayArea() {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 120),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: _previewSegs.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.text_fields,
                    size: 40,
                    color: Colors.grey.shade300,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Nhập câu bên dưới (dùng [ ] để gom cụm)\nvà bấm 'Tách từ'",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey.shade400,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            )
          : SelectionContainer.disabled(
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                children: List.generate(
                  _previewSegs.length,
                  (index) => _buildDraggableChip(index),
                ),
              ),
            ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blueGrey.withOpacity(0.04),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blueGrey.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            "Nhập câu hoàn chỉnh:",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _sentenceController,
            maxLines: 3,
            style: const TextStyle(fontSize: 15),
            decoration: InputDecoration(
              hintText: "Ví dụ: Flutter [rất tuyệt] vời...",
              hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.all(12),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.content_cut, size: 18),
                  label: const Text("Tách từ"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: _generateChipsFromSentence,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.shuffle, size: 18),
                  label: const Text("Xáo trộn"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColor.primary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: const BorderSide(color: AppColor.primary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: _previewSegs.isNotEmpty ? _shufflePreview : null,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDraggableChip(int index) {
    final seg = _previewSegs[index];

    return DragTarget<int>(
      onWillAccept: (data) => data != null && data != index,
      onAccept: (sourceIndex) => _onSwapPreview(sourceIndex, index),
      builder: (context, candidateData, rejectedData) {
        final isHovering = candidateData.isNotEmpty;

        return MouseRegion(
          cursor: _isDragging
              ? SystemMouseCursors.grabbing
              : SystemMouseCursors.grab,
          child: Draggable<int>(
            data: index,
            onDragStarted: () => setState(() => _isDragging = true),
            onDragEnd: (_) => setState(() => _isDragging = false),
            feedback: Material(
              color: Colors.transparent,
              child: Opacity(
                opacity: 0.9,
                child: Transform.scale(
                  scale: 1.05,
                  child: _buildChipUI(
                    seg.text,
                    color: AppColor.pink,
                    isFeedback: true,
                  ),
                ),
              ),
            ),
            childWhenDragging: Opacity(
              opacity: 0.3,
              child: _buildChipUI(seg.text, color: Colors.grey.shade500),
            ),
            child: isHovering
                ? _buildSwapTargetUI(seg.text)
                : _buildChipUI(seg.text, color: AppColor.primary),
          ),
        );
      },
    );
  }

  Widget _buildChipUI(
    String label, {
    required Color color,
    bool isFeedback = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
        boxShadow: isFeedback
            ? [
                BoxShadow(
                  color: AppColor.pink.withOpacity(0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 8),
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 2,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _buildSwapTargetUI(String label) {
    return DottedBorderContainer(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: AppColor.pink.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: AppColor.pink.withOpacity(0.5),
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}

// Widget vẽ viền đứt nét (dùng lại code cũ của bạn)
class DottedBorderContainer extends StatelessWidget {
  final Widget child;
  const DottedBorderContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _DottedBorderPainter(), child: child);
  }
}

class _DottedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColor.pink.withOpacity(0.5)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      const Radius.circular(8),
    );

    // Vẽ nét đứt thủ công đơn giản (hoặc dùng thư viện dotted_border)
    // Ở đây vẽ liền cho đơn giản, nếu muốn nét đứt cần PathMetric
    canvas.drawRRect(rrect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
