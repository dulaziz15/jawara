import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
// Import relatif untuk FilterPesanWargaDialog karena berada di folder yang sama
import 'filter.dart'; 
import 'package:jawara/presentation/widgets/sidebar/sidebar.dart';


// --- DEFINISI DATA MODEL ---
class AspirationData {
  final int no;
  final String pengirim;
  final String judul;
  final String status;

  // Constructor harus const agar list _data bisa const
  const AspirationData({
    required this.no,
    required this.pengirim,
    required this.judul,
    required this.status,
  });
}

@RoutePage()
class AspirasiPage extends StatelessWidget {
  const AspirasiPage({super.key});

  // --- Sample Data List ---
  final List<AspirationData> _data = const [
    const AspirationData(
        no: 1, pengirim: 'Habibie Ed Dien', judul: 'tes', status: 'Pending'),
    // Contoh data tambahan (opsional)
    const AspirationData(
        no: 2, pengirim: 'Budi Santoso', judul: 'Lampu Jalan Mati', status: 'Diproses'),
    const AspirationData(
        no: 3, pengirim: 'Siti Aisyah', judul: 'Masalah Kebersihan', status: 'Selesai'),
  ];

  // --- Widget untuk menampilkan badge status berwarna ---
  Widget _buildStatusBadge(String status) {
    Color backgroundColor;
    Color textColor = Colors.black;

    switch (status.toLowerCase()) {
      case 'pending':
        backgroundColor = Colors.yellow.shade200;
        break;
      case 'diproses':
        backgroundColor = Colors.blue.shade200;
        break;
      case 'selesai':
        backgroundColor = Colors.green.shade200;
        break;
      default:
        backgroundColor = Colors.grey.shade300;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  // --- Widget untuk tombol pagination ---
  Widget _buildPagination() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Previous Button
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.chevron_left),
          style: IconButton.styleFrom(
            backgroundColor: Colors.white,
            side: const BorderSide(color: Colors.grey, width: 0.5),
          ),
        ),
        const SizedBox(width: 8),

        // Current Page Button (Page 1)
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

        // Next Button
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
                       Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: ElevatedButton(
                  onPressed: () {
                    // Panggil FilterPesanWargaDialog
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return const FilterPesanWargaDialog();
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding: const EdgeInsets.all(12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    minimumSize: const Size(60, 50), // Ukuran tombol kecil
                  ),
                  child: const Icon(
                    Icons.filter_list,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

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
                        // Border bawah pada header
                        border: const TableBorder(
                          bottom: BorderSide(color: Colors.grey, width: 0.5),
                          horizontalInside: BorderSide(
                            color: Colors.grey,
                            width: 0.5,
                          ),
                        ),
                        // Header Tabel
                        columns: const [
                          DataColumn(
                              label: Text('NO',
                                  style: TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(
                              label: Text('PENGIRIM',
                                  style: TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(
                              label: Text('JUDUL',
                                  style: TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(
                              label: Text('STATUS',
                                  style: TextStyle(fontWeight: FontWeight.bold))),
                        ],
                        // Baris Data
                        rows: _data
                            .map(
                              (item) => DataRow(
                                cells: [
                                  DataCell(Text(item.no.toString())),
                                  DataCell(Text(item.pengirim)),
                                  DataCell(Text(item.judul)),
                                  DataCell(_buildStatusBadge(item.status)),
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