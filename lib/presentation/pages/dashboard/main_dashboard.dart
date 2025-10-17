import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:jawara/core/models/finance_model.dart';
import 'package:jawara/core/models/population_model.dart';
import 'package:jawara/presentation/pages/dashboard/dashboard_kegiatan.dart';
import 'package:jawara/presentation/pages/dashboard/widgets/stat_card.dart';

@RoutePage()
class MainDashboardPage extends StatelessWidget {
  MainDashboardPage({super.key});

  // Dummy data
  final FinanceData financeData = FinanceData.dummy();
  final PopulationData populationData = PopulationData.dummy();
  final EventData eventData = EventData(
    totalKegiatan: 15,
    kategoriData: [],
    waktuData: [],
    penanggungJawabData: [],
    bulananData: [],
  ); // bisa diganti dengan generate dari DashboardKegiatanPage

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Grid Ringkasan Statistik
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.2,
              children: [
                // === Keuangan ===
                StatCard(
                  title: 'Saldo Bersih',
                  value: financeData.totalIncome - financeData.totalExpense,
                  valueColor: Colors.purple,
                  icon: Icons.account_balance_wallet,
                ),
                StatCard(
                  title: 'Pendapatan Bulanan Terakhir',
                  value: financeData.monthlyIncome.last.amount,
                  valueColor: Colors.green,
                  icon: Icons.attach_money,
                ),

                // === Kependudukan ===
                StatCard(
                  title: 'Total Penduduk',
                  value: populationData.totalPeople.toDouble(),
                  valueColor: Colors.blue,
                  icon: Icons.people,
                  isCurrency: false,
                ),
                StatCard(
                  title: 'Total Keluarga',
                  value: populationData.totalFamilies.toDouble(),
                  valueColor: Colors.orange,
                  icon: Icons.home,
                  isCurrency: false,
                ),

                // === Kegiatan ===
                StatCard(
                  title: 'Total Kegiatan Tahun Ini',
                  value: eventData.totalKegiatan.toDouble(),
                  valueColor: Colors.teal,
                  icon: Icons.event,
                  isCurrency: false,
                ),
                // Contoh tambahan: kegiatan hari ini
                StatCard(
                  title: 'Kegiatan Hari Ini',
                  value: 3, // bisa diganti dengan kalkulasi dari eventData
                  valueColor: Colors.green,
                  icon: Icons.today,
                  isCurrency: false,
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Bisa ditambahkan chart ringkas di bawah ini jika perlu
          ],
        ),
      ),
    );
  }
}
