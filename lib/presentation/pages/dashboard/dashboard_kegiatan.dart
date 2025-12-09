import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:jawara/core/models/dashboard_kegiatan_model.dart';
import 'package:jawara/core/models/finance_models.dart';
import 'package:jawara/core/repositories/dashboard_kegiatan_reposiotry.dart';
import 'package:jawara/presentation/pages/dashboard/widgets/stat_card.dart';
import 'package:jawara/presentation/pages/dashboard/widgets/pie_chart.dart';
import 'package:jawara/presentation/pages/dashboard/widgets/bar_chart.dart';
import 'package:jawara/presentation/widgets/sidebar/sidebar.dart';
import 'package:async/async.dart';

@RoutePage()
class DashboardKegiatanPage extends StatelessWidget {
  DashboardKegiatanPage({super.key});

  final DashboardKegiatanRepository repo = DashboardKegiatanRepository();

  final List<String> bulanLabels = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'Mei',
    'Jun',
    'Jul',
    'Agu',
    'Sep',
    'Okt',
    'Nov',
    'Des',
  ];

  @override
  Widget build(BuildContext context) {
    final currentYear = DateTime.now().year;

    return Scaffold(
      drawer: Sidebar(),
      appBar: AppBar(
        title: const Text(
          'Dashboard Kegiatan',
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // === Total Kegiatan Card ===
            StreamBuilder<int>(
              stream: repo.getTotalActivities(),
              builder: (ctx, snap) {
                final total = snap.data ?? 0;
                return StatCard(
                  title: 'Total Kegiatan',
                  value: total.toDouble(),
                  valueColor: Colors.blue,
                  icon: Icons.event,
                  isCurrency: false,
                );
              },
            ),

            const SizedBox(height: 24),

            // === Kegiatan berdasarkan Waktu ===
            StreamBuilder<List<int>>(
              stream: StreamZip([
                repo.getActivityLewat(),
                repo.getActivityHariIni(),
                repo.getActivityAkanDatang(),
              ]),
              builder: (context, snap) {
                if (!snap.hasData) return SizedBox();
                final data = snap.data!;
                return _buildWaktuSection(context, data[0], data[1], data[2]);
              },
            ),

            const SizedBox(height: 24),

            // === Bar Chart Agenda per Bulan ===
            _buildBarChartPerBulan(currentYear),
          ],
        ),
      ),
    );
  }

  Widget _buildBarChartPerBulan(int year) {
    // StreamZip untuk 12 bulan agar bisa digabung
    final streams = List.generate(
      12,
      (index) => repo.getActivitiesPerMonth(index + 1, year),
    );

    return StreamBuilder<List<int>>(
      stream: StreamZip(streams),
      builder: (context, snap) {
        if (!snap.hasData) return SizedBox();

        final monthlyCounts = snap.data!;
        final barData = List<MonthlyData>.generate(12, (index) {
          return MonthlyData(
            month: bulanLabels[index],
            amount: monthlyCounts[index].toDouble(),
          );
        });

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Agenda Per Bulan ($year)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            BarChart(title: '', data: barData, color: Colors.blue),
          ],
        );
      },
    );
  }

  Widget _buildWaktuSection(
    BuildContext context,
    int lewat,
    int hariIni,
    int akanDatang,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Kegiatan berdasarkan Waktu',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildWaktuCard(
                    'Sudah Lewat',
                    lewat,
                    Colors.orange,
                    Icons.event_busy,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildWaktuCard(
                    'Hari Ini',
                    hariIni,
                    Colors.green,
                    Icons.today,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildWaktuCard(
                    'Akan Datang',
                    akanDatang,
                    Colors.blue,
                    Icons.event_available,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWaktuCard(String title, int value, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            value.toString(),
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
