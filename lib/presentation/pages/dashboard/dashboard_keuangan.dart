import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:jawara/core/models/finance_model.dart';
import 'package:jawara/presentation/pages/dashboard/widgets/bar_chart.dart';
import 'package:jawara/presentation/pages/dashboard/widgets/pie_chart.dart';
import 'package:jawara/presentation/pages/dashboard/widgets/stat_card.dart';
import 'package:jawara/presentation/widgets/sidebar/sidebar.dart';

@RoutePage()
class DashboardKeuanganPage extends StatelessWidget {
  DashboardKeuanganPage({super.key});

  final FinanceData financeData = FinanceData.dummy();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Sidebar(),
      appBar: AppBar(
        title: const Text(
          'Dashboard Keuangan',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF6C63FF),
        foregroundColor: Colors.white,
        centerTitle: false,
        elevation: 0,
      ),
      backgroundColor: Colors.grey[50],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Statistik Cards
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.2,
              children: [
                StatCard(
                  title: 'Total Pendapatan',
                  value: financeData.totalIncome,
                  valueColor: Colors.green,
                  icon: Icons.attach_money,
                ),
                StatCard(
                  title: 'Total Pengeluaran',
                  value: financeData.totalExpense,
                  valueColor: Colors.red,
                  icon: Icons.money_off,
                ),
                StatCard(
                  title: 'Jumlah Transaksi',
                  value: financeData.transactionCount.toDouble(),
                  valueColor: Colors.blue,
                  icon: Icons.list_alt,
                  isCurrency: false,
                ),
                StatCard(
                  title: 'Saldo Bersih',
                  value: financeData.totalIncome - financeData.totalExpense,
                  valueColor: Colors.purple,
                  icon: Icons.account_balance_wallet,
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Chart Pendapatan Bulanan
            BarChart(
              title: 'Pendapatan per Bulan',
              data: financeData.monthlyIncome,
              color: Colors.green,
            ),

            const SizedBox(height: 24),

            // Chart Pengeluaran Bulanan
            BarChart(
              title: 'Pengeluaran per Bulan',
              data: financeData.monthlyExpense,
              color: Colors.red,
            ),

            const SizedBox(height: 24),

            // Chart Kategori
            Row(
              children: [
                Expanded(
                  child: PieChart(
                    title: 'Pendapatan by Kategori',
                    data: financeData.incomeByCategory,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: PieChart(
                    title: 'Pengeluaran by Kategori',
                    data: financeData.expenseByCategory,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}