import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:async/async.dart';
import 'package:jawara/core/models/population_model.dart';
import 'package:jawara/core/repositories/dashboard_penduduk_repository.dart';
import 'package:jawara/presentation/pages/dashboard/widgets/pie_chart.dart';
import 'package:jawara/presentation/pages/dashboard/widgets/stat_card.dart';
import 'package:jawara/presentation/widgets/sidebar/sidebar.dart';

@RoutePage()
class DashboardKependudukanPage extends StatelessWidget {
  DashboardKependudukanPage({super.key});

  final _repository = DashboardKependudukanRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Sidebar(),
      appBar: AppBar(
        title: const Text(
          'Dashboard Kependudukan',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF6C63FF),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.grey[50],
      body: StreamBuilder<PopulationData>(
        stream: _repository.fetchDashboardData(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final data = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: StatCard(
                        title: 'Total Keluarga',
                        value: data.totalFamilies.toDouble(),
                        valueColor: Colors.blue,
                        icon: Icons.home,
                        isCurrency: false,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: StatCard(
                        title: 'Total Penduduk',
                        value: data.totalPeople.toDouble(),
                        valueColor: Colors.green,
                        icon: Icons.people,
                        isCurrency: false,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                PieChart(title: 'Status Penduduk', data: data.statusData),
                const SizedBox(height: 24),
                PieChart(title: 'Jenis Kelamin', data: data.genderData),
                const SizedBox(height: 24),
                PieChart(title: 'Pekerjaan Penduduk', data: data.jobData),
                const SizedBox(height: 24),
                PieChart(title: 'Peran dalam Keluarga', data: data.familyRoleData),
                const SizedBox(height: 24),
                PieChart(title: 'Agama', data: data.religionData),
                const SizedBox(height: 24),
                PieChart(title: 'Pendidikan', data: data.educationData),
              ],
            ),
          );
        },
      ),
    );
  }
}
