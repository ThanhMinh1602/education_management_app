import 'package:blooket/app/core/components/button/custom_button.dart';
import 'package:blooket/app/core/constants/app_color.dart';
import 'package:flutter/material.dart';

class AnswerTyping extends StatefulWidget {
  // Callback trả dữ liệu về cha để lưu
  final Function(List<String> answers)? onChanged;

  // [NEW] Dữ liệu khởi tạo (dành cho Edit)
  final List<String>? initialAnswers;

  const AnswerTyping({
    super.key,
    this.onChanged,
    this.initialAnswers, // Nhận data từ cha
  });

  @override
  State<AnswerTyping> createState() => _AnswerTypingState();
}

class _AnswerTypingState extends State<AnswerTyping> {
  // Pair: Controller + FocusNode cho từng dòng
  final List<({TextEditingController ctrl, FocusNode node})> _items = [];

  @override
  void initState() {
    super.initState();
    _initData();
  }

  // [NEW] Hàm khởi tạo dữ liệu
  void _initData() {
    if (widget.initialAnswers != null && widget.initialAnswers!.isNotEmpty) {
      // Nếu có data cũ (Edit), loop qua và tạo các dòng
      for (var answer in widget.initialAnswers!) {
        _addItem(answer);
      }
    } else {
      // Nếu không có data (Create mới), tạo 1 dòng trống
      _addNewLine();
    }
  }

  @override
  void dispose() {
    for (var item in _items) {
      item.ctrl.dispose();
      item.node.dispose();
    }
    super.dispose();
  }

  // Bắn dữ liệu ra ngoài
  void _notifyChange() {
    if (widget.onChanged != null) {
      final answers = _items
          .map((e) => e.ctrl.text.trim())
          .where((text) => text.isNotEmpty) // Chỉ lấy các ô có dữ liệu
          .toList();
      widget.onChanged!(answers);
    }
    // Cập nhật lại UI để check trạng thái nút Add
    setState(() {});
  }

  // [NEW] Hàm helper để tạo item mà không validate dòng cuối (dùng cho init)
  void _addItem(String content) {
    final controller = TextEditingController(text: content);
    final focusNode = FocusNode();

    // Lắng nghe thay đổi text
    controller.addListener(_notifyChange);

    _items.add((ctrl: controller, node: focusNode));
    // Không cần setState ở đây vì initState được gọi trước build
  }

  void _addNewLine() {
    // Validate: Nếu dòng cuối cùng đang trống thì không cho thêm
    if (_items.isNotEmpty && _items.last.ctrl.text.trim().isEmpty) {
      _items.last.node.requestFocus(); // Focus lại vào ô trống đó
      return;
    }

    final controller = TextEditingController();
    final focusNode = FocusNode();

    // Lắng nghe thay đổi text
    controller.addListener(_notifyChange);

    setState(() {
      _items.add((ctrl: controller, node: focusNode));
    });

    // Auto focus vào dòng mới sau khi UI render xong
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) focusNode.requestFocus();
    });
  }

  void _removeLine(int index) {
    // Không cho xóa nếu chỉ còn 1 dòng
    if (_items.length <= 1) return;

    final item = _items[index];

    // Clean resource
    item.ctrl.dispose();
    item.node.dispose();

    setState(() {
      _items.removeAt(index);
    });

    _notifyChange();
  }

  @override
  Widget build(BuildContext context) {
    // Check xem có được phép thêm dòng mới không (dòng cuối có text chưa)
    final canAddMore =
        _items.isEmpty || _items.last.ctrl.text.trim().isNotEmpty;

    return Container(
      // Padding nên để cha quản lý, nhưng đây là widget con nên padding nội bộ nhỏ
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Nhập các câu trả lời chính xác:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Người chơi nhập đúng một trong các đáp án dưới đây sẽ được tính điểm.',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade500,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 16.0),

          // Danh sách input
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12.0),
            itemBuilder: (context, index) {
              return _buildAnswerInput(index);
            },
          ),

          const SizedBox(height: 20.0),

          // Nút thêm
          Center(
            child: SizedBox(
              width: 200, // Fixed width cho đẹp trên web
              child: ElevatedButton.icon(
                icon: const Icon(Icons.add, size: 20),
                label: const Text('Thêm đáp án khác'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: canAddMore
                      ? AppColor.primary
                      : Colors.grey.shade300,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: canAddMore ? 2 : 0,
                ),
                // Disable nút nếu chưa nhập xong dòng trên
                onPressed: canAddMore ? _addNewLine : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnswerInput(int index) {
    final item = _items[index];
    // Chỉ cho phép xóa nếu có nhiều hơn 1 dòng
    final isRemovable = _items.length > 1;

    return Row(
      children: [
        // Số thứ tự (Visual guide)
        Container(
          width: 30,
          alignment: Alignment.center,
          child: Text(
            "${index + 1}.",
            style: TextStyle(
              color: Colors.grey.shade600,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        const SizedBox(width: 8),

        // Input Field
        Expanded(
          child: TextField(
            controller: item.ctrl,
            focusNode: item.node,
            // Sự kiện Enter -> Thêm dòng mới (UX cho Web)
            textInputAction: TextInputAction.next,
            onSubmitted: (_) {
              // Nếu là dòng cuối cùng thì enter sẽ tạo dòng mới
              if (index == _items.length - 1) {
                _addNewLine();
              }
            },
            decoration: InputDecoration(
              hintText: 'Nhập câu trả lời...',
              hintStyle: TextStyle(color: Colors.grey.shade400),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColor.primary, width: 2),
              ),
            ),
          ),
        ),

        const SizedBox(width: 12.0),

        // Nút xóa
        // Dùng Opacity để giữ khoảng cách layout ngay cả khi ẩn
        SizedBox(
          width: 40,
          child: isRemovable
              ? IconButton(
                  onPressed: () => _removeLine(index),
                  icon: const Icon(Icons.delete_outline),
                  color: Colors.red.shade400,
                  tooltip: 'Xóa dòng này',
                  hoverColor: Colors.red.withOpacity(0.1),
                  splashRadius: 20,
                )
              : null,
        ),
      ],
    );
  }
}
