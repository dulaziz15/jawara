import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:jawara/presentation/pages/LogAktivitas/filter_aktivitas.dart';

class ActivityLog {
  final int no;
  final String description;
  final String actor;
  final String date;

  const ActivityLog({
    required this.no,
    required this.description,
    required this.actor,
    required this.date,
  });
}

final List<ActivityLog> _data = const [
  ActivityLog(
    no: 1,
    description: 'Menambahkan rumah baru dengan alamat: fasda',
    actor: 'Admin Jawara',
    date: '10 Oktober 2025',
  ),
  ActivityLog(
    no: 2,
    description: 'Menyetujui pesan warga: tes',
    actor: 'Admin Jawara',
    date: '11 Oktober 2025',
  ),
  ActivityLog(
    no: 3,
    description: 'Menghapus event: Lomba 17agustus pada ate 16 Agustus 2025',
    actor: 'Admin Jawara',
    date: '14 Oktober 2025',
  ),
];

@RoutePage()
class ListAktivitasPage extends StatefulWidget {
  const ListAktivitasPage({super.key});

  @override
  State<ListAktivitasPage> createState() => _ListAktivitasState();
}

class _ListAktivitasState extends State<ListAktivitasPage> {
  // Tidak ada filtering, langsung pakai data asli
  List<ActivityLog> logs = _data;

  void _openFilterDialog() {
    showDialog(context: context, builder: (context) => const FilterAktivitas());
  }

  // --- Widget untuk tombol pagination ---
  Widget _buildPagination() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Tombol Previous
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.chevron_left),
          style: IconButton.styleFrom(
            backgroundColor: Colors.white,
            side: const BorderSide(color: Colors.grey, width: 0.5),
          ),
        ),
        const SizedBox(width: 8),

        // Tombol Halaman Aktif
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.deepPurple,
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: const Text(
            '1',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(width: 8),

        // Tombol Next
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.chevron_right),
          style: IconButton.styleFrom(
            backgroundColor: Colors.white,
            side: const BorderSide(color: Colors.grey, width: 0.5),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Log Aktivitas',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF4F6DF5),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search Bar
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
                    onChanged: (value) {
                      setState(() {
                        logs = _data.where((log) {
                          final matchDesc = log.description.toLowerCase().contains(value.toLowerCase());
                          final matchActor = log.actor.toLowerCase().contains(value.toLowerCase());
                          return matchDesc || matchActor;
                        }).toList();
                      });
                    },
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

          // Jumlah data ditemukan
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              '${logs.length} data ditemukan',
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ),

          // List Data
          Expanded(
            child: logs.isEmpty
                ? Center(
                    child: Text(
                      'Data tidak ditemukan',
                      style: TextStyle(color: Colors.grey.shade500),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: logs.length,
                    itemBuilder: (context, index) {
                      final log = logs[index];
                      return _buildDataCard(log);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openFilterDialog,
        backgroundColor: const Color(0xFF4F6DF5),
        child: const Icon(Icons.filter_list, color: Colors.white),
      ),
    );
  }

  Widget _buildDataCard(ActivityLog log) {
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
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
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Tanggal: ${log.date}',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    // Handle actions if needed
                  },
                  itemBuilder: (context) => const [
                    PopupMenuItem(value: 'detail', child: Text('Detail')),
                  ],
                  icon: const Icon(Icons.more_vert, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
