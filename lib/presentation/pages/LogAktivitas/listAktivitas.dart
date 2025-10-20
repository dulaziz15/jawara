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
      backgroundColor: Colors.grey.shade100,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: _openFilterDialog,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(16),
                    elevation: 4,
                    minimumSize: const Size(56, 56), // ukuran tombol kotak
                  ),
                  child: const Icon(
                    Icons.filter_list,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // --- Card/Container untuk Tabel dan Pagination ---
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                children: [
                  // --- Tabel Data ---
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columnSpacing: 30,
                        dataRowHeight: 50,
                        headingRowHeight: 40,
                        border: const TableBorder(
                          bottom: BorderSide(color: Colors.grey, width: 0.5),
                          horizontalInside: BorderSide(
                            color: Colors.grey,
                            width: 0.5,
                          ),
                        ),
                        columns: const [
                          DataColumn(
                            label: Text(
                              'NO',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Deskripsi',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Aktor',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Tanggal',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                        rows: logs
                            .map(
                              (item) => DataRow(
                                cells: [
                                  DataCell(Text(item.no.toString())),
                                  DataCell(Text(item.description)),
                                  DataCell(Text(item.actor)),
                                  DataCell(Text(item.date)),
                                ],
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ),

                  // --- Pagination ---
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: _buildPagination(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
