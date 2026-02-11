import 'package:blooket/app/core/constants/app_color.dart';
import 'package:flutter/material.dart';

class AnswerMultiChose extends StatefulWidget {
  final Function(List<String> options, List<String> correctAnswers)? onChanged;

  /// ✅ Chỉ lưu link ảnh để gửi lên API
  final void Function(String? imageUrl)? onQuestionImageUrlChanged;
  final String? initialQuestionImageUrl;

  final List<String>? initialOptions;
  final List<String>? initialCorrectAnswers;

  const AnswerMultiChose({
    super.key,
    this.onChanged,
    this.onQuestionImageUrlChanged,
    this.initialQuestionImageUrl,
    this.initialOptions,
    this.initialCorrectAnswers,
  });

  @override
  State<AnswerMultiChose> createState() => _AnswerMultiChoseState();
}

class _AnswerMultiChoseState extends State<AnswerMultiChose> {
  int _selectedAnswerIndex = 0;
  late final List<TextEditingController> _controllers;

  // hover
  final List<bool> _isHovering = List.generate(4, (_) => false);

  // ✅ Image URL
  late final TextEditingController _imageUrlController;
  String? _questionImageUrl;

  bool _urlFormatError = false; // lỗi format url (không phải http/https)
  bool _urlLoadError = false; // lỗi load ảnh (Image.network fail)

  @override
  void initState() {
    super.initState();

    _imageUrlController = TextEditingController(
      text: widget.initialQuestionImageUrl?.trim() ?? '',
    );

    _questionImageUrl = _normalizeUrl(_imageUrlController.text);

    _controllers = List.generate(4, (index) {
      final text =
          (widget.initialOptions != null &&
              index < widget.initialOptions!.length)
          ? widget.initialOptions![index]
          : '';
      return TextEditingController(text: text);
    });

    if (widget.initialCorrectAnswers != null &&
        widget.initialCorrectAnswers!.isNotEmpty &&
        widget.initialOptions != null) {
      final correctText = widget.initialCorrectAnswers!.first;
      final index = widget.initialOptions!.indexOf(correctText);
      if (index != -1) _selectedAnswerIndex = index;
    }

    for (final c in _controllers) {
      c.addListener(_notifyChange);
    }

    // emit initial url nếu hợp lệ
    if (_questionImageUrl != null) {
      widget.onQuestionImageUrlChanged?.call(_questionImageUrl);
    }
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    _imageUrlController.dispose();
    super.dispose();
  }

  void _notifyChange() {
    if (widget.onChanged == null) return;
    final options = _controllers.map((e) => e.text).toList();
    final correct = options[_selectedAnswerIndex];
    widget.onChanged!(options, [correct]);
  }

  void _onSelectAnswer(int index) {
    setState(() => _selectedAnswerIndex = index);
    _notifyChange();
  }

  String? _normalizeUrl(String raw) {
    final url = raw.trim();
    if (url.isEmpty) return null;

    final uri = Uri.tryParse(url);
    final ok =
        uri != null &&
        (uri.scheme == 'http' || uri.scheme == 'https') &&
        uri.host.isNotEmpty;

    return ok ? url : null;
  }

  void _onUrlChanged(String raw) {
    final normalized = _normalizeUrl(raw);

    setState(() {
      _questionImageUrl = normalized;
      _urlFormatError = (raw.trim().isNotEmpty && normalized == null);
      _urlLoadError = false; // reset lỗi load khi user sửa url
    });

    // Gửi link hợp lệ lên ngoài để bạn dùng call API
    widget.onQuestionImageUrlChanged?.call(_questionImageUrl);
  }

