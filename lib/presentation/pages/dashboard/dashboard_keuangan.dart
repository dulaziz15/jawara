import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:jawara/core/models/finance_models.dart';
import 'package:jawara/core/services/dashboard_keuangan_service.dart';
import 'package:jawara/presentation/pages/dashboard/widgets/bar_chart.dart';
import 'package:jawara/presentation/pages/dashboard/widgets/pie_chart.dart';
import 'package:jawara/presentation/pages/dashboard/widgets/stat_card.dart';
import 'package:jawara/presentation/widgets/sidebar/sidebar.dart';

@RoutePage()
class DashboardKeuanganPage extends StatefulWidget {
  DashboardKeuanganPage({super.key});

  @override
  State<DashboardKeuanganPage> createState() => _DashboardKeuanganPageState();
}

class _DashboardKeuanganPageState extends State<DashboardKeuanganPage> {
  final DashboardKeuanganService service = DashboardKeuanganService();
  int selectedMonth = 0; // 0 = semua bulan, 1..12 valid
  final int selectedYear = DateTime.now().year;

  List<DropdownMenuItem<int>> _monthItems() {
    final months = ['Semua Bulan','Jan','Feb','Mar','Apr','Mei','Jun','Jul','Agu','Sep','Okt','Nov','Des'];
    return List.generate(months.length, (i) => DropdownMenuItem(value: i, child: Text(months[i])));
  }

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
      body: StreamBuilder<FinanceData>(
        stream: service.getDashboardData(selectedYear, bulan: selectedMonth == 0 ? null : selectedMonth),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final financeData = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(child: DropdownButtonFormField<int>(
                      value: selectedMonth,
                      items: _monthItems(),
                      onChanged: (v) => setState(() => selectedMonth = v ?? 0),
                      decoration: const InputDecoration(labelText: 'Filter Bulan'),
                    )),
                  ],
                ),

                const SizedBox(height: 16),

                // =====================================
                // Statistik Cards
                // =====================================
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.2,
                  children: [
                    StatCard(
                      title: selectedMonth == 0 ? 'Total Pendapatan' : 'Pendapatan (${selectedMonth == 0 ? '' : selectedMonth})',
                      value: financeData.totalIncome,
                      valueColor: Colors.green,
                      icon: Icons.attach_money,
                    ),
                    StatCard(
                      title: selectedMonth == 0 ? 'Total Pengeluaran' : 'Pengeluaran (${selectedMonth == 0 ? '' : selectedMonth})',
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
                      value:
                          financeData.totalIncome - financeData.totalExpense,
                      valueColor: Colors.purple,
                      icon: Icons.account_balance_wallet,
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // =============================
                // Chart Pendapatan Bulanan
                // =============================
                BarChart(
                  title: 'Pendapatan per Bulan',
                  data: financeData.monthlyIncome,
                  color: Colors.green,
                ),

                const SizedBox(height: 24),

                // =============================
                // Chart Pengeluaran Bulanan
                // =============================
                BarChart(
                  title: 'Pengeluaran per Bulan',
                  data: financeData.monthlyExpense,
                  color: Colors.red,
                ),

                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }
}
