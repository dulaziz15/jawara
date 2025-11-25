import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jawara/core/models/activity_models.dart';
import 'package:jawara/presentation/pages/LogAktivitas/filter_aktivitas.dart';

@RoutePage()
class ListAktivitasPage extends StatefulWidget {
  const ListAktivitasPage({super.key});

  @override
  State<ListAktivitasPage> createState() => _ListAktivitasState();
}

class _ListAktivitasState extends State<ListAktivitasPage> {
  List<ActivityModel> logs = [];
  List<ActivityModel> filteredLogs = [];

  void _filterData(String value) {
    setState(() {
      filteredLogs = logs.where((log) {
        final matchDesc = log.description.toLowerCase().contains(value.toLowerCase());
        final matchActor = log.actor.toLowerCase().contains(value.toLowerCase());
        return matchDesc || matchActor;
      }).toList();
    });
  }

  void _openFilterDialog() {
    showDialog(context: context, builder: (context) => const FilterAktivitas());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // Ambil realtime data dari Firestore
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("activity_logs")
            .orderBy("date", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text("Belum ada aktivitas"),
            );
          }

          logs = snapshot.data!.docs.map((doc) {
            return ActivityModel.fromMap(doc.data() as Map<String, dynamic>);
          }).toList();

          if (filteredLogs.isEmpty) {
            filteredLogs = List.from(logs);
          }

          return Column(
            children: [
              // Search Bar (TETAP SESUAI UI AWAL)
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search, color: Colors.grey),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        onChanged: (value) => _filterData(value),
                        decoration: const InputDecoration(
                          hintText: 'Cari berdasarkan deskripsi atau aktor...',
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Counter jumlah data ditemukan
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  '${filteredLogs.length} data ditemukan',
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ),

              // List Aktivitas
              Expanded(
                child: filteredLogs.isEmpty
                    ? const Center(child: Text("Data tidak ditemukan"))
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: filteredLogs.length,
                        itemBuilder: (context, index) =>
                            _buildDataCard(filteredLogs[index]),
                      ),
              ),
            ],
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _openFilterDialog,
        backgroundColor: const Color(0xFF6C63FF),
        child: const Icon(Icons.filter_list, color: Colors.white),
      ),
    );
  }

  /// CARD UI tetap sama seperti code awal
  Widget _buildDataCard(ActivityModel log) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              log.description,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 4),
            Text(
              'Aktor: ${log.actor}',
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),

            const SizedBox(height: 4),
            Text(
              'Tanggal: ${DateFormat("dd MMMM yyyy • HH:mm").format(log.date)}',
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
