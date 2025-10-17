import 'package:flutter/material.dart';
import 'package:jawara/core/utils/formatter_util.dart';

class StatCard extends StatelessWidget {
  final String title;
  final double value;
  final Color valueColor;
  final IconData icon;
  final bool isCurrency;

  const StatCard({
    Key? key,
    required this.title,
    required this.value,
    required this.valueColor,
    required this.icon,
    this.isCurrency = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // === Ikon + Arah ===
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: valueColor, size: 24),
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: valueColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    valueColor == Colors.green
                        ? Icons.arrow_upward
                        : Icons.arrow_downward,
                    color: valueColor,
                    size: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // === Judul ===
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
            ),
            const SizedBox(height: 6),

            // === Nilai ===
            Text(
              isCurrency
                  ? FormatterUtil.formatCurrency(value)
                  : value.toStringAsFixed(0),
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: valueColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
