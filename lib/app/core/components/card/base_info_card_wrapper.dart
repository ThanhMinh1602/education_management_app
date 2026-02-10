import 'package:flutter/material.dart';

class BaseInfoCardWrapper extends StatelessWidget {
  final Widget child;
  final bool isDetail;
  final bool isEditing;
  final VoidCallback onToggleEdit;

  const BaseInfoCardWrapper({
    super.key,
    required this.child,
    this.isDetail = false,
    required this.isEditing,
    required this.onToggleEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF909CC2), Color(0xFF6876A0)], // Màu giống ClassCard
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6876A0).withOpacity(0.4),
            offset: const Offset(0, 8),
            blurRadius: 16,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            // Trang trí hình tròn
            Positioned(
              top: -30,
              right: -30,
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  shape: BoxShape.circle,
                ),
              ),
            ),

            // Nội dung chính
            isDetail
                ? SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: child,
                  )
                : Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 16, 20),
                    child: child,
                  ),

            // Nút Edit (Chỉ hiện ở mode Detail)
            if (isDetail)
              Positioned(top: 16, right: 16, child: _buildEditButton()),
          ],
        ),
      ),
    );
  }

  Widget _buildEditButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onToggleEdit,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isEditing ? Colors.white : Colors.black.withOpacity(0.2),
            shape: BoxShape.circle,
            boxShadow: isEditing
                ? [
                    const BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ]
                : [],
          ),
          child: Icon(
            isEditing ? Icons.check_rounded : Icons.edit_rounded,
            color: isEditing ? const Color(0xFF00B894) : Colors.white,
            size: 20,
          ),
        ),
      ),
    );
  }
}
