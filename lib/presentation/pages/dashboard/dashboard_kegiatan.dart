import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:async/async.dart';
import 'package:jawara/core/models/finance_models.dart';
import 'package:jawara/core/repositories/dashboard_kegiatan_reposiotry.dart';
import 'package:jawara/presentation/pages/dashboard/widgets/bar_chart.dart';
import 'package:jawara/presentation/pages/dashboard/widgets/stat_card.dart';
import 'package:jawara/presentation/widgets/sidebar/sidebar.dart';

@RoutePage()
class DashboardKegiatanPage extends StatelessWidget {
  DashboardKegiatanPage({super.key});

  final DashboardKegiatanRepository repo = DashboardKegiatanRepository();

  final List<String> bulanLabels = const [
    'Jan','Feb','Mar','Apr','Mei','Jun',
    'Jul','Agu','Sep','Okt','Nov','Des',
  ];

  @override
  Widget build(BuildContext context) {
    final currentYear = DateTime.now().year;

    return Scaffold(
      drawer: const Sidebar(),
      appBar: AppBar(
        title: const Text(
          'Dashboard Kegiatan',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        backgroundColor: const Color(0xFF6C63FF),
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.grey[50],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            /// TOTAL KEGIATAN
            StreamBuilder<int>(
              stream: repo.getTotalActivities(),
              builder: (_, snap) {
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

            /// WAKTU KEGIATAN
            StreamBuilder<List<int>>(
              stream: StreamZip([
                repo.getActivityLewat(),
                repo.getActivityHariIni(),
                repo.getActivityAkanDatang(),
              ]),
              builder: (_, snap) {
                if (!snap.hasData) return const SizedBox();

                final data = snap.data!;
                return _buildWaktuSection(
                  context,
                  data[0], data[1], data[2],
                );
              },
            ),

            const SizedBox(height: 24),

            /// CHART PER BULAN
            _buildBarChartPerBulan(currentYear),
          ],
        ),
      ),
    );
  }

  Widget _buildBarChartPerBulan(int year) {
    final streams = List.generate(
      12,
      (i) => repo.getActivitiesPerMonth(i + 1, year),
    );

    return StreamBuilder<List<int>>(
      stream: StreamZip(streams),
      builder: (_, snap) {
        if (!snap.hasData) return const SizedBox();

        final monthly = snap.data!;
        final data = List.generate(12, (i) {
          return MonthlyData(
            month: bulanLabels[i],
            amount: monthly[i].toDouble(),
          );
        });

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Agenda Per Bulan ($year)",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            BarChart(
              title: '',
              data: data,
              color: Colors.blue,
            ),
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
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Kegiatan Berdasarkan Waktu',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
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

  Widget _buildWaktuCard(
    String title,
    int value,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(.3)),
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
