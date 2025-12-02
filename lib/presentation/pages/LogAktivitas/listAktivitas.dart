import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jawara/core/models/activity_models.dart';

@RoutePage()
class ListAktivitasPage extends StatefulWidget {
  const ListAktivitasPage({super.key});

  @override
  State<ListAktivitasPage> createState() => _ListAktivitasState();
}

class _ListAktivitasState extends State<ListAktivitasPage> {
  // State untuk query pencarian
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // --- Search Bar (Sesuai Pattern Contoh) ---
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
                )
              ],
            ),
            child: Row(
              children: [
                const Icon(Icons.search, color: Colors.grey),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                    decoration: const InputDecoration(
                      hintText: 'Cari aktivitas atau aktor...',
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // --- List Data dari Firebase ---
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              // Mengambil data langsung (atau bisa via Repository jika ada)
              stream: FirebaseFirestore.instance
                  .collection("activities")
                  .orderBy("date", descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Terjadi kesalahan: ${snapshot.error}'));
                }

                // 1. Konversi Dokumen ke Model
                final allLogs = snapshot.data?.docs.map((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      // Pastikan ID dokumen ikut ter-parsing jika dibutuhkan logic delete/edit
                      return ActivityModel.fromMap(data, doc.id);
                    }).toList() ?? [];

                // 2. Filter berdasarkan search query (Description OR Actor)
                final displayedLogs = allLogs.where((log) {
                  final query = _searchQuery.toLowerCase();
                  return log.description.toLowerCase().contains(query) ||
                         log.actor.toLowerCase().contains(query);
                }).toList();

                return Column(
                  children: [
                    // Counter Data Ditemukan
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Text(
                        '${displayedLogs.length} data ditemukan',
                        style: const TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                    ),
                    
                    // List View
                    Expanded(
                      child: displayedLogs.isEmpty
                          ? Center(
                              child: Text(
                                'Data tidak ditemukan',
                                style: TextStyle(color: Colors.grey.shade500),
                              ),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              itemCount: displayedLogs.length,
                              itemBuilder: (context, index) {
                                final log = displayedLogs[index];
                                return _buildDataCard(log);
                              },
                            ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // --- Widget Card (Sesuai Style Contoh) ---
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
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Deskripsi Utama
            Text(
              log.description,
              style: const TextStyle(
                fontWeight: FontWeight.bold, 
                fontSize: 16
              ),
            ),
            const SizedBox(height: 4),
            
            // Aktor
            Text(
              'Aktor: ${log.actor}',
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 4),

            // Tanggal (Formatted)
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