import 'package:flutter/material.dart';

class CategoryData {
  final String category;
  final double percentage;
  final Color color;
  final double? amount;

  CategoryData({
    required this.category,
    required this.percentage,
    required this.color,
    this.amount,
  });
}
