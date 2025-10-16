import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:jawara/core/models/pengeluaran_model.dart'; // pastikan path sesuai struktur project-mu

@RoutePage()
class PengeluaranDaftarPage extends StatelessWidget {
  const PengeluaranDaftarPage({super.key});

  // --- Widget untuk menampilkan badge status verifikasi ---
  Widget _buildVerifikasiBadge(DateTime tanggalTerverifikasi) {
    final now = DateTime.now();
    final diff = now.difference(tanggalTerverifikasi).inDays;

    String status;
    Color backgroundColor;

    if (diff < 2) {
      status = 'Baru Diverifikasi';
      backgroundColor = Colors.green.shade200;
    } else {
      status = 'Terverifikasi';
      backgroundColor = Colors.blue.shade200;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        status,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
      ),
    );
  }

  // --- Widget Pagination ---
  Widget _buildPagination() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.chevron_left),
          style: IconButton.styleFrom(
            backgroundColor: Colors.white,
            side: const BorderSide(color: Colors.grey, width: 0.5),
          ),
        ),
        const SizedBox(width: 8),
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

  // --- Widget utama ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: ElevatedButton(
                  onPressed: () {
                    // nanti bisa diisi filter dialog pengeluaran
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding: const EdgeInsets.all(12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    minimumSize: const Size(60, 50),
                  ),
                  child: const Icon(
                    Icons.filter_list,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            // --- Card Container ---
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                children: [
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
                          horizontalInside:
                              BorderSide(color: Colors.grey, width: 0.5),
                        ),
                        columns: const [
                          DataColumn(
                              label: Text('NO',
                                  style: TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(
                              label: Text('NAMA PENGELUARAN',
                                  style: TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(
                              label: Text('KATEGORI',
                                  style: TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(
                              label: Text('JUMLAH (Rp)',
                                  style: TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(
                              label: Text('VERIFIKATOR',
                                  style: TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(
                              label: Text('TANGGAL',
                                  style: TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(
                              label: Text('STATUS',
                                  style: TextStyle(fontWeight: FontWeight.bold))),
                        ],
                        rows: dummyPengeluaran
                            .map(
                              (item) => DataRow(
                                cells: [
                                  DataCell(Text(item.id.toString())),
                                  DataCell(Text(item.namaPengeluaran)),
                                  DataCell(Text(item.kategoriPengeluaran)),
                                  DataCell(Text(
                                      item.jumlahPengeluaran.toStringAsFixed(0))),
                                  DataCell(Text(item.verifikator)),
                                  DataCell(Text(
                                      '${item.tanggalPengeluaran.day}/${item.tanggalPengeluaran.month}/${item.tanggalPengeluaran.year}')),
                                  DataCell(
                                      _buildVerifikasiBadge(item.tanggalTerverifikasi)),
                                ],
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ),

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
