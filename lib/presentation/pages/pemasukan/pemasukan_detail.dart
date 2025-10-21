import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:jawara/core/models/pemasukan_model.dart';
import 'package:jawara/core/utils/formatter_util.dart';

@RoutePage()
class LaporanPemasukanLainDetailPage extends StatelessWidget {
  final int laporanPemasukanId;

  const LaporanPemasukanLainDetailPage({
    super.key,
    @PathParam('id') required this.laporanPemasukanId,
  });

  // Helper untuk format bulan
  String _getBulan(int bulan) {
    const namaBulan = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni', 'Juli',
      'Agustus', 'September', 'Oktober', 'November', 'Desember',
    ];
    return namaBulan[bulan - 1];
  }

  // Helper widget untuk menampilkan baris detail teks
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  // Helper widget untuk menampilkan baris lampiran dengan ikon
  Widget _buildAttachmentRow(String label, String filename) {
    IconData icon = Icons.description_outlined; // Default to document
    if (filename.isNotEmpty) {
      if (filename.toLowerCase().endsWith('.jpg') ||
          filename.toLowerCase().endsWith('.png') ||
          filename.toLowerCase().endsWith('.jpeg')) {
        icon = Icons.image_outlined;
      }
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 6),
          // Cek apakah ada nama file lampiran
          filename.isEmpty
              ? const Text(
                  "Tidak ada bukti",
                  style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic, color: Colors.grey),
                )
              : Row(
                  children: [
                    Icon(icon, color: Colors.deepPurple, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        filename,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Ambil data pemasukan yang sesuai berdasarkan ID
    final pemasukan = dummyPemasukan.firstWhere((item) => item.id == laporanPemasukanId);

    // Format tanggal pemasukan
    final String tanggalPemasukanFormatted =
        '${pemasukan.tanggalPemasukan.day} '
        '${_getBulan(pemasukan.tanggalPemasukan.month)} '
        '${pemasukan.tanggalPemasukan.year}';

    // Format tanggal terverifikasi
    final String tanggalTerverifikasiFormatted =
        '${pemasukan.tanggalTerverifikasi.day} '
        '${_getBulan(pemasukan.tanggalTerverifikasi.month)} '
        '${pemasukan.tanggalTerverifikasi.year}';

    // Format jumlah pemasukan
    final String jumlahFormatted = FormatterUtil.formatCurrency(pemasukan.jumlahPemasukan);

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade100,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => context.router.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card Detail Laporan Pemasukan
            Card(
              color: Colors.white,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow("Nama Pemasukan:", pemasukan.namaPemasukan),
                    _buildDetailRow("Kategori Pemasukan:", pemasukan.kategoriPemasukan),
                    _buildDetailRow("Jumlah Pemasukan:", 'Rp $jumlahFormatted'),
                    _buildDetailRow("Tanggal Pemasukan:", tanggalPemasukanFormatted),
                    _buildDetailRow("Verifikator:", pemasukan.verifikator),
                    _buildDetailRow("Tanggal Terverifikasi:", tanggalTerverifikasiFormatted),
                    const Divider(height: 24),
                    _buildAttachmentRow("Bukti:", pemasukan.bukti),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
