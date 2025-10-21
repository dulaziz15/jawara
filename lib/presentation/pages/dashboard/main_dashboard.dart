import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:jawara/core/models/finance_model.dart';
import 'package:jawara/core/models/population_model.dart';
import 'package:jawara/presentation/pages/dashboard/dashboard_kegiatan.dart';
import 'package:jawara/presentation/pages/dashboard/widgets/stat_card.dart';

@RoutePage()
class MainDashboardPage extends StatefulWidget {
  const MainDashboardPage({super.key});

  @override
  State<MainDashboardPage> createState() => _MainDashboardPageState();
}

class _MainDashboardPageState extends State<MainDashboardPage> {
  // Dummy data
  late FinanceData financeData;
  late PopulationData populationData;
  late EventData eventData;

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() async {
    // Simulate data loading delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    setState(() {
      financeData = FinanceData.dummy();
      populationData = PopulationData.dummy();
      eventData = EventData(
        totalKegiatan: 15,
        kategoriData: [],
        waktuData: [],
        penanggungJawabData: [],
        bulananData: [],
      );
      _isLoading = false;
    });
  }

  void _refreshData() async {
    setState(() {
      _isLoading = true;
    });
    
    await Future.delayed(const Duration(seconds: 1));
    
    setState(() {
      financeData = FinanceData.dummy();
      populationData = PopulationData.dummy();
      eventData = EventData(
        totalKegiatan: 15 + DateTime.now().second % 5, // Random change for demo
        kategoriData: [],
        waktuData: [],
        penanggungJawabData: [],
        bulananData: [],
      );
      _isLoading = false;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Data berhasil diperbarui'),
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
      backgroundColor: Colors.grey.shade50,
      body: _isLoading
          ? _buildLoadingState()
          : RefreshIndicator(
              onRefresh: () async => _refreshData(),
              color: const Color(0xFF6C63FF),
              backgroundColor: Colors.white,
              child: CustomScrollView(
                slivers: [
                  // Header Section
                  SliverAppBar(
                    expandedHeight: 120,
                    flexibleSpace: FlexibleSpaceBar(
                      title: Text(
                        'Main Dashboard',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              blurRadius: 4,
                              color: Colors.black.withOpacity(0.3),
                            ),
                          ],
                        ),
                      ),
                      background: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              const Color(0xFF6C63FF),
                              Colors.purple.shade400,
                            ],
                          ),
                        ),
                      ),
                    ),
                    pinned: true,
                    actions: [
                      IconButton(
                        icon: const Icon(Icons.refresh, color: Colors.white),
                        onPressed: _refreshData,
                        tooltip: 'Refresh Data',
                      ),
                    ],
                  ),

                  // Content Section
                  SliverPadding(
                    padding: const EdgeInsets.all(16),
                    sliver: SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Welcome Section
                          _buildWelcomeSection(),
                          const SizedBox(height: 24),

                          // Quick Stats Grid
                          _buildStatsGrid(crossAxisCount, size),
                          const SizedBox(height: 24),

                          // Recent Activity Section
                          _buildRecentActivitySection(),
                        ],
                      ),
                    ),
                  ),
                ],
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
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF6C63FF).withOpacity(0.1),
            Colors.purple.shade50,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.purple.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid(int crossAxisCount, Size size) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
        GridView.count(
          crossAxisCount: crossAxisCount,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: size.width > 400 ? 1.1 : 1.3,
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

            // === Kegiatan ===
            if (crossAxisCount > 2) ...[
              StatCard(
                title: 'Total Kegiatan',
                value: eventData.totalKegiatan.toDouble(),
                valueColor: Colors.teal,
                icon: Icons.event_available_rounded,
                isCurrency: false,
              ),
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
      ],
    );
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
      String title, String subtitle, IconData icon, Color color) {
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
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade800,
                    fontSize: 14,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right_rounded,
            color: Colors.grey.shade400,
          ),
        ],
      ),
    );
  }
}