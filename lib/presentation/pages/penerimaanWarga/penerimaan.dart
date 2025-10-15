import 'package:flutter/material.dart';
import 'package:jawara/presentation/pages/penerimaanWarga/filter_accept.dart';
// Import relatif untuk FilterPesanWargaDialog
import 'filter_accept.dart'; // Asumsikan FilterPesanWargaDialog ada di filter.dart

// --- DEFINISI DATA MODEL (Diselaraskan dengan Gambar) ---
class RegistrationData {
  final int no;
  final String nama;
  final String nik;
  final String email;
  final String jenisKelamin; // 'L' atau 'P'
  final String fotoIdentitasAsset; // Path asset/URL gambar
  final String statusRegistrasi; // 'Pending' atau 'Diterima'

  const RegistrationData({
    required this.no,
    required this.nama,
    required this.nik,
    required this.email,
    required this.jenisKelamin,
    required this.fotoIdentitasAsset,
    required this.statusRegistrasi,
  });
}

class PenerimaanPage extends StatelessWidget {
  const PenerimaanPage({super.key});

  // --- Sample Data List (Diselaraskan dengan Gambar) ---
  final List<RegistrationData> _data = const [
    // Data 1 (Pending)
    RegistrationData(
      no: 1,
      nama: 'Rendha Putra Rahmadya',
      nik: '3505115120400002',
      email: 'rendhazuper@gmail.com',
      jenisKelamin: 'L',
      fotoIdentitasAsset: 'assets/id_photo_1.jpg', // Ganti dengan path asset/URL sebenarnya
      statusRegistrasi: 'Pending',
    ),
    // Data 2 (Pending)
    RegistrationData(
      no: 2,
      nama: 'Anti Micin',
      nik: '1234567890987654',
      email: 'antimicin3@gmail.com',
      jenisKelamin: 'L',
      fotoIdentitasAsset: 'assets/id_photo_2.jpg', // Ganti dengan path asset/URL sebenarnya
      statusRegistrasi: 'Pending',
    ),
    // Data 3 (Diterima)
    RegistrationData(
      no: 3,
      nama: 'Ijat',
      nik: '2025202520252025',
      email: 'ijat@gmail.com',
      jenisKelamin: 'L',
      fotoIdentitasAsset: 'assets/id_photo_3.jpg', // Ganti dengan path asset/URL sebenarnya
      statusRegistrasi: 'Diterima',
    ),
    // Data 4 (Diterima)
    RegistrationData(
      no: 4,
      nama: 'Raudhil Firdaus Naufal',
      nik: '3201122501050002',
      email: 'raudhilfirdausn@gmail.com',
      jenisKelamin: 'L',
      fotoIdentitasAsset: 'assets/id_photo_4.jpg', // Ganti dengan path asset/URL sebenarnya
      statusRegistrasi: 'Diterima',
    ),
  ];
  
  // --- Widget untuk menampilkan badge status berwarna ---
  Widget _buildStatusBadge(String status) {
    Color backgroundColor;
    Color textColor = Colors.black;

    switch (status.toLowerCase()) {
      case 'pending':
        backgroundColor = Colors.yellow.shade200;
        break;
      case 'diterima': // Perubahan status
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

  // --- Widget untuk tombol Aksi (Titik Tiga) yang memunculkan PopupMenu ---
  Widget _buildActionMenu(BuildContext context, RegistrationData data) {
    return PopupMenuButton<String>(
      // Icon titik tiga
      icon: const Icon(Icons.more_horiz),
      // Posisi popup di bawah tombol
      offset: const Offset(0, 40), 
      // Bentuk kotak menu
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      // Item dalam menu
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        const PopupMenuItem<String>(
          value: 'detail',
          child: Text('Detail'),
        ),
        const PopupMenuItem<String>(
          value: 'edit',
          child: Text('Edit'),
        ),
      ],
      // Aksi ketika item dipilih
      onSelected: (String value) {
        if (value == 'detail') {
          // TODO: Implementasi navigasi ke halaman Detail
          print('Detail data ${data.no}');
        } else if (value == 'edit') {
          // TODO: Implementasi navigasi ke halaman Edit
          print('Edit data ${data.no}');
        }
      },
    );
  }


  // --- Widget untuk tombol pagination (Tidak diubah) ---
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
            // --- Tombol Filter di Kanan Atas (Diubah menyerupai gambar) ---
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
                        return const FilterPenerimaanWargaDialog();
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
                        columnSpacing: 25, // Diperkecil agar lebih padat
                        dataRowHeight: 80, // Ditinggikan untuk menampung gambar
                        headingRowHeight: 40,
                        border: const TableBorder(
                          // Garis horizontal antar baris
                          horizontalInside: BorderSide(color: Colors.grey, width: 0.5), 
                          // Garis di bawah header
                          bottom: BorderSide(color: Colors.grey, width: 0.5), 
                        ),
                        // Header Tabel (Diselaraskan dengan Gambar)
                        columns: const [
                          DataColumn(label: Text('NO', style: TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('NAMA', style: TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('NIK', style: TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('EMAIL', style: TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('JENIS KELAMIN', style: TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('FOTO IDENTITAS', style: TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('STATUS REGISTRASI', style: TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('AKSI', style: TextStyle(fontWeight: FontWeight.bold))),
                        ],
                        // Baris Data
                        rows: _data
                            .map(
                              (item) => DataRow(
                                cells: [
                                  DataCell(Text(item.no.toString())),
                                  DataCell(Text(item.nama)),
                                  DataCell(Text(item.nik)),
                                  DataCell(Text(item.email)),
                                  DataCell(Text(item.jenisKelamin)),
                                  DataCell(
                                    // Widget untuk menampilkan Foto Identitas
                                    // Catatan: Ganti Image.asset dengan NetworkImage jika menggunakan URL
                                    Image.asset(
                                      'assets/placeholder.png', // Ganti dengan item.fotoIdentitasAsset jika Anda telah menambahkannya ke pubspec.yaml
                                      width: 60,
                                      height: 60,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) => const Icon(Icons.image_not_supported, size: 40),
                                    ),
                                  ),
                                  DataCell(_buildStatusBadge(item.statusRegistrasi)),
                                  DataCell(_buildActionMenu(context, item)), // Kolom Aksi
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