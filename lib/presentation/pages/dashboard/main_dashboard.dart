import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jawara/core/models/dashboard_kegiatan_model.dart';
import 'package:jawara/core/models/finance_models.dart';
import 'package:jawara/core/models/population_model.dart';
import 'package:jawara/core/repositories/dashboard_kegiatan_reposiotry.dart';
import 'package:jawara/core/repositories/dashboard_penduduk_repository.dart';
import 'package:jawara/core/services/dashboard_keuangan_service.dart';
import 'package:jawara/presentation/pages/dashboard/dashboard_kegiatan.dart';
import 'package:jawara/presentation/pages/dashboard/widgets/stat_card.dart';
import 'package:jawara/presentation/widgets/sidebar/sidebar.dart';

@RoutePage()
class MainDashboardPage extends StatefulWidget {
  const MainDashboardPage({super.key});

  @override
  State<MainDashboardPage> createState() => _MainDashboardPageState();
}

class _MainDashboardPageState extends State<MainDashboardPage> {
  late FinanceData financeData;
  late PopulationData populationData;
  // late DashboardKegiatanModel kegiatanData;
  // late EventData eventData;
  bool _isLoading = true;

  final DashboardKeuanganService _financeService = DashboardKeuanganService();
  // final DashboardKegiatanRepository _kegiatanRepository =
  //     DashboardKegiatanRepository();
  final DashboardKependudukanRepository _pendudukRepository =
      DashboardKependudukanRepository();

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() async {
    final finance = await _financeService
        .getDashboardData(DateTime.now().year)
        .first;
    final population = await _pendudukRepository.fetchDashboardData().first;
    // final kegiatan = await _kegiatanRepository.getRecentActivities();
    setState(() {
      financeData = finance;
      populationData = population;
      // kegiatanData = kegiatan
      // kegiatanData = kegiatan;
      // eventData = EventData(
      //   totalKegiatan: 15,
      //   kategoriData: [],
      //   waktuData: [],
      //   penanggungJawabData: [],
      //   bulananData: [],
      // );
      _isLoading = false;
    });
  }

  void _refreshData() async {
    setState(() => _isLoading = true);

    final finance = await _financeService
        .getDashboardData(DateTime.now().year)
        .first;

    // setState(() {
    //   financeData = finance;
    //   populationData = PopulationData.dummy();
    //   eventData = EventData(
    //     totalKegiatan: 15 + DateTime.now().second % 5,
    //     kategoriData: [],
    //     waktuData: [],
    //     penanggungJawabData: [],
    //     bulananData: [],
    //   );
    //   _isLoading = false;
    // });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Data keuangan berhasil diperbarui'),
        backgroundColor: Colors.green.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;
    final crossAxisCount = isTablet ? 4 : 2;

    return Scaffold(
      drawer: Sidebar(),
      appBar: AppBar(
        title: const Text(
          'Main Dashboard',
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
      backgroundColor: Colors.grey.shade50,
      body: _isLoading
          ? _buildLoadingState()
          : RefreshIndicator(
              onRefresh: () async => _refreshData(),
              color: const Color(0xFF6C63FF),
              backgroundColor: Colors.white,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return CustomScrollView(
                    slivers: [
                      SliverPadding(
                        padding: const EdgeInsets.all(16),
                        sliver: SliverToBoxAdapter(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildWelcomeSection(),
                              const SizedBox(height: 24),
                              _buildStatsGrid(crossAxisCount, constraints),
                              const SizedBox(height: 24),
                              _buildRecentActivitySection(),
                              const SizedBox(height: 24),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(Color(0xFF6C63FF)),
          ),
          SizedBox(height: 16),
          Text(
            'Memuat Dashboard...',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 80),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(
            0xFF6C63FF,
          ).withOpacity(0.1), // Ganti dengan satu warna
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF6C63FF).withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Selamat Datang! 👋',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Berikut ringkasan data terkini wilayah Anda',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsGrid(int crossAxisCount, BoxConstraints constraints) {
    final gridHeight = _calculateGridHeight(
      crossAxisCount,
      constraints.maxWidth,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Ringkasan Statistik',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade800,
          ),
        ),
        const SizedBox(height: 16),
        ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: gridHeight,
            maxHeight: gridHeight + 200, // Memberikan ruang ekstra
          ),
          child: GridView.count(
            crossAxisCount: crossAxisCount,
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
                valueColor: const Color(0xFF6C63FF),
                icon: Icons.account_balance_wallet_rounded,
              ),
              StatCard(
                title: 'Pendapatan',
                value: financeData.totalIncome,
                valueColor: Colors.green,
                icon: Icons.trending_up_rounded,
              ),

              // === Kependudukan ===
              StatCard(
                title: 'Total Penduduk',
                value: populationData.totalPeople.toDouble(),
                valueColor: Colors.blue,
                icon: Icons.people_alt_rounded,
                isCurrency: false,
              ),
              StatCard(
                title: 'Total Keluarga',
                value: populationData.totalFamilies.toDouble(),
                valueColor: Colors.orange,
                icon: Icons.home_work_rounded,
                isCurrency: false,
              ),

              // === Kegiatan === (hanya untuk tablet)
              if (crossAxisCount > 2) ...[
                // StatCard(
                //   title: 'Total Kegiatan',
                //   value: eventData.totalKegiatan.toDouble(),
                //   valueColor: Colors.teal,
                //   icon: Icons.event_available_rounded,
                //   isCurrency: false,
                // ),
                StatCard(
                  title: 'Kegiatan Aktif',
                  value: 3,
                  valueColor: Colors.pink,
                  icon: Icons.today_rounded,
                  isCurrency: false,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  double _calculateGridHeight(int crossAxisCount, double screenWidth) {
    final rows = (crossAxisCount > 2) ? 2.0 : 2.0; // 2 rows untuk semua ukuran
    final itemHeight =
        screenWidth / crossAxisCount / _calculateChildAspectRatio(screenWidth);
    return (itemHeight * rows) +
        (16 * (rows - 1)); // itemHeight * rows + spacing
  }

  double _calculateChildAspectRatio(double screenWidth) {
    if (screenWidth > 600) {
      return 1.3; // Tablet
    } else if (screenWidth > 400) {
      return 1.4; // Medium phone
    } else {
      return 1.6; // Small phone - lebih tinggi untuk mencegah overflow
    }
  }

  Widget _buildRecentActivitySection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Aktivitas Terkini',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
              ),
              Icon(
                Icons.notifications_active_rounded,
                color: Colors.orange.shade400,
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildActivityItem(
            'Pembayaran iuran',
            '5 pembayaran baru hari ini',
            Icons.payment_rounded,
            Colors.green,
          ),
          _buildActivityItem(
            'Kegiatan rutinan',
            'Senam sehat akan dimulai',
            Icons.fitness_center_rounded,
            Colors.blue,
          ),
          _buildActivityItem(
            'Data penduduk',
            '2 keluarga baru terdaftar',
            Icons.people_rounded,
            Colors.purple,
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem(
    String title,
    String subtitle,
    IconData icon,
    Color color,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade800,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right_rounded, color: Colors.grey.shade400),
        ],
      ),
    );
  }
}
