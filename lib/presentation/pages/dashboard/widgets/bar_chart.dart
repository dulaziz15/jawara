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
    double maxValue = data.map((e) => e.amount).reduce((a, b) => a > b ? a : b);

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
            SizedBox(
              height: 200,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: data.map((item) {
                  double height = (item.amount / maxValue) * 150;
                  return Expanded(
                    child: Column(
                      children: [
                        Text(
                          FormatterUtil.formatCompactCurrency(item.amount),
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          height: height,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(8),
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item.month,
                          style: const TextStyle(
                            fontSize: 12,
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