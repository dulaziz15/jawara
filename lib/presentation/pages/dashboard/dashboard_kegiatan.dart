import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:jawara/core/models/catergory_data.dart';
import 'package:jawara/core/models/finance_model.dart';
import 'package:jawara/core/models/kegiatan_models.dart';
import 'package:jawara/presentation/pages/dashboard/widgets/stat_card.dart';
import 'package:jawara/presentation/pages/dashboard/widgets/pie_chart.dart';
import 'package:jawara/presentation/pages/dashboard/widgets/bar_chart.dart';
import 'package:jawara/presentation/widgets/sidebar/sidebar.dart';

@RoutePage()
class DashboardKegiatanPage extends StatelessWidget {
  DashboardKegiatanPage({super.key});

  // Generate data dari dummyPengeluaran
  EventData get eventData => _generateEventData();

  EventData _generateEventData() {
    final now = DateTime.now();
    final currentYear = now.year;

    // Filter kegiatan untuk tahun ini
    final kegiatanTahunIni = dummyPengeluaran
        .where((kegiatan) => kegiatan.tanggalPelaksanaan.year == currentYear)
        .toList();

    // Hitung total kegiatan
    final totalKegiatan = kegiatanTahunIni.length;

    // Kategori data
    final kategoriMap = <String, int>{};
    for (var kegiatan in kegiatanTahunIni) {
      kategoriMap[kegiatan.kategoriKegiatan] =
          (kategoriMap[kegiatan.kategoriKegiatan] ?? 0) + 1; // Diperbaik
    }

    final kategoriData = kategoriMap.entries.map((entry) {
      return CategoryData(
        category: entry.key,
        percentage: totalKegiatan > 0 ? (entry.value / totalKegiatan * 100) : 0,
        color: _getColorForCategory(entry.key),
      );
    }).toList();

    // Waktu data
    final sudahLewat = kegiatanTahunIni
        .where(
          (k) => k.tanggalPelaksanaan.isBefore(
            DateTime(currentYear, now.month, now.day),
          ),
        )
        .length;

    final hariIni = kegiatanTahunIni
        .where(
          (k) =>
              k.tanggalPelaksanaan.year == now.year &&
              k.tanggalPelaksanaan.month == now.month &&
              k.tanggalPelaksanaan.day == now.day,
        )
        .length;

    final akanDatang = kegiatanTahunIni
        .where(
          (k) => k.tanggalPelaksanaan.isAfter(
            DateTime(currentYear, now.month, now.day),
          ),
        )
        .length;

    final waktuData = [
      CategoryData(
        category: 'Sudah Lewat',
        percentage: totalKegiatan > 0 ? (sudahLewat / totalKegiatan * 100) : 0,
        color: Colors.orange,
      ),
      CategoryData(
        category: 'Hari Ini',
        percentage: totalKegiatan > 0 ? (hariIni / totalKegiatan * 100) : 0,
        color: Colors.green,
      ),
      CategoryData(
        category: 'Akan Datang',
        percentage: totalKegiatan > 0 ? (akanDatang / totalKegiatan * 100) : 0,
        color: Colors.blue,
      ),
    ];

    // Penanggung Jawab data
    final penanggungJawabMap = <String, int>{};
    for (var kegiatan in kegiatanTahunIni) {
      penanggungJawabMap[kegiatan.penanggungJawab] =
          (penanggungJawabMap[kegiatan.penanggungJawab] ?? 0) + 1;
    }

    final penanggungJawabData = penanggungJawabMap.entries.map((entry) {
      return CategoryData(
        category: entry.key,
        percentage: totalKegiatan > 0 ? (entry.value / totalKegiatan * 100) : 0,
        color: _getColorForPenanggungJawab(entry.key),
      );
    }).toList();

    // Data bulanan
    final bulananMap = <String, int>{};
    final bulanLabels = [
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

    for (var label in bulanLabels) {
      bulananMap[label] = 0;
    }

    for (var kegiatan in kegiatanTahunIni) {
      final bulanIndex = kegiatan.tanggalPelaksanaan.month - 1;
      if (bulanIndex >= 0 && bulanIndex < bulanLabels.length) {
        final bulanLabel = bulanLabels[bulanIndex];
        bulananMap[bulanLabel] = (bulananMap[bulanLabel] ?? 0) + 1;
      }
    }

    final bulananData = bulananMap.entries.map((entry) {
      return MonthlyData(month: entry.key, amount: entry.value.toDouble());
    }).toList();

    return EventData(
      totalKegiatan: totalKegiatan,
      kategoriData: kategoriData,
      waktuData: waktuData,
      penanggungJawabData: penanggungJawabData,
      bulananData: bulananData,
    );
  }

  Color _getColorForCategory(String category) {
    final colors = {
      'Pelatihan': Colors.blue,
      'Seminar': Colors.green,
      'Kompetisi': Colors.orange,
      'Webinar': Colors.purple,
    };
    return colors[category] ?? Colors.grey;
  }

  Color _getColorForPenanggungJawab(String penanggungJawab) {
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.red,
      Colors.teal,
      Colors.indigo,
      Colors.pink,
    ];
    final index = penanggungJawab.hashCode % colors.length;
    return colors[index];
  }

