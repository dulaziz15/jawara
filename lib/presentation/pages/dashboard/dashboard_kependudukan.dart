import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:jawara/core/models/population_model.dart';
import 'package:jawara/presentation/pages/dashboard/widgets/stat_card.dart';
import 'package:jawara/presentation/pages/dashboard/widgets/pie_chart.dart';

@RoutePage()
class DashboardKependudukanPage extends StatelessWidget {
  DashboardKependudukanPage({super.key});

  final PopulationData populationData = PopulationData.dummy();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // === Statistik Cards ===
            Row(
              children: [
                Expanded(
                  child: StatCard(
                    title: 'Total Keluarga',
                    value: populationData.totalFamilies.toDouble(),
                    valueColor: Colors.blue,
                    icon: Icons.home,
                    isCurrency: false,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: StatCard(
                    title: 'Total Penduduk',
                    value: populationData.totalPeople.toDouble(),
                    valueColor: Colors.green,
                    icon: Icons.people,
                    isCurrency: false,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // === Pie Chart: Status Penduduk ===
            PieChart(
              title: 'Status Penduduk',
              data: populationData.statusData,
            ),

            const SizedBox(height: 24),

            // === Pie Chart: Jenis Kelamin ===
            PieChart(
              title: 'Jenis Kelamin',
              data: populationData.genderData,
            ),

            const SizedBox(height: 24),

            // === Pie Chart: Pekerjaan ===
            PieChart(
              title: 'Pekerjaan Penduduk',
              data: populationData.jobData,
            ),

            const SizedBox(height: 24),

            // === Pie Chart: Peran dalam Keluarga ===
            PieChart(
              title: 'Peran dalam Keluarga',
              data: populationData.familyRoleData,
            ),

            const SizedBox(height: 24),

            // === Pie Chart: Agama ===
            PieChart(
              title: 'Agama',
              data: populationData.religionData,
            ),

            const SizedBox(height: 24),

            // === Pie Chart: Pendidikan ===
            PieChart(
              title: 'Pendidikan',
              data: populationData.educationData,
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