  void _clearUrl() {
    setState(() {
      _imageUrlController.clear();
      _questionImageUrl = null;
      _urlFormatError = false;
      _urlLoadError = false;
    });
    widget.onQuestionImageUrlChanged?.call(null);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildQuestionImageUrl(context),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            const crossAxisCount = 2;
            const spacing = 20.0;
            final totalSpacing = spacing * (crossAxisCount - 1);
            final itemWidth =
                (constraints.maxWidth - totalSpacing) / crossAxisCount;
            const itemHeight = 80.0;
            final ratio = itemWidth / itemHeight;

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: 4,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                childAspectRatio: ratio,
                crossAxisSpacing: spacing,
                mainAxisSpacing: spacing,
              ),
              itemBuilder: (context, index) => _buildWebAnswerItem(index),
            );
          },
        ),
      ],
    );
  }

  Widget _buildQuestionImageUrl(BuildContext context) {
    final hasUrl = _questionImageUrl != null;

    final showErrorText = _urlFormatError || _urlLoadError;
    final errorText = _urlFormatError
        ? 'URL không hợp lệ. Vui lòng dùng http/https.'
        : 'URL hợp lệ nhưng không tải được ảnh.';

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: Row(
        children: [
          // Preview
          Container(
            width: 92,
            height: 92,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey.shade50,
              border: Border.all(color: Colors.grey.shade200),
            ),
            clipBehavior: Clip.antiAlias,
            child: !hasUrl
                ? Icon(
                    Icons.image_outlined,
                    color: Colors.grey.shade400,
                    size: 32,
                  )
                : Image.network(
                    _questionImageUrl!,
                    fit: BoxFit.cover,
                    // ✅ Nếu link chết / không phải ảnh -> báo lỗi UI
                    errorBuilder: (_, __, ___) {
                      // tránh setState liên tục khi rebuild:
                      if (!_urlLoadError) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (mounted) setState(() => _urlLoadError = true);
                        });
                      }
                      return Icon(
                        Icons.broken_image_outlined,
                        color: Colors.red.shade300,
                        size: 32,
                      );
                    },
                  ),
          ),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ảnh cho câu hỏi',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),

                TextField(
                  controller: _imageUrlController,
                  onChanged: _onUrlChanged,
                  keyboardType: TextInputType.url,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    hintText: 'Dán URL ảnh (https://...)',
                    isDense: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    suffixIcon: _imageUrlController.text.trim().isEmpty
                        ? null
                        : IconButton(
                            tooltip: 'Xóa',
                            onPressed: _clearUrl,
                            icon: const Icon(Icons.close),
                          ),
                  ),
                ),

                if (showErrorText)
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      errorText,
                      style: TextStyle(
                        color: Colors.red.shade600,
                        fontSize: 13,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWebAnswerItem(int index) {
    final isSelected = _selectedAnswerIndex == index;
    final isHovering = _isHovering[index];

    Color borderColor;
    double borderWidth;
    Color backgroundColor;

    if (isSelected) {
      borderColor = AppColor.pink;
      borderWidth = 2.5;
      backgroundColor = AppColor.pink.withOpacity(0.08);
    } else if (isHovering) {
      borderColor = Colors.grey.shade500;
      borderWidth = 1.5;
      backgroundColor = Colors.grey.shade50;
    } else {
      borderColor = Colors.grey.shade300;
      borderWidth = 1.0;
      backgroundColor = Colors.white;
    }

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovering[index] = true),
      onExit: (_) => setState(() => _isHovering[index] = false),
      child: GestureDetector(
        onTap: () => _onSelectAnswer(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          decoration: BoxDecoration(
            color: backgroundColor,
            border: Border.all(color: borderColor, width: borderWidth),
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: isSelected || isHovering
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [],
          ),
          child: Row(
            children: [
              Transform.scale(
                scale: 1.2,
                child: Radio<int>(
                  value: index,
                  groupValue: _selectedAnswerIndex,
                  activeColor: AppColor.pink,
                  splashRadius: 20,
                  onChanged: (val) => _onSelectAnswer(val!),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _controllers[index],
                  mouseCursor: SystemMouseCursors.text,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: isSelected
                        ? FontWeight.w600
                        : FontWeight.normal,
                    color: Colors.black87,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    hintText: 'Option ${index + 1}',
                    hintStyle: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 15,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                ),
              ),
              if (isSelected)
                const Icon(Icons.check_circle, color: AppColor.pink, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
