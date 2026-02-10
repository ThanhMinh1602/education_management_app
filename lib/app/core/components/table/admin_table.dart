import 'package:flutter/material.dart';

class AdminTable extends StatelessWidget {
  final List<String> columns;
  final List<DataRow> rows;
  final bool isLoading;

  const AdminTable({
    super.key,
    required this.columns,
    required this.rows,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (rows.isEmpty) {
      return _buildEmptyState();
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF909CC2).withOpacity(0.08),
            offset: const Offset(0, 4),
            blurRadius: 24,
          ),
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Theme(
          // Override Theme để bảng đẹp hơn
          data: Theme.of(context).copyWith(
            dividerColor: Colors.grey.shade100,
            dataTableTheme: DataTableThemeData(
              headingRowColor: MaterialStateProperty.all(
                const Color(0xFFF9FAFB),
              ),
              dataRowColor: MaterialStateProperty.resolveWith((states) {
                if (states.contains(MaterialState.hovered)) {
                  return const Color(0xFFF3E5F5); // Màu tím nhạt khi hover
                }
                return Colors.white;
              }),
              headingTextStyle: const TextStyle(
                color: Color(0xFF64748B), // Màu chữ header xám xanh hiện đại
                fontWeight: FontWeight.w700,
                fontSize: 13,
                letterSpacing: 0.5,
              ),
              dataTextStyle: const TextStyle(
                color: Color(0xFF334155), // Màu chữ data đậm hơn
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ConstrainedBox(
                  constraints: BoxConstraints(minWidth: constraints.maxWidth),
                  child: DataTable(
                    headingRowHeight: 52,
                    dataRowHeight: 76, // Row cao thoáng
                    columnSpacing: 24,
                    horizontalMargin: 24,
                    dividerThickness: 1,
                    showCheckboxColumn:
                        false, // Tắt cột checkbox nếu không dùng
                    columns: columns.map((col) {
                      return DataColumn(
                        label: Text(col.toUpperCase()),
                        // Có thể thêm logic sort tại đây sau này
                      );
                    }).toList(),
                    rows: rows,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.inbox_rounded, size: 48, color: Colors.grey[300]),
          ),
          const SizedBox(height: 16),
          Text(
            "Không có dữ liệu",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Danh sách hiện đang trống.",
            style: TextStyle(color: Colors.grey[500], fontSize: 13),
          ),
        ],
      ),
    );
  }
}