  @override
  Widget build(BuildContext context) {
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
            StatCard(
              title: 'Total Kegiatan',
              value: eventData.totalKegiatan.toDouble(),
              valueColor: Colors.blue,
              icon: Icons.event,
              isCurrency: false,
            ),

            const SizedBox(height: 24),

            // === Kegiatan per Kategori ===
            if (eventData.kategoriData.isNotEmpty)
              PieChart(
                title: 'Kegiatan per Kategori',
                data: eventData.kategoriData,
              ),

            if (eventData.kategoriData.isNotEmpty) const SizedBox(height: 24),

            // === Kegiatan berdasarkan Waktu ===
            _buildWaktuSection(context),

            const SizedBox(height: 24),

            // === Penanggung Jawab Terbanyak ===
            if (eventData.penanggungJawabData.isNotEmpty)
              PieChart(
                title: 'Penanggung Jawab Terbanyak',
                data: eventData.penanggungJawabData,
              ),

            if (eventData.penanggungJawabData.isNotEmpty)
              const SizedBox(height: 24),

            // === Kegiatan per Bulan ===
            BarChart(
              title: 'Kegiatan per Bulan (Tahun Ini)',
              data: eventData.bulananData,
              color: Colors.blue,
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildWaktuSection(BuildContext context) {
    final waktuData = eventData.waktuData;

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

            // Grid untuk cards waktu
            Row(
              children: [
                Expanded(
                  child: _buildWaktuCard(
                    'Sudah Lewat',
                    _getCountFromPercentage(waktuData, 'Sudah Lewat'),
                    Colors.orange,
                    Icons.event_busy,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildWaktuCard(
                    'Hari Ini',
                    _getCountFromPercentage(waktuData, 'Hari Ini'),
                    Colors.green,
                    Icons.today,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildWaktuCard(
                    'Akan Datang',
                    _getCountFromPercentage(waktuData, 'Akan Datang'),
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

  int _getCountFromPercentage(List<CategoryData> data, String category) {
    final item = data.firstWhere(
      (item) => item.category == category,
      orElse: () =>
          CategoryData(category: category, percentage: 0, color: Colors.grey),
    );
    return (eventData.totalKegiatan * item.percentage / 100).round();
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

// Model untuk data event
class EventData {
  final int totalKegiatan;
  final List<CategoryData> kategoriData;
  final List<CategoryData> waktuData;
  final List<CategoryData> penanggungJawabData;
  final List<MonthlyData> bulananData;

  EventData({
    required this.totalKegiatan,
    required this.kategoriData,
    required this.waktuData,
    required this.penanggungJawabData,
    required this.bulananData,
  });
}
