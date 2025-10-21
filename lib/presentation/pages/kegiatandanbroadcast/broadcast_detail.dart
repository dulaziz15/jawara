import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
// Ganti path ini sesuai dengan lokasi file model broadcast Anda
import 'package:jawara/core/models/broadcast_models.dart'; 

@RoutePage()
class BroadcastDetailPage extends StatelessWidget {
  // Menerima ID broadcast dari halaman sebelumnya
  final int broadcastId;

  const BroadcastDetailPage({
    super.key,
    @PathParam('id') required this.broadcastId,
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
  
  // Helper widget baru untuk menampilkan baris lampiran dengan ikon
  Widget _buildAttachmentRow(String label, String filename, IconData icon) {
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
                  "Tidak ada lampiran",
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
    // Ambil data broadcast yang sesuai berdasarkan ID
    final broadcast = dummyBroadcast.firstWhere((item) => item.id == broadcastId);

    // Format tanggal
    final String tanggalFormatted =
        '${broadcast.tanggalPublikasi.day} '
        '${_getBulan(broadcast.tanggalPublikasi.month)} '
        '${broadcast.tanggalPublikasi.year}';

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
                    _buildDetailRow("Judul Broadcast:", broadcast.judulBroadcast),
                    _buildDetailRow("Isi Pesan:", broadcast.isiPesan),
                    _buildDetailRow("Tanggal Publikasi:", tanggalFormatted),
                    _buildDetailRow("Dibuat oleh:", broadcast.dibuatOleh),
                    const Divider(height: 24),
                    _buildAttachmentRow(
                        "Lampiran Gambar:", broadcast.lampiranGambar, Icons.image_outlined),
                    _buildAttachmentRow(
                        "Lampiran Dokumen:", broadcast.lampiranDokumen, Icons.description_outlined),
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