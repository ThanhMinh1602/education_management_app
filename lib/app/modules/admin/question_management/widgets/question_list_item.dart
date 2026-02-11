import 'package:blooket/app/core/components/common/app_tooltip.dart';
import 'package:flutter/material.dart';

import 'package:blooket/app/core/components/button/custom_icon_button.dart';
import 'package:blooket/app/core/constants/app_color.dart';
import 'package:blooket/app/core/constants/app_colors.dart';
import 'package:blooket/app/data/model/question_model.dart';

class QuestionListItem extends StatelessWidget {
  const QuestionListItem({
    super.key,
    required this.questionModel,
    required this.index,
    this.onEdit,
    this.onDelete,
    this.onCopy,
    this.onUp,
    this.onDown,
  });

  final QuestionModel questionModel;
  final int index;

  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onCopy;
  final VoidCallback? onUp;
  final VoidCallback? onDown;

  bool get _hasImage {
    final url = questionModel.mediaUrl?.trim();
    return url != null && url.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final q = questionModel.content.question.trim();
    final questionText = q.isEmpty ? 'Nội dung câu hỏi đang trống...' : q;

    return Material(
      color: Colors.white,
      elevation: 0,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              offset: const Offset(0, 6),
              blurRadius: 14,
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // LEFT: content + image
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Content
                  Expanded(
                    child: _QuestionContent(
                      index: index,
                      questionText: questionText,
                      typeLabel: questionModel.type.label,
                      typeColor: questionModel.type.color,
                      answers: questionModel.content.answersDisplay.join(', '),
                    ),
                  ),

                  if (_hasImage) ...[
                    const SizedBox(width: 12),
                    _QuestionThumb(url: questionModel.mediaUrl!.trim()),
                  ],
                ],
              ),
            ),

            const SizedBox(width: 14),

            // ACTIONS (edit + delete/copy)
            SizedBox(
              width: 124,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CustomIconButton(
                    icon: Icons.edit_note_rounded,
                    label: 'Sửa',
                    iconColor: Colors.white,
                    backgroundColor: AppColor.pink,
                    onTap: onEdit,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: CustomIconButton(
                          icon: Icons.delete_outline_rounded,
                          iconColor: Colors.white,
                          backgroundColor: Colors.redAccent,
                          onTap: onDelete,
                          iconSize: 18,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: CustomIconButton(
                          icon: Icons.copy_rounded,
                          iconColor: Colors.white,
                          backgroundColor: AppColors.primary,
                          onTap: onCopy,
                          iconSize: 18,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: 12),

            // RIGHT: up/down
            Column(
              children: [
                CustomIconButton(
                  onTap: onUp,
                  icon: Icons.keyboard_arrow_up_rounded,
                  backgroundColor: Colors.grey.shade100,
                  iconColor: Colors.grey.shade700,
                  iconSize: 22,
                  borderRadius: 10,
                ),
                const SizedBox(height: 8),
                CustomIconButton(
                  onTap: onDown,
                  icon: Icons.keyboard_arrow_down_rounded,
                  backgroundColor: Colors.grey.shade100,
                  iconColor: Colors.grey.shade700,
                  iconSize: 22,
                  borderRadius: 10,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _QuestionContent extends StatelessWidget {
  const _QuestionContent({
    required this.index,
    required this.questionText,
    required this.typeLabel,
    required this.typeColor,
    required this.answers,
  });

  final int index;
  final String questionText;
  final String typeLabel;
  final Color typeColor;
  final String answers;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title row
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${index + 1}. ',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: AppColor.primary,
              ),
            ),
            Expanded(
              child: Text(
                questionText,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: Color(0xFF2D3436),
                  height: 1.3,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),

        const SizedBox(height: 10),

        // Type pill
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: typeColor.withOpacity(0.08),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: typeColor.withOpacity(0.45)),
          ),
          child: Text(
            typeLabel.toUpperCase(),
            style: TextStyle(
              color: typeColor,
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.4,
            ),
          ),
        ),

        const SizedBox(height: 8),

        // Answers
        Text(
          '• Đáp án: $answers',
          style: TextStyle(
            color: Colors.grey.shade700,
            fontSize: 13,
            fontStyle: FontStyle.italic,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

class _QuestionThumb extends StatelessWidget {
  const _QuestionThumb({required this.url});
  final String url;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        width: 76,
        height: 76,
        child: Image.network(
          url,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, progress) {
            if (progress == null) return child;
            return Container(
              color: Colors.grey.shade100,
              alignment: Alignment.center,
              child: SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  value: progress.expectedTotalBytes == null
                      ? null
                      : progress.cumulativeBytesLoaded /
                            (progress.expectedTotalBytes ?? 1),
                ),
              ),
            );
          },
          errorBuilder: (_, __, ___) => Container(
            color: Colors.grey.shade100,
            alignment: Alignment.center,
            child: Icon(
              Icons.broken_image_outlined,
              color: Colors.grey.shade500,
              size: 28,
            ),
          ),
        ),
      ),
    );
  }
}
