import 'package:blooket/app/core/components/card/base_info_card_wrapper.dart';
import 'package:blooket/app/core/components/card/info_card_badge.dart';
import 'package:blooket/app/core/components/card/info_card_editable_field.dart';
import 'package:blooket/app/data/model/level_model.dart';
import 'package:blooket/app/data/model/request/content/level_request.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LevelInfoCard extends StatefulWidget {
  final LevelModel? levelModel;
  final bool isDetail;

  final String? name;
  final String? description;
  final int? order;
  final bool? isActive;
  final DateTime? createdAt;

  final Function(LevelRequest request)? onSave;
  final VoidCallback? onDelete;

  final VoidCallback? onViewDetail;

  const LevelInfoCard({
    super.key,
    this.levelModel,
    this.isDetail = false,
    this.name,
    this.description,
    this.order,
    this.isActive,
    this.createdAt,
    this.onSave,
    this.onDelete,
    this.onViewDetail,
  });

  @override
  State<LevelInfoCard> createState() => _LevelInfoCardState();
}

class _LevelInfoCardState extends State<LevelInfoCard> {
  late TextEditingController _nameCtrl;
  late TextEditingController _descCtrl;
  late TextEditingController _orderCtrl;

  bool _isEditing = false;
  bool? _tempIsActive;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  void _initData() {
    _nameCtrl = TextEditingController(text: _getName());
    _descCtrl = TextEditingController(text: _getDesc());
    _orderCtrl = TextEditingController(text: _getOrder().toString());
    _tempIsActive = _getIsActive();
  }

  String _getName() => widget.levelModel?.name ?? widget.name ?? '';
  String _getDesc() =>
      widget.levelModel?.description ?? widget.description ?? '';
  int _getOrder() => widget.levelModel?.order ?? widget.order ?? 0;
  bool _getIsActive() => widget.levelModel?.isActive ?? widget.isActive ?? true;
  DateTime _getCreatedAt() =>
      widget.levelModel?.createdAt ?? widget.createdAt ?? DateTime.now();

  @override
  void didUpdateWidget(covariant LevelInfoCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.levelModel != oldWidget.levelModel && !_isEditing) {
      _initData();
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    _orderCtrl.dispose();
    super.dispose();
  }

  void _handleToggleEdit() {
    if (_isEditing) {
      FocusScope.of(context).unfocus();
      final request = LevelRequest(
        name: _nameCtrl.text,
        description: _descCtrl.text,
        order: int.tryParse(_orderCtrl.text) ?? _getOrder(),
      );

      if (widget.onSave != null) {
        widget.onSave!(request);
      }
    }
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseInfoCardWrapper(
      isDetail: widget.isDetail,
      isEditing: _isEditing,
      onToggleEdit: _handleToggleEdit,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _isEditing
                        ? SizedBox(
                            width: 100,
                            child: InfoCardEditableField(
                              controller: _orderCtrl,
                              style: const TextStyle(
                                color: Color(0xFFFFE082),
                                fontWeight: FontWeight.bold,
                              ),
                              hint: "Thứ tự",
                              keyboardType: TextInputType.number,
                            ),
                          )
                        : InfoCardBadge(
                            label: "ORDER",
                            content: "#${_getOrder()}",
                          ),

                    const SizedBox(height: 8),

                    _isEditing
                        ? InfoCardEditableField(
                            controller: _nameCtrl,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                            ),
                            hint: "Tên cấp độ",
                          )
                        : Text(
                            _getName(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          const Text(
            "Mô tả:",
            style: TextStyle(
              color: Colors.white70,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          _isEditing
              ? Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white12),
                  ),
                  child: InfoCardEditableField(
                    controller: _descCtrl,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      height: 1.4,
                    ),
                    hint: "Chưa có mô tả...",
                    maxLines: 3,
                  ),
                )
              : Text(
                  _getDesc().isEmpty ? "Chưa có mô tả..." : _getDesc(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    height: 1.4,
                  ),
                  maxLines: widget.isDetail ? null : 3,
                  overflow: widget.isDetail ? null : TextOverflow.ellipsis,
                ),

          const SizedBox(height: 24),

          if (widget.isDetail)
            _buildDetailFooter()
          else ...[
            Spacer(),
            _buildListFooter(),
          ],
        ],
      ),
    );
  }

  Widget _buildListFooter() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: widget.onViewDetail,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFEDBBC6),
          foregroundColor: const Color(0xFF6A4C53),
          padding: const EdgeInsets.symmetric(vertical: 12),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'XEM CHI TIẾT',
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
            ),
            SizedBox(width: 8),
            Icon(Icons.arrow_forward_rounded, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Tooltip(
          message:
              "Ngày tạo: ${DateFormat('dd/MM/yyyy HH:mm').format(_getCreatedAt())}",
          child: Row(
            children: [
              const Icon(Icons.access_time, color: Colors.white38, size: 14),
              const SizedBox(width: 4),
              Text(
                DateFormat('dd/MM/yyyy').format(_getCreatedAt()),
                style: const TextStyle(color: Colors.white38, fontSize: 11),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
