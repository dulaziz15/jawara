import 'package:flutter/material.dart';
import '../../../../core/models/finance_models.dart';
import '../../../../core/utils/formatter_util.dart';

class BarChart extends StatelessWidget {
  final String title;
  final List<MonthlyData> data;
  final Color color;

  const BarChart({
    Key? key,
    required this.title,
    required this.data,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ============================================
    // Hitung nilai maksimum (hindari nilai 0)
    // ============================================
    final double maxValue = data.isEmpty
        ? 1
        : data.map((e) => e.amount).reduce((a, b) => a > b ? a : b);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),

            // ============================================
            // CHART
            // ============================================
            SizedBox(
              height: 200,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: data.map((item) {
                  // ============================================
                  // Kalkulasi tinggi batang secara aman (no NaN)
                  // ============================================
                  double height = (maxValue == 0)
                      ? 0
                      : (item.amount / maxValue) * 150;

                  if (height.isNaN || height.isInfinite) {
                    height = 0;
                  }

                  return Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // BATANG
                        Container(
                          height: height,
                          width: 20,
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(8),
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),

                        // BULAN
                        Text(
                          item.month,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),

                        // NOMINAL
                        Text(
                          FormatterUtil.formatCompactCurrency(item.amount),
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
