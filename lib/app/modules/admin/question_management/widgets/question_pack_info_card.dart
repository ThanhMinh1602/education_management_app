import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:blooket/app/core/components/button/custom_action_button.dart';
import 'package:blooket/app/core/components/card/info_card_editable_field.dart';
import 'package:blooket/app/core/constants/app_color.dart';
import 'package:blooket/app/data/model/question_pack_model.dart';

class QuestionPackInfoCard extends StatefulWidget {
  final QuestionPackModel? pack;

  final Function(String title, String description)? onSaveInfo;

  final VoidCallback? onSaveAndClose;

  const QuestionPackInfoCard({
    super.key,
    this.pack,
    this.onSaveInfo,
    this.onSaveAndClose,
  });

  @override
  State<QuestionPackInfoCard> createState() => _QuestionPackInfoCardState();
}

class _QuestionPackInfoCardState extends State<QuestionPackInfoCard> {
  late TextEditingController _titleCtrl;
  late TextEditingController _descCtrl;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  void _initData() {
    _titleCtrl = TextEditingController(text: widget.pack?.title ?? '');
    _descCtrl = TextEditingController(text: widget.pack?.description ?? '');
  }

  @override
  void didUpdateWidget(covariant QuestionPackInfoCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.pack != oldWidget.pack && !_isEditing) {
      _initData();
    }
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  void _toggleEdit() {
    if (_isEditing) {
      if (widget.onSaveInfo != null) {
        if (_titleCtrl.text != widget.pack?.title ||
            _descCtrl.text != widget.pack?.description) {
          widget.onSaveInfo!(_titleCtrl.text, _descCtrl.text);
        }
      }
    }
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.pack == null) {
      return const Center(
        child: CircularProgressIndicator(color: AppColor.primary),
      );
    }

    final pack = widget.pack!;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColor.primary,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Column(
              children: [
                _isEditing
                    ? InfoCardEditableField(
                        controller: _titleCtrl,

                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                        ),
                        hint: "Nhập tên bộ đề...",
                      )
                    : Text(
                        pack.title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          height: 1.2,
                        ),
                      ),
                const SizedBox(height: 8),
                _buildStatusBadge(pack.isPublic),
              ],
            ),
          ),

          const SizedBox(height: 24),
          const Divider(color: Colors.white24, height: 1),
          const SizedBox(height: 20),

          _buildInfoRow(Icons.layers_rounded, "Level:", pack.levelName),
          const SizedBox(height: 12),
          _buildInfoRow(Icons.person_rounded, "Giáo viên:", pack.teacherName),
          const SizedBox(height: 12),
          if (pack.createdAt != null)
            _buildInfoRow(
              Icons.calendar_month_rounded,
              "Ngày tạo:",
              DateFormat('dd/MM/yyyy').format(pack.createdAt!),
            ),

          const SizedBox(height: 20),
          const Divider(color: Colors.white24, height: 1),
          const SizedBox(height: 20),

          const Text(
            "MÔ TẢ",
            style: TextStyle(
              color: Colors.white70,
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 8),

          _isEditing
              ? Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: InfoCardEditableField(
                    controller: _descCtrl,
                    maxLines: 4,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      height: 1.5,
                    ),
                    hint: "Nhập mô tả...",
                  ),
                )
              : Text(
                  (pack.description == null || pack.description!.isEmpty)
                      ? "Chưa có mô tả cho bộ đề này."
                      : pack.description!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    height: 1.5,
                    fontStyle: FontStyle.italic,
                  ),
                ),

          const SizedBox(height: 32),

          if (!_isEditing)
            CustomActionButton(
              width: double.infinity,
              onTap: widget.onSaveAndClose,
              icon: Icons.save_outlined,
              text: 'SAVE & CLOSE',
            ),

          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: _buildGlassButton(
                  icon: _isEditing ? Icons.check : Icons.edit_outlined,
                  text: _isEditing ? 'Lưu thông tin' : 'Sửa thông tin',

                  backgroundColor: _isEditing
                      ? Colors.green.withOpacity(0.3)
                      : null,
                  onTap: _toggleEdit,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildGlassButton(
                  icon: Icons.settings_outlined,
                  text: 'Cài đặt',
                  onTap: () {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(bool isPublic) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isPublic ? Colors.greenAccent.withOpacity(0.2) : Colors.black26,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isPublic
              ? Colors.greenAccent.withOpacity(0.6)
              : Colors.white30,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isPublic ? Icons.public : Icons.lock_outline,
            color: isPublic ? Colors.greenAccent : Colors.white70,
            size: 12,
          ),
          const SizedBox(width: 6),
          Text(
            isPublic ? "Công khai" : "Riêng tư",
            style: TextStyle(
              color: isPublic ? Colors.greenAccent : Colors.white70,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.white70, size: 16),
        const SizedBox(width: 10),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 13),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildGlassButton({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
    Color? backgroundColor,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: backgroundColor ?? Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 1.5,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, color: Colors.white, size: 22),
                  const SizedBox(height: 6),
                  Text(
                    text,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
