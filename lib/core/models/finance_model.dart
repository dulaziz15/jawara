import 'package:flutter/material.dart';
import 'package:jawara/core/models/catergory_data.dart';
// Asumsikan file 'catergory_data.dart' sudah ada di project Anda
// import 'package:jawara/core/models/catergory_data.dart'; 

class FinanceData {
  final double totalIncome;
  final double totalExpense;
  final int transactionCount;
  final List<MonthlyData> monthlyIncome;
  final List<MonthlyData> monthlyExpense;
  final List<CategoryData> incomeByCategory;
  final List<CategoryData> expenseByCategory;

  FinanceData({
    required this.totalIncome,
    required this.totalExpense,
    required this.transactionCount,
    required this.monthlyIncome,
    required this.monthlyExpense,
    required this.incomeByCategory,
    required this.expenseByCategory,
  });

  // Data dummy factory
  factory FinanceData.dummy() {
    return FinanceData(
      totalIncome: 50000000,
      totalExpense: 2100000,
      transactionCount: 15,
      monthlyIncome: [
        MonthlyData(month: 'Jan', amount: 45000000),
        MonthlyData(month: 'Feb', amount: 38000000),
        MonthlyData(month: 'Mar', amount: 52000000),
        MonthlyData(month: 'Apr', amount: 41000000),
        MonthlyData(month: 'Mei', amount: 48000000),
        MonthlyData(month: 'Jun', amount: 55000000),
        MonthlyData(month: 'Jul', amount: 42000000),
        MonthlyData(month: 'Agu', amount: 58000000),
        MonthlyData(month: 'Sep', amount: 47000000),
        MonthlyData(month: 'Okt', amount: 60000000),
      ],
      monthlyExpense: [
        MonthlyData(month: 'Jan', amount: 1800000),
        MonthlyData(month: 'Feb', amount: 2200000),
        MonthlyData(month: 'Mar', amount: 1900000),
        MonthlyData(month: 'Apr', amount: 2100000),
        MonthlyData(month: 'Mei', amount: 2400000),
        MonthlyData(month: 'Jun', amount: 1700000),
        MonthlyData(month: 'Jul', amount: 2600000),
        MonthlyData(month: 'Agu', amount: 2000000),
        MonthlyData(month: 'Sep', amount: 2300000),
        MonthlyData(month: 'Okt', amount: 2200000),
      ],
      incomeByCategory: [
        CategoryData(
          category: 'Penjualan Produk',
          amount: 35000000,
          percentage: 70,
          color: Colors.blue,
        ),
        CategoryData(
          category: 'Layanan Konsultasi',
          amount: 10000000,
          percentage: 20,
          color: Colors.green,
        ),
        CategoryData(
          category: 'Lainnya',
          amount: 5000000,
          percentage: 10,
          color: Colors.orange,
        ),
      ],
      expenseByCategory: [
        CategoryData(
          category: 'Gaji Karyawan',
          amount: 1200000,
          percentage: 57,
          color: Colors.purple,
        ),
        CategoryData(
          category: 'Operasional',
          amount: 500000,
          percentage: 24,
          color: Colors.red,
        ),
        CategoryData(
          category: 'Peralatan',
          amount: 300000,
          percentage: 14,
          color: Colors.amber,
        ),
        CategoryData(
          category: 'Lainnya',
          amount: 100000,
          percentage: 5,
          color: Colors.grey,
        ),
      ],
    );
  }
}

class MonthlyData {
  final String month;
  final double amount;

  MonthlyData({required this.month, required this.amount});
}